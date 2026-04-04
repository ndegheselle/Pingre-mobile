import 'package:forui/forui.dart';

/// A collapsible widget with a custom header and child, backed by [FAccordion].
class CollapsibleWidget extends StatelessWidget {
  final Widget title;
  final Widget child;
  final bool initiallyExpanded;
  final Widget icon;

  const CollapsibleWidget({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
    this.icon = const Icon(FIcons.chevronDown),
  });

  @override
  Widget build(BuildContext context) {
    return FAccordion(
      children: [
        FAccordionItem(
          title: title,
          icon: icon,
          initiallyExpanded: initiallyExpanded,
          child: child,
        ),
      ],
    );
  }
}
