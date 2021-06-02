import 'package:age/age.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/classes/InterAppCommunicationArguments.dart';
import 'package:flutter_app/classes/envirnment.dart';
import 'package:flutter_app/page_models/reward_model.dart';
import 'package:flutter_app/pages/a_pages_index.dart';
import 'package:flutter_app/pages/player_rewards_page.dart';

import 'package:flutter_app/pages/player_onboarding.dart';
import 'package:flutter_app/widgets/a_widgets_index.dart';
import 'package:flutter_app/widgets/scratch_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/pages/family_onboarding.dart';
import 'helper_index.dart';
import 'package:flutter_app/pages/user_on_boaring/onboarding.dart';

enum ConfirmAction { NO, YES }
enum SnackbarMessageTypes { ERROR, INFO, WARN, DEFAULT, SUCCESS }
enum SnackbarDuration { SHORT, MEDIUM, LONG }
enum AdventureGamingCardState { PLAYED, NEXT, LOCKED }
enum AppConnectionStatus { CONNECTED, DISCONNECTED }

class YipliUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  static AppConnectionStatus appConnectionStatus;

  //Todo: Remove this from Utils and make remove static
  static String smsVerificationCode;

  static void goToHomeScreen([game]) {
    navigatorKey.currentState
        .pushReplacementNamed(FitnessGaming.routeName, arguments: game);
  }

  static void goToWorldSelectionPage() {
    navigatorKey.currentState
        .pushReplacementNamed(WorldSelectionPage.routeName);
  }

  static void goToStartJourney() {
    navigatorKey.currentState.pushReplacementNamed(StartJourney.routeName);
  }

  static void goToNoNetworkPage() {
    navigatorKey.currentState.pushReplacementNamed(NoNetworkPage.routeName);
  }

  static void goToNoFoundPage() {
    navigatorKey.currentState.pushReplacementNamed(NotPageFound.routeName);
  }

  static void goToUserOnboardingPage() {
    navigatorKey.currentState
        .pushReplacementNamed(UserOnboardingPage.routeName);
  }

  static void goToLogoutScreen() {
    navigatorKey.currentState.pushReplacementNamed(Logout.routeName);
  }

  static void goToPlayerQuestioner() {
    navigatorKey.currentState.pushReplacementNamed(PlayerQuestioner.routeName);
  }

  static void goToForgotPasswordPage(String _email) {
    navigatorKey.currentState
        .pushReplacementNamed(ForgotPassword.routeName, arguments: _email);
  }

  static void goToLoginPage(String _email) {
    navigatorKey.currentState
        .pushReplacementNamed(Login.routeName, arguments: _email);
  }

  static void goToVerificationScreen(
      String displayName, String email, User loggedInUser) {
    navigatorKey.currentState.pushReplacementNamed(
      VerificationScreen.routeName,
      arguments: VerificationScreenInput(
        loggedInUser: loggedInUser,
        displayName: displayName,
        email: email,
      ),
    );
  }

  static void goToPlayersPage([playerList]) {
    navigatorKey.currentState
        .pushNamed(PlayerPage.routeName, arguments: playerList);
  }

  static void replaceWithPlayersPage([playerList]) {
    navigatorKey.currentState
        .pushReplacementNamed(PlayerPage.routeName, arguments: playerList);
  }

  static void goToPlayerOnBoardingPage(PlayerPageArguments playerArgs) {
    navigatorKey.currentState
        .pushNamed(PlayerOnboardingPage.routeName, arguments: playerArgs);
  }

  // static void goToPlayerRewards(PlayerModel playerDetails) {
  //   navigatorKey.currentState
  //       .pushNamed(PlayerRewards.routeName, arguments: playerDetails);
  // }

  static void goToEditPlayersPage(
      PlayerProfileArguments playerProfileArguments) {
    navigatorKey.currentState.pushNamed(PlayerEditProfile.routeName,
        arguments: playerProfileArguments);
  }

  static void goToPlayerAddPage(List<PlayerModel> allPlayerDetails) {
    navigatorKey.currentState
        .pushNamed(PlayerAdd.routeName, arguments: allPlayerDetails);
  }

  static void goToAddMatScreen({MatPageArguments args}) {
    navigatorKey.currentState
        .pushReplacementNamed(AddNewMatPage.routeName, arguments: args);
  }

  static void goToMatMenu() {
    navigatorKey.currentState.pushReplacementNamed(MatMenuPage.routeName);
  }

  static void gotoAdventureGaming() {
    navigatorKey.currentState.pushReplacementNamed(AdventureGaming.routeName);
  }

  static void goToPlayerProfile(PlayerDetails playerTile) {
    navigatorKey.currentState
        .pushNamed(PlayerProfilePage.routeName, arguments: playerTile);
  }

  static void goToPlayerProfileBottomNavigation() {
    navigatorKey.currentState.pushNamed(
      PlayerProfilePage.routeName,
    );
  }

