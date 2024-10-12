import 'package:exprense_tracker/models/transaction.dart';
import 'package:exprense_tracker/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions;

    final expenses = transactions
        .where((trasaction) => trasaction.type == TransactionType.expense)
        .toList();

    final Map<String, double> categoryTotals = {};
    for (var transaction in expenses) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    List<charts.Series<MapEntry<String, double>, String>> series = [
      charts.Series(
        id: 'Gastos',
        data: categoryTotals.entries.toList(),
        domainFn: (MapEntry<String, double> entry, _) => entry.key,
        measureFn: (MapEntry<String, double> entry, _) => entry.value,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      )
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      height: 300,
      child: charts.BarChart(
        series,
        animate: true,
      ),
    );
  }
}
