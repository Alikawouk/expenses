import 'dart:developer';

import 'package:expenses/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDAte;
  final formatter = DateFormat.yMd();
  Category _selectedcategory = Category.food;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(label: Text('Title')),
                maxLength: 50,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          label: Text('Amount'), prefixText: '\$'),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(_selectedDAte == null
                            ? 'No date selected'
                            : formatter.format(_selectedDAte!)),
                        IconButton(
                            onPressed: () async {
                              // ignore: prefer_const_declarations
                              final now = DateTime.now();
                              final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: now,
                                  firstDate: DateTime(
                                      now.year - 1, now.month, now.day),
                                  lastDate: now);
                              setState(() {
                                _selectedDAte = pickedDate;
                              });
                            },
                            icon: const Icon(Icons.calendar_month))
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  DropdownButton(
                      value: _selectedcategory,
                      items: Category.values
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)))
                          .toList(),
                      onChanged: (newCat) {
                        if (newCat == null) return;
                        setState(() {
                          _selectedcategory = newCat;
                        });
                      }),
                  const Spacer(),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('cancel')),
                  ElevatedButton(
                      onPressed: () {
                        final enteredAmount =
                            double.tryParse(_amountController.text);
                        final amountIsInvalid =
                            enteredAmount == null || enteredAmount <= 0;

                        //const snackBar = SnackBar(content: Text('error'));
                        if (_titleController.text.trim().isEmpty ||
                            amountIsInvalid ||
                            _selectedDAte == null) {
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('invalid input'),
                              content: const Text(
                                  'please make sure to enter a valid data'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                    },
                                    child: const Text('OK'))
                              ],
                            ),
                          );
                        } else {
                          widget.onAddExpense(Expense(
                              category: _selectedcategory,
                              tittle: _titleController.text,
                              amount: enteredAmount,
                              date: _selectedDAte!));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('save expense'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