//  static void goToBuddyRequestPage(Players currentPlayer) {
//    navigatorKey.currentState
//        .pushNamed(BuddyRequest.routeName, arguments: currentPlayer);
//  }

  static void goToRewardsPage(String currentPlayerId) {
    navigatorKey.currentState
        .pushNamed(RewardsPage.routeName, arguments: currentPlayerId);
  }

  static void goToRewardsModelPage(String currentPlayerId) {
    navigatorKey.currentState.pushNamed(
        RewardsModel.getModelRef(currentPlayerId),
        arguments: currentPlayerId);
  }

  static void goToLoginScreen() {
    navigatorKey.currentState.pushReplacementNamed(Login.routeName);
  }

  static void goToIntroSliderPage() {
    navigatorKey.currentState.pushReplacementNamed(IntroScreen.routeName);
  }

  static void goToUserProfilePage() {
    navigatorKey.currentState.pushNamed(UserProfile.routeName);
  }

  static void goToEditUserScreen([UserModel userProfile]) {
    navigatorKey.currentState
        .pushNamed(UserEditProfile.routeName, arguments: userProfile);
  }

  static void goToViewImageScreen(image) {
    navigatorKey.currentState.pushNamed(ViewImage.routeName, arguments: image);
  }

  static void gotoRegisterMatPage({bool isOnboardingFlow = false}) {
    navigatorKey.currentState
        .pushNamed(RegisterMatPage.routeName, arguments: isOnboardingFlow);
  }

  static void gotoFamilyOnBoarding() {
    navigatorKey.currentState.pushNamed(FamilyOnboardingPage.routeName);
  }

  static Future<String> inputDialogAsync(BuildContext context, String title,
      String inputLabel, String inputHint, String actionButtonLabel) async {
    String inputTextFromUser = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: YipliLogoLarge(heightScaleDownFactor: 10),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                cursorColor: Theme.of(context).primaryColorLight,
                autofocus: true,
                decoration: new InputDecoration(
                    hintStyle: Theme.of(context).textTheme.caption,
                    labelStyle: Theme.of(context).textTheme.bodyText2,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.8))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.5))),
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.8))),
                    disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0,
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(0.3))),
                    labelText: inputLabel,
                    hintText: inputHint),
                onChanged: (value) {
                  inputTextFromUser = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              focusColor: androidTVFocusColor,
              child: Text(actionButtonLabel,
                  style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                if (inputTextFromUser.length < 3) {
                  YipliUtils.showNotification(
                      //context: context,
                      msg:
                          "Please name your mat with more than 2 letters. Be creative!",
                      type: SnackbarMessageTypes.WARN);
                } else {
                  Navigator.of(context).pop(inputTextFromUser);
                }
              },
            ),
            FlatButton(
              focusColor: androidTVFocusColor,
              child:
                  Text('Cancel', style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<ProfilePicCaptureAndUploadResult> profilePicOptions(
      BuildContext context,
      Size sizeToUpload,
      String fileName,
      String userId,
      String profilePicUrl,
      DatabaseReference pathRef) async {
    File imageToUpload =
        await YipliUtils.getImage(context, profilePicUrl, pathRef);
    if (imageToUpload != null) {
      File croppedImage = await ImageCropper.cropImage(
        sourcePath: imageToUpload.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: sizeToUpload.width.round(),
        maxWidth: sizeToUpload.height.round(),
        cropStyle: CropStyle.circle,
        compressQuality: 35,
        androidUiSettings: AndroidUiSettings(
            backgroundColor: Theme.of(context).backgroundColor,
            statusBarColor: Theme.of(context).primaryColor,
            toolbarTitle: "That's a Yipli picture!",
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Theme.of(context).primaryColorLight,
            lockAspectRatio: true),
      );

      if (croppedImage != null) {
        StorageUploadTask uploadTask = FirebaseStorageUtil.upload(context,
            croppedImage, FirebaseStorageUtil.profilePicsRef, fileName);

        ProfilePicCaptureAndUploadResult result =
            ProfilePicCaptureAndUploadResult(
          uploadTask: uploadTask,
          imageFile: croppedImage,
        );
        return result;
      }
      return null;
    }
    return null;
  }

  static Future<File> getImage(BuildContext context, String profilePicUrl,
      DatabaseReference pathRef) async {
    File image;
    final imageSource = await showDialog<ImageSource>(
        barrierDismissible: true,
        context: context,
        builder: (context) => AlertDialog(
              insetPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 30.0),
              backgroundColor: Colors.transparent.withOpacity(0.6),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  return InkWell(
                    focusColor: androidTVFocusColor,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: height,
                      width: width,
                      padding: EdgeInsets.fromLTRB(
                          30.0, 30.0, 30.0, 30.0), //symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ///for camera
                          YipliUtils.buildBigButton(context,
                              icon: FontAwesomeIcons.camera,
                              text: "Capture",
                              text2: "",
                              buttonColor: Theme.of(context).primaryColor,
                              iconColor: Theme.of(context).accentColor,
                              onTappedFunction: () {
                            Navigator.pop(context, ImageSource.camera);
                          }),

                          Divider(
                              thickness: 2,
                              color: Theme.of(context).primaryColor),

                          YipliUtils.buildBigButton(context,
                              icon: FontAwesomeIcons.image,
                              text: "Gallery",
                              text2: "",
                              buttonColor: Theme.of(context).primaryColor,
                              iconColor: Theme.of(context).accentColor,
                              onTappedFunction: () {
                            Navigator.pop(context, ImageSource.gallery);
                          }),
                          profilePicUrl != null
                              ? Divider(
                                  thickness: 2,
                                  color: Theme.of(context).primaryColor)
                              : Container(height: 0),

                          profilePicUrl != null
                              ? YipliUtils.buildBigButton(
                                  context,
                                  icon: Icons.delete,
                                  text: "Remove",
                                  text2: "",
                                  buttonColor: Theme.of(context).primaryColor,
                                  iconColor: yipliErrorRed,
                                  onTappedFunction: () async {
                                    //First remove the profile-pic-url property
                                    pathRef.remove();

                                    //Now remove the image from firebase storage.
                                    await FirebaseStorageUtil.profilePicsRef
                                        .child(profilePicUrl)
                                        .delete();

                                    print('$profilePicUrl profile pic deleted');

                                    Navigator.pop(context);
                                  },
                                )
                              : Container(height: 0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ));

    if (imageSource != null) {
      PickedFile pickedImage =
          await ImagePicker().getImage(source: imageSource);
      image = File(pickedImage.path);
      if (image != null) {
        return image;
      }
    }
    return null;
  }

  static Future<void> showErrorAlert(
      BuildContext context, String s, List<Map<String, Object>> actionButtons) {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        List<Widget> actionButtonsList = new List();
        for (var actionButton in actionButtons) {
          actionButtonsList.add(FlatButton(
            focusColor: androidTVFocusColor,
            child: Text(actionButton["buttonText"]),
            onPressed: actionButton["onPressed"],
          ));
        }

        return AlertDialog(
          title: Text("Yipli"),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: Container(
                child: Text(s),
              ))
            ],
          ),
          actions: actionButtonsList,
        );
      },
    );
  }

  static _smsCodeSent(String verificationId, List<int> code) {
    // set the verification code so that we can use it to log the user in
    print("CODE SENT! !");
    smsVerificationCode = verificationId;
  }

  static _codeAutoRetrievalTimeout(String verificationId) {
    // set the verification code so that we can use it to log the user in
    print("CODE AUTO TIMEOUT! !");

    smsVerificationCode = verificationId;
  }

  static Future<ConfirmAction> showPhoneVerificationDialog(BuildContext ctx,
      String phoneNumber, Function onSuccess, Function onFailed) async {
    final YipliTextInput otpInput = new YipliTextInput(
        "One Time Passcode",
        "Enter your OTP here",
        Icons.security,
        false,
        YipliValidators.validateOTP,
        null,
        null,
        true,
        TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        Theme.of(ctx).primaryColorLight.withOpacity(0.8));

    otpInput
        .addWhitelistingTextFormatter(FilteringTextInputFormatter.digitsOnly);

    print("Verification for +91$phoneNumber started ... ");
    YipliButton verifyButton;
    verifyButton = new YipliButton("Verify", null, null);
    verifyButton.setClickHandler(() async {
      try {
        String code = otpInput.getText();
        if (code.length < 6) {
          return YipliUtils.showNotification(
              context: ctx,
              msg: "Enter Valid OTP",
              type: SnackbarMessageTypes.ERROR);
        }
        AuthCredential _authCredential = PhoneAuthProvider.credential(
            verificationId: smsVerificationCode, smsCode: code);
        User currentLoggedInUser = AuthService.getLoggedFirebaseUser();
        await currentLoggedInUser.updatePhoneNumber(_authCredential);

        Navigator.of(ctx).pop(ConfirmAction.YES);
        onSuccess();
        return ConfirmAction.YES;
      } catch (exception) {
        YipliUtils.showNotification(
            context: ctx,
            msg: "Verification failed! ${exception.message}",
            type: SnackbarMessageTypes.ERROR);
      }
    });
    return showDialog<ConfirmAction>(
        context: ctx,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          AuthService.mobAuth.verifyPhoneNumber(
            phoneNumber: "+91" + phoneNumber,
            codeSent: (verificationId, [code]) =>
                _smsCodeSent(verificationId, [code]),
            codeAutoRetrievalTimeout: (verificationId) =>
                _codeAutoRetrievalTimeout(verificationId),
            verificationCompleted: (AuthCredential phoneCredential) async {
              print("Verification complete!");
              User currentLoggedInUser = AuthService.getLoggedFirebaseUser();

              await currentLoggedInUser.updatePhoneNumber(phoneCredential);
              onSuccess();
            },
            verificationFailed: (FirebaseAuthException exception) {
              //Todo Handle phone verification error
              print(
                  "Verification FAILED! - ${exception.code} -- ${exception.message}");

              onFailed();
            },
            timeout: Duration(seconds: 60),
          );

          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            backgroundColor: Theme.of(ctx).primaryColor,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            // title: YipliLogoLarge(heightScaleDownFactor: 10),
            content: Container(
              height: MediaQuery.of(ctx).size.height / 4,
              // width: (screenSize.width * 0.7),
              decoration: BoxDecoration(
                  color: Theme.of(ctx).primaryColorDark,
                  border: Border.all(
                    color: yipliNewBlue,
                    width: 3.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text("OTP has been sent on $phoneNumber",
                        style: Theme.of(ctx).textTheme.bodyText2),
                    otpInput,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: FlatButton(
                            focusColor: androidTVFocusColor,
                            child: Text('Cancel',
                                style: Theme.of(ctx)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: yipliErrorRed)),
                            onPressed: () {
                              Navigator.of(dialogContext).pop(ConfirmAction.NO);
                              return ConfirmAction.NO;
                            },
                          ),
                        ),
                        Expanded(
                          child: verifyButton,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  static Future<void> getPhoneOtp(BuildContext ctx, String phoneNumber,
      Function onSuccess, Function onFailed) async {
    await AuthService.mobAuth.verifyPhoneNumber(
        phoneNumber: "+91" + phoneNumber,
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId),
        verificationCompleted: (AuthCredential phoneCredential) {
          print('OTP sent to phone no : ' + phoneNumber);
        },
        verificationFailed: (FirebaseAuthException exception) {
          //Todo Handle phone verification error
          print(
              "Verification FAILED! - ${exception.code} -- ${exception.message}");
          switch (exception.code) {
            case "invalid-phone-number":
              YipliUtils.showNotification(
                  context: ctx,
                  msg: "Invalid Phone number. Enter valid phone and try again.",
                  type: SnackbarMessageTypes.ERROR);
              break;
            case "too-many-requests":
              YipliUtils.showNotification(
                  context: ctx,
                  msg:
                      "You have exhausted to number of login attempts. Pls try again after 24 hrs.",
                  type: SnackbarMessageTypes.ERROR);
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(ctx).pushReplacementNamed('/login_screen');
              });
              break;
          }
        },
        timeout: Duration(seconds: 60));
  }

  static Future<ConfirmAction> asyncConfirmDialog(
      BuildContext context, String confirmationText) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: YipliLogoLarge(heightScaleDownFactor: 10),
          content: Text(confirmationText,
              style: Theme.of(context).textTheme.bodyText2),
          actions: <Widget>[
            FlatButton(
              focusColor: androidTVFocusColor,
              child: Text('Yes', style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.YES);
              },
            ),
            FlatButton(
              focusColor: androidTVFocusColor,
              child:
                  Text('Cancel', style: Theme.of(context).textTheme.bodyText2),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.NO);
              },
            ),
          ],
        );
      },
    );
  }

  static InkWell buildBigButton(BuildContext context,
      {IconData icon,
      @required String text,
      @required String text2,
      Function onTappedFunction,
      Color buttonColor,
      Color iconColor}) {
    if (buttonColor == null) buttonColor = Theme.of(context).accentColor;
    if (iconColor == null) iconColor = Theme.of(context).primaryColorLight;
    return InkWell(
      focusColor: androidTVFocusColor,
      borderRadius: BorderRadius.circular(10),
      onTap: onTappedFunction,
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Icon(
                        icon,
                        color: iconColor,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          text,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        (text2.length > 0)
                            ? Text(
                                text2,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.w600),
                              )
                            : Padding(padding: EdgeInsets.all(0)),
                      ],
                    ),
                    flex: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static InkWell buildOnboardingStyleButton(BuildContext context,
      {IconData icon,
      @required String text,
      Function onTappedFunction,
      Color buttonColor,
      Color iconColor,
      Color textColor}) {
    if (buttonColor == null) buttonColor = Theme.of(context).accentColor;
    if (iconColor == null) iconColor = Theme.of(context).primaryColorLight;
    if (textColor == null) textColor = Theme.of(context).primaryColorLight;
    return InkWell(
      focusColor: androidTVFocusColor,
      borderRadius: BorderRadius.circular(10),
      onTap: onTappedFunction,
      child: Container(
        decoration: BoxDecoration(
            color: buttonColor, borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Icon(
                        icon,
                        color: iconColor,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 18, color: textColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static InkWell buildVeryBigButton(BuildContext context,
      {IconData icon,
      @required String text,
      @required String text2,
      @required Widget anim,
      @required String infoText,
      Function onTappedFunction}) {
    return InkWell(
      focusColor: androidTVFocusColor,
      borderRadius: BorderRadius.circular(10),
      onTap: onTappedFunction,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Icon(
                          icon,
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            text,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: anim,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    infoText,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> resetSharedPref(String strKey) async {
    print("About to delete SharedPref : $strKey");
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    sharedPreference.setBool(strKey, false);
  }

  static void initializeApp() {
    if (navigatorKey.currentState.canPop()) {
      navigatorKey.currentState.popUntil((route) => route.isFirst);
    }
    resetSharedPref('mat_add_skipped');
    navigatorKey.currentState.pushReplacementNamed(FitnessGaming.routeName);
  }

  static ClipOval getPlayerProfilePicIcon(
      context, String playerProfilePicUrl, double sizeScaleDownFactor) {
    return ClipOval(
      child: Container(
        height: (MediaQuery.of(context).size.height) / sizeScaleDownFactor,
        width: (MediaQuery.of(context).size.width) / sizeScaleDownFactor,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: playerProfilePicUrl == null || playerProfilePicUrl == ""
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/images/placeholder_image.png"),
              )
            : FadeInImage(
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 100),
                image: FirebaseImage(
                    "${FirebaseStorageUtil.profilepics}/$playerProfilePicUrl"),
                placeholder: AssetImage('assets/images/img_loading.gif'),
              ),
      ),
    );
  }

  static Widget getPlayerProfilePicIconWithoutConstraints(
      context, String playerProfilePicUrl,
      [bool showBorder = false]) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Align(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
                height: constraints.maxHeight,
                width: constraints.maxHeight,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: showBorder
                        ? Border.all(color: yipliLogoOrange, width: 3)
                        : null),
                child: ClipOval(
                  child: playerProfilePicUrl == null ||
                          playerProfilePicUrl == ""
                      ? Image.asset("assets/images/placeholder_image.png")
                      : Image(
                          image: FirebaseImage(
                              "${FirebaseStorageUtil.profilepics}/$playerProfilePicUrl")),
                )),
          ),
        );
      },
    );
  }

  static Widget getPlayerProfilePicIconRect(context, String playerProfilePicUrl,
      [bool showBorder = false]) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
            height: constraints.maxHeight,
            width: constraints.maxHeight,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: showBorder
                    ? Border.all(color: Theme.of(context).accentColor, width: 3)
                    : null),
            child: Image(image: getProfilePicImage(playerProfilePicUrl)));
      },
    );
  }

  static ImageProvider getProfilePicImage(String playerProfilePicUrl) {
    return playerProfilePicUrl == null || playerProfilePicUrl == ""
        ? AssetImage("assets/images/placeholder_image.png")
        : FirebaseImage(
            "${FirebaseStorageUtil.profilepics}/$playerProfilePicUrl");
  }

  static void showNotification(
      {BuildContext context,
      String msg,
      Function onClose,
      SnackbarMessageTypes type = SnackbarMessageTypes.DEFAULT,
      SnackbarDuration duration = SnackbarDuration.MEDIUM}) {
    Color snackBarBackgroundColor = getSnackBarBackgroundColor(type, context);
    int durationForNotification = getNotificationDuration(duration);
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      barBlur: 3.0,
      messageText: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              msg,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),
      //message: ,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      backgroundColor: snackBarBackgroundColor,
      duration: Duration(seconds: durationForNotification),
      onStatusChanged: (FlushbarStatus status) {
        if (status == FlushbarStatus.DISMISSED) {
          if (onClose != null) {
            onClose();
          }
        }
      },
    )..show(context);
  }

  static Color getSnackBarBackgroundColor(
      SnackbarMessageTypes type, BuildContext context) {
    switch (type) {
      case SnackbarMessageTypes.ERROR:
        return Colors.red[600].withOpacity(0.8);
      case SnackbarMessageTypes.WARN:
        return Colors.red[800].withOpacity(0.8);
      case SnackbarMessageTypes.INFO:
        return Theme.of(context).accentColor.withOpacity(0.8);
      case SnackbarMessageTypes.SUCCESS:
        return Colors.blue[800].withOpacity(0.8);
      case SnackbarMessageTypes.DEFAULT:
        return Colors.black12.withOpacity(0.8);
    }
    return Colors.black12.withOpacity(0.8);
  }

  static void goToRoute(String pageOption,
      [bool replaceStack = false, dynamic arguments]) {
    if (replaceStack) {
      navigatorKey.currentState
          .pushReplacementNamed(pageOption, arguments: arguments);
    } else
      navigatorKey.currentState.pushNamed(pageOption, arguments: arguments);
  }

  static int getNotificationDuration(SnackbarDuration duration) {
    switch (duration) {
      case SnackbarDuration.SHORT:
        return 1;
      case SnackbarDuration.MEDIUM:
        return 3;

      case SnackbarDuration.LONG:
        return 5;
    }
    return 3;
  }

  static Widget getProfilePicImageIcon(
      BuildContext context, String profilePicUrl, bool isSelected) {
    return Container(
      padding: EdgeInsets.all(0),
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: FirebaseImage(
              "${FirebaseStorageUtil.profilepics}/$profilePicUrl"),
        ),
      ),
    );
  }

  static getNetworkConnectivityStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      // API
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      // API
      return true;
    } else {
      return false;
    }
  }

  static showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Updating..'),
      ),
    );
  }

  static manageAppConnectivity(BuildContext context) {
    Platform.isIOS
        ? YipliUtils.appConnectionStatus = AppConnectionStatus.CONNECTED
        : Connectivity()
            .onConnectivityChanged
            .listen((ConnectivityResult event) {
            processChangedConnectivity(event, context);
          });
    YipliUtils.appConnectionStatus = AppConnectionStatus.CONNECTED;
  }

  static void processChangedConnectivity(
      ConnectivityResult event, BuildContext context) {
    switch (event) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        // TODO: Handle this case.
        FirebaseDatabase.instance.goOnline().then((value) {
          YipliUtils.appConnectionStatus = AppConnectionStatus.CONNECTED;
          try {
            BotToast.showSimpleNotification(
              title: "You are connected to the network.",
              backgroundColor: Colors.blue[800].withOpacity(0.8),
              hideCloseButton: true,
            );
          } catch (e) {
            print('expection for bottoast - $e');
          }
          if (YipliUtils.navigatorKey.currentState != null)
            YipliUtils.navigatorKey.currentState
                .pushReplacementNamed(FitnessGaming.routeName);
        });
        break;
      case ConnectivityResult.none:
        // TODO: Handle this case.
        FirebaseDatabase.instance.goOffline().then((value) {
          YipliUtils.appConnectionStatus = AppConnectionStatus.DISCONNECTED;
          try {
            BotToast.showSimpleNotification(
              title: "Please connect to the network and check again.",
              backgroundColor: Colors.red[600].withOpacity(0.8),
              hideCloseButton: true,
            );
          } catch (e) {
            print('expection for bottoast - $e');
          }

          YipliUtils.navigatorKey.currentState
              .pushReplacementNamed(NoNetworkPage.routeName);
        });
        break;
    }
  }

  static double getImageHeight(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return screenSize.height / 4;
  }
