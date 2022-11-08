import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/state/data_list/data_list_bloc.dart';
import 'package:trading/domain/usecases/interface/data_list_operation.dart';
import 'package:trading/presentation/widgets/box_decor.dart';
import 'package:trading/presentation/widgets/infinite_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataListWidget<T> extends StatefulWidget {
  const DataListWidget(
      {Key? key,
      required this.getAllData,
      required this.searchData,
      required this.itemBuilder,
      this.header})
      : super(key: key);

  final GetDataUC getAllData;
  final SearchDataUC searchData;
  final ListWidgetBuilder<T> itemBuilder;
  final Widget? header;

  @override
  State<DataListWidget<T>> createState() => _DataListWidgetState<T>();
}

class _DataListWidgetState<T> extends State<DataListWidget<T>> {
  final TextEditingController _searchController = TextEditingController();
  late final ValueNotifier<ChangeListState<T>> _changeState;

  @override
  void initState() {
    super.initState();
    _changeState = ValueNotifier(
        const ChangeListState(items: [], status: LoadDataStatus.empty));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _changeState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataListBloc<T>(
          getAllData: widget.getAllData, searchData: widget.searchData)
        ..add(const LoadListData()),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<DataListBloc<T>, DataListState<T>>(
            buildWhen: (previous, current) =>
                current.search == null && previous.search != null,
            builder: (context, state) {
              return TextFormField(
                controller: _searchController,
                initialValue: state.search,
                onChanged: (value) {
                  context.read<DataListBloc<T>>().add(SearchChanged(value));
                },
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: UItext.search),
              );
            },
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<DataListBloc<T>, DataListState<T>>(
              buildWhen: (previous, current) =>
                  (current.search != null && previous.search == null) ||
                  (current.search == null && previous.search != null),
              builder: (context, state) {
                return IconButton(
                  icon: Icon(state.search == null ? Icons.search : Icons.clear),
                  color: Colors.white,
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<DataListBloc<T>>()
                        .add(const SearchChanged(''));
                  },
                );
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BoxDecor(
            child: BlocListener<DataListBloc<T>, DataListState<T>>(
              listener: (context, state) {
                _changeState.value = ChangeListState<T>(
                    items: state.items,
                    status: state.status,
                    error: state.errorMessage);
              },
              child: Builder(builder: (context) {
                final bloc = context.read<DataListBloc<T>>();
                return Column(
                  children: [
                    if (widget.header != null) widget.header!,
                    Expanded(
                      child: InfiniteList<T>(
                        onEndScroll: () => bloc.add(const LoadListData()),
                        onRefresh: () => bloc.add(const ReloadListData()),
                        changeState: _changeState,
                        separate: const SizedBox(
                          width: 1,
                        ),
                        itemBuilder: widget.itemBuilder,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
