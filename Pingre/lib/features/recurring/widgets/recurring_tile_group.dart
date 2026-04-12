import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/models/time_range.dart';
import 'package:pingre/common/widgets/data/time_range_icon.dart';
import 'package:pingre/common/widgets/data/value_display.dart';
import 'package:pingre/features/recurring/models/recurring.dart';
import 'package:pingre/features/recurring/screens/overlay_recurring_edit.dart';
import 'package:pingre/features/recurring/services/recurring.dart';
import 'package:pingre/features/tags/widgets/tags_display.dart';
import 'package:pingre/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Multipliers to convert a recurring transaction value to a monthly equivalent.
Decimal _monthlyMultiplier(TimeRangeUnit unit) => switch (unit) {
      TimeRangeUnit.day => Decimal.parse('30.4375'), // 365.25 / 12
      TimeRangeUnit.week => Decimal.parse('4.348'), // 52 / 12
      TimeRangeUnit.twoWeeks => Decimal.parse('2.174'), // 26 / 12
      TimeRangeUnit.month => Decimal.one,
      TimeRangeUnit.quarter => Decimal.parse('0.3333'),
      TimeRangeUnit.year => Decimal.parse('0.0833'),
    };

/// Multipliers to convert a recurring transaction value to a yearly equivalent.
Decimal _yearlyMultiplier(TimeRangeUnit unit) => switch (unit) {
      TimeRangeUnit.day => Decimal.fromInt(365),
      TimeRangeUnit.week => Decimal.fromInt(52),
      TimeRangeUnit.twoWeeks => Decimal.fromInt(26),
      TimeRangeUnit.month => Decimal.fromInt(12),
      TimeRangeUnit.quarter => Decimal.fromInt(4),
      TimeRangeUnit.year => Decimal.one,
    };

class RecurringTileGroup extends StatelessWidget {
  final String label;
  final List<RecurringTransaction> items;

  const RecurringTileGroup({
    super.key,
    required this.label,
    required this.items,
  });

  Decimal _computeTotal(Decimal Function(TimeRangeUnit) multiplier) {
    return items.fold(Decimal.zero, (sum, r) {
      final scaled = (r.transaction.value.toRational() * multiplier(r.range).toRational()).toDecimal(scaleOnInfinitePrecision: 2);
      return sum + scaled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final monthlyTotal = _computeTotal(_monthlyMultiplier);
    final yearlyTotal = _computeTotal(_yearlyMultiplier);

    return FTileGroup(
      label: Text(label),
      divider: .full,
      children: [
        ...items.map(
          (recurring) => FTile(
              prefix: TimeRangeIcon(unit: recurring.range),
              title: Text(recurring.name),
              subtitle: TagsDisplayText(selection: recurring.transaction.tags),
              suffix: ValueDisplay(value: recurring.transaction.value),
              onPress: () => showRecurringTransactionEdit(
                context,
                recurringTransaction: recurring,
              ),
          ),
        ),
        FTile(
          style: .delta(contentStyle: .delta(padding: .value(.symmetric(vertical: 4, horizontal: 8)))),
          title: Text(l10n.recurringTotalMonthly),
          details: ValueDisplay(value: monthlyTotal, isHeader: true),
        ),
        FTile(
          style: .delta(contentStyle: .delta(padding: .value(.symmetric(vertical: 4, horizontal: 8)))),
          title: Text(l10n.recurringTotalYearly),
          details: ValueDisplay(value: yearlyTotal, isHeader: true),
        )
      ],
    );
  }
}
