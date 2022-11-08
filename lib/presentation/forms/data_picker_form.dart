import 'package:trading/common/ui_colors.dart';
import 'package:trading/common/ui_text.dart';
import 'package:trading/presentation/forms/form.dart';
import 'package:trading/presentation/widgets/button.dart';
import 'package:trading/presentation/widgets/data_picker_scroller.dart';
import 'package:flutter/material.dart';

class DataPickerForm extends StatefulWidget {
  const DataPickerForm(
      {Key? key,
      required this.maxDate,
      required this.minDate,
      required this.initDate,
      required this.title,
      required this.onChanged})
      : super(key: key);

  final DateTime initDate;
  final DateTime minDate;
  final DateTime maxDate;
  final String title;
  final ValueChanged<DateTime> onChanged;

  @override
  State<DataPickerForm> createState() => _DataPickerFormState();
}

class _DataPickerFormState extends State<DataPickerForm> {
  DateTime? dateSelect;

  @override
  Widget build(BuildContext context) {
    return ModalForm(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              widget.title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  letterSpacing: 1.25,
                  color: UIColor.formFontColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          DataPickerScroller(
            maxDate: widget.maxDate,
            minDate: widget.minDate,
            initDate: widget.initDate,
            onDateChanged: (value) => dateSelect = value,
          ),
          Button(
            caption: UItext.selectBtn,
            onClick: () {
              widget.onChanged(dateSelect ?? widget.initDate);
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
