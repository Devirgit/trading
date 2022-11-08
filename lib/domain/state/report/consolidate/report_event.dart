part of 'report_bloc.dart';

enum EventType { load, change }

abstract class ReportEvent extends Equatable {
  const ReportEvent({
    required this.categoryUID,
  });

  final CategoryUID categoryUID;
  @override
  List<Object> get props => [categoryUID];
}

class LoadReport extends ReportEvent {
  const LoadReport(CategoryUID categoryUID) : super(categoryUID: categoryUID);
}

class ChangePerriod extends ReportEvent {
  const ChangePerriod(
    CategoryUID categoryUID, {
    required this.start,
    required this.end,
  }) : super(categoryUID: categoryUID);

  final DateTime start;
  final DateTime end;
}
