import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/presentation/forms/data_picker_form.dart';
import 'package:trading/presentation/forms/form.dart';
import 'package:trading/presentation/misc/display_transformation.dart';
import 'package:trading/presentation/widgets/button.dart';
import 'package:flutter/material.dart';

class DatePeriod {
  const DatePeriod(this.sart, this.end);
  final DateTime sart;
  final DateTime end;
}

class FormSelectPeriod extends StatefulWidget {
  const FormSelectPeriod(
      {Key? key, this.startPeriod, this.endPeriod, required this.onChanged})
      : super(key: key);

  final ValueChanged<DatePeriod> onChanged;
  final DateTime? startPeriod;
  final DateTime? endPeriod;

  @override
  State<FormSelectPeriod> createState() => _FormSelectPeriodState();
}

class _FormSelectPeriodState extends State<FormSelectPeriod> {
  late DateTime startPeriod;
  late DateTime endPeriod;

  @override
  void initState() {
    super.initState();
    endPeriod = widget.endPeriod ?? DateTime.now();
    startPeriod = widget.startPeriod ??
        DateTime(endPeriod.year, endPeriod.month - 3, endPeriod.day);
  }

  @override
  Widget build(BuildContext context) {
    return ModalForm(
      child: Column(children: [
        const Align(
          alignment: Alignment.topLeft,
          child: Text(
            UItext.selectPeriod,
            textAlign: TextAlign.left,
            style: TextStyle(
                letterSpacing: 1.25,
                color: UIColor.formFontColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              _ClickTextField(
                hintText: ViewFormat.formatingDate(startPeriod),
                label: UItext.beginPeriod,
                onClick: () => Forms.show(
                    context,
                    DataPickerForm(
                      title: UItext.endPeriod.toUpperCase(),
                      maxDate: DateTime.now(),
                      minDate: DateTime(DateTime.now().year - 3),
                      initDate: startPeriod,
                      onChanged: (startDate) {
                        startPeriod = startDate;
                        setState(() {});
                      },
                    )),
              ),
              _ClickTextField(
                hintText: ViewFormat.formatingDate(endPeriod),
                label: UItext.endPeriod,
                onClick: () => Forms.show(
                    context,
                    DataPickerForm(
                      title: UItext.endPeriod.toUpperCase(),
                      maxDate: DateTime.now(),
                      minDate: DateTime(DateTime.now().year - 3),
                      initDate: endPeriod,
                      onChanged: (endDate) {
                        endPeriod = endDate;
                        setState(() {});
                      },
                    )),
              ),
            ],
          ),
        ),
        Button(
            caption: UItext.selectBtn,
            onClick: () {
              widget.onChanged(DatePeriod(startPeriod, endPeriod));
              Forms.close(context);
            })
      ]),
    );
  }
}

class _ClickTextField extends StatelessWidget {
  const _ClickTextField(
      {Key? key,
      required this.hintText,
      required this.label,
      required this.onClick})
      : super(key: key);
  final String label;
  final String hintText;
  final GestureTapCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(
                label,
                style: const TextStyle(
                    color: UIColor.formFontColor, fontSize: 14.0),
              )),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: onClick,
            child: Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: UIColor.formFontColor,
                  )),
              child: Padding(
                padding: const EdgeInsets.only(top: 14, left: 10),
                child: Text(
                  hintText,
                  style: const TextStyle(
                      color: UIColor.formFontColor, fontSize: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
