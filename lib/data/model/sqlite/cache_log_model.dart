enum LogOperation { create, update, delete }

extension LogOperationX on LogOperation {
  int get type {
    switch (this) {
      case LogOperation.create:
        return 2;
      case LogOperation.delete:
        return 1;
      case LogOperation.update:
        return 3;
    }
  }
}

class CacheLogModel {
  CacheLogModel(
      {required this.tableName,
      required this.operation,
      required this.itemId,
      this.synchronized = 0});

  final LogOperation operation;
  final String tableName;
  final int itemId;
  final int synchronized;

  Map<String, dynamic> toJson() {
    return {
      'operation': operation.index,
      'table_name': tableName,
      'itemid': itemId,
      'date': DateTime.now().microsecondsSinceEpoch,
      'synchronized': synchronized
    };
  }
}
