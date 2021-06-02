import 'package:flutter_app/page_models/page_model_index.dart';

class CurrentMatModel extends ChangeNotifier {
  String _currentMatId;

  set currentMatId(String value) {
    _currentMatId = value;
    if (value != null) {
      mat.dispose();
      _initialize();
    }
  }

  CurrentMatModel._internal(this._currentMatId);

  MatModel mat;

  factory CurrentMatModel(String matId) {
    CurrentMatModel currentMatModel = CurrentMatModel._internal(matId);
    matId ?? currentMatModel._initialize();
    return currentMatModel;
  }

  void _initialize() {
    mat = MatModel.initialize(_currentMatId);
    mat.addListener(() {
      notifyListeners();
    });
  }

  @override
  String toString() =>
      'CurrentPlayerModel(_currentMatId: $_currentMatId, mat: $mat)';
}
