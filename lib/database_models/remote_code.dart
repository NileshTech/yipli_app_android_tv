import 'database_model_index.dart';

class RemoteCode {
  static String remoteCodesRefName = "remote-codes";

  int _timestamp;
  String _remoteCode;

  RemoteCode([
    this._remoteCode,
    this._timestamp,
  ]);

  String get remoteCode => _remoteCode;
  int get timestamp => _timestamp;

  Future<bool> persistNewRemoteCode(userId, code) async {
    DatabaseReference newRemoteCodeDb;
    print('This is create new record');

    try {
      newRemoteCodeDb = FirebaseDatabaseUtil().remoteCodeDBRef(userId);
      await newRemoteCodeDb.set({
        "remote-code": code,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      }).catchError((error) {
        print(error);
        return null;
      });

      print('Generated code: ${newRemoteCodeDb.key}  for user: $userId');
    } catch (exp) {
      print("Exception occured in adding the generated code to backend : $exp");
      return false;
    }

    print("Successfully persisted new remote code to the backend.");
    return true;
  }

  RemoteCode.fromSnapshot(dynamic snapshot) {
    if (snapshot != null) {
      _timestamp = snapshot["timestamp"];
      _remoteCode = snapshot["remote-code"];
    } else {
      _timestamp = null;
      _remoteCode = null;
    }
  }

  Future<RemoteCode> getRemoteCodeFromDB(userId) async {
    DatabaseReference newRemoteCodeDb;
    print('This is create new record');
    try {
      newRemoteCodeDb = FirebaseDatabaseUtil().remoteCodeDBRef(userId);
      DataSnapshot remoteCodeSnapshot = await newRemoteCodeDb.once();

      print('Generated code: ${remoteCodeSnapshot.value}  for user: $userId');

      if (remoteCodeSnapshot.value != null)
        return RemoteCode.fromSnapshot(remoteCodeSnapshot.value);
      else
        return null;
    } catch (exp) {
      print("Exception occured in adding the generated code to backend : $exp");
      return null;
    }
  }
}
