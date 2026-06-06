import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/transactions/models/transaction_model.dart';

class CreateTransactionData {
  final String accountId;
  final String categoryId;
  final double amount;
  final String transactionType;
  final String description;
  final DateTime transactionDate;
  final bool isRecurring;
  final String? recurrenceRule;

  CreateTransactionData({
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.transactionType,
    required this.description,
    required this.transactionDate,
    this.isRecurring = false,
    this.recurrenceRule,
  });
}

class UpdateTransactionData {
  final String? accountId;
  final String? categoryId;
  final double? amount;
  final String? transactionType;
  final String? description;
  final DateTime? transactionDate;
  final bool? isRecurring;
  final String? recurrenceRule;

  UpdateTransactionData({
    this.accountId,
    this.categoryId,
    this.amount,
    this.transactionType,
    this.description,
    this.transactionDate,
    this.isRecurring,
    this.recurrenceRule,
  });
}

class TransactionFilter {
  final String? accountId;
  final String? categoryId;
  final String? transactionType;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  TransactionFilter({
    this.accountId,
    this.categoryId,
    this.transactionType,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });
}

class TransactionsState {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final bool hasMore;
  final String? errorMessage;

  TransactionsState({
    required this.transactions,
    this.isLoading = false,
    this.hasMore = true,
    this.errorMessage,
  });

  TransactionsState copyWith({
    List<TransactionModel>? transactions,
    bool? isLoading,
    bool? hasMore,
    String? errorMessage,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit() : super(TransactionsState(transactions: []));

  Future<void> loadTransactions({int page = 1, TransactionFilter? filter}) async {
    emit(state.copyWith(isLoading: true));
    // Simulation
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(isLoading: false));
  }

  Future<void> createTransaction(CreateTransactionData data) async {
    emit(state.copyWith(isLoading: true));
    // Implementation would call repository and invalidate cache or update local state
    emit(state.copyWith(isLoading: false));
  }

  Future<void> updateTransaction(String id, UpdateTransactionData data) async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(isLoading: false));
  }

  Future<void> deleteTransaction(String id) async {
    emit(state.copyWith(isLoading: true));
    // After deletion, update state
    final updatedList = state.transactions.where((t) => t.id != id).toList();
    emit(state.copyWith(isLoading: false, transactions: updatedList));
  }

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;
    // Load next page
  }
}
