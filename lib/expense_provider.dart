import 'package:flutter/material.dart';
import './database_helper.dart';
import './expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> _originalExpenses = [];

  List<Expense> get expenses => _expenses;

  double get totalExpense {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  Future<void> addExpense(String title, double amount, DateTime date, String category) async {
    final newExpense = {
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
    await DatabaseHelper.instance.insert(newExpense);
    fetchExpenses();
  }

    Future<void> updateExpense(Expense expense) async {
    final updatedExpense = {
      'id': expense.id,
      'title': expense.title,
      'amount': expense.amount,
      'date': expense.date.toIso8601String(),
      'category': expense.category,
    };
    await DatabaseHelper.instance.update(updatedExpense);
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    final data = await DatabaseHelper.instance.queryAllRows();
    _expenses = data.map((item) {
      return Expense(
        id: item['id'],
        title: item['title'],
        amount: item['amount'],
        date: DateTime.parse(item['date']),
        category: item['category'] ?? 'Other', // Default category if not found
      );
    }).toList();
    _originalExpenses = _expenses;
    notifyListeners();
  }

  void filterExpensesByDate(DateTimeRange dateRange) {
    _expenses = _originalExpenses.where((expense) {
      return expense.date.isAfter(dateRange.start) &&
          expense.date.isBefore(dateRange.end.add(const Duration(days: 1)));
    }).toList();
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper.instance.delete(id);
    fetchExpenses();
  }
}
