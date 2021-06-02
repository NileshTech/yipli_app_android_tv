import 'database_model_index.dart';

class Players {
  static String refName = "players";
  String _id;
  String _gender;
  String _name;
  String _weight;
  String _height;
  String _dob;
  String _userId;
  bool _bIsCurrentPlayer = false;
  String _profilePicUrl;
  FileImage _profilePic;

  FileImage get profilePic => _profilePic;
  String get profilePicUrl => _profilePicUrl;

  Players(this._id, this._name, this._weight, this._height, this._dob,
      this._bIsCurrentPlayer, this._userId);

  String get id => _id;

  Players.fromSnapshot(dynamic snapshot, key) {
    _id = key;
    _gender = snapshot['gender'];
    _name = snapshot['name'];

    _weight = snapshot['weight'];

    _height = snapshot['height'];
    _dob = snapshot['dob'];

    _userId = snapshot['user-id'];

    _profilePicUrl = snapshot['profile-pic-url'];
  }

  String get name => _name;

  String get weight => _weight;

  String get height => _height;

  String get dob => _dob;

  String get userId => _userId;

  String get gender => _gender;

  bool get bIsCurrentPlayer => _bIsCurrentPlayer;

  Future<String> deleteRecord() async {
    print('This is delete the record');
    DatabaseReference newPlayerDb =
        FirebaseDatabaseUtil().playersRef().child(this._id);
    await newPlayerDb.remove().catchError((error) {
      print(error);
      return null;
    });
    return this._id;
  }

  Future<String> persistNewRecord() async {
    DatabaseReference newPlayerDb;
    print('This is create new record');
    var rng1 = new Random();
    String buddyCode = "";
    for (var i = 0; i < 10; i++) {
      int temp = rng1.nextInt(100);
      String tempstring = temp.toString();
      print(tempstring);
      buddyCode = buddyCode + tempstring;
    }

    newPlayerDb = FirebaseDatabaseUtil().playersRef().push();
    await newPlayerDb.set({
      "user-id": this.userId,
      "name": this.name,
      "weight": this.weight,
      "height": this.height,
      "dob": this.dob,
      "gender": this.gender,
      // "player-code": buddyCode,
      "added-on": DateTime.now().millisecondsSinceEpoch,
    }).catchError((error) {
      print(error);
      return null;
    });

    print('Created new player with ID : ${newPlayerDb.key}');

    if (this.profilePic != null) {
      FirebaseStorageUtil.profilePicsRef
          .child("${newPlayerDb.key}.jpg")
          .putFile(
            this.profilePic.file,
          );

      FirebaseDatabaseUtil().playersRef().child(newPlayerDb.key);
      await newPlayerDb.update({
        "profile-pic-url": "${newPlayerDb.key}.jpg",
      }).catchError((error) {
        print(error);
        return newPlayerDb.key;
      });
    } else {
      print("profile pic is null. Cannot update it.");
    }
    print(
        "profiles/users/${AuthService.getCurrentUserId()}/players/${newPlayerDb.key}");
    print("FirebaseDatabaseUtil().playerCodeRef.child(buddyCode)");
    FirebaseDatabaseUtil().playerCodeRef.child(buddyCode);
    DatabaseReference newPlayerCodeDb =
        FirebaseDatabaseUtil().playerCodeRef.push();

    await newPlayerCodeDb.update({
      "player-path":
          "profiles/users/${AuthService.getCurrentUserId()}/players/${newPlayerDb.key}",
      "player-code": buddyCode,
    }).catchError((error) {
      print(error);

      return newPlayerCodeDb.key;
    });

    return newPlayerDb.key;
  }

  Future<String> persistRecord() async {
    print('This is update record');
    DatabaseReference newPlayerDb;
    newPlayerDb = FirebaseDatabaseUtil().playersRef().child(this._id);
    await newPlayerDb.update({
      "name": this.name,
      "weight": this.weight,
      "height": this.height,
      "dob": this.dob,
      "gender": this.gender,
      "profile-pic-url": this.profilePicUrl,
    }).catchError((error) {
      print(error);
      return null;
    });
    return this._id;
  }

