import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookEventScreen extends StatefulWidget {
  final String eventId;
  final Map<String, dynamic> event;
  final String userId;

  const BookEventScreen({
    super.key,
    required this.eventId,
    required this.event,
    required this.userId,
  });

  @override
  State<BookEventScreen> createState() => _BookEventScreenState();
}

class _BookEventScreenState extends State<BookEventScreen> {
  String _paymentMethod = 'Bkash';
  String _paymentType = 'online';
  final _transactionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _bookEvent() async {
    if (widget.event['amount'] > 0 && _transactionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter transaction ID')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create booking document
      await FirebaseFirestore.instance.collection('bookings').add({
        'event_id': widget.eventId,
        'user_id': widget.userId,
        'payment_type': _paymentType,
        'payment_method': _paymentMethod,
        'transection_id': _transactionController.text,
        'booking_date': Timestamp.now(),
        'status': 'pending',
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking successful!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Event', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow('Event', widget.event['event_title']),
                    _buildDetailRow(
                      'Date',
                      widget.event['date'].toDate().toString().split(' ')[0],
                    ),
                    _buildDetailRow('Amount', '৳${widget.event['amount']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (widget.event['amount'] > 0) ...[
              Text(
                'Payment Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Type'),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'online', label: Text('Online')),
                          ButtonSegment(
                            value: 'offline',
                            label: Text('Offline'),
                          ),
                        ],
                        selected: {_paymentType},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() => _paymentType = newSelection.first);
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Payment Method'),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _paymentMethod,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items:
                            ['Bkash', 'Nagad', 'Rocket']
                                .map(
                                  (method) => DropdownMenuItem(
                                    value: method,
                                    child: Text(method),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() => _paymentMethod = value!);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _transactionController,
                        decoration: InputDecoration(
                          labelText: 'Transaction ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _bookEvent,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[200],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child:
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm Booking'),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
