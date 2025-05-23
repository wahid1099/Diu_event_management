import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:diu_evento/screens/events/book_event_screen.dart'; // Add this import

// Update the class definition to include uid
class EventDetailsScreen extends StatelessWidget {
  final String eventId;
  final Map<String, dynamic> event;
  final String uid; // Add this

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.event,
    required this.uid, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event['event_title'] ?? 'Event Details'),
        backgroundColor: Colors.deepPurple.shade400,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              event['image_url'] ?? 'https://via.placeholder.com/400x200',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(Icons.event, size: 50, color: Colors.grey),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['event_title'] ?? 'Untitled Event',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    Icons.category,
                    event['category'] ?? 'Uncategorized',
                  ),
                  _buildInfoRow(
                    Icons.location_on,
                    event['location'] ?? 'No venue',
                  ),
                  _buildInfoRow(
                    Icons.calendar_today,
                    event['date'] != null
                        ? DateFormat(
                          'MMM dd, yyyy',
                        ).format((event['date'] as Timestamp).toDate())
                        : 'No date',
                  ),
                  _buildInfoRow(
                    Icons.people,
                    'Capacity: ${event['capacity'] ?? 'Not specified'}',
                  ),
                  _buildInfoRow(
                    Icons.attach_money,
                    'Fee: ${event['amount'] ?? 'Free'}',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event['description'] ?? 'No description available',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Add bottom navigation bar for booking
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => BookEventScreen(
                      eventId: eventId,
                      event: event,
                      userId: uid,
                    ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[200],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Book Now',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
        ],
      ),
    );
  }
}
