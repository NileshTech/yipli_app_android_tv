import 'package:flutter_app/page_models/page_model_index.dart';

class GamesModel extends ChangeNotifier {
  static String refName = "games";
  List<GameDetails> allGames;
  static DatabaseReference getGamesDatabaseRefName() {
    return FirebaseDatabaseUtil().gamesRef;
  }

  StreamTransformer gamesModelTransformer;

  GamesModel() {
    allGames = new List<GameDetails>();
  }

  void handleGamesDataStreamTransform(Event event, EventSink<GamesModel> sink) {
    //   print("Adding handler for stream transformation in faq model");
    GamesModel changedGamesModel = GamesModel.fromSnapshotValue(event.snapshot);
    sink.add(changedGamesModel);
  }

  void initialize() {
    print("Creating the stream transformer for games model");
    gamesModelTransformer = StreamTransformer<Event, GamesModel>.fromHandlers(
        handleData: handleGamesDataStreamTransform);
    print("Adding games listener");
    FirebaseDatabaseUtil()
        .getModelStreamFromDbReference(
            getGamesDatabaseRefName(), gamesModelTransformer)
        .listen((changedData) {
      setChangedGamesData(changedData);
      notifyListeners();
      print("Listeners notified in Games model!!");
    });
  }

  void setChangedGamesData(GamesModel changedGamesData) {
    allGames = changedGamesData.allGames;
  }

  GamesModel.fromSnapshotValue(DataSnapshot gamesSnapshot) {
    allGames = new List<GameDetails>();

    LinkedHashMap fetchedGamesMap = gamesSnapshot.value;

    if (fetchedGamesMap != null) {
      for (var player in fetchedGamesMap.entries) {
        print("Creating model for ${player.key}");
        GameDetails playerToAdd =
            getGameDetailsFromSnapshot(player.value, player.key);
        allGames.add(playerToAdd);
      }
    }
  }

  GameDetails getGameDetailsFromSnapshot(dynamic value, dynamic key) {
    GameDetails updatedGameDetails = new GameDetails(
        id: key,
        androidUrl: value['android-url'] ?? "",
        iconImgUrl: value['icon-img-url'] ?? "",
        intensityLevel: value['intensity-level'] ?? "",
        iosUrl: value['ios-url'] ?? "",
        name: value['name'] ?? "",
        type: value['type'] ?? "",
        windowsUrl: value['windows-url'] ?? "",
        description: value['description'] ?? "",
        dynamiclink: value['dynamic-link'] ?? "");
    return updatedGameDetails;
  }

  List<GameDetails> getAllGames() {
    return allGames;
  }
}
