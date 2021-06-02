import 'a_widgets_index.dart';

class PlayerProfileDivider extends StatefulWidget {
  final double sizedBoxHeight;
  final IconData dividerIcon;
  final Color dividerIconColor;
  final String dividerText;
  final Color dividerTextColor;
  final Color dividerColor;

  PlayerProfileDivider(
      {this.sizedBoxHeight,
      this.dividerIcon,
      this.dividerIconColor,
      this.dividerText,
      this.dividerTextColor,
      this.dividerColor});

  @override
  _PlayerProfileDividerState createState() => _PlayerProfileDividerState();
}

class _PlayerProfileDividerState extends State<PlayerProfileDivider>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.sizedBoxHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: PlayAnimation<double>(
                    curve: Curves.decelerate,
                    duration: 1000.milliseconds,
                    tween: (0.0).tweenTo(1.0),
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: Divider(
                          color: widget.dividerColor,
                          height: 3,
                          thickness: 2,
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: PlayAnimation<double>(
                    curve: Curves.bounceInOut,
                    duration: 1000.milliseconds,
                    tween: (0.0).tweenTo(1.0),
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: Icon(
                                widget.dividerIcon,
                                color: widget.dividerIconColor,
                                size: 20,
                              ),
                            ),
                            Text(
                              widget.dividerText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: widget.dividerTextColor),
                            ),

//                          AnimatedDefaultTextStyle(
//                            duration: Duration(milliseconds: 100),
//                            curve: Curves.elasticInOut,
//                            child: widget.dividerText,
//                            style: animated
//                                ? (Theme.of(context)
//                                    .textTheme
//                                    .headline6
//                                    .copyWith(color: widget.dividerTextColor))
//                                : (Theme.of(context)
//                                    .textTheme
//                                    .subtitle2
//                                    .copyWith(color: widget.dividerTextColor)),
//                          ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: PlayAnimation<double>(
                    curve: Curves.decelerate,
                    duration: 1000.milliseconds,
                    tween: (0.0).tweenTo(1.0),
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: Divider(
                          color: widget.dividerColor,
                          height: 3,
                          thickness: 2,
                        ),
                      );
                    }),
              ),
            )
          ],
        ));
  }
}
