import 'package:flutter/cupertino.dart';

import 'a_widgets_index.dart';

class FaqListWidget extends StatefulWidget {
  @override
  _FaqListWidgetState createState() => _FaqListWidgetState();

  final FaqDetails faqDetails;

  FaqListWidget(this.faqDetails);
}

class _FaqListWidgetState extends State<FaqListWidget> with AnimationMixin {
  double _animatedHeight = 0.0;

  IconData faqDropDownIcon = Icons.arrow_forward_ios;
  Animation<double> iconRotationAngle;

  Widget _buildAnimatedContainer() {
    final TextStyle textStyle = (Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(color: Theme.of(context).accentColor));
    final Size txtSize = _textSize(widget.faqDetails.answer, textStyle);

    // print("animated height from animted container : $_animatedHeight");
    //print("txtsize animted container : $txtSize");

    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).primaryColorLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              0.0, // Move to right 10  horizontally
              0.1, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      height: _animatedHeight, //== 0.0 ? (txtSize.height + 16) : 0,
      padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6),
      width: MediaQuery.of(context).size.width * .9,
      child: Center(
        child: ResponsiveContainer(
          heightPercent: 90.0, //value percent of screen total height
          widthPercent: 100.0,
          child: AutoSizeText(
            widget.faqDetails.answer,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ),
    );
  }

  AnimationController angleController;
  @override
  void initState() {
    super.initState();
    angleController = createController()
      ..mirror(duration: Duration(milliseconds: 120));
    iconRotationAngle = Tween(begin: 0.0, end: pi / 2).animate(angleController);
    angleController.stop();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = (Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(color: Theme.of(context).accentColor));
    final Size txtSize = _textSize(widget.faqDetails.answer, textStyle);
    //  print(' animated height from build: $_animatedHeight');

    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () => setState(() {
            print('On tap executing');
            // angleController.play();
            if (_animatedHeight != 0.0) {
              _animatedHeight = 0.0;
              angleController.reverse();
            } else {
              _animatedHeight = txtSize.height + 20;
              angleController.forward();
              // 32 is added as per the padding ( EdgeInsets.all(8.0))of the animated builder, this ill not have impact on the responsive
            }
          }),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(2.0),
              width: MediaQuery.of(context).size.width * .95,
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20.0, // soften the shadow
                    spreadRadius: 0.0, //extend the shadow
                    offset: Offset(
                      0.0, // Move to right horizontally
                      0.75, // Move to bottom Vertically
                    ),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // the complete row containing all the elements
                children: <Widget>[
                  ///question
                  Expanded(
                    flex: 10,
                    child: ResponsiveContainer(
                      heightPercent: 6.0, //value percent of screen total height
                      widthPercent: 80.0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4, 2, 0, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                widget.faqDetails.question,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Transform.rotate(
                      angle: iconRotationAngle.value,
                      child: Icon(
                        faqDropDownIcon,
                        color: IconTheme.of(context).color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1.0,
        ),

        ///building the container
        _buildAnimatedContainer(),
        SizedBox(
          height: MediaQuery.of(context).size.height / 70,
        ),
      ],
    );
  }

  // Here it is!
  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text:
            TextSpan(text: text, style: Theme.of(context).textTheme.subtitle1),
        // maxLines: 4,
        textDirection: TextDirection.ltr)
      ..layout(
        minWidth: 0,
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      );
    return textPainter.size;
  }
}
