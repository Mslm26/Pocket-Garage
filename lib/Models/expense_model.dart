import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String vehicleId;
  final String type;
  final String title;
  final double amount;
  final DateTime date;
  final DateTime? createdAt;

  Expense({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.title,
    required this.amount,
    required this.date,
    this.createdAt,
  });

  factory Expense.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Expense(
      id: doc.id,
      vehicleId: data['vehicleId'] ?? '',
      type: data['type'] ?? 'Other',
      title: data['title'] ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
