import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/firebase_storage.dart';
import 'package:flutter_app/helpers/helper_index.dart';
import 'package:flutter_app/pages/yipli_page_frame.dart';

class ExcerciseDetailScreen extends StatefulWidget {
  static const String routeName = "/excercise_detail_screen";
  final String desc;
  final String name;
  final String videourl;

  ExcerciseDetailScreen(this.desc, this.name, this.videourl);

  @override
  _ExcerciseDetailScreenState createState() => _ExcerciseDetailScreenState();
}

class _ExcerciseDetailScreenState extends State<ExcerciseDetailScreen> {
  final String image = "${FirebaseStorageUtil.excercises}/";
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return YipliPageFrame(
      title: Text(widget.name),
      toShowBottomBar: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 3,
              child: Container(
                child: ClipRRect(
                  child: FadeInImage(
                    fadeInDuration: Duration(milliseconds: 100),
                    image: FirebaseImage(
                      image + widget.videourl,
                    ),
                    placeholder: AssetImage('assets/images/imageloading.png'),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Flexible(
                child: SizedBox(
              height: 20,
            )),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Text(
                    widget.desc,
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
