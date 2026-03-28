import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ErrorDisplay extends StatelessWidget {
  final String? error;
  final Widget? child;

  const ErrorDisplay({super.key, required this.child, this.error});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            decoration: BoxDecoration(
              border: error?.isNotEmpty == true
                  ? Border.all(color: context.theme.colors.error, width: 1)
                  : null,
              borderRadius: context.theme.style.borderRadius,
            ),
            child: child,
          ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1,
                child: child,
              ),
            );
          },
          child: error != null
              ? Padding(padding: .directional(top: 4), child: Text(
                  error!,
                  style: context.theme.typography.sm.copyWith(
                    color: context.theme.colors.error,
                    fontWeight: .w600,
                  ),
                ))
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
