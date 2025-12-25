import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/expense_model.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore;

  ExpenseRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<Expense>> getExpenses(String vehicleId) {
    return _firestore
        .collection('vehicles')
        .doc(vehicleId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Expense.fromFirestore(doc);
      }).toList();
    });
  }

  Future<void> addExpense(String vehicleId, Expense expense) async {
    final data = expense.toMap();
    data['vehicleId'] = vehicleId;

    await _firestore
        .collection('vehicles')
        .doc(vehicleId)
        .collection('expenses')
        .add(data);
  }

  Future<void> updateExpense(String vehicleId, Expense expense) async {
    final data = expense.toMap();
    data.remove('createdAt');

    await _firestore
        .collection('vehicles')
        .doc(vehicleId)
        .collection('expenses')
        .doc(expense.id)
        .update(data);
  }

  Future<void> deleteExpense(String vehicleId, String expenseId) async {
    await _firestore
        .collection('vehicles')
        .doc(vehicleId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }
}
