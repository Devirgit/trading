import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/core/components/input_validator.dart';
import 'package:trading/core/types/types.dart';
import 'package:trading/domain/entitis/stock_entity.dart';
import 'package:trading/domain/state/stock/form/stock_deal_bloc.dart';
import 'package:trading/internal/injection/di.dart';
import 'package:trading/presentation/forms/form.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/widgets/button.dart';
import 'package:trading/presentation/widgets/exchange_volume.dart';
import 'package:trading/presentation/widgets/info_dialogs.dart';
import 'package:trading/presentation/widgets/textfild_with_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ModalFormBuySale extends StatelessWidget {
  const ModalFormBuySale(this.initDeal,
      {Key? key,
      required this.currentPrice,
      required this.actionType,
      this.onSuccess})
      : super(key: key);

  final DealType actionType;
  final StockDealParams initDeal;
  final double currentPrice;
  final SuccessForm<StockEntity>? onSuccess;

  @override
  Widget build(BuildContext context) {
    return actionType == DealType.buy
        ? BlocProvider(
            create: (context) => StockDealBloc(
                initDeal: initDeal,
                formType: actionType,
                action: Di.get(name: 'BuyStock')),
            child: _BuyForm(
              initDeal,
              currentPrice: currentPrice,
              onSuccess: onSuccess,
            ),
          )
        : BlocProvider(
            create: (context) => StockDealBloc(
                initDeal: initDeal,
                formType: actionType,
                action: Di.get(name: 'SellStock')),
            child: _SellForm(
              initDeal,
              currentPrice: currentPrice,
              onSuccess: onSuccess,
            ),
          );
  }
}

class _BuyForm extends StatelessWidget {
  const _BuyForm(this.initDeal,
      {Key? key, this.onSuccess, required this.currentPrice})
      : super(key: key);

  final StockDealParams initDeal;
  final double currentPrice;
  final SuccessForm<StockEntity>? onSuccess;

  @override
  Widget build(BuildContext context) {
    return _DealForm.buy(
      initDeal: initDeal,
      currentPrice: currentPrice,
      onSuccess: onSuccess,
      child: BlocBuilder<StockDealBloc, StockDealState>(
        buildWhen: (previous, current) =>
            previous.calcParams != current.calcParams,
        builder: (context, state) {
          return ExchangeVolume(
            startVolume: ViewFormat.formatCostDisplay(initDeal.price,
                patern: currentPrice),
            endVolume: state.calcParams == -1
                ? '?'
                : ViewFormat.formatCostDisplay(state.calcParams,
                    patern: currentPrice),
          );
        },
      ),
    );
  }
}

class _SellForm extends StatelessWidget {
  const _SellForm(this.initDeal,
      {Key? key, this.onSuccess, required this.currentPrice})
      : super(key: key);

  final StockDealParams initDeal;
  final double currentPrice;
  final SuccessForm<StockEntity>? onSuccess;

  @override
  Widget build(BuildContext context) {
    return _DealForm.sell(
      initDeal: initDeal,
      currentPrice: currentPrice,
      onSuccess: onSuccess,
      child: BlocBuilder<StockDealBloc, StockDealState>(
        buildWhen: (previous, current) =>
            previous.calcParams != current.calcParams,
        builder: (context, state) {
          return Text(
              state.calcParams == -1
                  ? '?'
                  : ViewFormat.formatCostDisplay(state.calcParams,
                      patern: 0.00000001),
              style: TextStyle(
                  letterSpacing: 1.25,
                  color: state.calcParams < 0
                      ? UIColor.negativePositionColor
                      : UIColor.positivPositionColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600));
        },
      ),
    );
  }
}

class _DealForm extends StatelessWidget {
  const _DealForm._(
      {Key? key,
      required this.calcDataForm,
      required this.initDeal,
      this.calcDataLabel = UItext.averagePrice,
      this.priceFieldLabel = UItext.buyPrice,
      this.formType = DealType.buy,
      required this.currentPrice,
      this.onSuccess,
      this.volumeFieldLabel = UItext.buyVolume})
      : super(key: key);

  const _DealForm.buy(
      {required StockDealParams initDeal,
      required double currentPrice,
      required Widget child,
      SuccessForm<StockEntity>? onSuccess})
      : this._(
            calcDataForm: child,
            currentPrice: currentPrice,
            initDeal: initDeal,
            onSuccess: onSuccess);

  const _DealForm.sell(
      {required StockDealParams initDeal,
      required double currentPrice,
      required Widget child,
      SuccessForm<StockEntity>? onSuccess})
      : this._(
            priceFieldLabel: UItext.sellPrice,
            volumeFieldLabel: UItext.sellVolume,
            calcDataLabel: UItext.profitPrice,
            calcDataForm: child,
            formType: DealType.sell,
            currentPrice: currentPrice,
            initDeal: initDeal,
            onSuccess: onSuccess);

  final String volumeFieldLabel;
  final String priceFieldLabel;
  final Widget calcDataForm;
  final String calcDataLabel;
  final DealType formType;
  final double currentPrice;
  final StockDealParams initDeal;
  final SuccessForm<StockEntity>? onSuccess;

