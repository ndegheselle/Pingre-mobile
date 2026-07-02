enum TransactionFilter { expenses, income }

class ReportFilters {
  final Set<TransactionFilter> transactionType;
  final Set<String> tagIds;

  /// When set, reports use a sliding window of the last [slidingDays] days
  /// instead of calendar-aligned periods.
  final int? slidingDays;

  const ReportFilters({
    this.transactionType = const {
      TransactionFilter.expenses,
      TransactionFilter.income,
    },
    this.tagIds = const {},
    this.slidingDays,
  });

  ReportFilters copyWith({
    Set<TransactionFilter>? transactionType,
    Set<String>? tagIds,
    int? slidingDays,
  }) {
    return ReportFilters(
      transactionType: transactionType ?? this.transactionType,
      tagIds: tagIds ?? this.tagIds,
      slidingDays: slidingDays ?? this.slidingDays,
    );
  }

  /// Returns the same filters with the sliding window disabled.
  ReportFilters withoutSliding() {
    return ReportFilters(transactionType: transactionType, tagIds: tagIds);
  }
}