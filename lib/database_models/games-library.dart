import 'database_model_index.dart';

class GamesLibrary {
  static String refName = "games-library";

  String _id;
  String _iconImgUrl;
  String _intensityLevel;
  String _iosUrl;
  String _name;
  String _androidUrl;
  String _windowsUrl;
  String _type;

  GamesLibrary(
      {id,
      iconImgUrl,
      intensityLevel,
      iosUrl,
      name,
      androidUrl,
      windowsUrl,
      type});

  String get id => _id;
  String get type => _type;

  String get iconImgUrl => _iconImgUrl;

  String get windowsUrl => _windowsUrl;

  String get androidUrl => _androidUrl;

  String get name => _name;

  String get iosUrl => _iosUrl;

  String get intensityLevel => _intensityLevel;

  GamesLibrary.fromSnapshot(dynamic snapshot, String key) {
    _id = key;
    _iconImgUrl = snapshot['icon-img-url'];
    _intensityLevel = snapshot['intensity-level'];
    _iosUrl = snapshot['ios-url'];
    _name = snapshot['name'];
    _androidUrl = snapshot['android-url'];
    _windowsUrl = snapshot['windows-url'];
    _type = snapshot['type'];
  }

  factory GamesLibrary.fromJson(Map<dynamic, dynamic> parsedJson) {
    return GamesLibrary(
      id: parsedJson["id"],
      iconImgUrl: parsedJson['icon-img-url'],
      intensityLevel: parsedJson['intensity-level'],
      iosUrl: parsedJson['ios-url'],
      name: parsedJson['name'],
      androidUrl: parsedJson['android-url'],
      windowsUrl: parsedJson['windows-url'],
      type: parsedJson['type'],
    );
  }

  static Future<List<GamesLibrary>> getAllGames() async {
    var games = await FirebaseDatabaseUtil().gamesRef.once();
    List<GamesLibrary> listOfGames = new List<GamesLibrary>();
    print(games);
    LinkedHashMap gamesMap = games.value;

    for (var gameLibKey in gamesMap.keys) {
      GamesLibrary gamesLibrary =
          GamesLibrary.fromSnapshot(gamesMap[gameLibKey], gameLibKey);
      listOfGames.add(gamesLibrary);
    }

    return listOfGames;
  }
}
