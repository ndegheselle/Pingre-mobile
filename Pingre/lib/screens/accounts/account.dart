import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

class Metadata
{
  final String name;
  final String description;
  final Color color;
  final IconData icon;

  Metadata({
    required this.name,
    required this.description,
    required this.color,
    required this.icon
  });
}

/// Represent a bank account
class Account {
  final String id;
  final Metadata metadata;
  Decimal balance;
  final List<Transaction> transactions;

  Account({
    required this.id,
    required this.metadata,
    Decimal? balance,
    List<Transaction>? transactions,
  }) : balance = balance ?? Decimal.zero,
       transactions = transactions ?? [];

  void addTransaction(Transaction transaction) {
    transactions.add(transaction);
    balance += transaction.amount;
  }
}

/// Transaction category (e.g. Food, Rent, Salary)
class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
}

/// A line of transaction in an account
class Transaction {
  final String id;
  final DateTime date;
  final Decimal amount;
  final String description;
  final Category? category;
  final List<String> tags;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    this.description = '',
    this.category,
    List<String>? tags,
  }) : tags = tags ?? [];
}

/// Type of recurrence for a recurrent transaction
enum EnumRecurrence {
  daily,
  weekly,
  biWeekly,
  monthly,
  biMonthly,
  quarter,
  semester,
  yearly,
}

/// Transaction that can be repeated
class RecurrentTransaction extends Transaction {
  final EnumRecurrence recurrence;
  final DateTime startDate;
  final DateTime? endDate;

  RecurrentTransaction({
    required super.id,
    required super.date,
    required super.amount,
    super.description = '',
    super.category,
    required this.recurrence,
    required this.startDate,
    this.endDate,
  });

  bool isActiveOn(DateTime date) {
    if (date.isBefore(startDate)) return false;
    if (endDate != null && date.isAfter(endDate!)) return false;
    return true;
  }
}
