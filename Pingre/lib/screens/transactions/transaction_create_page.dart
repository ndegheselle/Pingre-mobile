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
              Expanded(child: Tags()),
              SizedBox(height: 4),
              FTextField.multiline(label: const Text('Notes')),
              SizedBox(height: 4),
              SizedBox(height: 60, child: Row(
                children: [
                  Expanded(
                    child: FDateField(
                      label: const Text("Date"),
                      control: .managed(initial: .now()),
                      clearable: true,
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: FTimeField(
                      label: const Text("Time"),
                      control: .managed(initial: .now()),
                      hour24: true,
                    ),
                  ),
                ],
              )),
              SizedBox(height: 8),
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
