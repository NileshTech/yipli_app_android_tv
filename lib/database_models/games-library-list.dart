import 'package:flutter_app/database_models/database_model_index.dart';

class GamesLibraryList {
  List<GamesLibrary> gamesList;

  GamesLibraryList({this.gamesList});

  factory GamesLibraryList.fromJSON(Map<dynamic, dynamic> json) {
    return GamesLibraryList(gamesList: parseGames(json));
  }

  static List<GamesLibrary> parseGames(Map json) {
    var gList = json['games-library'] as List;
    List<GamesLibrary> gamesListToSend =
        gList.map((data) => GamesLibrary.fromJson(data)).toList(); //Add this
    return gamesListToSend;
  }
}
