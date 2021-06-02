import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/ExcerciseDetails.dart';
import 'package:flutter_app/helpers/firebase_database.dart';

class ExcerciseModel extends ChangeNotifier {
  static String refName = "excercies";

  static DatabaseReference getExcerciseDatabaseRefName() {
    return FirebaseDatabaseUtil().excerciseRef;
  }

  List<ExcerciseDetails> allExcercise;

  StreamTransformer excerciseModelTransformer;

  ExcerciseModel() {
    allExcercise = new List<ExcerciseDetails>();
  }

  void handleExcerciseDataStreamTransform(
      // print("Adding handler for stream transformation in excercise model");
      Event event,
      EventSink<ExcerciseModel> sink) {
    print("Adding handler for stream transformation in excercise model");
    ExcerciseModel changedExcerciseModel =
        ExcerciseModel.fromSnapshotValue(event.snapshot);
    sink.add(changedExcerciseModel);
  }

  void initialize() {
    print("Creating the stream transformer for excercise model");
    excerciseModelTransformer =
        StreamTransformer<Event, ExcerciseModel>.fromHandlers(
            handleData: handleExcerciseDataStreamTransform);
    print("Adding excercise listener");
    //print("Adding excercise listener");
    FirebaseDatabaseUtil()
        .getModelStreamFromDbReference(
            getExcerciseDatabaseRefName(), excerciseModelTransformer)
        .listen((changedData) {
      setChangedExcerciseData(changedData);
      notifyListeners();
      //print("Listeners notified in excercise model!!");
    });
  }

  void setChangedExcerciseData(ExcerciseModel changedExcerciseData) {
    allExcercise = changedExcerciseData.allExcercise;
  }

  ExcerciseModel.fromSnapshotValue(DataSnapshot excerciseSnapshot) {
    allExcercise = new List<ExcerciseDetails>();
    List<dynamic> fetchedExcerciseMap = excerciseSnapshot.value;
    if (fetchedExcerciseMap != null) {
      for (var excercise in fetchedExcerciseMap.sublist(0)) {
        ExcerciseDetails excerciseDetails = new ExcerciseDetails(
          excercise['desc'],
          excercise['name'],
          excercise['videoUrl'],
        );
        allExcercise.add(excerciseDetails);
      }
    } else
      print('excercise list null');
  }
}
