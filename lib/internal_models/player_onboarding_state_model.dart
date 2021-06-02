import 'package:flutter/cupertino.dart';

enum PlayerAddedState { DEFAULT, NEW_PLAYER_ADDED, FIRST_PLAYER_ADDED }

class PlayerOnBoardingStateModel extends ChangeNotifier {
  bool _isInProgress;
  PlayerAddedState _playerAddedState;

  PlayerOnBoardingStateModel() {
    this._isInProgress = false;
    this._playerAddedState = PlayerAddedState.DEFAULT;
  }

  PlayerAddedState get playerAddedState => _playerAddedState;

  set playerAddedState(PlayerAddedState value) {
    _playerAddedState = value;
    notifyListeners();
  }

  set isInProgress(bool value) {
    _isInProgress = value;
    notifyListeners();
  }

  bool get isInProgress => _isInProgress;
}
