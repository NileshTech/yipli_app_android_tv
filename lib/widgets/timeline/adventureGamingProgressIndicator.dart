import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:flutter_app/pages/a_pages_index.dart';
import 'package:flutter_app/widgets/a_widgets_index.dart';
import 'package:percent_indicator/percent_indicator.dart';

enum AdventureGamingProgressProps { opacity, translation }

class AdventureGamingProgressIndicator extends StatelessWidget {
  final String titleText;

  final double progressPercentage;
  final int currentClass;
  final int totalClass;

  const AdventureGamingProgressIndicator({
    Key key,
    @required this.progressPercentage,
    @required this.titleText,
    this.currentClass,
    this.totalClass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                bottom: constraints.maxHeight * (5 / 77),
              ),
              child: Text(
                titleText,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                LinearPercentIndicator(
                  alignment: MainAxisAlignment.center,
                  width: _screenSize.width * 0.8,
                  lineHeight: constraints.maxHeight * (4 / 77),
                  animation: true,
                  curve: Curves.decelerate,
                  animationDuration: 1000,
                  padding: EdgeInsets.only(
                      bottom: constraints.maxHeight * (25 / 77)),
                  percent: progressPercentage,
                  backgroundColor: accentLightGray,
                  progressColor: yipliLogoBlue,
                ),
                //@TODO Sangram: Add animation for the marker
                LinearPercentIndicator(
                  width: _screenSize.width * 0.8,
                  alignment: MainAxisAlignment.center,
                  lineHeight: constraints.maxHeight * (27 / 77),
                  animation: true,
                  curve: Curves.decelerate,
                  animationDuration: 1000,
                  percent: progressPercentage,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  progressColor: Colors.transparent,
                  center: Container(
                    alignment: Alignment.bottomLeft,
                    margin: EdgeInsets.only(
                      left: constraints.maxHeight * (18 / 77),
                    ),
                    child: FractionallySizedBox(
                      widthFactor: progressPercentage,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PlayAnimation<
                                MultiTweenValues<AdventureGamingProgressProps>>(
                              curve: Curves.bounceOut,
                              tween: MultiTween<AdventureGamingProgressProps>()
                                ..add(AdventureGamingProgressProps.opacity,
                                    0.0.tweenTo(1.0), 1000.milliseconds)
                                ..add(
                                    AdventureGamingProgressProps.translation,
                                    (-1 * 50.0).tweenTo(0.0),
                                    1000.milliseconds),
                              builder: (context, child, value) {
                                return Transform.translate(
                                  offset: Offset(
                                      0,
                                      value.get(AdventureGamingProgressProps
                                          .translation)),
                                  child: Opacity(
                                      opacity: value.get(
                                          AdventureGamingProgressProps.opacity),
                                      child: child),
                                );
                              },
                              child: FaIcon(
                                FontAwesomeIcons.mapMarkerAlt,
                                color: yipliLogoOrange,
                                size: constraints.maxHeight * (15 / 77),
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * (1 / 77),
                            ),
                            PlayAnimation<double>(
                              curve: Curves.decelerate,
                              duration: 1000.milliseconds,
                              tween: (0.0).tweenTo(1.0),
                              builder: (context, child, value) {
                                return Transform.scale(
                                  scale: value,
                                  child: child,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: yipliLogoOrange,
                                ),
                                height: constraints.maxHeight * (8 / 77),
                                width: constraints.maxHeight * (8 / 77),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      bottom: constraints.maxHeight * (4 / 77),
                      right: constraints.maxHeight * (20 / 77)),
                  alignment: Alignment.centerRight,
                  child: FaIcon(
                    FontAwesomeIcons.flagCheckered,
                    size: constraints.maxHeight * (15 / 77),
                  ),
                )
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 4.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //         gradient: LinearGradient(
            //       transform: GradientRotation(pi / 2),
            //       colors: [
            //         Color(0xFF101010),
            //         Color(0xFF000000),
            //         Color(0xFF101010).withOpacity(0.0),
            //         Color(0xFF101010).withOpacity(0.0),
            //       ],
            //       stops: [0, 0.3, 0.6, 1],
            //     )),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           'Get ready for your next thrill !!',
            //           style: Theme.of(context).textTheme.subtitle1,
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //           child: Text(
            //             '$currentClass' '/' '$totalClass',
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .subtitle1
            //                 .copyWith(color: yipliLogoOrange),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
