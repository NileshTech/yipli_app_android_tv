import 'a_widgets_index.dart';

class YipliLoader extends StatefulWidget {
  final double radius;
  final double dotRadius;
  final BoxConstraints boxConstraints;
  final bool useOpaqueBackground;
  final Color backgroundColor;

  YipliLoader(
      {this.radius = 45.0,
      this.dotRadius = 15.0,
      this.boxConstraints,
      this.useOpaqueBackground = true,
      this.backgroundColor});

  @override
  _YipliLoaderState createState() => _YipliLoaderState();
}

class _YipliLoaderState extends State<YipliLoader>
    with SingleTickerProviderStateMixin {
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;
  AnimationController controller;

  double radius;
  double dotRadius;

  @override
  void initState() {
    super.initState();

    radius = widget.radius;
    dotRadius = widget.dotRadius;

    //print(dotRadius);

    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animationRadiusIn = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0)
          radius = widget.radius * animationRadiusIn.value;
        else if (controller.value >= 0.0 && controller.value <= 0.25)
          radius = widget.radius * animationRadiusOut.value;
      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    /*print(
        "widget.boxConstraints.minWidth : ${widget.boxConstraints != null ? widget.boxConstraints.minWidth : null}");
    */
    return Container(
      decoration: widget.useOpaqueBackground
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (widget.backgroundColor != null)
                  ? widget.backgroundColor.withOpacity(0.9)
                  : Theme.of(context).primaryColor.withOpacity(0.9),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: (widget.backgroundColor != null)
                  ? widget.backgroundColor
                  : null,
            ),
      width: (widget.boxConstraints != null)
          ? widget.boxConstraints.minWidth
          : MediaQuery.of(context).size.width,
      height: (widget.boxConstraints != null)
          ? widget.boxConstraints.minHeight
          : MediaQuery.of(context).size.height,
      //color: Colors.black12,
      child: new Center(
        child: new RotationTransition(
          turns: animationRotation,
          child: new Container(
            child: new Center(
              child: Stack(
                children: <Widget>[
                  new Transform.translate(
                    offset: Offset(0.0, 0.0),
                    child: Dot(
                      radius: 0,
                      color: yipliLogoBlue,
                    ),
                  ),
                  new Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: yipliLogoBlue,
                    ),
                    offset: Offset(
                      radius * cos(0.0),
                      radius * sin(0.0),
                    ),
                  ),
                  new Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: yipliLogoOrange,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 1 * pi / 4),
                      radius * sin(0.0 + 1 * pi / 4),
                    ),
                  ),
                  new Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: yipliLogoBlue,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 2 * pi / 4),
                      radius * sin(0.0 + 2 * pi / 4),
                    ),
                  ),
                  new Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: yipliLogoBlue,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 3 * pi / 4),
                      radius * sin(0.0 + 3 * pi / 4),
                    ),
                  ),
                  new Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: yipliLogoBlue,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 4 * pi / 4),
                      radius * sin(0.0 + 4 * pi / 4),
                    ),
                  ),
                  new Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: yipliLogoBlue,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 5 * pi / 4),
                      radius * sin(0.0 + 5 * pi / 4),
                    ),
                  ),
                  new Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: yipliLogoBlue,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 6 * pi / 4),
                      radius * sin(0.0 + 6 * pi / 4),
                    ),
                  ),
                  new Transform.translate(
                    child: Dot(
                      radius: dotRadius,
                      color: yipliLogoBlue,
                    ),
                    offset: Offset(
                      radius * cos(0.0 + 7 * pi / 4),
                      radius * sin(0.0 + 7 * pi / 4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