  @override
  Widget build(BuildContext context) {
    String? volumeError;

    return BlocListener<StockDealBloc, StockDealState>(
      listener: (context, state) {
        switch (state.status) {
          case FormValidStatus.submitInProgress:
            InfoDialogs.beginProcess(context, UItext.savingData);
            break;
          case FormValidStatus.submitSuccess:
            InfoDialogs.endProcess(context);
            if (onSuccess != null) {
              onSuccess!(context, state.changedStock);
            }
            break;
          case FormValidStatus.submitFailure:
            InfoDialogs.endProcess(context);
            break;
          default:
        }
      },
      child: ModalForm(
          child: Column(children: [
        //header form
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              const Text(
                UItext.symbolName,
                textAlign: TextAlign.left,
                style: TextStyle(
                    letterSpacing: 1.25,
                    color: UIColor.formFontColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                initDeal.symbol,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    letterSpacing: 1.25,
                    color: UIColor.fontColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        //body form
        Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 20.0),
          child: Column(children: [
            BlocBuilder<StockDealBloc, StockDealState>(
              buildWhen: (previous, current) {
                if ((current.status == FormValidStatus.error) &&
                    current.count.isNotValid) {
                  volumeError = current.count.error;
                } else {
                  volumeError = null;
                }
                return ((current.count.isNotValid) &&
                        (current.status == FormValidStatus.error)) ||
                    ((current.count != previous.count));
              },
              builder: (context, state) {
                return TextfieldWithLabel(
                  keyboardType: TextInputType.number,
                  fieldName: '_volumeField',
                  label: volumeFieldLabel,
                  hintText: UItext.volumeSH,
                  error: volumeError,
                  onChange: (value) => context
                      .read<StockDealBloc>()
                      .add(VolumeChangeEvent(type: formType, volume: value)),
                );
              },
            ),
            _PriceInput(currentPrice,
                formType: formType, fieldLabel: priceFieldLabel),
          ]),
        ),
        //calc form
        Align(
          alignment: Alignment.topLeft,
          child: Column(children: [
            Row(
              children: [
                const Text(
                  UItext.totalVolume,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      letterSpacing: 1.25,
                      color: UIColor.formFontColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                BlocBuilder<StockDealBloc, StockDealState>(
                  buildWhen: (previous, current) =>
                      previous.calcNewCount != current.calcNewCount,
                  builder: (context, state) {
                    return ExchangeVolume(
                      startVolume: ViewFormat.formatCostDisplay(initDeal.count,
                          patern: 0.00000001),
                      endVolume: state.calcNewCount == -1
                          ? '?'
                          : ViewFormat.formatCostDisplay(state.calcNewCount,
                              patern: 0.00000001),
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  calcDataLabel,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      letterSpacing: 1.25,
                      color: UIColor.formFontColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                calcDataForm
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            BlocBuilder<StockDealBloc, StockDealState>(
              buildWhen: (previous, current) {
                return (((previous.status == FormValidStatus.submitFailure) &&
                        current.status != FormValidStatus.submitFailure) ||
                    (current.status == FormValidStatus.submitFailure));
              },
              builder: (context, state) {
                if (state.status == FormValidStatus.submitFailure) {
                  return Text(
                    state.errorMessage ?? '',
                    style: TextStyle(color: Colors.red[700], fontSize: 14),
                  );
                }
                return const SizedBox(
                  height: 19,
                );
              },
            ),

            const SizedBox(
              height: 5.0,
            ),
            //submit form
            Button(
              caption: formType == DealType.buy ? UItext.buy : UItext.sell,
              color: formType == DealType.buy
                  ? UIColor.positivPositionColor
                  : UIColor.negativePositionColor,
              onClick: () {
                context.read<StockDealBloc>().add(SubmitEvent(type: formType));
              },
            )
          ]),
        ),
      ])),
    );
  }
}

class _PriceInput extends StatefulWidget {
  const _PriceInput(
    this.currentPrice, {
    required this.fieldLabel,
    required this.formType,
    Key? key,
  }) : super(key: key);

  final double currentPrice;
  final String fieldLabel;
  final DealType formType;

  @override
  _PriceInputState createState() => _PriceInputState();
}

class _PriceInputState extends State<_PriceInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? priceError;

    return BlocBuilder<StockDealBloc, StockDealState>(
      buildWhen: (previous, current) {
        if ((current.status == FormValidStatus.error) &&
            current.price.isNotValid) {
          priceError = current.price.error;
        } else {
          priceError = null;
        }
        return ((current.price.isNotValid) &&
                (current.status == FormValidStatus.error)) ||
            ((current.price != previous.price));
      },
      builder: (context, state) {
        return TextfieldWithLabel(
          keyboardType: TextInputType.number,
          fieldName: '_priceField',
          label: widget.fieldLabel,
          hintText: UItext.priceSH,
          controller: _controller,
          error: priceError,
          onChange: (value) => context
              .read<StockDealBloc>()
              .add(PriceChangeEvent(type: widget.formType, price: value)),
          labelTrailing: InkWell(
            onTap: () => {
              context.read<StockDealBloc>().add(PriceChangeEvent(
                  type: widget.formType,
                  price: widget.currentPrice.toString())),
              _controller.text = widget.currentPrice.toString()
            },
            child: Text(
              '(${UItext.currentPriceShort} ${ViewFormat.formatCostDisplay(widget.currentPrice)})',
              style: const TextStyle(
                  decoration: TextDecoration.underline,
                  color: UIColor.formFontColor,
                  fontSize: 14.0),
            ),
          ),
        );
      },
    );
  }
}
