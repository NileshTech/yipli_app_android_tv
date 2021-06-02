import 'package:flutter_app/helpers/helper_index.dart';
import 'package:flutter_app/page_models/page_model_index.dart';

class UserModel extends ChangeNotifier {
  static String refName = "users";

  String contactNo;
  String currentPlayerId;
  String currentMatId;
  String displayName;
  String email;
  String profilePicUrl;
  String id;
  String location;
  // RemoteCode remoteCode = new RemoteCode();
  bool hasSubscribed;

  String getUserDatabaseRefName(userId) {
    return "profiles/users/$userId";
  }

  UserModel();

  StreamTransformer userModelTransformer;

  void handlePlayerDataStreamTranform(Event event, EventSink<UserModel> sink) {
    print("Adding handler for stream transform");
    UserModel changedUserModel;

    if (event.snapshot.value != null) {
      changedUserModel =
          UserModel.fromSnapshotValue(event.snapshot.value, event.snapshot.key);
    }

    sink.add(changedUserModel);
  }

  void initialize() {
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        id = firebaseUser.uid;
        print("Creating the stream transformer for user model");

        userModelTransformer = StreamTransformer<Event, UserModel>.fromHandlers(
            handleData: handlePlayerDataStreamTranform);
        print("Adding listener");
        FirebaseDatabaseUtil()
            .getModelStream(getUserDatabaseRefName(id), userModelTransformer)
            .listen((changedUserData) {
          print("User data found to be changed!!");
          if (changedUserData != null) {
            setUserData(changedUserData);
            notifyListeners();
            print("User Listeners notified!!");
          }
        });
      }
    });
  }

  void setUserData(UserModel changedUserData) {
    id = changedUserData.id;
    displayName = changedUserData.displayName;
    email = changedUserData.email;
    contactNo = changedUserData.contactNo;
    location = changedUserData.location;
    currentPlayerId = changedUserData.currentPlayerId;
    profilePicUrl = changedUserData.profilePicUrl;
    currentMatId = changedUserData.currentMatId;
    hasSubscribed = changedUserData.hasSubscribed;
    // remoteCode = changedUserData.remoteCode;
    print("New data for User $id has been changed");
  }

  UserModel.fromSnapshotValue(dynamic value, dynamic key) {
    print("Creating player from Stream Snapshot value");
    id = key;
    displayName = value['display-name'];
    location = value['location'];
    email = value['email'];
    contactNo = value['contact-no'];
    profilePicUrl = value['profile-pic-url'];
    currentPlayerId = value['current-player-id'];
    currentMatId = value['current-mat-id'];
    hasSubscribed = value['has-subscribed'] ?? false;
    // if (value["remote-play"] != null) {
    //   try {
    //     remoteCode = RemoteCode.fromSnapshotValue(value["remote-play"]);
    //   } catch (exp) {
    //     print("Exception $exp");
    //   }
    // }
  }
}
