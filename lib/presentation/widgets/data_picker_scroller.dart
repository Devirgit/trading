import 'package:trading/common/ui_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class PickerWidget extends StatelessWidget {
  PickerWidget({
    Key? key,
    required this.scrollController,
    this.itemExtent = 40,
    required this.onSelectedItemChanged,
    required List<Widget> children,
    bool looping = false,
  })  : childDelegate = looping
            ? ListWheelChildLoopingListDelegate(children: children)
            : ListWheelChildListDelegate(children: children),
        super(key: key);

  final FixedExtentScrollController scrollController;
  final ValueChanged<int> onSelectedItemChanged;
  final double itemExtent;
  final ListWheelChildDelegate childDelegate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 80,
        height: 190,
        child: ListWheelScrollView.useDelegate(
            itemExtent: itemExtent,
            diameterRatio: 1,
            controller: scrollController,
            onSelectedItemChanged: onSelectedItemChanged,
            physics: const FixedExtentScrollPhysics(),
            childDelegate: childDelegate));
  }
}

class DataPickerScroller extends StatefulWidget {
  const DataPickerScroller({
    Key? key,
    required this.maxDate,
    required this.minDate,
    required this.onDateChanged,
    this.disabledColor = Colors.grey,
    TextStyle? style,
    DateTime? initDate,
  })  : initDate = initDate ?? maxDate,
        style = const TextStyle(fontSize: 20, color: Colors.white),
        super(key: key);

  final DateTime initDate;
  final DateTime minDate;
  final DateTime maxDate;
  final ValueChanged<DateTime> onDateChanged;
  final TextStyle style;
  final Color disabledColor;

  @override
  State<DataPickerScroller> createState() => _DataPickerScrollerState();
}

class _DataPickerScrollerState extends State<DataPickerScroller> {
  late int selectedDay;
  late int selectedMonth;
  late int indexSelectedYear;

  late FixedExtentScrollController dayController;
  late FixedExtentScrollController monthController;
  late FixedExtentScrollController yearController;

  bool isDayPickerScrolling = false;
  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;
  bool isMonthCorrectScrolling = false;
  bool isDayCorrectScrolling = false;
  late int oldDaysInMonth;

  bool get isScrolling =>
      isDayPickerScrolling || isMonthPickerScrolling || isYearPickerScrolling;

