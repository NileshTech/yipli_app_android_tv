import 'package:flutter_app/page_models/page_model_index.dart';

class PlayerGameSessionModel extends ChangeNotifier {
  static Query getPlayerGameSessionDatabaseQuery(String playerId) {
    print("Reference set = " + "sessions/game-sessions");
    return FirebaseDatabaseUtil()
        .rootRef
        .child("sessions")
        .child("game-sessions")
        .orderByChild("player-id")
        .equalTo(playerId);
  }

  List<PlayerGameSessionData> playerGameSessionAllData =
      new List<PlayerGameSessionData>();
  String playerId;
  int lastPlayed;

  StreamTransformer playerGameSessionModelTransformer;

  void transformDBPlayerGameSessionModelData(
      Event event, EventSink<PlayerGameSessionModel> sink) {
    print("Adding handler for stream transform of PlayerGameSessionModel");
    PlayerGameSessionModel changedPlayerGameSessionModel =
        PlayerGameSessionModel.fromSnapshotValue(event.snapshot, playerId);
    sink.add(changedPlayerGameSessionModel);
  }

  PlayerGameSessionModel(
    this.playerId,
    this.lastPlayed,
  );

  void initialize() {
    print("Creating the stream transformer for PlayerGameSessionModel");
    playerGameSessionModelTransformer =
        StreamTransformer<Event, PlayerGameSessionModel>.fromHandlers(
            handleData: transformDBPlayerGameSessionModelData);

    var playerGameSessionDatabaseRefName =
        getPlayerGameSessionDatabaseQuery(playerId);
    FirebaseDatabaseUtil()
        .getModelStreamFromDbQuery(
            playerGameSessionDatabaseRefName, playerGameSessionModelTransformer)
        .listen((changedPlayerGameSessionData) {
      print("PlayerGameSession data found to be changed!!");
      setChangedPlayerGameSessionData(changedPlayerGameSessionData);
      notifyListeners();
      print("Class Listeners notified!!");
    });
  }

  void setChangedPlayerGameSessionData(
      PlayerGameSessionModel changedPlayerGameSessionModelData) {
    playerGameSessionAllData =
        changedPlayerGameSessionModelData.playerGameSessionAllData;

    print("New data for class $playerId has been changed");
  }

  PlayerGameSessionModel.fromSnapshotValue(
      dynamic playerGameSessionSnapshot, this.playerId) {
    //LinkedHashMap fetchedGamesMap = gamesSnapshot.value;

    LinkedHashMap fetchedPlayerGameSessionMap = playerGameSessionSnapshot.value;
    if (fetchedPlayerGameSessionMap != null) {
      playerGameSessionAllData.clear();
      for (var playerSingleGameSession in fetchedPlayerGameSessionMap.entries) {
        PlayerGameSessionData playerGameSessionData = new PlayerGameSessionData(
          age: playerSingleGameSession.value['age' ?? '0'].toString(),
          duration: playerSingleGameSession.value['duration' ?? '0'].toString(),
          calories: playerSingleGameSession.value['calories'],
          fitnessPoints: double.parse(
              (playerSingleGameSession.value['fitness-points']).toString()),
          gameId: playerSingleGameSession.value['game-id'],
          intensity: playerSingleGameSession.value['intensity'].toString(),
        );
        playerGameSessionAllData.add(playerGameSessionData);
      }
    } else
      print('game session list null');
  }
}
