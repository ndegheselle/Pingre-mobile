import 'package:flutter/material.dart';
import 'package:pingre/widgets/time_range.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionssPageState();
}

class _TransactionssPageState extends State<TransactionsPage> {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: .start,
    children: [
      TimeRange(value: TimeRangeUnit.month)
    ],
  );
}
