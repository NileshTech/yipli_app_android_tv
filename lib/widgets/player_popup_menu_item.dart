import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/color_scheme.dart';

class PlayerPopUpMenu extends StatelessWidget {
  final String tileText;
  final IconData tileIcon;
  final Function onTap;

  PlayerPopUpMenu({
    this.tileText,
    this.tileIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 1.0),
      dense: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
//          Icon(
//            tileIcon,
//            size: 18,
//            color: Theme.of(context).accentColor,
//          ),
          Text(tileText,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Theme.of(context).accentColor)),
        ],
      ),
      focusColor: androidTVFocusColor,
      onTap: onTap,
    );
  }
}
