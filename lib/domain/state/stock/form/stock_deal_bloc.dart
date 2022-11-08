import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/input_validator.dart';
import 'package:trading/core/components/validator/input_num.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/state/bloc_transform.dart';
import 'package:trading/domain/usecases/interface/sell_buy_operation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'stock_deal_event.dart';
part 'stock_deal_state.dart';

const _duration = Duration(milliseconds: 300);

class StockDealBloc extends Bloc<StockDealEvent, StockDealState> {
  StockDealBloc(
      {required StockDealParams initDeal,
      required SellBuyUC action,
      required DealType formType})
      : _formType = formType,
        _initParams = initDeal,
        _actionForm = action,
        super(const StockDealState()) {
    on<VolumeChangeEvent>(_onVolumeChanged, transformer: debounce(_duration));
    on<PriceChangeEvent>(_onPriceChanged, transformer: debounce(_duration));
    on<SubmitEvent>(_onSubmit);
  }
  final StockDealParams _initParams;
  final DealType _formType;
  final SellBuyUC _actionForm;

  double _calculateNewCount(double val) {
    return _formType == DealType.buy
        ? _initParams.count + val
        : _initParams.count - val;
  }

  double _calcAVGPrice(double buyPrice, double buyCount) {
    return (_initParams.count * _initParams.price + buyCount * buyPrice) /
        (_initParams.count + buyCount);
  }

  double _calcPNL(double sellPrice, double sellCount) {
    return sellCount * sellPrice - sellCount * _initParams.price;
  }

  double _calcParams(double dealPrice, double dealCount) {
    return _formType == DealType.buy
        ? _calcAVGPrice(dealPrice, dealCount)
        : _calcPNL(dealPrice, dealCount);
  }

  void _onVolumeChanged(
    VolumeChangeEvent event,
    Emitter<StockDealState> emit,
  ) {
    final count = InputNum.dirty(event.volume);
    final newCount = _calculateNewCount(count.clearValue);

    emit(state.copyWith(
        calcNewCount: count.clearValue == 0 ? -1 : newCount,
        calcParams: (state.price.clearValue == 0) || (count.clearValue == 0)
            ? -1
            : _calcParams(state.price.clearValue, count.clearValue),
        count: count,
        status: FormValidate.status([state.price, count]),
        errorMessage: newCount < 0 ? UItext.notCalcCount : null));
  }

  void _onPriceChanged(
    PriceChangeEvent event,
    Emitter<StockDealState> emit,
  ) {
    final price = InputNum.dirty(event.price);
    emit(state.copyWith(
        calcParams: (price.clearValue == 0) || (state.calcNewCount == -1)
            ? -1
            : _calcParams(price.clearValue, state.count.clearValue),
        price: price,
        status: FormValidate.status([state.count, price])));
  }

  Future<void> _onSubmit(
    SubmitEvent event,
    Emitter<StockDealState> emit,
  ) async {
    if (state.status == FormValidStatus.valid) {
      emit(state.copyWith(status: FormValidStatus.submitInProgress));

      if (state.calcNewCount < 0) {
        return emit(state.copyWith(
            status: FormValidStatus.submitFailure,
            errorMessage: UItext.notCalcCount));
      }

      final respons = await _actionForm(StockDealParams(
          categoryUID: _initParams.categoryUID,
          count: state.count.clearValue,
          price: state.price.clearValue,
          symbol: _initParams.symbol,
          symbolID: _initParams.symbolID,
          stockUID: _initParams.stockUID));
      respons.result(
          (error) => emit(state.copyWith(
              status: FormValidStatus.submitFailure,
              errorMessage: error.message)), (stock) {
        emit(StockDealState.success(stock));
      });
    } else {
      if (state.status == FormValidStatus.invalid) {
        emit(state.copyWith(status: FormValidStatus.error));
      }
    }
  }
}
