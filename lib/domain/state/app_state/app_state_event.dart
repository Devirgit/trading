part of 'app_state.dart';

abstract class AppStateEvent extends Equatable {
  const AppStateEvent();
  @override
  List<Object> get props => [];
}

class RequestBuyStock extends AppStateEvent {
  const RequestBuyStock({required this.categoryUID});
  final CategoryUID categoryUID;

  @override
  List<Object> get props => [categoryUID];
}

class AddStock extends RequestBuyStock {
  const AddStock({required CategoryUID categoryUID, required this.symbol})
      : super(categoryUID: categoryUID);

  final PriceEntity symbol;
  @override
  List<Object> get props => [symbol, categoryUID];
}

class ChangeStock extends RequestBuyStock {
  const ChangeStock({required CategoryUID categoryUID, required this.stock})
      : super(categoryUID: categoryUID);

  final StockEntity stock;
  @override
  List<Object> get props => [stock, categoryUID];
}