//* --------- AdventureGameCardContent widgets start here ----------

  static IconData getIconForCardState(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
        return Icons.check_circle;
      case AdventureGamingCardState.NEXT:
        return Icons.location_on;
      case AdventureGamingCardState.LOCKED:
        return Icons.fiber_manual_record;
    }
    return null;
  }

  static IconData getIconForButton(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
        return Icons.refresh;
      case AdventureGamingCardState.NEXT:
        return Icons.play_arrow;
      case AdventureGamingCardState.LOCKED:
        return Icons.lock;
    }
    return null;
  }

  static getColorForCardState(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
        return yipliLogoBlue;
      case AdventureGamingCardState.NEXT:
        return yipliLogoOrange;
      case AdventureGamingCardState.LOCKED:
        return accentLightGray;
    }
    return null;
  }

  static getBorderColorForCardState(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.LOCKED:
        return primarycolor;
      case AdventureGamingCardState.NEXT:
        return yipliLogoOrange;
    }
    return null;
  }

  static getButtonColor(AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return yipliLogoBlue;
      case AdventureGamingCardState.LOCKED:
        return accentLightGray;
    }
    return null;
  }

  static Widget getLockedOverlay(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return IgnorePointer(child: Container());

      case AdventureGamingCardState.LOCKED:
        return Stack(children: [
          Container(
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(8.0),
              color: appbackgroundcolor.withOpacity(0.8),
            ),
          ),
          Positioned.fill(
            child: Icon(Icons.lock, color: accentLightGray),
          ),
        ]);
    }
    return null;
  }

  static Widget getImageLockedOverlay(
      AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return IgnorePointer(child: Container());

      case AdventureGamingCardState.LOCKED:
        return Container(
          decoration: BoxDecoration(
            //shape: BoxShape.circle,
            color: appbackgroundcolor.withOpacity(0.8),
          ),
        );
    }
    return null;
  }

  static showButton(AdventureGamingCardState adventureGamingCardState) {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return Positioned(
          bottom: 50,
          right: 5,
          child: FloatingActionButton(
            focusColor: androidTVFocusColor,
            heroTag: DateTime.now().toString(),
            mini: true,
            backgroundColor: getButtonColor(adventureGamingCardState),
            child: FaIcon(getIconForButton(adventureGamingCardState), size: 18),
            onPressed: () {},
          ),
        );

      case AdventureGamingCardState.LOCKED:
        return Positioned.fill(
          child: Center(
            child: Icon(Icons.lock, size: 30, color: accentLightGray),
          ),
        );
    }
  }

  static String getLocalStorageKeyForPlayer(String id) {
    return "player-data-$id";
  }

  static Widget showTipOfTheDay() {
    /// this is for tips category and tips
    Query tipsDBRef = FirebaseDatabaseUtil()
        .rootRef
        .child("inventory")
        .child("tips")
        .child("list")
        .orderByChild("category");
    print('tipsDBRef from utils - $tipsDBRef');

    /// this is for tips tips count
    Query tipsCountDBRef = FirebaseDatabaseUtil()
        .rootRef
        .child("inventory")
        .child("tips")
        .orderByChild("count");

    print('tipsCountDBRef from utils - ${(tipsCountDBRef).onValue}');
    return StreamBuilder<Event>(
        stream: tipsCountDBRef.onValue,
        builder: (context, event1) {
          if ((event1.connectionState == ConnectionState.waiting) ||
              event1.hasData == null)
            return YipliLoaderMini(loadingMessage: 'Loading Tip');
          int randomListLengthStream1 =
              (event1?.data?.snapshot?.value ?? {'count': 0})['count'];
          // print('randomListLengthStream1 - $randomListLengthStream1');
          return StreamBuilder<Event>(
              stream: tipsDBRef.onValue,
              builder: (context, event2) {
                if ((event2.connectionState == ConnectionState.waiting) ||
                    event2.hasData == null)
                  return YipliLoaderMini(loadingMessage: 'Loading Tip');
                // print('on value - ${(tipsDBRef.onValue)}');
                int listLengthMax = randomListLengthStream1;
                int randomListLength = new Random().nextInt(listLengthMax);
                return TipOfTheDay(
                  tipHeadingText: (event2?.data?.snapshot?.value ??
                          [
                            {'category': ''}
                          ])
                      .elementAt(randomListLength)['category'],
                  imagePath: 'assets/images/healthTipImg.png',
                  healthTipText: (event2?.data?.snapshot?.value ??
                          [
                            {'tip': ''}
                          ])
                      .elementAt(randomListLength)['tip'],
                );
              });
        });
  }

  static Future<void> showDailyTipForCurrentPlayer(
      BuildContext context, String playerId) async {
    final keyIsDailyTipShownToPlayer = 'Daily_Tip_' + playerId;

    //checking if the player has seen the tip
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int diffBetweenNextTip = 43200000; //half day daily tip time
    int tipLastShownTime = prefs.getInt(keyIsDailyTipShownToPlayer);
    print('tipLastShownTime - $tipLastShownTime');
    if (tipLastShownTime == null ||
        ((currentTime - tipLastShownTime) > diffBetweenNextTip)) {
      Future.delayed(YipliUtils.getNotificationDuration(SnackbarDuration.SHORT)
              .seconds)
          .then((value) => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => YipliUtils.showTipOfTheDay()));
      prefs.setInt(keyIsDailyTipShownToPlayer,
          new DateTime.now().millisecondsSinceEpoch);

      //prefs.setBool(keyIsDailyTipShownToPlayer, false);
    }
  }

  static Future<void> doNotShowDailyTipForRecentlyAddedPlayer(
      String playerId) async {
    final keyIsDailyTipShownToPlayer = 'Daily_Tip_' + playerId;

    //checking if the player has seen the tip
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(
        keyIsDailyTipShownToPlayer, new DateTime.now().millisecondsSinceEpoch);
  }

  static Widget showRewardOfTheDay(String playerId, int rewardLastShownTime) {
    return GiveScratchCard(playerId, rewardLastShownTime);
  }

  static Future<void> showDailyRewardsForCurrentPlayer(
      BuildContext context, String playerId) async {
    final keyIsDailyRewardShownToPlayer = 'Daily_Rewards_' + playerId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    int diffBetweenNextReward = 43200000; //half day daily tip time
    int rewardLastShownTime = prefs.getInt(keyIsDailyRewardShownToPlayer);
    print('rewardLastShownTime - $rewardLastShownTime');

    if (rewardLastShownTime == null ||
        ((currentTime - rewardLastShownTime) > diffBetweenNextReward)) {
      Future.delayed(YipliUtils.getNotificationDuration(SnackbarDuration.SHORT)
              .seconds)
          .then((value) => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return YipliUtils.showRewardOfTheDay(
                    playerId, rewardLastShownTime);
              }));
      prefs.setInt(keyIsDailyRewardShownToPlayer,
          new DateTime.now().millisecondsSinceEpoch);
    }
  }

  static int getAgeFromDOB(DateTime date) {
    print("In GetAgeFromDOB");
    DateTime today = DateTime.now();
    AgeDuration age;

    try {
      // Find out your age
      age = Age.dateDifference(
          fromDate: date, toDate: today, includeToDate: false);
    } catch (exp) {
      print("Exception In GetAgeFromDOB : $exp");
    }

    return int.parse(age.toString());
  }

  static String convertInterAppArgsToDynamicLinkArgString(
      InterAppCommunicationArguments args) {
    String strToParse = args.toJson().toString();
    print("strToParse  :  " + strToParse);

    //If we want to passarguments to dynamic link %26 is delimeter between evry key value pair.
    //Every key  value pair must be identified by '='
    String equalsToChar = Platform.isIOS ? "%3D" : "=";

    String parsedStr = strToParse
        .substring(1, (strToParse.length) - 1)
        .replaceAll(": ", equalsToChar)
        .replaceAll(", ", "%26");
    print("parsedStr  :  " + parsedStr);

    return parsedStr;
  }

  static openAppWithDynamicLink(String dynamiclink) async {
    try {
      print("Launching dynamic link : " + dynamiclink);
      await launch(dynamiclink);
    } catch (e) {
      print("Exception caught in dynamiclink launching : ");
      print(e);
    }
  }

//Code for auto verification after every second
  static Future<bool> checkEmailVerified() async {
    AuthService.firebaseUser = AuthService.mobAuth.currentUser;
    await AuthService.firebaseUser.reload();
    if (AuthService.firebaseUser.emailVerified) {
      return true;
    }
    return false;
  }

  static Future<void> unlinkPhoneAuthProvider() async {
    AuthService.firebaseUser = AuthService.mobAuth.currentUser;
    try {
      AuthService.firebaseUser.unlink(PhoneAuthProvider.PROVIDER_ID);
    } catch (e) {
      print("e.message");
    }
  }
}
