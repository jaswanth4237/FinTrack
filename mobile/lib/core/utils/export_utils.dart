import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile/features/transactions/models/transaction_model.dart';

Future<String> exportTransactionsToCSV(
  List<TransactionModel> transactions,
  String currencyCode,
) async {
  final directory = await getApplicationDocumentsDirectory();
  final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final filePath = '${directory.path}/fintrack_export_$dateStr.csv';
  final file = File(filePath);

  final header = 'date,description,category,type,amount,account,currency\n';
  final buffer = StringBuffer(header);

  String escapeCSVField(String val) {
    if (val.contains(',') || val.contains('"') || val.contains('\n') || val.contains('\r')) {
      return '"${val.replaceAll('"', '""')}"';
    }
    return val;
  }

  for (var t in transactions) {
    final date = DateFormat('yyyy-MM-dd').format(t.transactionDate);
    final desc = escapeCSVField(t.description ?? '');
    final cat = escapeCSVField(t.categoryName ?? '');
    final acc = escapeCSVField(t.accountName ?? '');
    
    buffer.write('$date,$desc,$cat,${t.transactionType},${t.amount},$acc,$currencyCode\n');
  }

  await file.writeAsString(buffer.toString());
  return filePath;
}
