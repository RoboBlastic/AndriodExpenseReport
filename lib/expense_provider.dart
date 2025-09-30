import 'package:flutter/material.dart';
import './database_helper.dart';
import './expense.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

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
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper.instance.delete(id);
    fetchExpenses();
  }
}
