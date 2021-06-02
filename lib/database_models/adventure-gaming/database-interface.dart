import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/database_models/adventure-gaming/adventure_gaming_data.dart';
import 'package:flutter_app/database_models/adventure-gaming/class.dart';
import 'package:flutter_app/database_models/adventure-gaming/player_progress.dart';
import 'package:flutter_app/database_models/database_model_index.dart';
import 'package:flutter_app/helpers/helper_index.dart';
import 'package:flutter_app/page_models/player_model.dart';
import 'package:intl/intl.dart';

import 'worlds.dart';

//Following are mapped to the firebase backend.
//With more Worlds and curriculum getting added, Keep on adding their KEYS and use existing structure.
const CAVE_WORLD_INDEX = 0;
const WORLDS_KEY = "worlds";
const STORYLINE_KEY = "storyline";

const CURRICULUM_KEY = "curriculum";
const FIRST_CURRICULUM_KEY = "c0";

const ADV_INVENTORY_REF = "/inventory/adventure-gaming";

const PROGRESS_ZERO = "p0";

class PlayerProgressDatabaseHandler {
  PlayerModel playerModel;
  PlayerProgressDatabaseHandler({
    @required this.playerModel,
  });

  String _getAdventureGamingStatsPath() {
    print(
        "_getAdventureGamingStatsPath : /agp/${playerModel.userId}/${playerModel.id}/$WORLDS_KEY/$CAVE_WORLD_INDEX/$PROGRESS_ZERO");
    return "/agp/${playerModel.userId}/${playerModel.id}/$WORLDS_KEY/$CAVE_WORLD_INDEX/$PROGRESS_ZERO";
  }

  /* Takes index(from agp), as an input, and returns the corresponding class db ref*/
  String _getClassRefFromChapterIndex(int index) {
    print(
        "_getClassRefFromChapterIndex : $ADV_INVENTORY_REF/$CURRICULUM_KEY/$FIRST_CURRICULUM_KEY/$index");
    return "$ADV_INVENTORY_REF/$CURRICULUM_KEY/$FIRST_CURRICULUM_KEY/$index";
  }

  /* Start Index of curriculum decision tree based no player details */
  int getInitialClassIndexForPlayerModel(PlayerModel playerModel) {
    try {
      DateTime playerModelDob =
          new DateFormat('MM-dd-yyyy').parse(playerModel.dob);

      int age = YipliUtils.getAgeFromDOB(playerModelDob);

      //Check id the Age is <6 or >14
      if (age < 6) {
        return 0; //0 is the index of the 1st class with least intensity.
        //Any one less than 6 can be starting at the 0th index of curriculum.
      } else if (age > 14) {
        //This player is an adult.
        //TODo : Initial class depends on Adults questionire.
      } else {
        //Handle the start indexes for every age group specially
        switch (age) {
          case 6:
            return 0;
            break;
          case 7:
            return 10;
            break;
          case 8:
            return 20;
            break;
          case 9:
            return 30;
            break;
          case 10:
            return 40;
            break;
          case 11:
            return 50;
            break;
          case 12:
            return 60;
            break;
          case 13:
            return 70;
            break;
          case 14:
            return 80;
            break;
        }
      }
    } catch (exp) {
      print("Exception in calculating GetInitialClassIndexForPlayerModel $exp");
    }
    return 0; //least intensity class index
  }

  PlayerProgress _getInitialPlayerProgressData() {
    return PlayerProgress.fromMap({
      "next-chapter-ref": _getChapterRefFromChapterIndex(0),
      "next-class-ref": _getClassRefFromChapterIndex(
          getInitialClassIndexForPlayerModel(
              playerModel)), // to be decided based on the age, where to start
      "current-index": 0,
      "total-fp": 0,
      'average-rating': 0,
      'progress-stats': [],
    });
  }

