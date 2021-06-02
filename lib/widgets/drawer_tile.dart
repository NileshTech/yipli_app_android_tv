import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:flutter_app/helpers/utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrawTile extends StatelessWidget {
  final String tileText;
  final String targetRoute;
  final bool shouldReplaceViewStack;
  final Widget iconWidget;

  DrawTile(
      {this.tileText,
      this.iconWidget,
      this.targetRoute,
      this.shouldReplaceViewStack = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: iconWidget,
            ),
            Expanded(
              flex: 2,
              child: Text(tileText,
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Theme.of(context).accentColor)),
            ),
          ],
        ),
      ),
      focusColor: androidTVFocusColor,
      onTap: () {
        if (shouldReplaceViewStack) {
          Navigator.of(context).pushReplacementNamed(targetRoute);
        } else {
          Navigator.of(context).pop();
          targetRoute == null
              ? YipliUtils.showNotification(
                  context: context,
                  msg: "Please add player and check again.",
                  type: SnackbarMessageTypes.ERROR,
                  duration: SnackbarDuration.MEDIUM)
              : Navigator.of(context).pushNamed(targetRoute);
        }
      },
    );
  }
}
