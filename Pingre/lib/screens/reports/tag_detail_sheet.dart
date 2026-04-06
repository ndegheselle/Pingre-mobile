import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:pingre/models/time_range.dart';
import 'package:pingre/services/tags.dart';
import 'package:pingre/services/transactions.dart';
import 'package:pingre/widgets/data/transaction_summary.dart';
import 'package:pingre/widgets/layout/sheet_container.dart';
import 'package:provider/provider.dart';

/// Show a draggable bottom sheet listing all transactions for [tag] in [range].
Future<void> showTagDetailSheet(
  BuildContext context, {
  required Tag tag,
  required TimeRange range,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => _TagDetailSheet(
        tag: tag,
        range: range,
        scrollController: scrollController,
      ),
    ),
  );
}

class _TagDetailSheet extends StatefulWidget {
  final Tag tag;
  final TimeRange range;
  final ScrollController scrollController;

  const _TagDetailSheet({
    required this.tag,
    required this.range,
    required this.scrollController,
  });

  @override
  State<_TagDetailSheet> createState() => _TagDetailSheetState();
}

class _TagDetailSheetState extends State<_TagDetailSheet> {
  late Future<List<Transaction>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Transaction>> _load() async {
    final service = context.read<TransactionsService>();
    final all = await service.getByRange(widget.range);
    return all
        .where((t) => t.tags.all.any((tag) => tag.id == widget.tag.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SheetContainer(
      title: widget.tag.name,
      scrollController: widget.scrollController,
      child: FutureBuilder<List<Transaction>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: FCircularProgress());
          }

          final transactions = snapshot.data!;

          if (transactions.isEmpty) {
            return Center(
              child: Text(
                'No transactions for this tag',
                style: context.theme.typography.base,
              ),
            );
          }

          return ListView.builder(
            controller: widget.scrollController,
            itemCount: transactions.length,
            itemBuilder: (context, index) =>
                TransactionSummary(transaction: transactions[index]),
          );
        },
      ),
    );
  }
}
