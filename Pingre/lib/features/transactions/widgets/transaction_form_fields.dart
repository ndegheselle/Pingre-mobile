import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/common/widgets/data/error_display.dart';
import 'package:pingre/common/widgets/inputs/value_input.dart';
import 'package:pingre/features/tags/models/tags_selection.dart';
import 'package:pingre/features/tags/screens/overlay_tags_select.dart';
import 'package:pingre/features/tags/widgets/tags_display.dart';
import 'package:pingre/features/transactions/models/transaction.dart';
import 'package:pingre/l10n/app_localizations.dart';

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
  final bool readonly;

  const TransactionFormFields({
    super.key,
    required this.formData,
    this.readonly = false,
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
    final l10n = AppLocalizations.of(context)!;

    return Column(
        children: [
          ValueInput(controller: _valueController, readonly: widget.readonly),
          const SizedBox(height: 4),
          Expanded(
            child: Center(
              child: FormField<TagsSelection?>(
                initialValue: widget.formData.tags,
                validator: (value) => value == null
                    ? l10n.tagValidationError
                    : null,
                onSaved: (value) {
                  if (value != null) widget.formData.tags = value;
                },
                builder: (state) => ErrorDisplay(
                  error: state.errorText,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TagsDisplay(selection: state.value),
                      const SizedBox(height: 4),
                      if (!widget.readonly)
                        Align(
                          alignment: Alignment.center,
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
                              child: Text(l10n.selectTags),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: FDateField(
                  control: .managed(controller: _dateController),
                  enabled: !widget.readonly,
                ),
              ),
              const SizedBox(width: 4),
              SizedBox(
                width: 110,
                child: FTimeField(
                  control: .managed(controller: _timeController),
                  hour24: true,
                  enabled: !widget.readonly,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          FTextField.multiline(
            hint: l10n.notesHint,
            control: .managed(controller: _noteController),
            enabled: !widget.readonly,
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
