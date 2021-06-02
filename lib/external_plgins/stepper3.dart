// Copyright 2020 J-P Nurmi <jpnurmi@gmail.com>
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter_app/external_plgins/stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show CircleAvatar, Colors, Icons, Step, StepState, StepperType, Theme;

import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:flutter_app/widgets/buttons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:flutter/material.dart' show Step, StepState, StepperType;

// TODO(dragostis): Missing functionality:
//   * mobile horizontal mode with adding/removing steps
//   * alternative labeling
//   * stepper feedback in the case of high-latency interactions

const double _kLineWidth = 1.0;
const double _kStepSize = 44.0;
const double _kStepMargin = 24.0;
const double _kStepPadding = 8.0;
const double _kStepSpacing = 12.0;
const double _kStepFontSize = 20.0;
const double _kStepSmallFontSize = 15.0;
const double _kTriangleHeight =
    _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0
const Duration _kThemeAnimationDuration = const Duration(milliseconds: 200);

/// A cupertino stepper widget that displays progress through a sequence of
/// steps. Steppers are particularly useful in the case of forms where one step
/// requires the completion of another one, or where multiple steps need to be
/// completed in order to submit the whole form.
///
/// The widget is a flexible wrapper. A parent class should pass [currentStep]
/// to this widget based on some logic triggered by the three callbacks that it
/// provides.
///
/// See also:
///
///  * [Step]
///  * <https://material.io/archive/guidelines/components/steppers.html>
class YipliCupertinoStepper extends StatefulWidget {
  /// Creates a stepper from a list of steps.
  ///
  /// This widget is not meant to be rebuilt with a different list of steps
  /// unless a key is provided in order to distinguish the old stepper from the
  /// new one.
  ///
  /// The [steps], [type], and [currentStep] arguments must not be null.
  const YipliCupertinoStepper({
    Key key,
    @required this.steps,
    this.physics,
    this.type = YipliStepperType.vertical,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
  })  : assert(steps != null),
        assert(type != null),
        assert(currentStep != null),
        // assert(0 <= currentStep && currentStep < 3),
        super(key: key);

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<YipliStep> steps;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics physics;

  /// The type of stepper that determines the layout. In the case of
  /// [StepperType.horizontal], the content of the current step is displayed
  /// underneath as opposed to the [StepperType.vertical] case where it is
  /// displayed in-between.
  final YipliStepperType type;

  /// The index into [steps] of the current step whose content is displayed.
  final int currentStep;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int> onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback onStepCancel;

  /// The callback for creating custom controls.
  ///
  /// If null, the default controls from the current theme will be used.
  ///
  /// This callback which takes in a context and two functions,[onStepContinue]
  /// and [onStepCancel]. These can be used to control the stepper.
  ///
  /// {@tool dartpad --template=stateless_widget_scaffold}
  /// Creates a stepper control with custom buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Stepper(
  ///     controlsBuilder:
  ///       (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
  ///          return Row(
  ///            children: <Widget>[
  ///              FlatButton(
  ///                onPressed: onStepContinue,
  ///                child: const Text('NEXT'),
  ///              ),
  ///              FlatButton(
  ///                onPressed: onStepCancel,
  ///                child: const Text('CANCEL'),
  ///              ),
  ///            ],
  ///          );
  ///       },
  ///     steps: const <Step>[
  ///       Step(
  ///         title: Text('A'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///       Step(
  ///         title: Text('B'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final ControlsWidgetBuilder controlsBuilder;

  @override
  _YipliCupertinoStepperState createState() => _YipliCupertinoStepperState();
}

