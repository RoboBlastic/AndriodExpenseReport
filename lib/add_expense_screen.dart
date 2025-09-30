import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './expense.dart';
import './expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCategory = 'Food';

  final _categories = [
    'Food',
    'Travel',
    'Shopping',
    'Bills',
    'Health',
    'Entertainment',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      final expense = widget.expense!;
      _titleController.text = expense.title;
      _amountController.text = expense.amount.toString();
      _selectedDate = expense.date;
      _selectedCategory = expense.category;
    }
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    if (widget.expense == null) {
      Provider.of<ExpenseProvider>(context, listen: false).addExpense(
        enteredTitle,
        enteredAmount,
        _selectedDate!,
        _selectedCategory,
      );
    } else {
      final updatedExpense = Expense(
        id: widget.expense!.id,
        title: enteredTitle,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      );
      Provider.of<ExpenseProvider>(context, listen: false).updateExpense(updatedExpense);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add New Expense' : 'Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹'),
              keyboardType: TextInputType.number,
            ),
            DropdownButtonFormField(
              initialValue: _selectedCategory,
              items: _categories.map((String category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue.toString();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
            ),
            SizedBox(
              height: 70,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}',
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _submitData,
              child: Text(widget.expense == null ? 'Add Expense' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
