enum TransactionFilter { expenses, income }

class ReportFilters {
  final Set<TransactionFilter> transactionType;
  final Set<String> tagIds;

  const ReportFilters({
    this.transactionType = const {
      TransactionFilter.expenses,
      TransactionFilter.income,
    },
    this.tagIds = const {},
  });

  ReportFilters copyWith({
    Set<TransactionFilter>? transactionType,
    Set<String>? tagIds,
  }) {
    return ReportFilters(
      transactionType: transactionType ?? this.transactionType,
      tagIds: tagIds ?? this.tagIds,
    );
  }
}