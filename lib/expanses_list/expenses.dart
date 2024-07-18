import 'package:expenses/chart/chart.dart';
import 'package:expenses/expanses_list/expanses_list.dart';
import 'package:expenses/models/expense.dart';
import 'package:expenses/widgets/newExpense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      category: Category.work,
      tittle: 'flutter course',
      amount: 29.98,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.pleasure,
      tittle: 'cinema',
      amount: 9.71,
      date: DateTime.now(),
    ),
    Expense(
      category: Category.food,
      tittle: ' breakfast',
      amount: 31.3,
      date: DateTime.now(),
    )
  ];
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    setState(() {
      _registeredExpenses.remove(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (ctx) => NewExpense(
                          onAddExpense: _addExpense,
                        ));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Center(
          child: width < 600
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Chart(
                        expenses: _registeredExpenses,
                      ),
                    ),
                    Expanded(
                        child: ExpensesList(
                            onRemoveExpense: _removeExpense,
                            expenses: _registeredExpenses))
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Chart(
                        expenses: _registeredExpenses,
                      ),
                    ),
                    Expanded(
                        child: ExpensesList(
                            onRemoveExpense: _removeExpense,
                            expenses: _registeredExpenses))
                  ],
                )),
    );
  }
}
