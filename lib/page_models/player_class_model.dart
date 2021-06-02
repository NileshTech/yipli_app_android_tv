import 'package:flutter_app/page_models/page_model_index.dart';

class PlayerLiveClassesModel extends ChangeNotifier {
  String getPlayerLiveClassesDatabaseRefName() {
    print("Reference sent = " +
        "profiles/users/$userId/players/$playerId/added-classes");
    return "profiles/users/$userId/players/$playerId/added-classes";
  }

  String userId;
  String playerId;

  List<String> addedClassIds = List<String>();

  PlayerLiveClassesModel();

  StreamTransformer playerLiveClassModelTransformer;

  void transformDBDataToPlayerLiveClassesData(
      Event event, EventSink<PlayerLiveClassesModel> sink) {
    print("Adding handler for stream transform");
    PlayerLiveClassesModel changedPlayerLiveClassModel =
        PlayerLiveClassesModel.fromSnapshotValue(
            event.snapshot.value, event.snapshot.key, userId, playerId);
    sink.add(changedPlayerLiveClassModel);
  }

  void initialize() {
    print("Creating the stream transformer for LiveClassModel");
    playerLiveClassModelTransformer =
        StreamTransformer<Event, PlayerLiveClassesModel>.fromHandlers(
            handleData: transformDBDataToPlayerLiveClassesData);
    print("Adding listener");

    FirebaseDatabaseUtil()
        .getModelStream(getPlayerLiveClassesDatabaseRefName(),
            playerLiveClassModelTransformer)
        .listen((changedPlayerLiveClassesData) {
      print("Live Class data found to be changed!!");
      setChangedPlayerLiveClassesData(changedPlayerLiveClassesData);
      notifyListeners();
      print("Class Listeners notified!!");
    });
  }

  void setChangedPlayerLiveClassesData(
      PlayerLiveClassesModel changedPlayerLiveClassesData) {
    addedClassIds = changedPlayerLiveClassesData.addedClassIds;
    print("New data for player class ${addedClassIds.length} has been changed");
  }

  PlayerLiveClassesModel.fromSnapshotValue(
      dynamic value, dynamic key, this.userId, this.playerId) {
    print("Creating player from Stream Snapshot value");

    if (value != null) {
      LinkedHashMap valuesEntries = value;
      for (var entry in valuesEntries.entries) {
        print("Adding classes list: ${entry.key}");
        addedClassIds.add(entry.value);
      }
    }
  }
}
