import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './expense_provider.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses;

    if (expenses.isEmpty) {
      return const SizedBox.shrink();
    }

    final Map<String, double> categoryData = {};
    for (var expense in expenses) {
      categoryData.update(expense.category, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    final List<PieChartSectionData> pieChartSections = categoryData.entries.map((entry) {
      final isTouched = entry.key == 'Food'; // This is just an example, you might want to handle touch events
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: _getColorForCategory(entry.key),
        value: entry.value,
        title: '${entry.key}\n${(entry.value / expenseProvider.totalExpense * 100).toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    }).toList();

    return SizedBox(
      height: 300,
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              // Handle touch events here
            },
          ),
          borderData: FlBorderData(show: false),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: pieChartSections,
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Food':
        return Colors.red;
      case 'Travel':
        return Colors.blue;
      case 'Shopping':
        return Colors.green;
      case 'Bills':
        return Colors.orange;
      case 'Health':
        return Colors.purple;
      case 'Entertainment':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
