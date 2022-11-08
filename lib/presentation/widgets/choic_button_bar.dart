import 'package:trading/common/ui_colors.dart';
import 'package:flutter/material.dart';

class ChoicButtonBar extends StatefulWidget {
  const ChoicButtonBar(
      {Key? key,
      required this.actionButton,
      this.onSelect,
      this.height = 48.0,
      this.initSelectIndex = 0})
      : super(key: key);

  final List<Widget> actionButton;
  final ValueChanged<int>? onSelect;
  final double height;
  final int initSelectIndex;

  @override
  State<ChoicButtonBar> createState() => _ChoicButtonBarState();
}

class _ChoicButtonBarState extends State<ChoicButtonBar>
    with RestorationMixin, TickerProviderStateMixin {
  final RestorableIntN _indexSelected = RestorableIntN(0);
  AnimationController? _moveController;
  late Animation<Offset> _moveAnimation;
  late int _oldIndexSelected;

  @override
  String get restorationId => 'choice_button_bar';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_indexSelected, 'choice_index_button');
  }

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this)
      ..addStatusListener(_handleMoveProgressChanged);

    _oldIndexSelected = widget.initSelectIndex;
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: Offset(_oldIndexSelected.toDouble(), 0),
        end: Offset(_oldIndexSelected.toDouble(), 0.0),
      ),
    );
  }

  @override
  void dispose() {
    _indexSelected.dispose();
    _moveController!.dispose();
    super.dispose();
  }

  void _updateMoveAnimation() {
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: Offset(_oldIndexSelected.toDouble(), 0.0),
        end: Offset(_indexSelected.value!.toDouble(), 0.0),
      ),
    );
  }

  void _handleMoveProgressChanged(AnimationStatus animation) {
    if (_moveController!.isCompleted) {
      _oldIndexSelected = _indexSelected.value!.toInt();
      if (widget.onSelect != null) {
        widget.onSelect!(_oldIndexSelected);
      }
    }
  }

  void _handleClick(int index) {
    if ((!_moveController!.isAnimating) && (_oldIndexSelected != index)) {
      _indexSelected.value = index;
      _moveController!.value = 0;
      _moveController!.forward();
      setState(() {
        _updateMoveAnimation();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget tabsBtn;
    final int countWidget;

    if (widget.actionButton.isNotEmpty) {
      countWidget = widget.actionButton.length;
      tabsBtn = Row(
          children: List<Widget>.generate(countWidget, (index) {
        return Expanded(
            child: _WrapChoicButton(
          index: index,
          onSelect: _handleClick,
          child: widget.actionButton[index],
        ));
      }));
    } else {
      tabsBtn = Wrap();
      countWidget = 0;
    }
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget selectContent = SlideTransition(
            position: _moveAnimation,
            child: _SelectContainer(constraints.maxWidth / countWidget));

        return Container(
          decoration: BoxDecoration(
            color: UIColor.primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.14),
                blurRadius: 5.0,
                offset: Offset(0, 4),
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.12),
                blurRadius: 10.0,
                offset: Offset(0, 1),
              ),
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: widget.height,
          child: Stack(
            children: [
              selectContent,
              tabsBtn,
            ],
          ),
        );
      },
    );
  }
}

class _WrapChoicButton extends StatelessWidget {
  const _WrapChoicButton(
      {Key? key,
      required this.child,
      required this.index,
      required this.onSelect})
      : super(key: key);

  final Widget child;
  final int index;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: child,
      onTap: () {
        onSelect(index);
      },
    );
  }
}

class ChoicButton extends StatelessWidget {
  const ChoicButton({Key? key, required this.caption}) : super(key: key);

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(caption,
            style: const TextStyle(
                color: UIColor.historyFontColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w600)));
  }
}

class _SelectContainer extends StatelessWidget {
  const _SelectContainer(this.width, {Key? key}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: UIColor.accentColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.14),
            blurRadius: 1.0,
            offset: Offset(1, 1),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 1.0,
            offset: Offset(0, 2),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            blurRadius: 3.0,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
