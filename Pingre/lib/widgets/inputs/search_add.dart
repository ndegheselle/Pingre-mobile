import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class SearchWithAdd extends StatefulWidget {
  final void Function(String) onAdd;
  final TextEditingController controller;
  final String? hint;

  const SearchWithAdd({super.key, required this.controller, required this.onAdd, this.hint});

  @override
  State<SearchWithAdd> createState() => _SearchWithAddState();
}

class _SearchWithAddState extends State<SearchWithAdd> {
  void _add() {
    widget.onAdd(widget.controller.text.trim());
    widget.controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FTextField(
            control: .managed(controller: widget.controller),
            prefixBuilder: (context, style, variants) => Padding(
              padding: .directional(start: 8),
              child: Opacity(opacity: 0.5, child: Icon(FIcons.search)),
            ),
            hint: widget.hint ?? 'Search or add ...',
            clearable: (value) => value.text.isNotEmpty,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: widget.controller,
          builder: (context, _, _) {
            final showButton = widget.controller.text.isNotEmpty;
            return AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              alignment: Alignment.centerRight,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.centerRight,
                  widthFactor: showButton ? 1.0 : 0.0,
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      FButton.icon(
                        variant: .outline,
                        onPress: _add,
                        child: const Icon(FIcons.plus),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
