import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/export_utils.dart';
import 'package:mobile/features/transactions/models/transaction_model.dart';

import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => '.';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUpAll(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  group('exportTransactionsToCSV', () {
    final transactions = [
      TransactionModel(
        id: '1',
        userId: 'u1',
        accountId: 'a1',
        categoryId: 'c1',
        transactionDate: DateTime(2023, 10, 1),
        description: 'Groceries',
        categoryName: 'Food',
        transactionType: 'expense',
        amount: 50.0,
        accountName: 'Bank',
        isRecurring: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 'synced',
      ),
      TransactionModel(
        id: '2',
        userId: 'u1',
        accountId: 'a1',
        categoryId: 'c2',
        transactionDate: DateTime(2023, 10, 2),
        description: 'Salary',
        categoryName: 'Job',
        transactionType: 'income',
        amount: 5000.0,
        accountName: 'Bank',
        isRecurring: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 'synced',
      ),
    ];

    test('The returned file path ends with .csv', () async {
      final path = await exportTransactionsToCSV(transactions, 'INR');
      expect(path.endsWith('.csv'), true);
    });

    test('The CSV content contains the header row with columns in the correct order', () async {
      final path = await exportTransactionsToCSV(transactions, 'INR');
      final content = await File(path).readAsString();
      expect(content.startsWith('date,description,category,type,amount,account,currency'), true);
    });

    test('The CSV contains the correct number of data rows matching the input list length', () async {
      final path = await exportTransactionsToCSV(transactions, 'INR');
      final content = await File(path).readAsString();
      final lines = content.trim().split('\n');
      expect(lines.length, transactions.length + 1); // +1 for header
    });
  });
}
