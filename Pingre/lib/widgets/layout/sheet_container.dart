import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// A container widget for bottom sheets with a styled background,
/// top border, title (top left), and close button (top right).
class SheetContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const SheetContainer({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .infinity,
      width: .infinity,
      decoration: BoxDecoration(
        color: context.theme.colors.background,
        border: Border(top: BorderSide(color: context.theme.colors.border)),
        borderRadius: BorderRadius.only(
          topLeft: context.theme.style.borderRadius.topLeft,
          topRight: context.theme.style.borderRadius.topRight,
        ),
      ),
      child: Padding(
        padding: const .only(left: 8, right: 8, bottom: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: context.theme.typography.xl.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(FIcons.x, color: context.theme.colors.foreground),
                ),
              ],
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
