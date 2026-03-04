import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/widgets/time_range.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionssPageState();
}

class _TransactionssPageState extends State<TransactionsPage> {
  bool _isTimeRolling = false;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(child: TimeRange(value: EnumTimeRange.month)),
          SizedBox(width: 4),
          FTooltip(
            tipBuilder: (context, _) =>
                Text(_isTimeRolling ? "Rolling time" : "Range time"),
            child: FButton(
              variant: .secondary,
              onPress: () => setState(() => _isTimeRolling = !_isTimeRolling),
              child: Icon(
                _isTimeRolling ? FIcons.calendarClock : FIcons.calendarRange,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
