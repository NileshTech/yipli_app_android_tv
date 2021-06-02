class PlayerActionTypes {
  static String refName = "player-action-types";
  String _id;
  String _activityScale;
  String _type;

  PlayerActionTypes(this._id, this._activityScale, this._type);

  String get id => _id;

  String get type => _type;

  String get activityScale => _activityScale;

  PlayerActionTypes.fromSnapshot(dynamic snapshot) {
    _id = snapshot.key;

    _activityScale = snapshot['activity-scale'];
    _type = snapshot['type'];
  }
}
