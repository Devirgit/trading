import 'package:equatable/equatable.dart';

class PageListEntitis<T> extends Equatable {
  const PageListEntitis(this.items, {this.nextPage, this.prevPage});

  final List<T> items;
  final String? prevPage;
  final String? nextPage;

  @override
  List<Object?> get props => [items, prevPage, nextPage];
}
