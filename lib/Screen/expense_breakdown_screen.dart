import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../Theme/theme.dart';
import '../l10n/app_localizations.dart';
import '../Providers/expense_provider.dart';
import '../Models/expense_model.dart';

class ExpenseBreakdownScreen extends ConsumerStatefulWidget {
  final String vehicleId;

  const ExpenseBreakdownScreen({super.key, required this.vehicleId});

  @override
  ConsumerState<ExpenseBreakdownScreen> createState() =>
      _ExpenseBreakdownScreenState();
}

class _ExpenseBreakdownScreenState extends ConsumerState<ExpenseBreakdownScreen>
    with SingleTickerProviderStateMixin {
  String _selectedPeriod = 'Monthly';
  String? _selectedCategory;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutQuart);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Map<String, double> _calculateTotals(List<Expense> expenses) {
    DateTime now = DateTime.now();
    DateTime startDate;

    switch (_selectedPeriod) {
      case 'Weekly':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Monthly':
        startDate = DateTime(now.year, now.month, 1);
        break;
      case '6 Months':
        startDate = DateTime(now.year, now.month - 5, 1);
        break;
      case 'Yearly':
        startDate = DateTime(now.year, 1, 1);
        break;
      default:
        startDate = DateTime(now.year, now.month, 1);
    }

    final filtered = expenses.where(
        (e) => e.date.isAfter(startDate) || e.date.isAtSameMomentAs(startDate));

    final Map<String, double> tempTotals = {
      'Fuel': 0,
      'Maintenance': 0,
      'Wash': 0,
      'Tires': 0,
      'Other': 0,
    };

    for (var expense in filtered) {
      final amount = expense.amount;
      final type = expense.type;

      if (tempTotals.containsKey(type)) {
        tempTotals[type] = tempTotals[type]! + amount;
      } else {
        tempTotals['Other'] = tempTotals['Other']! + amount;
      }
    }

    final sortedEntries = tempTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final nonZeroEntries = sortedEntries.where((e) => e.value > 0).toList();

    return Map.fromEntries(nonZeroEntries);
  }

  Color _getGreyColor(int index, int totalItems) {
    if (totalItems <= 1) return Colors.grey[600]!;
    const startShade = 400;
    const endShade = 800;
    int shadeStep = (endShade - startShade) ~/ (totalItems);
    int shade = startShade + (index * shadeStep);
    if (shade < 450) return Colors.grey[400]!;
    if (shade < 550) return Colors.grey[500]!;
    if (shade < 650) return Colors.grey[600]!;
    if (shade < 750) return Colors.grey[700]!;
    return Colors.grey[800]!;
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseListProvider(widget.vehicleId));

    final catConfig = {
      'Fuel': {
        'label': AppLocalizations.of(context)!.translate('expense_fuel'),
        'icon': Icons.local_gas_station
      },
      'Maintenance': {
        'label': AppLocalizations.of(context)!.translate('expense_maintenance'),
        'icon': Icons.build
      },
      'Wash': {
        'label': AppLocalizations.of(context)!.translate('expense_wash'),
        'icon': Icons.local_car_wash
      },
      'Tires': {
        'label': AppLocalizations.of(context)!.translate('expense_tires'),
        'icon': Icons.tire_repair
      },
      'Other': {
        'label': AppLocalizations.of(context)!.translate('expense_other'),
        'icon': Icons.receipt
      },
      'Insurance': {
        'label': AppLocalizations.of(context)!.translate('expense_insurance'),
        'icon': Icons.verified_user
      },
      'Parts': {
        'label': AppLocalizations.of(context)!.translate('expense_parts'),
        'icon': Icons.settings
      },
    };

    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color?.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: theme.iconTheme.color, size: 20),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate('expense_breakdown_title'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: expensesAsync.when(
                loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.accent)),
                error: (error, stack) => Center(
                  child: Text(
                      AppLocalizations.of(context)!
                          .translate('error_loading_expenses'),
                      style: const TextStyle(color: Colors.red)),
                ),
                data: (expenses) {
                  final categoryTotals = _calculateTotals(expenses);
                  final totalExpense =
                      categoryTotals.values.fold(0.0, (sum, val) => sum + val);

                  if ((_selectedCategory == null ||
                          !categoryTotals.containsKey(_selectedCategory)) &&
                      categoryTotals.isNotEmpty) {
                    _selectedCategory = categoryTotals.keys.first;
                  } else if (categoryTotals.isEmpty) {
                    _selectedCategory = null;
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                'Weekly',
                                'Monthly',
                                '6 Months',
                                'Yearly'
                              ].map((period) {
                                final isSelected = _selectedPeriod == period;
                                String label;
                                switch (period) {
                                  case 'Weekly':
                                    label = AppLocalizations.of(context)!
                                        .translate('period_weekly');
                                    break;
                                  case 'Monthly':
                                    label = AppLocalizations.of(context)!
                                        .translate('period_monthly');
                                    break;
                                  case '6 Months':
                                    label = AppLocalizations.of(context)!
                                        .translate('period_6months');
                                    break;
                                  case 'Yearly':
                                    label = AppLocalizations.of(context)!
                                        .translate('period_yearly');
                                    break;
                                  default:
                                    label = period;
                                }

                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedPeriod = period;
                                        _animationController.forward(from: 0);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.accent
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.black
                                              : theme
                                                  .textTheme.bodyMedium?.color,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        if (totalExpense > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: theme.cardTheme.color,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate('total_expense'),
                                            style: theme.textTheme.labelSmall
                                                ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: AppLocalizations.of(
                                                            context)!
                                                        .locale
                                                        .toString(),
                                                    symbol: '₺')
                                                .format(totalExpense),
                                            style: theme.textTheme.headlineLarge
                                                ?.copyWith(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  AnimatedBuilder(
                                    animation: _animation,
                                    builder: (context, child) {
                                      return CustomPaint(
                                        size: const Size(220, 220),
                                        painter: PieChartPainter(
                                          categories: categoryTotals,
                                          selectedCategory: _selectedCategory,
                                          total: totalExpense,
                                          width: 30,
                                          animationValue: _animation.value,
                                          getGreyColor: _getGreyColor,
                                        ),
                                        child: SizedBox(
                                          width: 220,
                                          height: 220,
                                          child: Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          'top_category'),
                                                  style:
                                                      theme.textTheme.bodySmall,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  totalExpense > 0 &&
                                                          _selectedCategory !=
                                                              null
                                                      ? '${(((categoryTotals[_selectedCategory!] ?? 0) / totalExpense) * 100).toStringAsFixed(0)}%'
                                                      : '0%',
                                                  style: const TextStyle(
                                                    color: AppColors.accent,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _selectedCategory != null &&
                                                          catConfig[
                                                                  _selectedCategory!] !=
                                                              null
                                                      ? (catConfig[
                                                              _selectedCategory!]![
                                                          'label'] as String)
                                                      : (_selectedCategory ??
                                                          '-'),
                                                  style: theme
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: categoryTotals.entries
                                        .take(4)
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((entryIndex) {
                                      final index = entryIndex.key;
                                      final e = entryIndex.value;
                                      final category = e.key;

                                      final conf = catConfig[category] ??
                                          catConfig['Other']!;

                                      final Color color =
                                          (category == _selectedCategory)
                                              ? AppColors.accent
                                              : _getGreyColor(
                                                  index, categoryTotals.length);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              conf['label'] as String,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('no_expenses_period'),
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate('categories'),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                          itemCount: categoryTotals.length,
                          itemBuilder: (context, index) {
                            final entry =
                                categoryTotals.entries.elementAt(index);
                            final category = entry.key;
                            final amount = entry.value;
                            final percentage =
                                totalExpense > 0 ? amount / totalExpense : 0.0;
                            final conf =
                                catConfig[category] ?? catConfig['Other']!;
                            final icon = conf['icon'] as IconData;
                            final label = conf['label'] as String;

                            final isSelected = category == _selectedCategory;
                            final color = isSelected
                                ? AppColors.accent
                                : _getGreyColor(index, categoryTotals.length);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: theme.cardTheme.color,
                                    borderRadius: BorderRadius.circular(16),
                                    border: isSelected
                                        ? Border.all(
                                            color: AppColors.accent
                                                .withValues(alpha: 0.5),
                                            width: 1)
                                        : Border.all(color: Colors.transparent),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child:
                                            Icon(icon, color: color, size: 24),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  label,
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  NumberFormat.currency(
                                                          locale:
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .locale
                                                                  .toString(),
                                                          symbol: '₺')
                                                      .format(amount),
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: percentage *
                                                          _animation.value,
                                                      backgroundColor:
                                                          Colors.grey[800],
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(color),
                                                      minHeight: 6,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  '${(percentage * 100).toStringAsFixed(0)}%',
                                                  style: theme
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: isSelected
                                                        ? AppColors.accent
                                                        : theme.textTheme
                                                            .bodySmall?.color,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PieChartPainter extends CustomPainter {
  final Map<String, double> categories;
  final String? selectedCategory;
  final double total;
  final double width;
  final double animationValue;
  final Function(int, int) getGreyColor;

  PieChartPainter({
    required this.categories,
    required this.selectedCategory,
    required this.total,
    required this.width,
    required this.animationValue,
    required this.getGreyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -pi / 2;

    int index = 0;
    for (var entry in categories.entries) {
      final category = entry.key;
      final amount = entry.value;
      final sweepAngle = (amount / total) * 2 * pi * animationValue;

      final isSelected = category == selectedCategory;
      final Color color = isSelected
          ? AppColors.accent
          : getGreyColor(index, categories.length);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? width + 4 : width
        ..strokeCap = StrokeCap.butt
        ..color = color;

      if (isSelected) {
        final shadowPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width + 8
          ..color = AppColors.accent.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawArc(rect, startAngle, sweepAngle, false, shadowPaint);
      }

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.categories != categories ||
        oldDelegate.selectedCategory != selectedCategory;
  }
}
