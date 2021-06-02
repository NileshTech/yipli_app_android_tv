import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app/database_models/inventory.dart';
import 'package:flutter_app/database_models/mat-inventory.dart';
import 'package:flutter_app/database_models/users.dart';
import 'package:flutter_app/helpers/auth.dart';
import 'package:flutter_app/page_models/excercise_model.dart';

import 'helper_index.dart';

enum DatabaseHandlerStatusCode { SUCCESS, FAIL }

class DatabaseHandlerResponse {
  DatabaseHandlerStatusCode statusCode;
  String message;
  String errorDetails;
  DatabaseHandlerResponse({
    this.statusCode = DatabaseHandlerStatusCode.SUCCESS,
    this.message = "",
    this.errorDetails,
  });

  @override
  String toString() =>
      'DatabaseHandlerResponse(statusCode: $statusCode, message: $message, errorDetails: $errorDetails)';
}

class FirebaseDatabaseUtil {
  DatabaseReference _gamesRef;
  DatabaseReference _inventoryRef;
  DatabaseReference _matsInventoryRef;
  DatabaseReference _faqRef;
  DatabaseReference _excerciseRef;
  DatabaseReference _playerCodeRef;
  DatabaseReference _remoteCodeRef;
  static DatabaseReference _rootRef;
  DatabaseReference _fitnessCardsRef;

  static FirebaseDatabaseUtil _instance;

  static destroyInstance() {
    print("Destroying the current Firebase DB instance.");
    _instance = null;
  }

  FirebaseDatabaseUtil._internal() {
    print("Creating all the refs.");
    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _rootRef = FirebaseDatabase.instance.reference();
    _inventoryRef = _rootRef.child(Inventory.refName);
    _excerciseRef = _inventoryRef.child(ExcerciseModel.refName);
    _matsInventoryRef = _inventoryRef.child(MatsInventory.refName);
    _gamesRef = _inventoryRef.child(GamesModel.refName);
    _playerCodeRef = _rootRef.child("mappings/playercodes");
    _fitnessCardsRef = _inventoryRef.child('fitness-cards');
    _remoteCodeRef = _rootRef.child("remote-codes");
  }

  factory FirebaseDatabaseUtil() {
    if (_instance == null) {
      _instance = new FirebaseDatabaseUtil._internal();
    }
    return _instance;
  }

  DatabaseReference getUserRef() {
    print(
        "Returning UserRef for current user : /profiles/${Users.refName}/${AuthService.getCurrentUserId()}");
    return FirebaseDatabase.instance
        .reference()
        .child("/profiles/${Users.refName}/${AuthService.getCurrentUserId()}");
  }

  DatabaseReference get inventoryRef => _inventoryRef;
  DatabaseReference get playerCodeRef => _playerCodeRef;

  DatabaseReference get remoteCodeRef => _remoteCodeRef;
  DatabaseReference get gamesRef => _gamesRef;
  DatabaseReference playersRef() {
    return getUserRef().child("players");
  }

  DatabaseReference remoteCodeDBRef(String userId) {
    return _remoteCodeRef.child("$userId");
  }

  DatabaseReference get rootRef => _rootRef;

  //DatabaseReference get usersRef => _usersRef;
  DatabaseReference get faqRef => _faqRef;
  DatabaseReference get fitnessCardsRef => _fitnessCardsRef;
  DatabaseReference get excerciseRef => _excerciseRef;

  Stream<dynamic> getModelStreamSortedByPlayerId(String databaseRefName,
      StreamTransformer streamTransformer, String playerId) {
    DatabaseReference modelDBReference = _rootRef
        .child(databaseRefName)
        .orderByChild("player-id")
        .equalTo(playerId);
    Stream<Event> modelStream = modelDBReference.onValue;
    Stream<dynamic> modelStreamToReturn =
        modelStream.transform(streamTransformer);
    return modelStreamToReturn;
  }

  Stream<dynamic> getModelStream(
      String databaseRefName, StreamTransformer streamTransformer) {
    DatabaseReference modelDBReference = _rootRef.child(databaseRefName);
    Stream<Event> modelStream = modelDBReference.onValue;
    Stream<dynamic> modelStreamToReturn =
        modelStream.transform(streamTransformer);
    return modelStreamToReturn;
  }

  Stream<dynamic> getModelStreamFromDbReference(
      DatabaseReference databaseRefName, StreamTransformer streamTransformer) {
    Stream<Event> modelStream = databaseRefName.onValue;
    Stream<dynamic> modelStreamToReturn =
        modelStream.transform(streamTransformer);
    return modelStreamToReturn;
  }

  Stream<dynamic> getModelStreamFromDbQuery(
      Query query, StreamTransformer streamTransformer) {
    Stream<Event> modelStream = query.onValue;
    Stream<dynamic> modelStreamToReturn =
        modelStream.transform(streamTransformer);
    return modelStreamToReturn;
  }

  DatabaseReference get matsInventoryRef => _matsInventoryRef;

  static FirebaseDatabaseUtil get instance => _instance;
}

/*

Database rules:

{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null",
    "sessions":{
      "game-sessions":{
				".indexOn":["player-id"]
      }
    }
  }
}

*/
