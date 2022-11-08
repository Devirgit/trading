import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

typedef ActionDirectionCallback = void Function(ActionDirection direction);

enum ActionDirection { none, left, right }

const double _kDismissThreshold = 0.4;

class SlideActions extends StatefulWidget {
  const SlideActions({
    Key? key,
    this.direction = DismissDirection.horizontal,
    this.dragStartBehavior = DragStartBehavior.start,
    this.behavior = HitTestBehavior.opaque,
    this.closeOnScroll = true,
    this.leftActionPane,
    this.rightActionPane,
    this.onAction,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final DragStartBehavior dragStartBehavior;
  final HitTestBehavior behavior;
  final DismissDirection direction;
  final bool closeOnScroll;
  final Widget? leftActionPane;
  final Widget? rightActionPane;
  final ActionDirectionCallback? onAction;

  @override
  State<SlideActions> createState() => _SlideActionsState();
}

class _SlideActionsState extends State<SlideActions>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool get _directionIsXAxis {
    return widget.direction == DismissDirection.horizontal ||
        widget.direction == DismissDirection.endToStart ||
        widget.direction == DismissDirection.startToEnd;
  }

  AnimationController? _moveController;
  late Animation<Offset> _moveAnimation;
  bool isAction = false;
  double _dragExtent = 0.0;

  double get _overallDragAxisExtent {
    final Size size = context.size!;
    return _directionIsXAxis ? size.width : size.height;
  }

  @override
  bool get wantKeepAlive => (_moveController?.isAnimating ?? false);

  Widget? get actionPane {
    if (_actionDirection == ActionDirection.left) {
      if (widget.leftActionPane != null) {
        return widget.leftActionPane;
      }
    }
    if (_actionDirection == ActionDirection.right) {
      if (widget.rightActionPane != null) {
        return widget.rightActionPane;
      }
    }
    return null;
  }

  ActionDirection _extentToDirection(double extent) {
    if (extent == 0.0) return ActionDirection.none;
    return extent > 0 ? ActionDirection.left : ActionDirection.right;
  }

  ActionDirection get _actionDirection => _extentToDirection(_dragExtent);

  void _handleDragStart(DragStartDetails details) {
    if (_moveController!.isAnimating) {
      _dragExtent = _moveController!.value * _dragExtent.sign;
      _moveController!.stop();
    } else {
      _dragExtent = 0.0;
      _moveController!.value = 0.0;
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final double delta = details.primaryDelta!;
    final double oldDragExtent = _dragExtent;

    switch (widget.direction) {
      case DismissDirection.horizontal:
      case DismissDirection.vertical:
        _dragExtent += delta;
        break;

      case DismissDirection.up:
        if (_dragExtent + delta < 0) _dragExtent += delta;
        break;

      case DismissDirection.down:
        if (_dragExtent + delta > 0) _dragExtent += delta;
        break;

      case DismissDirection.endToStart:
        switch (Directionality.of(context)) {
          case TextDirection.rtl:
            if (_dragExtent + delta > 0) _dragExtent += delta;
            break;
          case TextDirection.ltr:
            if (_dragExtent + delta < 0) _dragExtent += delta;
            break;
        }
        break;

      case DismissDirection.startToEnd:
        switch (Directionality.of(context)) {
          case TextDirection.rtl:
            if (_dragExtent + delta < 0) _dragExtent += delta;
            break;
          case TextDirection.ltr:
            if (_dragExtent + delta > 0) _dragExtent += delta;
            break;
        }
        break;

      case DismissDirection.none:
        _dragExtent = 0;
        break;
    }
    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
      });
    }
    if (!_moveController!.isAnimating) {
      _moveController!.value = _dragExtent.abs() / _overallDragAxisExtent;
    }
    if (_moveController!.value > _kDismissThreshold) {
      if (!isAction) {
        isAction = true;
        Vibration.vibrate(duration: 40);
      }
    } else {
      if (isAction) {
        isAction = false;
        Vibration.vibrate(duration: 40);
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_moveController!.value > _kDismissThreshold) {
      if (widget.onAction != null) {
        widget.onAction!(_actionDirection);
      }
    }
    isAction = false;
    _moveController!.reverse();
  }

  void _updateMoveAnimation() {
    final double end = _dragExtent.sign;
    _moveAnimation = _moveController!.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: _directionIsXAxis ? Offset(end, 0.0) : Offset(0.0, end),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _updateMoveAnimation();
  }

  @override
  void dispose() {
    _moveController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget content = SlideTransition(
      position: _moveAnimation,
      child: widget.child,
    );

    if (actionPane != null) {
      content = Stack(children: <Widget>[
        if (!_moveAnimation.isDismissed)
          Positioned.fill(
            child: ClipRect(
              clipper: _SlideClipper(
                axis: _directionIsXAxis ? Axis.horizontal : Axis.vertical,
                moveAnimation: _moveAnimation,
              ),
              child: actionPane,
            ),
          ),
        content,
      ]);
    } else {
      content = widget.child;
    }

    return GestureDetector(
      onHorizontalDragStart: _directionIsXAxis ? _handleDragStart : null,
      onHorizontalDragUpdate: _directionIsXAxis ? _handleDragUpdate : null,
      onHorizontalDragEnd: _directionIsXAxis ? _handleDragEnd : null,
      onVerticalDragStart: _directionIsXAxis ? null : _handleDragStart,
      onVerticalDragUpdate: _directionIsXAxis ? null : _handleDragUpdate,
      onVerticalDragEnd: _directionIsXAxis ? null : _handleDragEnd,
      behavior: widget.behavior,
      dragStartBehavior: widget.dragStartBehavior,
      child: content,
    );
  }
}

class _SlideClipper extends CustomClipper<Rect> {
  _SlideClipper({
    required this.axis,
    required this.moveAnimation,
  }) : super(reclip: moveAnimation);

  final Axis axis;
  final Animation<Offset> moveAnimation;

  @override
  Rect getClip(Size size) {
    switch (axis) {
      case Axis.horizontal:
        final double offset = moveAnimation.value.dx * size.width;
        if (offset < 0) {
          return Rect.fromLTRB(size.width + offset, 0, size.width, size.height);
        }
        return Rect.fromLTRB(0, 0, offset, size.height);
      case Axis.vertical:
        final double offset = moveAnimation.value.dy * size.height;
        if (offset < 0) {
          return Rect.fromLTRB(
            0,
            size.height + offset,
            size.width,
            size.height,
          );
        }
        return Rect.fromLTRB(0, 0, size.width, offset);
    }
  }

  @override
  Rect getApproximateClipRect(Size size) => getClip(size);

  @override
  bool shouldReclip(_SlideClipper oldClipper) {
    return oldClipper.axis != axis ||
        oldClipper.moveAnimation.value != moveAnimation.value;
  }
}
