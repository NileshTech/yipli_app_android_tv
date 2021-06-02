import 'package:flutter_app/classes/classes_index.dart';

class UserDetails {
  String userName;
  String userMailId;
  String contactNo;
  String userLocation;
  FileImage userProfilePic;
  String profilePicUrl;
  String userId;
  bool hasSubscribed;

  UserDetails(
      {this.userProfilePic,
      this.profilePicUrl,
      this.userName,
      this.contactNo,
      this.userLocation,
      this.userMailId,
      this.userId,
      this.hasSubscribed = false});

  UserDetails.userDetailsFromDBUser(Users user) {
    this.userId = user?.id ?? "";
    this.userName = user?.displayName ?? "";
    this.userMailId = user?.email ?? "";
    this.contactNo = user?.contactNo ?? "";
    this.userLocation = user?.location ?? "";
    this.profilePicUrl = user?.profilePicUrl ?? null;
    this.hasSubscribed = user?.hasSubscribed ?? false;
  }

  UserDetails.userDetailsFromUserModel(UserModel userModel) {
    this.userId = userModel?.id ?? "";
    this.userName = userModel?.displayName ?? "";
    this.userMailId = userModel?.email ?? "";
    this.contactNo = userModel?.contactNo ?? "";
    this.userLocation = userModel?.location ?? "";
    this.profilePicUrl = userModel?.profilePicUrl ?? null;
    this.hasSubscribed = userModel?.hasSubscribed ?? false;
  }
}
