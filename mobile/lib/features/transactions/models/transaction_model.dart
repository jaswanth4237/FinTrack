class TransactionModel {
  final String id;
  final String userId;
  final String accountId;
  final String categoryId;
  final double amount;
  final String transactionType;
  final String? description;
  final DateTime transactionDate;
  final bool isRecurring;
  final String? recurrenceRule;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;
  final DateTime? syncedAt;
  
  // Extra fields for UI joined data
  final String? categoryName;
  final String? accountName;
  final String? categoryIcon;
  final String? categoryColor;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.transactionType,
    this.description,
    required this.transactionDate,
    required this.isRecurring,
    this.recurrenceRule,
    required this.createdAt,
    required this.updatedAt,
    required this.syncStatus,
    this.syncedAt,
    this.categoryName,
    this.accountName,
    this.categoryIcon,
    this.categoryColor,
  });
}
