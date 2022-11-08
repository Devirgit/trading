import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/types/types.dart';
import 'package:flutter/material.dart';

class ChangeListState<T> {
  const ChangeListState(
      {required this.status, required this.items, this.error});

  final LoadDataStatus status;
  final List<T> items;
  final String? error;
}

typedef ListWidgetBuilder<T> = Widget Function(
    BuildContext context, int index, List<T> item);

class InfiniteList<T> extends StatefulWidget {
  const InfiniteList(
      {Key? key,
      this.onEndScroll,
      this.onRefresh,
      this.separate,
      this.controller,
      required this.itemBuilder,
      required this.changeState})
      : super(key: key);

  final VoidCallback? onRefresh;
  final VoidCallback? onEndScroll;
  final ListWidgetBuilder<T> itemBuilder;
  final ValueNotifier<ChangeListState<T>> changeState;
  final Widget? separate;
  final ScrollController? controller;

  @override
  State<InfiniteList<T>> createState() => _InfiniteListState<T>();
}

class _InfiniteListState<T> extends State<InfiniteList<T>> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();
    _controller.addListener(_onScroll);
    widget.changeState.addListener(_changeList);
  }

  void _onScroll() {
    if (_isBottom) {
      if (widget.onEndScroll != null) widget.onEndScroll!();
    }
  }

  void _changeList() {
    setState(() {});
  }

  bool get _isBottom {
    if (!_controller.hasClients) return false;
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    widget.controller ?? _controller.dispose();
    widget.changeState.removeListener(_changeList);
    super.dispose();
  }

  Widget _reloadData(String? message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(
              message ?? UItext.errorData,
              textAlign: TextAlign.center,
              style: const TextStyle(color: UIColor.h2Color),
            ),
          ),
          FloatingActionButton(
            onPressed: widget.onRefresh,
            backgroundColor: UIColor.primaryColor,
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _loadInProcess(List<T> items) {
    if (items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return _loadedData(items,
        loading: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Center(child: CircularProgressIndicator()),
        ));
  }

  Widget _loadedData(List<T> items, {Widget? loading}) {
    if (items.isEmpty) {
      return const Center(
          child: Text(
        UItext.noSearchData,
        textAlign: TextAlign.center,
        style: TextStyle(color: UIColor.h2Color),
      ));
    }
    final count = items.length;
    return ListView.separated(
      itemCount: loading == null ? count : count + 1,
      controller: _controller,
      itemBuilder: (BuildContext context, int index) {
        if ((loading != null) && (count == index)) {
          return loading;
        }
        return widget.itemBuilder(context, index, items);
      },
      separatorBuilder: (BuildContext context, int index) =>
          widget.separate ?? const Divider(),
    );
  }

  Widget _loadEmpty() {
    return const Center(
      child: Text(
        UItext.noSearchData,
        style: TextStyle(color: UIColor.h2Color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.changeState.value;
    switch (state.status) {
      case LoadDataStatus.failure:
        return _reloadData(state.error);
      case LoadDataStatus.success:
        return _loadedData(state.items);
      case LoadDataStatus.loading:
        return _loadInProcess(state.items);
      case LoadDataStatus.empty:
        return _loadEmpty();
      default:
        return _reloadData('');
    }
  }
}
