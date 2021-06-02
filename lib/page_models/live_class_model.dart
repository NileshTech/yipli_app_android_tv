import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/helpers/firebase_database.dart';

class LiveClassModel extends ChangeNotifier {
  static String getLiveClassDatabaseRefName(classId) {
    return "inventory/classes/$classId";
  }

  final String _id;
  int durationInMinutes;
  String expertiseLevel;
  String instructorName;
  DateTime scheduledAt;
  String title;
  String exerciseType;

  LiveClassModel(this._id);

  StreamTransformer liveClassModelTransformer;

  void transformDBDataToLiveClassData(
      Event event, EventSink<LiveClassModel> sink) {
    print("Adding handler for stream transform");
    LiveClassModel changedLiveClassModel = LiveClassModel.fromSnapshotValue(
        event.snapshot.value, event.snapshot.key, this._id);
    sink.add(changedLiveClassModel);
  }

  void initialize() {
    print("Creating the stream transformer for LiveClassModel");
    liveClassModelTransformer =
        StreamTransformer<Event, LiveClassModel>.fromHandlers(
            handleData: transformDBDataToLiveClassData);
    print("Adding listener");

    FirebaseDatabaseUtil()
        .getModelStream(
            getLiveClassDatabaseRefName(_id), liveClassModelTransformer)
        .listen((changedLiveClassData) {
      print("Live Class data found to be changed!!");
      setChangedLiveClassData(changedLiveClassData);
      notifyListeners();
      print("Class Listeners notified!!");
    });
  }

  void setChangedLiveClassData(LiveClassModel changedLiveClassData) {
    durationInMinutes = changedLiveClassData.durationInMinutes;
    expertiseLevel = changedLiveClassData.expertiseLevel;
    instructorName = changedLiveClassData.instructorName;
    scheduledAt = changedLiveClassData.scheduledAt;
    title = changedLiveClassData.title;
    exerciseType = changedLiveClassData.exerciseType;
    print("New data for class $title has been changed");
  }

  LiveClassModel.fromSnapshotValue(dynamic value, dynamic key, this._id) {
    print("Creating player from Stream Snapshot value");
    durationInMinutes = int.parse(value['duration'].toString());
    expertiseLevel = value['expertise-level'].toString();
    instructorName = value['instructor-name'].toString();
    scheduledAt = DateTime.parse(value['scheduled-at-date'].toString() +
        " " +
        value['scheduled-at-time'].toString());
    title = value["title"].toString();
    exerciseType = value["type"].toString();
  }
}
