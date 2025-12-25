import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../Theme/theme.dart';
import 'add_vehicle_screen.dart';
import 'add_expense_screen.dart';
import '../Utils/snackbar_utils.dart';
import 'expense_breakdown_screen.dart';
import '../l10n/app_localizations.dart';
import '../Providers/vehicle_provider.dart';
import '../Providers/expense_provider.dart';
import '../Models/vehicle_model.dart';
import '../Models/expense_model.dart';

class VehicleDetailsScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  const VehicleDetailsScreen({
    super.key,
    required this.vehicleId,
  });

  @override
  ConsumerState<VehicleDetailsScreen> createState() =>
      _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends ConsumerState<VehicleDetailsScreen> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final vehicleAsync = ref.watch(vehicleDetailsProvider(widget.vehicleId));
    final theme = Theme.of(context);

    return vehicleAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(AppLocalizations.of(context)!.translate('error_occured')),
        ),
      ),
      data: (vehicle) {
        final String vehicleName = vehicle.name.isNotEmpty
            ? vehicle.name
            : AppLocalizations.of(context)!.translate('unnamed_vehicle');
        final String plate = vehicle.plate;
        final int year = vehicle.year;
        final String? imageUrl = vehicle.imageUrl;
        final DateTime? inspectionDate = vehicle.inspectionDate;
        final DateTime? insuranceDate = vehicle.insuranceDate;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              vehicleName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _confirmDelete(vehicle),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.accent),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddVehicleScreen(
                        vehicle: vehicle,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: _isDeleting
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.redAccent))
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 150
                            : 250,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          image: imageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: imageUrl == null
                            ? Center(
                                child: Icon(Icons.directions_car,
                                    size: 80,
                                    color: theme.iconTheme.color
                                        ?.withValues(alpha: 0.5)),
                              )
                            : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "$vehicleName ($year)",
                                    style:
                                        theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppColors.accent, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    plate,
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                _buildInfoCard(
                                  AppLocalizations.of(context)!
                                      .translate('next_inspection'),
                                  inspectionDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(inspectionDate)
                                      : AppLocalizations.of(context)!
                                          .translate('not_set'),
                                  Icons.calendar_month,
                                ),
                                const SizedBox(width: 16),
                                _buildInfoCard(
                                  AppLocalizations.of(context)!
                                      .translate('next_insurance'),
                                  insuranceDate != null
                                      ? DateFormat('dd/MM/yyyy')
                                          .format(insuranceDate)
                                      : AppLocalizations.of(context)!
                                          .translate('not_set'),
                                  Icons.security,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('expense_history'),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ExpenseBreakdownScreen(
                                      vehicleId: widget.vehicleId,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.pie_chart,
                                  color: AppColors.accent, size: 20),
                              label: Text(
                                  AppLocalizations.of(context)!
                                      .translate('analysis'),
                                  style:
                                      const TextStyle(color: AppColors.accent)),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                backgroundColor: theme.cardTheme.color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildExpenseList(),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    AddExpenseScreen(vehicleId: widget.vehicleId),
              );
            },
            backgroundColor: AppColors.accent,
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        );
      },
    );
  }

  Widget _buildExpenseList() {
    final expensesAsync = ref.watch(expenseListProvider(widget.vehicleId));
    final theme = Theme.of(context);

    return expensesAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
            AppLocalizations.of(context)!.translate('error_loading_expenses'),
            style: const TextStyle(color: Colors.red)),
      ),
      data: (expenses) {
        if (expenses.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate('no_expenses_found'),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];

            IconData icon;
            String typeLabel;

            switch (expense.type) {
              case 'Fuel':
                icon = Icons.local_gas_station;
                typeLabel =
                    AppLocalizations.of(context)!.translate('expense_fuel');
                break;
              case 'Maintenance':
                icon = Icons.build;
                typeLabel = AppLocalizations.of(context)!
                    .translate('expense_maintenance');
                break;
              case 'Wash':
                icon = Icons.local_car_wash;
                typeLabel =
                    AppLocalizations.of(context)!.translate('expense_wash');
                break;
              case 'Tires':
                icon = Icons.tire_repair;
                typeLabel =
                    AppLocalizations.of(context)!.translate('expense_tires');
                break;
              default:
                icon = Icons.receipt;
                typeLabel =
                    AppLocalizations.of(context)!.translate('expense_other');
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () => _showExpenseOptions(expense),
                borderRadius: BorderRadius.circular(12),
                child: _buildHistoryItem(
                  icon: icon,
                  title: expense.title.isNotEmpty ? expense.title : typeLabel,
                  date: DateFormat('dd MMM yyyy',
                          AppLocalizations.of(context)!.locale.toString())
                      .format(expense.date),
                  amount: '-₺${expense.amount.toStringAsFixed(2)}',
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showExpenseOptions(Expense expense) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.cardTheme.color,
      builder: (context) => SafeArea(
        child: Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.accent),
              title: Text(AppLocalizations.of(context)!.translate('edit'),
                  style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddExpenseScreen(
                    vehicleId: widget.vehicleId,
                    expense: expense,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.redAccent),
              title: Text(AppLocalizations.of(context)!.translate('delete'),
                  style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _deleteExpense(expense.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteExpense(String expenseId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)!.translate('delete_expense_title')),
        content: Text(
          AppLocalizations.of(context)!.translate('delete_expense_confirm'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.translate('cancel'),
                style: const TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.translate('delete'),
                style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref
            .read(expenseRepositoryProvider)
            .deleteExpense(widget.vehicleId, expenseId);

        if (mounted) {
          SnackBarUtils.showSuccess(context,
              AppLocalizations.of(context)!.translate('expense_deleted'));
        }
      } catch (e) {
        if (mounted) {
          SnackBarUtils.showError(context, "Hata: $e");
        }
      }
    }
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon,
                color: Theme.of(context).textTheme.bodyMedium?.color, size: 24),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Icon(icon, color: AppColors.accent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  date,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Vehicle vehicle) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            AppLocalizations.of(context)!.translate('delete_vehicle_title')),
        content: Text(
          AppLocalizations.of(context)!.translate('delete_vehicle_confirm'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.translate('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.translate('delete'),
                style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _deleteVehicle(vehicle);
    }
  }

  Future<void> _deleteVehicle(Vehicle vehicle) async {
    setState(() => _isDeleting = true);

    try {
      await ref
          .read(vehicleRepositoryProvider)
          .deleteVehicle(vehicle.id, vehicle.imageUrl);

      if (mounted) {
        Navigator.of(context).pop(); // Return to Home
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtils.showError(context, "Hata oluştu: $e");
        setState(() => _isDeleting = false);
      }
    }
  }
}
