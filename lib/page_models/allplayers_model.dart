import 'dart:async';
import 'dart:collection';

import 'package:flutter_app/page_models/page_model_index.dart';
import 'package:flutter_app/page_models/player_model.dart';

class AllPlayersModel extends ChangeNotifier {
  static String refName = "players";
  static String getPlayerDatabaseRefName(userId) {
    print("Reference sent:- /profile/users/$userId/players");
    return "/profiles/users/$userId/players";
  }

  List<PlayerModel> allPlayers;
  String defaultPlayerId;
  StreamTransformer allPlayersModelTransformer;

  void handleAllPlayerDataStreamTranform(
      Event event, EventSink<AllPlayersModel> sink) {
    print("Adding handler for stream transformation");
    AllPlayersModel changedPlayerModel =
        AllPlayersModel.fromSnapshotValue(event.snapshot);
    sink.add(changedPlayerModel);
  }

  AllPlayersModel() {
    allPlayers = new List<PlayerModel>();
  }

  void initialize() {
    String userId = AuthService.getCurrentUserId();
    print("Creating the stream transformer for All players model");
    allPlayersModelTransformer =
        StreamTransformer<Event, AllPlayersModel>.fromHandlers(
            handleData: handleAllPlayerDataStreamTranform);
    print("Adding listener");
    FirebaseDatabaseUtil()
        .getModelStream(
            getPlayerDatabaseRefName(userId), allPlayersModelTransformer)
        .listen((changedData) {
      AllPlayersModel changedAllPlayers = changedData;
      print(
          "Player data found to be changed!! ${changedAllPlayers.allPlayers.length}");
      setChangedPlayerData(changedData);
      notifyListeners();
      print("Listeners notified!!");
    });
  }

  void setChangedPlayerData(AllPlayersModel changedPlayerData) {
    allPlayers = changedPlayerData.allPlayers;
  }

  AllPlayersModel.fromSnapshotValue(DataSnapshot allPlayersModel) {
    allPlayers = new List<PlayerModel>();
    LinkedHashMap fetchedPlayersMap = allPlayersModel.value;
    if (fetchedPlayersMap != null) {
      for (var player in fetchedPlayersMap.entries) {
        print("Creating player model for ${player.key}");
        PlayerModel playerToAdd =
            PlayerModel.fromSnapshotValue(player.value, player.key);
        if (playerToAdd.id != null) {
          allPlayers.add(playerToAdd);
        } else {
          print("Skipping the player as player data is corrupted.");
        }
      }
    }
  }
}
