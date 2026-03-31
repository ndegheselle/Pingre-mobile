import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/screens/tags/tags_display.dart';
import 'package:pingre/screens/tags/tags_select.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/data/error_display.dart';
import 'package:pingre/widgets/inputs/value_input.dart';

class TransactionFormData {
  Decimal value;
  TagsSelection? tags;
  DateTime date;
  String notes;

  TransactionFormData({
    required this.value,
    required this.date,
    this.tags,
    this.notes = "",
  });

  factory TransactionFormData.fromTransaction(Transaction? tx) {
    final now = DateTime.now();
    return TransactionFormData(
      value: tx?.value ?? Decimal.fromInt(-1),
      date: tx?.date ?? now,
      tags: tx?.tags,
      notes: tx?.notes ?? "",
    );
  }
}

class TransactionFormFields extends StatefulWidget {
  final TransactionFormData formData;

  const TransactionFormFields({
    super.key,
    required this.formData,
  });

  @override
  State<TransactionFormFields> createState() => _TransactionFormFieldsState();
}

class _TransactionFormFieldsState extends State<TransactionFormFields> {
  late TextEditingController _noteController;
  late FTimeFieldController _timeController;
  late FDateFieldController _dateController;
  late NumberValueController _valueController;

  @override
  void initState() {
    super.initState();

    final d = widget.formData.date;

    _valueController = NumberValueController(widget.formData.value);
    _dateController = FDateFieldController(date: d);
    _timeController = FTimeFieldController(time: FTime(d.hour, d.minute));
    _noteController = TextEditingController(text: widget.formData.notes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          ValueInput(controller: _valueController),
          const SizedBox(height: 4),
          Expanded(
            child: Center(
              child: FormField<TagsSelection?>(
                initialValue: widget.formData.tags,
                validator: (value) => value == null
                    ? "At least one tag should be selected."
                    : null,
                onSaved: (value) {
                  if (value != null) widget.formData.tags = value;
                },
                builder: (state) => ErrorDisplay(
                  error: state.errorText,
                  child: Column(
                    children: [
                      TagsDisplay(selection: state.value),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 150,
                        child: FButton(
                          size: .sm,
                          variant: .secondary,
                          onPress: () async {
                            final selection = await showTagsSelect(
                              context,
                              initialSelection: state.value,
                            );
                            if (selection != null) {
                              state.didChange(selection);
                            }
                          },
                          prefix: const Icon(FIcons.tag),
                          child: const Text("Select tags"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FTextField.multiline(
            hint: 'Notes',
            control: .managed(controller: _noteController),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: FDateField(control: .managed(controller: _dateController)),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 110,
                child: FTimeField(
                  control: .managed(controller: _timeController),
                  hour24: true,
                ),
              ),
            ],
          ),
          // Hidden FormField to sync remaining controllers on save
          FormField<void>(
            onSaved: (_) {
              final date = _dateController.value;
              final time = _timeController.value;
              if (date != null && time != null) {
                widget.formData.date = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );
              }
              widget.formData.value = _valueController.value;
              widget.formData.notes = _noteController.text;
            },
            builder: (state) => const SizedBox.shrink(),
          ),
        ],
    );
  }
}
