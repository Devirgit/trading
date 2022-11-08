import 'package:trading/data/model/report_model.dart';
import 'package:hive_flutter/adapters.dart';

class ReportModelAdapter extends TypeAdapter<ReportModel> {
  @override
  final int typeId = 12;

  @override
  ReportModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportModel(
      investing: fields[0] as double,
      allProfit: fields[6] as double,
      avgInvest: fields[1] as double,
      avgNegativePnl: fields[5] as double,
      avgPositivePnl: fields[3] as double,
      maxProfit: fields[7] as double,
      minProfit: fields[8] as double,
      sumNegativePnl: fields[4] as double,
      sumPositivePnl: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ReportModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.investing)
      ..writeByte(1)
      ..write(obj.avgInvest)
      ..writeByte(2)
      ..write(obj.sumPositivePnl)
      ..writeByte(3)
      ..write(obj.avgPositivePnl)
      ..writeByte(4)
      ..write(obj.sumNegativePnl)
      ..writeByte(5)
      ..write(obj.avgNegativePnl)
      ..writeByte(6)
      ..write(obj.allProfit)
      ..writeByte(7)
      ..write(obj.maxProfit)
      ..writeByte(8)
      ..write(obj.minProfit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReportPeriodAdapter extends TypeAdapter<ReportPeriod> {
  @override
  final int typeId = 13;

  @override
  ReportPeriod read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportPeriod(
      endPeriod: fields[1] as DateTime,
      report: fields[2] as ReportModel,
      startPeriod: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ReportPeriod obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.startPeriod)
      ..writeByte(1)
      ..write(obj.endPeriod)
      ..writeByte(2)
      ..write(obj.report);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportPeriodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
