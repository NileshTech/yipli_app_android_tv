import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/classes/ExcerciseDetails.dart';
import 'package:flutter_app/helpers/firebase_storage.dart';
import 'package:flutter_app/helpers/helper_index.dart';
import 'package:flutter_app/widgets/excercise_details_screen.dart';

class ExcerciseListWidget extends StatefulWidget {
  final ExcerciseDetails excercseDetails;
  ExcerciseListWidget(this.excercseDetails);

  @override
  _ExcerciseListWidgetState createState() => _ExcerciseListWidgetState();
}

class _ExcerciseListWidgetState extends State<ExcerciseListWidget> {
  final String image = "${FirebaseStorageUtil.excercises}/";
  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                padding: EdgeInsets.only(right: 10),
                child: ClipRRect(
                  child: FadeInImage(
                    fadeInDuration: Duration(milliseconds: 100),
                    image: FirebaseImage(
                      image + widget.excercseDetails.videoUrl,
                    ),
                    placeholder: AssetImage('assets/images/imageloading.png'),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.excercseDetails.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              widget.excercseDetails.desc,
                              style: Theme.of(context)
                                  .textTheme
                                  .overline
                                  .copyWith(letterSpacing: 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          focusColor: androidTVFocusColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration:
                                    Duration(microseconds: 5000),
                                pageBuilder: (context, a, b) =>
                                    ExcerciseDetailScreen(
                                  widget.excercseDetails.desc,
                                  widget.excercseDetails.name,
                                  widget.excercseDetails.videoUrl,
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.play_arrow,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
