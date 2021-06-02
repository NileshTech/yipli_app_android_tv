import 'package:flutter_app/database_models/database_model_index.dart';

class SinglePlayerSession {
  static String refName = "single-player-sessions";
  String _id;

  String _game;
  String _playerHeight;
  String _endTime;
  String _difficultyLevel;
  String _device;
  String _yipliMoney;
  String _player;
  String _startTime;
  String _duration;
  String _points;
  String _playerDob;
  String _playerWeight;

  HashMap<String, int> _playerActionCountMap;

  SinglePlayerSession(
      this._id,
      this._game,
      this._playerHeight,
      this._endTime,
      this._difficultyLevel,
      this._device,
      this._yipliMoney,
      this._player,
      this._startTime,
      this._duration,
      this._points,
      this._playerDob,
      this._playerWeight,
      this._playerActionCountMap);

  String get id => _id;

  SinglePlayerSession.fromSnapshot(dynamic snapshot) {
    _id = snapshot.key;

    _playerHeight = snapshot['player-height'];
    _endTime = snapshot['end-time'];
    _difficultyLevel = snapshot['difficulty-level'];
    _device = snapshot['device'];
    _yipliMoney = snapshot['yipli-money'];
    _player = snapshot['player'];
    _startTime = snapshot['start-time'];
    _duration = snapshot['duration'];
    _points = snapshot['points'];
    _playerDob = snapshot['player-dob'];
    _playerWeight = snapshot['player-weight'];

    //@TODO -- Add player action count logic!
  }

  String get game => _game;

  String get playerHeight => _playerHeight;

  String get endTime => _endTime;

  String get difficultyLevel => _difficultyLevel;

  String get device => _device;

  String get yipliMoney => _yipliMoney;

  String get player => _player;

  String get startTime => _startTime;

  String get duration => _duration;

  String get points => _points;

  String get playerDob => _playerDob;

  String get playerWeight => _playerWeight;

  HashMap<String, int> get playerActionCountMap => _playerActionCountMap;
}
