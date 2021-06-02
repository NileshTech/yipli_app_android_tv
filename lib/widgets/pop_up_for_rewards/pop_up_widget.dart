import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';
import '../buttons.dart';
import 'package:supercharged/supercharged.dart';

// ignore: must_be_immutable
class PopUpMessageForRewardsCollection extends StatelessWidget {
  final String titleText;
  final String subTitleText;
  final String buttonText;
  final String imagePath;

  YipliButton pressToContinueButton;
  Function onExitPressed;

  PopUpMessageForRewardsCollection({
    this.titleText,
    this.subTitleText,
    this.buttonText,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    pressToContinueButton = new YipliButton(
      buttonText,
      null,
      null,
      screenSize.width * 0.3,
    );

    ConfettiController _confettiController;
    _confettiController = new ConfettiController(
      duration: new Duration(seconds: 1),
    );
    pressToContinueButton.setClickHandler(() {
      Navigator.pop(context);
    });
    _confettiController.play();
    return Stack(
      children: [
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: PlayAnimation<double>(
              curve: Curves.decelerate,
              duration: 1000.milliseconds,
              tween: (0.0).tweenTo(1.0),
              builder: (context, child, value) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    height: screenSize.height / 3,
                    width: screenSize.width * 0.7,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          color: yipliNewBlue,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(titleText,
                                style: Theme.of(context).textTheme.headline5),
                          ),
                        ),
                        Expanded(
                          child: Image.asset(imagePath),
                        ),
                        Expanded(
                          child: Text(subTitleText,
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.center),
                        ),
                        pressToContinueButton,
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        Center(
          child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.05,
              shouldLoop: false,
              colors: [
                Colors.red,
                Colors.blue,
              ]),
        ),
      ],
    );
  }
}
