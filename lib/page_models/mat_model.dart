import 'dart:async';
import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_app/helpers/auth.dart';
import 'package:flutter_app/helpers/firebase_database.dart';

class MatsModel extends ChangeNotifier {
  List<MatModel> allMats;

  MatsModel.initialize() {
    allMats = new List<MatModel>(); // creating empty list of mat model
    //   String userId = AuthService.getCurrentUserId();
    var matsModelTransformer = StreamTransformer<Event, MatsModel>.fromHandlers(
        handleData: handleModelStreamTransform);
    FirebaseDatabaseUtil()
        .getModelStream(getModelRef(), matsModelTransformer)
        .listen((changedData) async {
      MatsModel changedMatsData = changedData;
      print("MATs data found to be changed!!");
      refreshModel(changedMatsData);
      notifyListeners();
      print("MATs Listeners notified!!");
    });
  }

  static String getModelRef() {
    String userId = AuthService.getCurrentUserId();
    return "/profiles/users/$userId/mats";
  }

  void refreshModel(MatsModel newMatsModelData) {
    allMats = newMatsModelData.allMats;
  }

  MatsModel.fromSnapshotValue(DataSnapshot dataSnapshot) {
    allMats = new List<MatModel>();
    LinkedHashMap fetchedMatsMap = dataSnapshot.value;
    if (fetchedMatsMap != null) {
      for (var mat in fetchedMatsMap.entries) {
        print("Creating player model for ${mat.key}");
        MatModel matToAdd = MatModel.fromSnapshotValue(mat.value, mat.key);
        allMats.add(matToAdd);
      }
    }
  }

  void handleModelStreamTransform(Event event, EventSink<MatsModel> sink) {
    print("Adding handler for stream transformation");
    MatsModel newMatsModel = MatsModel.fromSnapshotValue(event.snapshot);
    sink.add(newMatsModel);
  }
}

class MatModel extends ChangeNotifier {
  final String matId;
  String displayName;
  String macAddress;
  String macName;
  DateTime registeredOn;
  String status;

  MatModel.initialize(this.matId) {
    //   String userId = AuthService.getCurrentUserId();
    if (matId != null) {
      var matModelTransformer = StreamTransformer<Event, MatModel>.fromHandlers(
          handleData: handleModelStreamTransform);
      FirebaseDatabaseUtil()
          .getModelStream(getModelRef(matId), matModelTransformer)
          .listen((changedData) async {
        MatModel changedMatData = changedData;
        print("MAT data found to be changed!!");
        refreshModel(changedMatData);
        notifyListeners();
        print("MAT Listeners notified!!");
      });
    }
  }

  static String getModelRef(matId) {
    String userId = AuthService.getCurrentUserId();
    print("The MAT reference sent : /profiles/users/$userId/mats/$matId");
    return "/profiles/users/$userId/mats/$matId";
  }

  void refreshModel(MatModel newMatModelData) {
    displayName = newMatModelData.displayName;
    macAddress = newMatModelData.macAddress;
    macName = newMatModelData.macName;
    registeredOn = newMatModelData.registeredOn;
    status = newMatModelData.status;
  }

  MatModel.fromSnapshotValue(dynamic value, this.matId) {
    print("MAT ID IS FOUND TO BE - $matId");
    displayName = value['display-name'].toString();
    macAddress = value['mac-address'].toString();
    macName = value['mac-name']?.toString() ?? null;
    registeredOn = DateTime.parse(value['registered-on'].toString());
    status = value['status'].toString();
  }

  void handleModelStreamTransform(Event event, EventSink<MatModel> sink) {
    print("Adding handler for stream transformation");
    MatModel newMatModel =
        MatModel.fromSnapshotValue(event.snapshot.value, event.snapshot.key);
    sink.add(newMatModel);
  }

  static Future<void> updateMatNickName(String matId, String newNickName) {
    DatabaseReference matToUpdateRef =
        FirebaseDatabaseUtil().rootRef.child(getModelRef(matId));
    return matToUpdateRef.update({"display-name": newNickName});
  }

  MatModel.create(
      {this.matId,
      this.displayName,
      this.macAddress,
      this.registeredOn,
      this.status,
      this.macName});

  Future<String> persist() async {
    DatabaseReference newUserMatDb =
        FirebaseDatabaseUtil().rootRef.child(MatsModel.getModelRef()).push();
    await newUserMatDb.set({
      "registered-on": this.registeredOn.toIso8601String(),
      "mac-address": this.macAddress,
      "mac-name": this.macName,
      "status": this.status,
      "display-name": this.displayName,
    }).catchError((error) {
      print(error);
      return null;
    });

    return newUserMatDb.key;
  }

  @override
  String toString() {
    return 'MatModel(matId: $matId, displayName: $displayName, macAddress: $macAddress, macName: $macName, registeredOn: $registeredOn, status: $status)';
  }
}
