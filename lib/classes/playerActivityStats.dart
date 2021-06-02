import 'classes_index.dart';

class ActivityStats {
  String strRedeemedFitnessPoints;
  String strTotalFitnessPoints;
  String strTotalDuration;
  String strTotalCaloriesBurnt;
  List<GameStats> gameStatistics;

  int iRedeemedFitnessPoints;
  int iTotalFitnessPoints;
  int iTotalDuration;
  int iTotalCaloriesBurnt;
  int iLastPlayedTimestamp;

  ActivityStats(
      {this.iRedeemedFitnessPoints = 0,
      this.iTotalFitnessPoints = 0,
      this.iTotalDuration = 0,
      this.iTotalCaloriesBurnt = 0,
      this.iLastPlayedTimestamp = 0}) {
    strRedeemedFitnessPoints = iRedeemedFitnessPoints.toString();
    strTotalFitnessPoints = iTotalFitnessPoints.toString();
    strTotalCaloriesBurnt = iTotalCaloriesBurnt.toString();
    strTotalDuration = iTotalDuration.toString();
    gameStatistics = List<GameStats>();
  }

  void addGameStatistics(dynamic data) {
    if (data != null) {
      for (var gameId in data.keys) {
        //If that game exists in the Yipli Inventory then add only, else ignore(must be stale/omitted data)

        gameStatistics.add(GameStats.fromSnapshot(data[gameId], gameId));
      }
    }
  }

  /// the below code will be required when the player sessions referred to discontinued games

//  List<GameStats> getValidGamesPlayedStatistics(GamesModel gamesModel) {
//    List<GameStats> validGamesPlayedStatistics = new List<GameStats>();
//    if (gamesModel != null) {
//      for (var playedGame in gameStatistics) {
//        for (var actualGame in gamesModel.allGames) {
//          if (actualGame.id == playedGame.gameId) {
//            validGamesPlayedStatistics.add(playedGame);
//          }
//        }
//      }

//    }
//    return validGamesPlayedStatistics;
//  }
}

class GameStats {
  String gameId;
  String caloriesBurnt;
  String fitnessPoints;
  String gamePoints;
  String duration;
  int lastPlayedTimestamp;
  GameStats(
      {this.gameId,
      this.caloriesBurnt = '0',
      this.fitnessPoints = '0',
      this.gamePoints = '0',
      this.duration = '0',
      this.lastPlayedTimestamp = 0});

  GameStats copyWith(
      {String gameId,
      String caloriesBurnt,
      String fitnessPoints,
      String gamePoints,
      String duration,
      int lastPlayedTimestamp}) {
    return GameStats(
        gameId: gameId ?? this.gameId,
        caloriesBurnt: caloriesBurnt ?? this.caloriesBurnt,
        fitnessPoints: fitnessPoints ?? this.fitnessPoints,
        gamePoints: gamePoints ?? this.gamePoints,
        duration: duration ?? this.duration,
        lastPlayedTimestamp: lastPlayedTimestamp ?? this.lastPlayedTimestamp);
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'caloriesBurnt': caloriesBurnt,
      'fitnessPoints': fitnessPoints,
      'gamePoints': gamePoints,
      'duration': duration,
      'lastPlayed': lastPlayedTimestamp
    };
  }

  static GameStats fromSnapshot(dynamic map, gameId) {
    if (map == null) return null;

    return GameStats(
      gameId: gameId,
      caloriesBurnt: (map['calories-burnt'] ?? '0').toString(),
      fitnessPoints: (map['fitness-points'] ?? '0').toString(),
      gamePoints: (map['game-points'] ?? '0').toString(),
      duration: (map['duration'] ?? '0').toString(),
      lastPlayedTimestamp: map["last-played"] ?? 0,
    );
  }

  static GameStats fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GameStats(
      gameId: map['gameId'],
      caloriesBurnt: map['caloriesBurnt'],
      fitnessPoints: map['fitnessPoints'],
      gamePoints: map['gamePoints'],
      duration: map['duration'],
      lastPlayedTimestamp: map["last-played"] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  static GameStats fromJson(String source) => fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is GameStats &&
        o.gameId == gameId &&
        o.caloriesBurnt == caloriesBurnt &&
        o.fitnessPoints == fitnessPoints &&
        o.gamePoints == gamePoints &&
        o.duration == duration &&
        o.lastPlayedTimestamp == o.lastPlayedTimestamp;
  }

  @override
  int get hashCode {
    return gameId.hashCode ^
        caloriesBurnt.hashCode ^
        fitnessPoints.hashCode ^
        gamePoints.hashCode ^
        duration.hashCode ^
        lastPlayedTimestamp.hashCode;
  }

  @override
  String toString() {
    return 'GameStats(gameId: $gameId, caloriesBurnt: $caloriesBurnt, fitnessPoints: $fitnessPoints, gamePoints: $gamePoints, duration: $duration, lastPlayedTimestamp: $lastPlayedTimestamp)';
  }
}
