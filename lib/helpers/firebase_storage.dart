import 'package:flutter_app/helpers/helper_index.dart';

class FirebaseStorageUtil {
  static final StorageReference profilePicsRef =
      FirebaseStorage.instance.ref().child('profile-pics');
  static final String profilepics =
      "gs://yipli-project.appspot.com/profile-pics";
  static const String gameIcons = "gs://yipli-project.appspot.com/game-icons";
  static const String excercises = "gs://yipli-project.appspot.com/excercises";
  static const String fitnessCards = "gs://yipli-project.appspot.com/fitness-cards";
  static const String adventureStory = "gs://yipli-project.appspot.com/Story";

  static StorageUploadTask upload(BuildContext context, File uploadFile,
      StorageReference storageRef, String fileName) {
    return storageRef.child(fileName).putFile(uploadFile);
  }
}
