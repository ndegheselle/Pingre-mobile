import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: FSelect<String>.rich(
              hint: 'Type',
              format: (s) => s,
              children: [
                FSelectItem(
                  prefix: const Icon(FIcons.bug),
                  title: const Text('Bug'),
                  subtitle: const Text('An unexpected problem or behavior'),
                  value: 'Bug',
                ),
                FSelectItem(
                  prefix: const Icon(FIcons.file),
                  title: const Text('Feature'),
                  subtitle: const Text('A new feature or enhancement'),
                  value: 'Feature',
                ),
                FSelectItem(
                  prefix: const Icon(FIcons.messageCircleQuestionMark),
                  title: const Text('Question'),
                  subtitle: const Text('A question or clarification'),
                  value: 'Question',
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            height: 38,
            width: 38,
            child: FButton.icon(onPress: () {}, child: const Icon(FIcons.plus)),
          ),
        ],
      ),
    ],
  );
}
