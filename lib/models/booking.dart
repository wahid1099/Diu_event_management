class Booking {
  final String bookingDate;
  final String eventId;
  final String paymentMethod;
  final String paymentType;
  final String status;
  final String transactionId;
  final String userId;

  Booking({
    required this.bookingDate,
    required this.eventId,
    required this.paymentMethod,
    required this.paymentType,
    required this.status,
    required this.transactionId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'booking_date': bookingDate,
      'event_id': eventId,
      'payment_method': paymentMethod,
      'payment_type': paymentType,
      'status': status,
      'transaction_id': transactionId,
      'user_id': userId,
    };
  }
}
