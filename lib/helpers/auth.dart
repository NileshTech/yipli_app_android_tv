import 'dart:convert';
import 'package:flutter_app/helpers/helper_index.dart';
import 'package:flutter_app/pages/verification_screen.dart';
import 'package:http/http.dart' as http;
import 'utils.dart';

bool blIsSignedIn = false;

class AuthService {
  static AuthCredential credential;

  // constructor
  AuthService();
  static User firebaseUser;
//For storing user Profile info
  static Map<String, dynamic> userProfile = new Map();

//This is the main Firebase auth object
  static FirebaseAuth mobAuth = FirebaseAuth.instance;

// For google sign in
  static final GoogleSignIn mobGoogleSignIn = GoogleSignIn();

  static final FacebookLogin mobFacebookSignIn = FacebookLogin();

  Future<dynamic> emailSignIn(String email, String password) async {
    credential = EmailAuthProvider.credential(email: email, password: password);

    UserCredential result = await mobAuth.signInWithEmailAndPassword(
        email: email, password: password);

    firebaseUser = result.user;

    //await checkPreviousLoggedInUserForDevice();

    print(firebaseUser);
    return firebaseUser;
  }

  //
  Future<User> phoneNumberSignIn(
      BuildContext context, String verificationId, String smsCode) async {
    credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      firebaseUser = (await mobAuth.signInWithCredential(credential)).user;
    } catch (e) {
      print("Exception is login with OTP : " + e.code);
      switch (e.code) {
        case "invalid-verification-id":
          //The verification ID used to create the phone auth credential is invalid.
          YipliUtils.showNotification(
              context: context,
              msg: "Something went wrong. Try again after sometime.",
              type: SnackbarMessageTypes.ERROR);
          break;
        case "invalid-verification-code":
          YipliUtils.showNotification(
              context: context,
              msg: "Invalid OTP. Enter valid otp and try again.",
              type: SnackbarMessageTypes.ERROR);
          break;
        case "too-many-requests":
          YipliUtils.showNotification(
              context: context,
              msg:
                  "You have exhausted the login attempts. Try again after 24 hrs or try logging with email.",
              type: SnackbarMessageTypes.ERROR);
          break;
        default:
          YipliUtils.showNotification(
              context: context,
              msg:
                  "There was an error logging you in at the moment. If error persists, please contact Yipli Support.",
              type: SnackbarMessageTypes.ERROR);

          break;
      }
    }

    if (firebaseUser != null) {
      YipliUtils.showNotification(
          context: context,
          msg: "You are now logged in",
          type: SnackbarMessageTypes.SUCCESS);
      YipliUtils.initializeApp();
    } else {
      print("Invalid - ");
    }
    return firebaseUser;
  }

  //Log in using google
  static Future<void> googleSignIn(BuildContext ctx) async {
    //For mobile
    // Step 1

    try {
      await signOut();
      GoogleSignInAccount googleUser = await mobGoogleSignIn.signIn();

      // Step 2
      if (googleUser == null) {
        //Login failed
        showErrorForGoogleOrFBSignIn(ctx);
      } else {
        GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential _res = await mobAuth.signInWithCredential(credential);
        firebaseUser = _res.user;
        print("Logged in with user : ${firebaseUser.uid}");
        if (firebaseUser == null) {
          //Login failed
          showErrorForGoogleOrFBSignIn(ctx);
        } else {
          if (!await Users.checkIfUserPresent(_res.user.uid)) {
            Users newUser = new Users(_res.user.uid, [], [], "",
                _res.user.email, _res.user.displayName);
            await newUser.persist();
            print(firebaseUser.uid);
          }
          //await checkPreviousLoggedInUserForDevice();
          //Utils.goToHomeScreen(_res.user.displayName);
          YipliUtils.initializeApp();
        }
      }
    } catch (e) {
      print("Error!!!");
      print(e);
      showErrorForGoogleOrFBSignIn(ctx);
    }
  }

  static void showErrorForGoogleOrFBSignIn(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor,
          title: new Text(
            "Failed to log in!",
          ),
          content: new Text(
            "Please make sure your Google Account is usable."
            "Also make sure that you have a active "
            "internet connection, and try again.",
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              focusColor: androidTVFocusColor,
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<User> signUpUser(
      String displayName, String email, String password) async {
    var result = await mobAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    credential = EmailAuthProvider.credential(email: email, password: password);
    result.user.sendEmailVerification();
    await result.user.updateProfile(displayName: displayName);
    await result.user.reload();
    AuthService.firebaseUser = result.user;
    //Todo : See why user is not getting displayname value
    return result.user;
  }

  //Log in using google
  Future<dynamic> facebookSignIn(BuildContext ctx) async {
    //For mobile
    // Step 1
    await signOut();
    print("Logged out Facebook");
    FacebookLoginResult result =
        await mobFacebookSignIn.logIn(['email', 'public_profile']);
    print('FaceBook signed in.');
    print(result.status);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print('User Logged in with Facebook account.');
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
        final profile = jsonDecode(graphResponse.body);

        credential = FacebookAuthProvider.credential(token);
        try {
          final resultOfFirebaseLogin =
              await mobAuth.signInWithCredential(credential);
          print("User : " + resultOfFirebaseLogin.user.displayName);
          firebaseUser = resultOfFirebaseLogin.user;
        } catch (e) {
          print(e);
          throw e;
        }

        if (firebaseUser == null) {
          //Login failed
          showErrorForGoogleOrFBSignIn(ctx);
        } else {
          if (!await Users.checkIfUserPresent(firebaseUser.uid)) {
            Users newUser = new Users(firebaseUser.uid, [], [], "",
                firebaseUser.email, firebaseUser.displayName);
            await newUser.persist();
            print(firebaseUser);
          }
          //await firebaseUser.sendEmailVerification();
          //await checkPreviousLoggedInUserForDevice();
          YipliUtils.initializeApp();
        }

        print(profile);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        print(result.errorMessage);
        break;
    }
  }

  static User getLoggedFirebaseUser() {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print("Error loading Firebase app (logged out?)");
      return null;
    }
  }

  static String getCurrentUserId() {
    if (firebaseUser != null) {
      return firebaseUser.uid;
    }
    return null;
  }

  static Future<User> getValidUserLogged() async {
    User currentFirebaseUser = getLoggedFirebaseUser();
    try {
      if (currentFirebaseUser != null) {
        AuthService.firebaseUser = currentFirebaseUser;

        //await currentFirebaseUser.reload();
        return currentFirebaseUser;
      } else {
        return null;
      }
    } catch (e) {
      if (currentFirebaseUser != null) mobAuth.signOut();
      return currentFirebaseUser;
    }
  }

  static Future<void> signOut() async {
    //Destroy all the db references
    FirebaseDatabaseUtil.destroyInstance();

    //For email
    await mobAuth.signOut();

    //for FB
    await mobFacebookSignIn.logOut();

    //for google
    await mobGoogleSignIn.signOut();
  }
}
