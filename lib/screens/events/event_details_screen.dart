import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'book_event_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  final Map<String, dynamic> event;

  const EventDetailsScreen({
    required this.eventId,
    required this.event,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                event['image_url'] ?? 'https://placeholder.com/500x300',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.error, size: 50),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          event['event_title'] ?? 'Untitled Event',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              event['status'] == 'pending'
                                  ? Colors.orange
                                  : event['status'] == 'approved'
                                  ? Colors.green
                                  : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event['status']?.toUpperCase() ?? 'PENDING',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  FutureBuilder<DocumentSnapshot>(
                    future:
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(event['created_by'])
                            .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>?;
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              userData?['profile_image'] ??
                                  'https://placeholder.com/100x100',
                            ),
                          ),
                          title: Text(userData?['name'] ?? 'Unknown User'),
                          subtitle: Text('Event Organizer'),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  Divider(height: 32),
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Date',
                    DateFormat(
                      'MMM dd, yyyy',
                    ).format((event['date'] as Timestamp).toDate()),
                  ),
                  _buildDetailRow(
                    Icons.access_time,
                    'Time',
                    DateFormat(
                      'hh:mm a',
                    ).format((event['date'] as Timestamp).toDate()),
                  ),
                  _buildDetailRow(
                    Icons.location_on,
                    'Location',
                    event['location'] ?? 'No location',
                  ),
                  _buildDetailRow(
                    Icons.category,
                    'Category',
                    event['category'] ?? 'No category',
                  ),
                  _buildDetailRow(
                    Icons.group,
                    'Department',
                    event['department'] ?? 'No department',
                  ),
                  _buildDetailRow(
                    Icons.school,
                    'Club',
                    event['club_name'] ?? 'No club',
                  ),
                  _buildDetailRow(
                    Icons.people,
                    'Capacity',
                    (event['capacity'] ?? 'No limit').toString(),
                  ),
                  _buildDetailRow(
                    Icons.attach_money,
                    'Amount',
                    '৳${event['amount'] ?? 0}'.toString(),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'About Event',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    event['description'] ?? 'No description available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Update the onPressed callback in the bottom navigation bar
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BookEventScreen(
                        eventId: eventId,
                        event: event,
                        userId: currentUser.uid,
                      ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please login to book events')),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[200],
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Register for Event'),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
