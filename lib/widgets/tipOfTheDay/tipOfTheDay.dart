import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../helpers/color_scheme.dart';

class TipOfTheDay extends StatelessWidget {
  final String healthTipText;
  final String imagePath;
  final String tipHeadingText;

  static const String routeName = "/tipoftheday";
  const TipOfTheDay({
    Key key,
    this.healthTipText,
    this.imagePath,
    this.tipHeadingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: tipOverlayContent(context),
        ));
  }

  tipOverlayContent(BuildContext context) {
    //* Background container - Shadow settings for the overlay are here.
    return Container(
      decoration: BoxDecoration(
          color: appbackgroundcolor, //Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: const Offset(3.0, 3.0),
              blurRadius: 10.0,
              spreadRadius: 5.0,
              color: yipliLogoBlue,
            ),
          ],
          border: Border.all(
              color: yipliLogoBlue.withOpacity(.4),
              width: 1,
              style: BorderStyle.solid)),

      //* This column contains all the visual elements

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          //Row with head line
          Container(
            decoration: BoxDecoration(
              color: yipliLogoBlue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 40),
                  child: Text(
                    tipHeadingText + ' Tip',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),

          //* Health Tip Image

          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
            child: Image.asset(imagePath, height: 70),
          ),

          //* Health Tip content/text

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
            child: Text(
              healthTipText,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(letterSpacing: .5)
                  .copyWith(
                      height: 1.6, color: Theme.of(context).primaryColorLight),
            ),
          ),

          //* Suggestion text at the bottom.

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  focusColor: androidTVFocusColor,
                  child: Text(
                    "Tap on card to dismiss.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(letterSpacing: 0)
                        .copyWith(color: accentLightGray),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
