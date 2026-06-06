import 'dart:async';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobile/core/database/app_database.dart';
import 'package:mobile/core/di/injection.dart';

enum SyncStatus { idle, syncing, error }

@singleton
class SyncManager {
  final AppDatabase _db = getIt<AppDatabase>();
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  
  SyncStatus _currentStatus = SyncStatus.idle;
  int _pendingCount = 0;
  DateTime? _lastSyncedAt;

  SyncManager() {
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        syncNow();
      }
    });
    _updatePendingCount();
  }

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;
  int get pendingCount => _pendingCount;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  Future<void> syncNow() async {
    if (_currentStatus == SyncStatus.syncing) return;
    
    _currentStatus = SyncStatus.syncing;
    _syncStatusController.add(_currentStatus);

    try {
      final pending = await _db.transactionsDao.getPendingTransactions();
      for (var t in pending) {
        // Mock sync logic: In real app, call API
        // For now, just mark as synced
        await _db.transactionsDao.updateTransaction(
          t.copyWith(
            syncStatus: 'synced', 
            syncedAt: Value(DateTime.now().millisecondsSinceEpoch)
          )
        );
      }
      
      _lastSyncedAt = DateTime.now();
      _currentStatus = SyncStatus.idle;
      await _updatePendingCount();
    } catch (e) {
      _currentStatus = SyncStatus.error;
    } finally {
      _syncStatusController.add(_currentStatus);
    }
  }

  Future<void> _updatePendingCount() async {
    final pending = await _db.transactionsDao.getPendingTransactions();
    _pendingCount = pending.length;
  }
}
