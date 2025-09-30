# Expense Tracker App Blueprint

## Overview

This document outlines the features, design, and architecture of a simple Flutter Expense Tracker application. The app allows users to record and view their expenses.

## Features & Design

- **Add Expense:** Users can add a new expense with a title, amount, and date.
- **View Expenses:** The main screen displays a list of all recorded expenses, sorted by date in descending order.
- **Delete Expense:** Users can delete an expense from the list.
- **Total Expense:** The app calculates and displays the total of all expenses.
- **Local Storage:** Expenses are stored locally on the device using a SQLite database.
- **State Management:** The `provider` package is used for state management, ensuring the UI updates automatically when the data changes.
- **Platform Support:** The application is configured to run on both mobile (Android/iOS) and desktop (Windows, macOS, Linux) platforms.

## Current Task: Display Total Expense

**Objective:** Add a feature to calculate and display the total of all recorded expenses.

**Plan:**

1.  **Expense Provider (`lib/expense_provider.dart`):**
    *   **Action:** Add a new getter named `totalExpense` to the `ExpenseProvider` class.
    *   **Implementation:** This getter will use the `fold` method on the `_expenses` list to iterate through all expenses and accumulate the sum of their `amount` values, returning a `double`.

2.  **Main Screen UI (`lib/main.dart`):**
    *   **Action:** Modify the body of the `Scaffold` to include a new section for the total.
    *   **Implementation:** The main `Column` will now contain the `Expanded` `ListView` and a new `Padding` widget at the bottom. This `Padding` widget will contain a `Row` that displays the text "Total Expense:" on the left and the value from `expenseProvider.totalExpense` on the right. The text will be styled to be bold and slightly larger for emphasis.
