import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../events/event_details_screen.dart';

class MyBookingsScreen extends StatelessWidget {
  final String uid;
  const MyBookingsScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('bookings')
                .where('user_id', isEqualTo: uid)
                .orderBy('booking_date', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final booking =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance
                        .collection('events')
                        .doc(booking['event_id'])
                        .get(),
                builder: (context, eventSnapshot) {
                  if (!eventSnapshot.hasData) {
                    return const Card(
                      child: ListTile(title: Text('Loading...')),
                    );
                  }

                  final event =
                      eventSnapshot.data!.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        // In the InkWell onTap:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => EventDetailsScreen(
                                  eventId: booking['event_id'],
                                  event: event,
                                  uid: uid,
                                ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Image.network(
                              event['image_url'] ?? '',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        event['event_title'] ?? 'Unknown Event',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            booking['status'] == 'pending'
                                                ? Colors.orange
                                                : booking['status'] ==
                                                    'approved'
                                                ? Colors.green
                                                : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        booking['status']?.toUpperCase() ??
                                            'PENDING',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Booked on: ${DateFormat('MMM dd, yyyy').format(booking['booking_date'].toDate())}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                if (booking['payment_type'] != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Payment: ${booking['payment_type']} (${booking['payment_method']})',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