  Future<DatabaseHandlerResponse> startJourneyForPlayer() async {
    Map<String, dynamic> newAdventureGamingPlayerData = {};
    PlayerProgress initialPlayerProgress = _getInitialPlayerProgressData();
    newAdventureGamingPlayerData[_getAdventureGamingStatsPath()] =
        initialPlayerProgress.toMap();
    newAdventureGamingPlayerData[_getHasWatchedVideoPath()] =
        true; // This will help to understand if Adv journey is started or not
    DatabaseHandlerResponse databaseHandlerResponse = DatabaseHandlerResponse();

    try {
      await FirebaseDatabase.instance
          .reference()
          .update(newAdventureGamingPlayerData);
      databaseHandlerResponse.message =
          "Initial Data for player saved successfully";
    } catch (e) {
      databaseHandlerResponse.errorDetails = e.toString();
      databaseHandlerResponse.message =
          "There was an error storing initial data of adventure gaming for player: ${playerModel.id} of user: ${playerModel.userId}";
      databaseHandlerResponse.statusCode = DatabaseHandlerStatusCode.FAIL;
    }
    return databaseHandlerResponse;
  }

//
  String _getChapterRefFromChapterIndex(int index) {
    print(
        "_getChapterRefFromChapterIndex :  $ADV_INVENTORY_REF/$WORLDS_KEY/$CAVE_WORLD_INDEX/$STORYLINE_KEY/$index");
    return "$ADV_INVENTORY_REF/$WORLDS_KEY/$CAVE_WORLD_INDEX/$STORYLINE_KEY/$index";
  }

  Stream<World> getWorldDataStream() {
    StreamTransformer worldModelTransformer =
        StreamTransformer<Event, World>.fromHandlers(
            handleData: handleWorldDataStreamTransform);

    return FirebaseDatabase.instance
        .reference()
        .child(_getWorldZeroPath())
        .onValue
        .transform(worldModelTransformer);
  }

  String _getWorldZeroPath() {
    return "$ADV_INVENTORY_REF/$WORLDS_KEY/$CAVE_WORLD_INDEX";
  }

  void handleWorldDataStreamTransform(Event data, EventSink<World> sink) {
    World changedWorldModel =
        World.fromMap(Map<String, dynamic>.from(data.snapshot.value));
    print("changedWorldModel $changedWorldModel");
    sink.add(changedWorldModel);
  }

  Stream<AdventureGamingData> getWorldAndPlayerProgressDataStream() {
    return StreamZip([
      getWorldDataStream(),
      getPlayerProgressDataStream(),
    ]).map(
      (worldAndPlayerData) {
        if (worldAndPlayerData != null) {
          print("worldAndPlayerData $worldAndPlayerData");
          AdventureGamingData adventureGamingData = AdventureGamingData(
            world: worldAndPlayerData[0],
            playerProgress: worldAndPlayerData[1],
          );
          print("adventureGamingData $adventureGamingData");

          return adventureGamingData;
        }
        return null;
      },
    );
  }

  Stream<PlayerProgress> getPlayerProgressDataStream() {
    StreamTransformer worldModelTransformer =
        StreamTransformer<Event, PlayerProgress>.fromHandlers(
            handleData: handlePlayerProgressDataStreamTransform);

    return FirebaseDatabase.instance
        .reference()
        .child(_getAdventureGamingStatsPath())
        .onValue
        .transform(worldModelTransformer);
  }

  void handlePlayerProgressDataStreamTransform(
      Event data, EventSink<PlayerProgress> sink) {
    PlayerProgress changedPlayerProgress =
        PlayerProgress.fromMap(Map<String, dynamic>.from(data.snapshot.value));
    print("PlayerProgress $changedPlayerProgress");

    sink.add(changedPlayerProgress);
  }

  Stream<AdventureGamingClassDetails> getClassDetailsStreamForClassRef(
      String classRef) {
    print("Got Class ref : $classRef");
    StreamTransformer classDetailsTransformer =
        StreamTransformer<Event, AdventureGamingClassDetails>.fromHandlers(
            handleData: handleClassDetailsTransform);

    return FirebaseDatabaseUtil()
        .rootRef
        .child(classRef)
        .onValue
        .transform(classDetailsTransformer);
  }

  void handleClassDetailsTransform(
      Event data, EventSink<AdventureGamingClassDetails> sink) {
    AdventureGamingClassDetails classDetails =
        AdventureGamingClassDetails.fromMap(
            Map<String, dynamic>.from(data.snapshot.value));
    print("Class details $classDetails");

    sink.add(classDetails);
  }

  Stream<bool> getHasPlayerWatchedVideoStream() {
    return FirebaseDatabaseUtil()
        .rootRef
        .child(_getHasWatchedVideoPath())
        .onValue
        .map((event) {
      if (event?.snapshot?.value != null) {
        return event?.snapshot?.value;
      }
      return false;
    });
  }

  String _getHasWatchedVideoPath() =>
      "/agp/${playerModel.userId}/${playerModel.id}/hasWatchedVideo";
}
