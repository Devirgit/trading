part of 'data_list_bloc.dart';

abstract class ListDataEvent extends Equatable {
  const ListDataEvent();

  @override
  List<Object> get props => [];
}

class LoadListData extends ListDataEvent {
  const LoadListData();

  @override
  List<Object> get props => [];
}

class ReloadListData extends ListDataEvent {
  const ReloadListData();

  @override
  List<Object> get props => [];
}

class SearchChanged extends ListDataEvent {
  const SearchChanged(this.text);

  final String text;

  @override
  List<Object> get props => [text];
}
