import 'package:flutter/material.dart';
import 'package:flutter_app/page_models/excercise_model.dart';
import 'package:flutter_app/pages/games_page.dart';
import 'package:flutter_app/pages/yipli_page_frame.dart';
import 'package:flutter_app/widgets/excercise_list_widget.dart';
import 'package:provider/provider.dart';

class ExcerciseListScreen extends StatefulWidget {
  static const String routeName = "/excercise_screen";

  @override
  ExcerciseListScreenState createState() => ExcerciseListScreenState();
}

class ExcerciseListScreenState extends State<ExcerciseListScreen> {
  Size screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print('page frame');

    return ChangeNotifierProvider<ExcerciseModel>(
      create: (context) {
        ExcerciseModel excerciseModel = new ExcerciseModel();
        excerciseModel.initialize();
        print("Returned excercise model");
        return excerciseModel;
      },
      child: YipliPageFrame(
        toShowBottomBar: true,
        title: Text('Excercise'),
        child:
            Consumer<ExcerciseModel>(builder: (context, excerciseModel, child) {
          if (excerciseModel == null) {
            print(
                'excercise model length: ${excerciseModel.allExcercise.length}');
            return YipliLoaderMini(
              loadingMessage: "Loading Excercise ... ",
            );
          }
          if (excerciseModel.allExcercise.length == 0) {
            print(
                'Excercise model length: ${excerciseModel.allExcercise.length}');
            return YipliLoaderMini(
              loadingMessage: "Loading Excercise ... ",
            );
          } else {
            return ListView.builder(
                padding: EdgeInsets.only(
                  top: 8,
                  right: 5,
                  left: 5,
                  bottom: screenSize.height / 4,
                ),
                itemExtent: screenSize.height / 6,
                itemCount: excerciseModel.allExcercise.length,
                itemBuilder: (context, int index) {
                  return ExcerciseListWidget(
                      excerciseModel.allExcercise[index]);
                });
          }
        }),
      ),
    );
  }
}