  Future<String> persistProfilePic() async {
    print('This is update record');
    DatabaseReference newPlayerDb;
    newPlayerDb = FirebaseDatabaseUtil().playersRef().child(this._id);
    await newPlayerDb.update({
      "profile-pic-url": this.profilePicUrl,
    }).catchError((error) {
      print(error);
      return null;
    });
    return this._id;
  }

  static Future<Players> getPlayerDetails(String playerId) async {
    Players playerToReturn;
    DatabaseReference playersDb =
        FirebaseDatabaseUtil().getUserRef().child("players/$playerId");

    DataSnapshot fetchedPlayer = await playersDb.once();

    playerToReturn = Players.fromSnapshot(fetchedPlayer.value, playerId);

    print('Found player with property : $playerToReturn ');
    return playerToReturn;
  }

/*  //TODO @Saketh - get buddies
  //TODO @Saketh - add buddies
  //TODO @Saketh - delete buddies
  static Future<List<Players>> getBuddies(Players currentPlayer) async {
    print("ingetbuddies");
    currentPlayer = await getPlayerDetails(
        "-M-PQAfuC5jFgH4WZq5M"); //ned to get it from backend dont hard code
    print("this is the print statement ${currentPlayer.gender}");
    List<Players> buddyPlayersToReturn = new List<Players>(); // use await
    for (int i = 0; i < currentPlayer._buddies.length; i++) {
      Players tempBuddyPlayer =
          await getPlayerDetails(currentPlayer._buddies[i].playerId);
      if (currentPlayer._buddies[i].status == Status.Accepted.toString())
        buddyPlayersToReturn.add(tempBuddyPlayer);
    }
//Print debug statement

    return buddyPlayersToReturn;
  }

  static void setAcceptedStatus(Players currentPlayer, Players buddyPlayer) {
    for (int i = 0; i <= currentPlayer.buddies.length; i++) {
      if (currentPlayer.buddies[i].playerId == buddyPlayer.id) {
        currentPlayer.buddies[i].status = Status.Accepted.toString();
      }
    }
    for (int i = 0; i <= buddyPlayer.buddies.length; i++) {
      if (buddyPlayer.buddies[i].playerId == currentPlayer.id) {
        buddyPlayer.buddies[i].status = Status.Accepted.toString();
      }
    }
  }

  static void addBuddy(Players currentPlayer, Players buddieplayer) async {
    //to be added in addbuddiescreen
    //once notification gets accepted
    setAcceptedStatus(currentPlayer, buddieplayer);
  }

  static void sendRequest(Players currentPlayer, Players buddieplayer) async {
    BuddyDetails tempdetails = new BuddyDetails(buddieplayer.id,
        new DateTime.now().toString(), new DateTime.now().toString());
    currentPlayer.buddies.add(tempdetails);
    tempdetails = new BuddyDetails(currentPlayer.id,
        new DateTime.now().toString(), new DateTime.now().toString());
    buddieplayer.buddies.add(tempdetails);
    //send notification here
    // use await
    //to be added in addbuddiescreen
  }

  static void deleteBuddy(String currentPlayerId, String buddyPlayerId) async {
    //set the specific buddie id to null
//    Players currentPlayer = await getPlayerDetails(currentPlayerId);
//    Players buddyPlayer = await getPlayerDetails(buddyPlayerId);
  }
*/
  Players.createDBPlayerFromPlayerDetails(PlayerDetails playerTile) {
    this._userId = playerTile.userId;
    this._id = playerTile.playerId;
    this._name = playerTile.playerName;
    this._weight = playerTile.weight;
    this._height = playerTile.height;
    this._dob = playerTile.dob;
    this._gender = playerTile.gender;
    this._profilePicUrl = playerTile.profilePicUrl;
    this._profilePic = playerTile.profilePic;
  }
}
