import 'package:trading/data/model/deal_model.dart';
import 'package:hive_flutter/adapters.dart';

class DealModelAdapter extends TypeAdapter<DealModel> {
  @override
  final int typeId = 6;

  @override
  DealModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DealModel(
      uid: fields[0] as int,
      count: fields[1] as double,
      price: fields[2] as double,
      typeID: fields[3] as int,
      pnl: fields[4] as double,
      volume: fields[5] as int,
      date: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DealModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.typeID)
      ..writeByte(4)
      ..write(obj.pnl)
      ..writeByte(5)
      ..write(obj.volume)
      ..writeByte(6)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DealListModelAdapter extends TypeAdapter<DealListModel> {
  @override
  final int typeId = 7;

  @override
  DealListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DealListModel(
      (fields[0] as List).cast<DealModel>(),
      nextPage: fields[2] as String?,
      prevPage: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DealListModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.items)
      ..writeByte(1)
      ..write(obj.prevPage)
      ..writeByte(2)
      ..write(obj.nextPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DealListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
