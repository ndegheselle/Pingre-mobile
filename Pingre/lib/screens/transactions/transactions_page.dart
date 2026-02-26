import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/widgets/time_range.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionssPageState();
}

class _TransactionssPageState extends State<TransactionsPage> {
  bool _isPeriod = false;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(child: TimeRange(value: EnumTimeRange.month)),
          SizedBox(width: 4),
          FButton(
            variant: .secondary,
            onPress: () => setState(() => _isPeriod = !_isPeriod),
            child: Icon(_isPeriod ? FIcons.calendarClock : FIcons.calendarRange),
          ),
        ],
      ),
    ],
  );
}
