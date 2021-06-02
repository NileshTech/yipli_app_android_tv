import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ProfileInfoTile extends StatelessWidget {
  final String userPlayerInfo;
  final IconData userPlayerIcon;
  final String userPlayerText;
  final double iconRotateAngle;

  ProfileInfoTile(
    this.userPlayerInfo,
    this.userPlayerIcon,
    this.userPlayerText, {
    this.iconRotateAngle = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Transform.rotate(
                angle: iconRotateAngle,
                child: Icon(
                  userPlayerIcon,
                  color: Theme.of(context).primaryColorLight,
                  size: 22.0,
                ),
              ),
            ),
            Text(
              userPlayerInfo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Theme.of(context).primaryColorLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
