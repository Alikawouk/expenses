import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final dateFormat = DateFormat.yMd();

const uuid = Uuid();

enum Category { food, travel, pleasure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight,
  Category.pleasure: Icons.movie,
  Category.work: Icons.work
};

class Expense {
  final String id;
  final String tittle;
  final double amount;
  final DateTime date;
  final Category category;

  String get formatedDate {
    return dateFormat.format(date);
  }

  Expense(
      {required this.category,
      required this.tittle,
      required this.amount,
      required this.date})
      : id = uuid.v4();
}

class ExpensePucket {
  final Category category;
  final List<Expense> expenses;

  ExpensePucket(this.category, this.expenses);

  ExpensePucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((element) => element.category == category)
            .toList();

  double get totalExpenses {
    double sum = 0;
    for (var expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
