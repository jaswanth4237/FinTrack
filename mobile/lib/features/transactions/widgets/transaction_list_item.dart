import 'package:flutter/material.dart';
import 'package:mobile/features/transactions/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: transaction.categoryColor != null 
            ? Color(int.parse(transaction.categoryColor!.replaceAll('#', '0xFF')))
            : Colors.blue,
          child: Icon(
            _getIconData(transaction.categoryIcon),
            color: Colors.white,
          ),
        ),
        title: Text(
          transaction.description ?? 'No Description',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${transaction.categoryName ?? 'Uncategorized'} • ${DateFormat('MMM dd').format(transaction.transactionDate)}',
        ),
        trailing: Text(
          '${transaction.transactionType == 'income' ? '+' : '-'}${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction.transactionType == 'income' ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    // Basic mapping for demo
    switch (iconName) {
      case 'restaurant': return Icons.restaurant;
      case 'car': return Icons.directions_car;
      case 'shopping-bag': return Icons.shopping_bag;
      case 'film': return Icons.movie;
      case 'heart': return Icons.favorite;
      case 'zap': return Icons.flash_on;
      case 'briefcase': return Icons.work;
      case 'code': return Icons.code;
      case 'trending-up': return Icons.trending_up;
      default: return Icons.category;
    }
  }
}
