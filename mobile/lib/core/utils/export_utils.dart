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

  for (var t in transactions) {
    final date = DateFormat('yyyy-MM-dd').format(t.transactionDate);
    final descValue = t.description ?? '';
    final desc = descValue.contains(',') ? '"$descValue"' : descValue;
    final catValue = t.categoryName ?? '';
    final cat = catValue.contains(',') ? '"$catValue"' : catValue;
    final accValue = t.accountName ?? '';
    final acc = accValue.contains(',') ? '"$accValue"' : accValue;
    
    buffer.write('$date,$desc,$cat,${t.transactionType},${t.amount},$acc,$currencyCode\n');
  }

  await file.writeAsString(buffer.toString());
  return filePath;
}
