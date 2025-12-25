import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../Theme/theme.dart';
import '../Utils/snackbar_utils.dart';
import '../l10n/app_localizations.dart';
import '../Providers/expense_provider.dart';
import '../Models/expense_model.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final String vehicleId;
  final Expense? expense;

  const AddExpenseScreen({
    super.key,
    required this.vehicleId,
    this.expense,
  });

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'Fuel';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      final expense = widget.expense!;
      _amountController.text = expense.amount.toString();
      _titleController.text = expense.title;
      _selectedType = expense.type;
      _selectedDate = expense.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, dynamic>> expenseTypes = [
      {
        'id': 'Fuel',
        'label': AppLocalizations.of(context)!.translate('expense_fuel'),
        'icon': Icons.local_gas_station
      },
      {
        'id': 'Maintenance',
        'label': AppLocalizations.of(context)!.translate('expense_maintenance'),
        'icon': Icons.build
      },
      {
        'id': 'Wash',
        'label': AppLocalizations.of(context)!.translate('expense_wash'),
        'icon': Icons.local_car_wash
      },
      {
        'id': 'Tires',
        'label': AppLocalizations.of(context)!.translate('expense_tires'),
        'icon': Icons.tire_repair
      },
      {
        'id': 'Other',
        'label': AppLocalizations.of(context)!.translate('expense_other'),
        'icon': Icons.receipt
      },
    ];

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.expense != null
                  ? AppLocalizations.of(context)!
                      .translate('edit_expense_title')
                  : AppLocalizations.of(context)!
                      .translate('add_expense_title'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: expenseTypes.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final type = expenseTypes[index];
                  final isSelected = _selectedType == type['id'];
                  return GestureDetector(
                    onTap: () {
                      final previousLabel = expenseTypes
                          .firstWhere((e) => e['id'] == _selectedType)['label'];

                      setState(() {
                        _selectedType = type['id'];
                        if (_titleController.text.isEmpty ||
                            _titleController.text == previousLabel) {
                          _titleController.text = type['label'];
                        }
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : theme.scaffoldBackgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            type['icon'],
                            color: isSelected
                                ? Colors.black
                                : theme.iconTheme.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          type['label'],
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.accent
                                : theme.textTheme.bodyMedium?.color,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _amountController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                prefixText: '₺ ',
                prefixStyle: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                hintText: '0.00',
                hintStyle: theme.textTheme.bodyMedium,
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.accent)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              style: theme.textTheme.bodyLarge,
              textCapitalization: TextCapitalization.sentences,
              maxLength: 50,
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.translate('title_label'),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.accent)),
                counterText: "",
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _selectedDate = picked);
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: AppColors.accent, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('dd MMMM yyyy',
                              AppLocalizations.of(context)!.locale.toString())
                          .format(_selectedDate),
                      style: theme.textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right, color: theme.iconTheme.color),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        widget.expense != null
                            ? AppLocalizations.of(context)!
                                .translate('save_changes')
                            : AppLocalizations.of(context)!
                                .translate('save_expense'),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _saveExpense() async {
    if (_amountController.text.isEmpty) {
      SnackBarUtils.showError(context,
          AppLocalizations.of(context)!.translate('enter_amount_error'));
      return;
    }

    final double amount =
        double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;

    if (amount <= 0) {
      SnackBarUtils.showError(context,
          AppLocalizations.of(context)!.translate('positive_amount_error'));
      return;
    }

    if (amount > 1000000) {
      SnackBarUtils.showError(
          context, AppLocalizations.of(context)!.translate('max_amount_error'));
      return;
    }

    try {
      setState(() => _isLoading = true);

      if (widget.expense != null) {
        final updatedExpense = Expense(
          id: widget.expense!.id,
          vehicleId: widget.vehicleId,
          type: _selectedType,
          title: _titleController.text.trim(),
          amount: amount,
          date: _selectedDate,
          createdAt: widget.expense!.createdAt,
        );

        await ref
            .read(expenseRepositoryProvider)
            .updateExpense(widget.vehicleId, updatedExpense);
      } else {
        final newExpense = Expense(
          id: '',
          vehicleId: widget.vehicleId,
          type: _selectedType,
          title: _titleController.text.trim(),
          amount: amount,
          date: _selectedDate,
          createdAt: DateTime.now(),
        );

        await ref
            .read(expenseRepositoryProvider)
            .addExpense(widget.vehicleId, newExpense);
      }

      if (mounted) {
        Navigator.pop(context);
        SnackBarUtils.showSuccess(
            context, AppLocalizations.of(context)!.translate('expense_saved'));
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, 'Hata: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
