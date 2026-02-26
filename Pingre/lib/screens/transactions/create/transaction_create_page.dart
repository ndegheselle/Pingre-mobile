import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/transactions/create/tags.dart';
import 'package:pingre/screens/transactions/create/value_input.dart';

class TransactionCreatePage extends StatefulWidget {
  const TransactionCreatePage({super.key});

  @override
  State<TransactionCreatePage> createState() => _TransactionCreatePageState();
}

class _TransactionCreatePageState extends State<TransactionCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
      ),
      child: Padding(
        padding: const .all(8),
        child: Column(
          children: [
            ValueInput(),
            SizedBox(height: 4),
            Tags(),
            SizedBox(height: 4),
            FTextField.multiline(hint: 'Notes ...'),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: FDateField(
                    control: .managed(initial: .now()),
                    clearable: true,
                  ),
                ),
                SizedBox(width: 4),
                SizedBox(
                  width: 100,
                  child: FTimeField(
                    control: .managed(initial: .now()),
                    hour24: true,
                  ),
                ),
              ],
            ),
            Spacer(),
            FButton(
              size: .lg,
              onPress: () => {},
              prefix: Icon(FIcons.plus),
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
