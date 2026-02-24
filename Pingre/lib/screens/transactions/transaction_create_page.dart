import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/transactions/tags.dart';
import 'package:pingre/screens/transactions/value_input.dart';


class TransactionCreatePage extends StatefulWidget {
  const TransactionCreatePage({super.key});

  @override
  State<TransactionCreatePage> createState() => _TransactionCreatePageState();
}

class _TransactionCreatePageState extends State<TransactionCreatePage> {
  @override
  Widget build(BuildContext context) {
    final theme = FTheme.of(context);

    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
      ),
      child: Padding(
        padding: const .all(4),
        child: Center(
          child: Column(
            children: [
              ValueInput(),
              SizedBox(height: 4),
              Tags(),
              Expanded(child: Text("fa")),
              FButton(
                onPress: () => {},
                prefix: Icon(FIcons.plus),
                child: const Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
