import 'a_widgets_index.dart';

class ShowTooltip extends StatefulWidget {
  final String toolTipText;
  final Widget child;
  bool showToolTip;

  ShowTooltip({Key key, this.toolTipText, this.child, this.showToolTip = false})
      : super(key: key);

  @override
  _ShowTooltipState createState() => _ShowTooltipState();
}

class _ShowTooltipState extends State<ShowTooltip> {
  CustomAnimationControl animationControlFlag = CustomAnimationControl.STOP;

  @override
  Widget build(BuildContext context) {
    GlobalKey _toolTipKey = GlobalKey();
    return Tooltip(
        key: _toolTipKey,
        preferBelow: false,
        showDuration: 500.milliseconds,
        padding: const EdgeInsets.all(5.0),
        message: "ℹ️ " + widget.toolTipText,
        textStyle: Theme.of(context)
            .textTheme
            .bodyText1
            .copyWith(color: Theme.of(context).primaryColorLight),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: appbackgroundcolor,
          border: Border.all(
            color: yipliLogoOrange,
            width: 1.0,
          ),
        ),
        child: GestureDetector(
            onTap: () {
              setState(() {
                final dynamic tooltip = _toolTipKey.currentState;
                tooltip.ensureTooltipVisible();
                print('tooltip current state - $tooltip');
              });
            },
            child: widget.child));
  }
}
