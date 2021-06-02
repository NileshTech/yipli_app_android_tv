import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/firebase_database.dart';

class GameModel extends ChangeNotifier {
  String id;
  String androidUrl;
  String description;
  String iconImgUrl;
  String intensityLevel;
  String iosUrl;
  String name;
  String type;
  String windowsUrl;
  GameModel({
    this.id,
    this.androidUrl,
    this.description,
    this.iconImgUrl,
    this.intensityLevel,
    this.iosUrl,
    this.name,
    this.type,
    this.windowsUrl,
  });

  GameModel copyWith({
    String id,
    String androidUrl,
    String description,
    String iconImgUrl,
    String intensityLevel,
    String iosUrl,
    String name,
    String type,
    String windowsUrl,
  }) {
    return GameModel(
      id: id ?? this.id,
      androidUrl: androidUrl ?? this.androidUrl,
      description: description ?? this.description,
      iconImgUrl: iconImgUrl ?? this.iconImgUrl,
      intensityLevel: intensityLevel ?? this.intensityLevel,
      iosUrl: iosUrl ?? this.iosUrl,
      name: name ?? this.name,
      type: type ?? this.type,
      windowsUrl: windowsUrl ?? this.windowsUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'android-url': androidUrl,
      'description': description,
      'icon-img-url': iconImgUrl,
      'intensity-level': intensityLevel,
      'ios-url': iosUrl,
      'name': name,
      'type': type,
      'windows-url': windowsUrl,
    };
  }

  static GameModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GameModel(
      id: map['id'],
      androidUrl: map['android-url'],
      description: map['description'],
      iconImgUrl: map['icon-img-url'],
      intensityLevel: map['intensity-level'],
      iosUrl: map['ios-url'],
      name: map['name'],
      type: map['type'],
      windowsUrl: map['windows-url'],
    );
  }

  static GameModel fromSnapshot(String key, dynamic map) {
    if (map == null) return null;

    return GameModel(
      id: key,
      androidUrl: map['android-url'],
      description: map['description'],
      iconImgUrl: map['icon-img-url'],
      intensityLevel: map['intensity-level'],
      iosUrl: map['ios-url'],
      name: map['name'],
      type: map['type'],
      windowsUrl: map['windows-url'],
    );
  }

  String toJson() => json.encode(toMap());

  static GameModel fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'GameModel(id: $id, androidUrl: $androidUrl, description: $description, iconImgUrl: $iconImgUrl, intensityLevel: $intensityLevel, iosUrl: $iosUrl, name: $name, type: $type, windowsUrl: $windowsUrl)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GameModel &&
        o.id == id &&
        o.androidUrl == androidUrl &&
        o.description == description &&
        o.iconImgUrl == iconImgUrl &&
        o.intensityLevel == intensityLevel &&
        o.iosUrl == iosUrl &&
        o.name == name &&
        o.type == type &&
        o.windowsUrl == windowsUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        androidUrl.hashCode ^
        description.hashCode ^
        iconImgUrl.hashCode ^
        intensityLevel.hashCode ^
        iosUrl.hashCode ^
        name.hashCode ^
        type.hashCode ^
        windowsUrl.hashCode;
  }

  static DatabaseReference getGameModelRef(gameId) {
    return FirebaseDatabaseUtil()
        .rootRef
        .child("inventory")
        .child("games")
        .child(gameId);
  }

  void handleGameModelDataStreamTransform(
      Event event, EventSink<GameModel> sink) {
    // print("Adding handler for stream transformation in faq model");
    GameModel changedGameModel =
        GameModel.fromSnapshot(event.snapshot.key, event.snapshot.value);
    sink.add(changedGameModel);
  }

  StreamTransformer gameModelTransformer;

  void initialize(String gameId) {
    // print("Creating the stream transformer for Game model");
    gameModelTransformer = StreamTransformer<Event, GameModel>.fromHandlers(
        handleData: handleGameModelDataStreamTransform);
    // print("Adding faq listener");
    FirebaseDatabaseUtil()
        .getModelStreamFromDbReference(
            getGameModelRef(gameId), gameModelTransformer)
        .listen((changedData) {
      if (changedData != null) {
        setChangedGameModelData(changedData);
        notifyListeners();
        //print("Listeners notified in faq model!!");
      }
    });
  }

  void setChangedGameModelData(GameModel changedData) {
    this.id = changedData.id;
    this.androidUrl = changedData.androidUrl;
    this.description = changedData.description;
    this.iconImgUrl = changedData.iconImgUrl;
    this.intensityLevel = changedData.intensityLevel;
    this.iosUrl = changedData.iosUrl;
    this.name = changedData.name;
    this.type = changedData.type;
    this.windowsUrl = changedData.windowsUrl;
  }
}
