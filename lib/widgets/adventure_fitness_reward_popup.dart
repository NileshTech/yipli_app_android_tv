import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/helpers/helper_index.dart';
import 'package:flutter_app/widgets/a_widgets_index.dart';

class AdventureRewardPopUp extends StatelessWidget {
  static const String routeName = "/adventureRewardPopUp";
  const AdventureRewardPopUp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: adventureRewardsPopUpContent(context),
      ),
    );
  }

  adventureRewardsPopUpContent(BuildContext context) {
    //* Background container - Shadow settings for the overlay are here.
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: const Offset(3.0, 3.0),
              blurRadius: 10.0,
              spreadRadius: 5.0,
              color: Colors.amberAccent,
            ),
          ],
          border: Border.all(
              color: Colors.amberAccent, width: 3, style: BorderStyle.solid)),

      //* This column contains all the visual elements

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          //Row with head line
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FITNESS REWARDS',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(
                    height: 0.1 * screenSize.width,
                    child: Hero(
                      tag: "yipli-logo",
                      child: YipliLogoAnimatedSmall(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //* yipli coin Image

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
            child: SizedBox(
              width: 60.0,
              height: 60.0,
              child: YipliCoin(coinPadding: 0.0),
            ),
          ),

          //* adventure content/text

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'That was awesome!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(letterSpacing: .5)
                      .copyWith(height: 1.6),
                ),
                Text(
                  'You completed Level 1 of the game world',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(letterSpacing: .5)
                      .copyWith(height: 1.6),
                ),
                Text(
                  '+1000',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(letterSpacing: .5)
                      .copyWith(height: 1.6, color: yipliLogoOrange),
                ),
                Text(
                  'Fitness Points',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(letterSpacing: .5)
                      .copyWith(height: 1.6),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: RaisedButton(
                    focusColor: androidTVFocusColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Collect',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    onPressed: () {},
                    color: yipliLogoBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
