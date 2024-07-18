import 'package:expenses/chart/chart_bar.dart';
import 'package:expenses/models/expense.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  Chart({required this.expenses, super.key});
  final List<Expense> expenses;
  List<ExpensePucket> get buckets {
    return [
      ExpensePucket.forCategory(expenses, Category.food),
      ExpensePucket.forCategory(expenses, Category.pleasure),
      ExpensePucket.forCategory(expenses, Category.travel),
      ExpensePucket.forCategory(expenses, Category.work),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;
    for (var element in buckets) {
      if (element.totalExpenses > maxTotalExpense) {
        maxTotalExpense = element.totalExpenses;
      }
    }
    return maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          height: constraints.maxHeight,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
                Theme.of(context).colorScheme.primary.withOpacity(0.0)
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          child: Column(
            children: [
              Expanded(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final ele in buckets)
                    ChartBar(
                      fill: ele.totalExpenses == 0
                          ? 0
                          : ele.totalExpenses / maxTotalExpense,
                    ),
                ],
              )),
              constraints.minHeight < 200
                  ? Container()
                  : const SizedBox(
                      height: 12,
                    ),
              constraints.minHeight < 200
                  ? Container()
                  : Row(
                      children: buckets
                          .map((e) => Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  categoryIcons[e.category],
                                  color: isDarkMode
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.7),
                                ),
                              )))
                          .toList(),
                    ),
            ],
          ),
        );
      },
    );
  }
}
