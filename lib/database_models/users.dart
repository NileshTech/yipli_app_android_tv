import 'package:flutter_app/page_models/page_model_index.dart';
import 'package:flutter_app/page_models/player_model.dart';

import 'database_model_index.dart';

class Users {
  static String refName = "users";
  String _id;
  List<PlayerModel> _players;
  List<String> _mats;
  String _contactNo;
  String _email;
  String _displayName;
  String _currentPlayerId;
  String _currentMatId;
  String _location;
  String _profilePicUrl;
  File _profilePic;

  bool hasSubscribed;

  String get location => _location;

  String get currentPlayerId => _currentPlayerId;
  String get currentMatId => _currentMatId;

  File get profilePic => _profilePic;
  String get profilePicUrl => _profilePicUrl;

  Users(this._id, this._players, this._mats, this._contactNo, this._email,
      this._displayName,
      [this._currentPlayerId, this._location, this._currentMatId]);

  String get id => _id;

  Future<String> persistProfilePic() async {
    print('This is user update record for user : ${this.id}');
    DatabaseReference newUserDb = FirebaseDatabaseUtil().getUserRef();
    await newUserDb
        .update({"profile-pic-url": this.profilePicUrl}).catchError((error) {
      print(error);
      return null;
    });
    return this._id;
  }

  Future<String> persistRecord() async {
    print('This is user update record for user : ${this.id}');
    DatabaseReference newUserDb = FirebaseDatabaseUtil().getUserRef();
    await newUserDb.update({
      "display-name": this.displayName,
      "email": this.email,
      "contact-no": this.contactNo,
      "location": this.location,
      "profile-pic-url": this.profilePicUrl,
      "has-subcribed": this.hasSubscribed
    }).catchError((error) {
      print(error);
      return null;
    });
    return this._id;
  }

  Users.fromSnapshot(dynamic snapshot, String uId) {
    _id = uId;
    _mats = snapshot['mats'];
    _contactNo = snapshot['contact-no'];
    _email = snapshot['email'];
    _displayName = snapshot['display-name'];
    _currentPlayerId = snapshot['current-player-id'];
    _location = snapshot['location'];
    _profilePicUrl = snapshot['profile-pic-url'];
    _profilePic = snapshot['profile-pic'];
    _currentMatId = snapshot['current-mat-id'];
    hasSubscribed = snapshot['has-subscribed'];
  }

  List<PlayerModel> get players => _players;

  List<String> get mats => _mats;

  String get contactNo => _contactNo;

  String get email => _email;

  String get displayName => _displayName;

  // Persistence methods
  static Future<bool> checkIfUserPresent(String userId) async {
    var user = await FirebaseDatabaseUtil().getUserRef().once();
    print("User $userId present? " + (user.value != null).toString());
    print('user value - ${user.value}');
    return !(user.value == null);
  }

  Future<String> persist() async {
    print('This is user update record');

    var databaseUpdates = new Map<String, dynamic>();
    databaseUpdates = {
      "display-name": this.displayName,
      "email": this.email,
      "contact-no": this.contactNo,
      "location": this.location,
    };

    await FirebaseDatabaseUtil()
        .rootRef
        .child("/profiles/users/${this._id}")
        .update(databaseUpdates)
        .catchError((error) {
      print(error);
      return null;
    });
    return this._id;
  }

  //Takes input the parentUserId and the currentPlayerId and updates the current-player-id field of the parent.
  static Future<void> changeCurrentPlayer(String currentPlayerId) async {
    return FirebaseDatabaseUtil().getUserRef().update({
      "current-player-id": currentPlayerId,
    });
  }

  Users.createDBUserFromUserDetails(UserDetails userTile) {
    this._id = userTile.userId;
    this._displayName = userTile.userName;
    this._email = userTile.userMailId;
    this._contactNo = userTile.contactNo;
    this._location = userTile.userLocation;
    this._profilePicUrl = userTile.profilePicUrl;
    this.hasSubscribed = userTile.hasSubscribed;
  }

  static Future<void> changeCurrentMat(String currentMatId) async {
    return FirebaseDatabaseUtil().getUserRef().update({
      "current-mat-id": currentMatId,
    });
  }

  //Function to validate the phone registered with any user or not\
  //If not registered, exit the sign in process. Donnt send OTP.
  static Future<bool> isPhoneRegisteredUnderAnyUser(String phoneNo) async {
    DataSnapshot userData = await FirebaseDatabaseUtil()
        .rootRef
        .child("profiles")
        .child(Users.refName)
        .orderByChild("contact-no")
        .equalTo(phoneNo)
        .once();

    if (userData.value != null) {
      return true;
    }
    return false;
  }

//Check if email entered is registered before
  static Future<bool> isEmailRegisteredUnderAnyUser(String email) async {
    DataSnapshot userData = await FirebaseDatabaseUtil()
        .rootRef
        .child("profiles")
        .child(Users.refName)
        .orderByChild("email")
        .equalTo(email)
        .once();

    if (userData.value != null) {
      return true;
    }
    return false;
  }
}
