import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/services/accounts.dart';

class AccountTypeIcon extends StatelessWidget {
  final AccountType type;
  final double size;

  const AccountTypeIcon({
    super.key,
    required this.type,
    this.size = 24,
  });

  IconData get _icon => switch (type) {
        AccountType.checking  => FIcons.landmark,
        AccountType.savings   => FIcons.piggyBank,
        AccountType.creditCard => FIcons.walletCards,
        AccountType.cash      => FIcons.banknote,
        AccountType.investment => FIcons.chartLine,
        AccountType.loan      => FIcons.handCoins,
        AccountType.mortgage  => FIcons.house,
      };

  @override
  Widget build(BuildContext context) => Icon(
        _icon,
        size: size,
      );
}