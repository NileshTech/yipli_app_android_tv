import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/firebase_storage.dart';

class GameIcon extends StatelessWidget {
  const GameIcon({
    Key key,
    @required this.imageLink,
  }) : super(key: key);

  final String imageLink;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 5,
                offset: Offset.fromDirection(1.5708, 4.0),
                spreadRadius: 0)
          ],
        ),
        child: ClipRRect(
          child: FadeInImage(
            fadeInDuration: Duration(milliseconds: 100),
            image: imageLink != null && imageLink != ""
                ? FirebaseImage(
                    "${FirebaseStorageUtil.gameIcons}/$imageLink",
                  )
                : AssetImage("assets/images/coming_soon.png"),
            placeholder: AssetImage('assets/images/imageloading.png'),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
