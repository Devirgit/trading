import 'package:trading/data/model/stock_model.dart';
import 'package:hive_flutter/adapters.dart';

class StockModelAdapter extends TypeAdapter<StockModel> {
  @override
  final int typeId = 5;

  @override
  StockModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockModel(
      uid: fields[1] as int,
      categoryUID: fields[2] as int,
      count: fields[5] as double,
      symbol: fields[3] as String,
      price: fields[6] as double,
      iconUri: fields[7] as String,
      symbolID: fields[4] as String,
      categoryName: fields[8] as String,
      updateDate: fields[9] as DateTime,
      currentPrice: fields[10] as double,
      pnl: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, StockModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.categoryUID)
      ..writeByte(3)
      ..write(obj.symbol)
      ..writeByte(4)
      ..write(obj.symbolID)
      ..writeByte(5)
      ..write(obj.count)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.iconUri)
      ..writeByte(8)
      ..write(obj.categoryName)
      ..writeByte(9)
      ..write(obj.updateDate)
      ..writeByte(10)
      ..write(obj.currentPrice)
      ..writeByte(11)
      ..write(obj.pnl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
