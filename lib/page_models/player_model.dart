import 'package:flutter_app/page_models/page_model_index.dart';
import 'package:intl/intl.dart';

class PlayerModel extends ChangeNotifier {
  static String refName = "players";

  static String getPlayerDatabaseRefName(userId, playerId) {
    return "profiles/users/$userId/players/$playerId";
  }

  static Query getPlayerSessionsDatabaseQuery(String playerId) {
    print("Reference set = " + "sessions/game-sessions");
    return FirebaseDatabaseUtil()
        .rootRef
        .child("sessions")
        .child("game-sessions")
        .orderByChild("player-id")
        .equalTo(playerId);
  }

  String get id => _id;
  set id(id) => _id;
  String _id;
  String _gender;
  String _name;
  String _sessions;
  String _weight;
  String _height;
  String _dob;
  String _userId;
  int _isMatTutDone;
  ActivityStats _activityStats = new ActivityStats();
  PlayerPerformanceDetails _playerPerformanceDetails =
      new PlayerPerformanceDetails();
  bool _bIsCurrentPlayer = false;
  String _profilePicUrl;
  FileImage _profilePic;

  ActivityStats getActivityStats(dynamic data) {
    if (data == null) {
      print('hello activity');
      return new ActivityStats(
          iRedeemedFitnessPoints: 0,
          iTotalFitnessPoints: 0,
          iTotalDuration: 0,
          iTotalCaloriesBurnt: 0,
          iLastPlayedTimestamp: 0);
    }
    //dynamic data = snapshot.value;
    print(
        "@@@@@@@@@@@ LAST PLAYED: ${data['last-played'] ?? DateTime.now().millisecondsSinceEpoch}");
    _activityStats = new ActivityStats(
      iLastPlayedTimestamp:
          data['last-played'] ?? DateTime.now().millisecondsSinceEpoch,
      iRedeemedFitnessPoints: data['redeemed-fitness-points'] ?? 0,
      iTotalFitnessPoints: data['total-fitness-points'] ?? 0,
      iTotalDuration: data['total-duration'] ?? 0,
      iTotalCaloriesBurnt: data['total-calories-burnt'] ?? 0,
    );

    _activityStats.addGameStatistics(data["games-statistics"]);

    print(
        'Activity print : Last Played:[${_activityStats.iLastPlayedTimestamp}] ${_activityStats.iTotalFitnessPoints}, ${_activityStats.strTotalDuration},${_activityStats.strTotalCaloriesBurnt},');
    return _activityStats;
  }

  StreamTransformer playerModelTransformer;

  void handlePlayerDataStreamTranform(
      Event event, EventSink<PlayerModel> sink) {
    print("Adding handler for stream transform");
    if (event.snapshot.value != null) {
      PlayerModel changedPlayerModel = PlayerModel.fromSnapshotValue(
          event.snapshot.value, event.snapshot.key);
      if (changedPlayerModel.id != null) {
        sink.add(changedPlayerModel);
      } else {
        print("Skipping the player as player ID is null.");
      }
    }
  }

  PlayerModel({playerid}) {
    this._id = playerid;
  }

  void initialize() {
    print("Creating the stream transformer");
    playerModelTransformer = StreamTransformer<Event, PlayerModel>.fromHandlers(
        handleData: handlePlayerDataStreamTranform);
    print("Adding listener");
    _userId = AuthService.getCurrentUserId();

    FirebaseDatabaseUtil()
        .getModelStream(
            getPlayerDatabaseRefName(userId, _id), playerModelTransformer)
        .listen((changedPlayerData) {
      print("Player data found to be changed!!");
      setChangedPlayerData(changedPlayerData);
      notifyListeners();
      print("Listeners notified!!");
    });
  }

  void setChangedPlayerData(PlayerModel changedPlayerData) {
    _id = changedPlayerData._id;
    _gender = changedPlayerData._gender;
    _name = changedPlayerData._name;
    _weight = changedPlayerData._weight;
    _height = changedPlayerData._height;
    _dob = changedPlayerData._dob;
    _activityStats = changedPlayerData._activityStats;
    _playerPerformanceDetails = changedPlayerData._playerPerformanceDetails;
    _profilePicUrl = changedPlayerData._profilePicUrl;
    _userId = changedPlayerData._userId;
    _isMatTutDone = changedPlayerData._isMatTutDone;

    print("New data for player $_name has been changed");
  }

  PlayerModel.fromSnapshotValue(dynamic value, dynamic key) {
    print("Creating player from Stream Snapshot value");
    try {
      _id = key;
      _gender = value['gender'] ?? '';

      _name = value['name'];

      _isMatTutDone = value['mat-tut-done'];

      _weight = value['weight'] ?? '';

      _height = value['height'] ?? '';

      _dob = value['dob'] == null
          ? ""
          : DateFormat('dd-MMM-yyyy')
              .format(new DateFormat('MM-dd-yyyy').parse(value['dob']));
      _activityStats = getActivityStats(value['activity-statistics']);
      _profilePicUrl = value['profile-pic-url'];

      _userId = AuthService.getCurrentUserId();
    } catch (exp) {
      print("Exception occured in retrieveing the Player Properties");
      print("Error message : $exp");
      _id =
          null; // setting null to indicate that player data is corrupted. Ignore this player.
    }
  }

  String get gender => _gender;

  String get name => _name;

  int get isMatTutDone => _isMatTutDone;

  String get sessions => _sessions;

  String get weight => _weight;

  String get height => _height;

  String get dob => _dob;

  String get userId => _userId;

  ActivityStats get activityStats => _activityStats;

  PlayerPerformanceDetails get playerPerformanceDetails =>
      _playerPerformanceDetails;

  bool get bIsCurrentPlayer => _bIsCurrentPlayer;

  String get profilePicUrl => _profilePicUrl;

  FileImage get profilePic => _profilePic;
}