class _YipliCupertinoStepperState extends State<YipliCupertinoStepper>
    with TickerProviderStateMixin {
  List<GlobalKey> _keys;
  final Map<int, YipliStepState> _oldStates = <int, YipliStepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );

    for (int i = 0; i < widget.steps.length; i += 1)
      _oldStates[i] = widget.steps[i].state;
  }

  @override
  void didUpdateWidget(YipliCupertinoStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1)
      _oldStates[i] = oldWidget.steps[i].state;
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? _kLineWidth : 0.0,
      height: 16.0,
      color: yipliWhite,
    );
  }

  Widget _buildCircleChild(int index, bool oldState) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final YipliStepState state =
        oldState ? _oldStates[index] : widget.steps[index].state;
    final bool isActive = widget.steps[index].isActive;
    assert(state != null);
    // switch (state) {
    // case YipliStepState.disabled:
    // case YipliStepState.indexed:
    //     // return Text(
    //   '${index + 1}',
    //   style: TextStyle(
    //       fontSize: _kStepFontSize,
    //       color: isActive
    //           ? CupertinoDynamicColor.resolve(
    //               CupertinoColors.white, context)
    //           : state == YipliStepState.disabled
    //               ? CupertinoDynamicColor.resolve(
    //                   CupertinoColors.placeholderText, context)
    //               : yipliNewDarkBlue),
    // );
    // return Icon(
    //   widget.steps[index].icon,
    //   // CupertinoIcons.pencil,
    //   color: isActive
    //       ? CupertinoDynamicColor.resolve(yipliWhite, context)
    //       : yipliWhite,
    //   size: _kStepFontSize,
    // );
    if (state == YipliStepState.editing) {
      return Icon(
        widget.steps[index].icon,
        // CupertinoIcons.pencil,
        color: isActive
            ? CupertinoDynamicColor.resolve(yipliWhite, context)
            : yipliWhite,
        size: _kStepFontSize,
      );
    } else {
      return Icon(
        widget.steps[index].icon,
        // CupertinoIcons.pencil,
        color: isActive
            ? CupertinoDynamicColor.resolve(yipliWhite, context)
            : yipliWhite,
        size: _kStepSmallFontSize,
      );
    }
    // case YipliStepState.error:
    //     return const Text('!',
    //         style: TextStyle(
    //             fontSize: _kStepFontSize, color: CupertinoColors.white));
    // }
    // return null;
  }

  Color _circleColor(int index) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    return widget.steps[index].isActive ? yipliNewBlue : primarycolor;
  }

  Color _borderColor(int index) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    return widget.steps[index].state == YipliStepState.disabled
        ? CupertinoDynamicColor.resolve(
            CupertinoColors.placeholderText, context)
        : yipliWhite;
  }

  Widget _buildCircle(int index, bool oldState) {
    final YipliStepState state =
        oldState ? _oldStates[index] : widget.steps[index].state;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: _kStepPadding),
      width: _kStepSize,
      height: _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: _kThemeAnimationDuration,
        decoration: ShapeDecoration(
          color: _circleColor(index),
          shape: CircleBorder(side: BorderSide(color: _borderColor(index))),
        ),
        child: Center(
          child: _buildCircleChild(index,
              oldState && widget.steps[index].state == YipliStepState.error),
        ),
      ),
    );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: _kStepPadding),
      width: _kStepSize,
      height: _kStepSize,
      child: Center(
        child: SizedBox(
          width: _kStepSize,
          height:
              _kTriangleHeight, // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: CupertinoDynamicColor.resolve(
                  CupertinoColors.systemRed, context),
            ),
            child: Align(
              alignment: const Alignment(
                  0.0, 0.8), // 0.8 looks better than the geometrical 0.33.
              child: _buildCircleChild(
                  index,
                  oldState &&
                      widget.steps[index].state != YipliStepState.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.steps[index].state == YipliStepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: _kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != YipliStepState.error)
        return _buildCircle(index, false);
      else
        return _buildTriangle(index, false);
    }
  }

  skipButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: IntrinsicWidth(
        child: CupertinoDialogAction(
          onPressed: widget.onStepCancel,
          child: Text(
            'Skip',
            style: TextStyle(
              color: yipliNewBlue,
            ),
          ),
        ),
      ),
      onPressed: widget.onStepCancel,
    );
  }

  Widget _buildVerticalControls() {
    YipliButton nextButton = YipliButton(
      'Next',
      null,
      null,
      MediaQuery.of(context).size.width / 4,
    );
    nextButton.setClickHandler(widget.onStepContinue);
    if (widget.controlsBuilder != null)
      return widget.controlsBuilder(context,
          onStepContinue: widget.onStepContinue,
          onStepCancel: widget.onStepCancel);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // widget.steps[widget.currentStep].isSkipButtonEnabled
          //     ? skipButton()
          //     : Container(height: 0, width: 0),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: IntrinsicWidth(
              child: CupertinoDialogAction(
                isDefaultAction: true,
                child: CircleAvatar(
                  backgroundColor: yipliGray,
                  radius: 27,
                  child: Icon(FontAwesomeIcons.angleDown,
                      size: 40.0, color: yipliNewBlue),
                ),

                //  Text(
                //   'Next',
                //   style: TextStyle(
                //     color: yipliNewBlue,
                //   ),
                // ),
                // onPressed: widget.onStepContinue,
              ),
            ),
            onPressed: widget.onStepContinue,
          ),
        ],
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final CupertinoTextThemeData textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case YipliStepState.indexed:
      case YipliStepState.editing:

      case YipliStepState.complete:
        return index == widget.currentStep
            ? Theme.of(context).textTheme.headline6.copyWith(
                  color: yipliWhite,
                  fontWeight: FontWeight.bold,
                )
            : Theme.of(context).textTheme.subtitle1.copyWith(
                  color: yipliGray,
                );

      // return textTheme.navActionTextStyle.copyWith(
      //   color: index == widget.currentStep ? yipliNewBlue : yipliGray,
      //   fontWeight:
      //       index == widget.currentStep ? FontWeight.bold : FontWeight.normal,
      // fontSize: index == widget.currentStep ? Theme.of(context)
      //       .textTheme
      //       .headline5
      //       .copyWith(color: Colors.white) :

      case YipliStepState.disabled:
        return textTheme.navActionTextStyle
            .copyWith(color: CupertinoDynamicColor.resolve(yipliGray, context));
      case YipliStepState.error:
        return textTheme.navActionTextStyle.copyWith(
            color: CupertinoDynamicColor.resolve(
                CupertinoColors.systemRed, context));
    }
    return null;
  }

  TextStyle _subtitleStyle(int index) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final CupertinoTextThemeData textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case YipliStepState.indexed:
      case YipliStepState.editing:
      case YipliStepState.complete:
        return textTheme.tabLabelTextStyle;
      case YipliStepState.disabled:
        return textTheme.tabLabelTextStyle.copyWith(
            color: CupertinoDynamicColor.resolve(
                CupertinoColors.placeholderText, context));
      case YipliStepState.error:
        return textTheme.tabLabelTextStyle.copyWith(
            color: CupertinoDynamicColor.resolve(
                CupertinoColors.systemRed, context));
    }
    return null;
  }

  Widget _buildHeaderText(int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: _kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.steps[index].title,
        ),
        // if (widget.steps[index].subtitle != null)
        //   Container(
        //     margin: const EdgeInsets.only(top: 2.0),
        //     child: AnimatedDefaultTextStyle(
        //       style: _subtitleStyle(index),
        //       duration: _kThemeAnimationDuration,
        //       curve: Curves.fastOutSlowIn,
        //       child: widget.steps[index].subtitle,
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: _kStepMargin),
      child: Row(
        children: <Widget>[
          _buildIcon(index),
          Container(
            margin: const EdgeInsetsDirectional.only(start: _kStepSpacing),
            child: Center(child: _buildHeaderText(index)),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: _kStepMargin,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: _kStepSize,
            child: Center(
              child: SizedBox(
                width: _isLast(index) ? 0.0 : _kLineWidth,
                child: Container(
                  color: CupertinoColors.opaqueSeparator.elevatedColor,
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 2 * _kStepMargin + _kStepSize,
              end: _kStepMargin,
              bottom: _kStepMargin,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                widget.steps[index].content,
                _buildVerticalControls(),
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _isCurrent(index)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: _kThemeAnimationDuration,
        ),
      ],
    );
  }

  Widget _buildVertical() {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: <Widget>[
        for (int i = 0; i < widget.steps.length; i += 1)
          Column(
            key: _keys[i],
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: _kStepMargin + (_kStepSize - _kLineWidth) / 2),
                child: _buildLine(!_isFirst(i)),
              ),
              Focus(
                canRequestFocus:
                    widget.steps[i].state == YipliStepState.complete,
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.steps[i].state == YipliStepState.complete
                      ? () {
                          // In the vertical case we need to scroll to the newly tapped
                          // step.
                          Scrollable.ensureVisible(
                            _keys[i].currentContext,
                            curve: Curves.fastOutSlowIn,
                            duration: _kThemeAnimationDuration,
                          );

                          if (widget.onStepTapped != null)
                            widget.onStepTapped(i);
                        }
                      : null,
                  child: _buildVerticalHeader(i),
                ),
              ),
              _buildVerticalBody(i),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: _kStepMargin + (_kStepSize - _kLineWidth) / 2),
                child: _buildLine(!_isLast(i)),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        Focus(
          canRequestFocus: widget.steps[i].state != YipliStepState.disabled,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: widget.steps[i].state != YipliStepState.disabled
                ? () {
                    if (widget.onStepTapped != null) widget.onStepTapped(i);
                  }
                : null,
            child: Row(
              children: <Widget>[
                Container(
                  height: 72.0,
                  child: Center(
                    child: _buildIcon(i),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsetsDirectional.only(start: _kStepSpacing),
                  child: _buildHeaderText(i),
                ),
              ],
            ),
          ),
        ),
        if (!_isLast(i))
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: _kStepPadding),
              height: _kLineWidth,
              color: CupertinoColors.separator,
            ),
          ),
      ],
    ];

    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(horizontal: _kStepMargin),
          child: Row(
            children: children,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(_kStepMargin),
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: _kThemeAnimationDuration,
                vsync: this,
                child: widget.steps[widget.currentStep].content,
              ),
              _buildVerticalControls(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<YipliCupertinoStepper>() !=
          null)
        throw FlutterError('Steppers must not be nested.\n'
            'The material specification advises that one should avoid embedding '
            'steppers within steppers. '
            'https://material.io/archive/guidelines/components/steppers.html#steppers-usage');
      return true;
    }());
    assert(widget.type != null);
    // switch (widget.type) {
    // case StepperType.vertical:
    return _buildVertical();
    // case StepperType.horizontal:
    // return _buildHorizontal();
    // }
    //  return null;
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({
    this.color,
  });

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(
      Path()..addPolygon(points, true),
      Paint()..color = color,
    );
  }
}