  bool get _isCurrentDateValid {
    final DateTime minSelectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay);
    final DateTime maxSelectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay + 1);

    final bool minCheck = widget.minDate.isBefore(maxSelectedDate);
    final bool maxCheck = widget.maxDate.isBefore(minSelectedDate);

    return minCheck && !maxCheck && minSelectedDate.day == selectedDay;
  }

  int dayControllerIndex = 0;
  int monthControllerIndex = 0;

  int get selectedYear => indexSelectedYear + widget.minDate.year;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initDate.day;
    indexSelectedYear = widget.initDate.year - widget.minDate.year;
    yearController =
        FixedExtentScrollController(initialItem: indexSelectedYear);

    selectedMonth = widget.initDate.month;
    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);

    oldDaysInMonth = _daysInMonth(selectedMonth, selectedYear);
  }

  @override
  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  bool _isInvalidMonth(int month) {
    return (widget.minDate.year == selectedYear &&
            widget.minDate.month > month) ||
        (widget.maxDate.year == selectedYear && widget.maxDate.month < month);
  }

  bool _isInvalidDay(int day) {
    return (selectedYear == widget.minDate.year &&
            widget.minDate.month == selectedMonth &&
            widget.minDate.day > day) ||
        (widget.maxDate.year == selectedYear &&
            widget.maxDate.month == selectedMonth &&
            widget.maxDate.day < day);
  }

  int _daysInMonth(int month, int year) {
    final firstDate = DateTime(year, month, 1);
    final lastDate = DateTime(year, month + 1);
    return lastDate.difference(firstDate).inDays;
  }

  void _pickerDidStopScrolling() {
    if (isScrolling) {
      return;
    }

    setState(() {});

    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (_isInvalidMonth(selectedMonth) && !isMonthCorrectScrolling) {
        isMonthCorrectScrolling = true;
        if (selectedYear == widget.minDate.year) {
          _animateToItemTarget(
              monthController, widget.minDate.month - selectedMonth);
          selectedMonth = widget.minDate.month;
        } else if (selectedYear == widget.maxDate.year) {
          _animateToItemTarget(
              monthController, widget.maxDate.month - selectedMonth);
          selectedMonth = widget.maxDate.month;
        }
      }

      if (_isInvalidDay(selectedDay) && !isDayCorrectScrolling) {
        isDayCorrectScrolling = true;
        if ((selectedYear == widget.minDate.year) &&
            (selectedMonth == widget.minDate.month)) {
          _animateToItemTarget(dayController, widget.minDate.day - selectedDay);
          selectedDay = widget.minDate.day;
        } else if ((selectedYear == widget.maxDate.year) &&
            selectedMonth == widget.maxDate.month) {
          _animateToItemTarget(dayController, widget.maxDate.day - selectedDay);
          selectedDay = widget.maxDate.day;
        }
      }
    });

    if (_isCurrentDateValid) {
      widget.onDateChanged(DateTime(selectedYear, selectedMonth, selectedDay));
    }
  }

  void _animateToItemTarget(
      FixedExtentScrollController controller, int targetItem) {
    controller.animateToItem(
      controller.selectedItem + targetItem,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 200),
    );
  }

  Widget _buildYearPicker() {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
          _pickerDidStopScrolling();
        }
        return false;
      },
      child: PickerWidget(
        scrollController: yearController,
        onSelectedItemChanged: (value) {
          indexSelectedYear = value;
        },
        children: List.generate(widget.maxDate.year - widget.minDate.year + 1,
            (index) {
          final int year = widget.minDate.year + index;
          return Text(
            year.toString(),
            style: widget.style,
          );
        }),
      ),
    );
  }

  Widget _buildMonthPicker() {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {
            isMonthPickerScrolling = true;
          } else if (notification is ScrollEndNotification) {
            isMonthPickerScrolling = false;
            if (isMonthCorrectScrolling) {
              isMonthCorrectScrolling = false;
            }
            _pickerDidStopScrolling();
          }
          return false;
        },
        child: PickerWidget(
          scrollController: monthController,
          looping: true,
          onSelectedItemChanged: (value) {
            if (_isInvalidMonth(value + 1) && !isMonthCorrectScrolling) {
              final int direction =
                  (monthControllerIndex - monthController.selectedItem) < 0
                      ? -1
                      : 1;
              _animateToItemTarget(monthController, direction);
            }
            monthControllerIndex = monthController.selectedItem;

            selectedMonth = value + 1;
          },
          children: List<Widget>.generate(12, (index) {
            return Text(
              (index + 1).toString().padLeft(2, '0'),
              style: TextStyle(
                  color: _isInvalidMonth(index + 1)
                      ? widget.disabledColor
                      : widget.style.color,
                  fontSize: widget.style.fontSize),
            );
          }),
        ));
  }

  Widget _buildDayPicker(int daysInMonth) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollStartNotification) {
            isDayPickerScrolling = true;
          } else if (notification is ScrollEndNotification) {
            isDayPickerScrolling = false;
            if (isDayCorrectScrolling) {
              isDayCorrectScrolling = false;
            }
            _pickerDidStopScrolling();
          }
          return false;
        },
        child: PickerWidget(
          scrollController: dayController,
          looping: true,
          onSelectedItemChanged: ((value) {
            if (_isInvalidDay(value + 1) && !isDayCorrectScrolling) {
              final int direction =
                  (dayControllerIndex - dayController.selectedItem) < 0
                      ? -1
                      : 1;
              _animateToItemTarget(dayController, direction);
            }
            dayControllerIndex = dayController.selectedItem;
            selectedDay = value + 1;
          }),
          children: List.generate(daysInMonth, (index) {
            return Text(
              (index + 1).toString().padLeft(2, '0'),
              style: TextStyle(
                  color: _isInvalidDay(index + 1)
                      ? widget.disabledColor
                      : widget.style.color,
                  fontSize: widget.style.fontSize),
            );
          }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final int newDaysInMonth = _daysInMonth(selectedMonth, selectedYear);
    if ((oldDaysInMonth > newDaysInMonth) && (selectedDay > newDaysInMonth)) {
      selectedDay = newDaysInMonth;
    }
    dayController.jumpToItem(selectedDay - 1);
    oldDaysInMonth = newDaysInMonth;
    final String dateStr = selectedDay.toString().padLeft(2, '0') +
        UItext.datePickerMonth(selectedMonth) +
        selectedYear.toString();
    return Column(children: [
      Center(child: Text(dateStr)),
      Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDayPicker(newDaysInMonth),
              Expanded(child: _buildMonthPicker()),
              _buildYearPicker(),
            ],
          ),
        ],
      ),
    ]);
  }
}
