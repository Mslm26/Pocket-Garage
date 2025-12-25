import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Repositories/expense_repository.dart';
import '../Models/expense_model.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

final expenseListProvider =
    StreamProvider.family<List<Expense>, String>((ref, vehicleId) {
  final repository = ref.watch(expenseRepositoryProvider);
  return repository.getExpenses(vehicleId);
});
