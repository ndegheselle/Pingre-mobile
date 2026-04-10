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
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: .center,
              children: [
                Padding(
                  padding: .only(top: 4),
                  child: Text(
                    title,
                    style: context.theme.typography.xl.copyWith(
                      fontWeight: .bold,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  child: Container(
                    width: 40,
                    height: 6,
                    decoration: BoxDecoration(
                      color: context.theme.colors.border,
                      borderRadius: context.theme.style.borderRadius,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: FButton.icon(
                    variant: .ghost,
                    onPress: () => Navigator.of(context).pop(),
                    child: Icon(FIcons.x),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(padding: const .all(4), child: child),
          ),
        ],
      ),
    );
  }
}
