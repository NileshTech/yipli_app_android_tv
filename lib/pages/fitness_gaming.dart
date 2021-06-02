import 'package:device_info/device_info.dart';
import 'package:flutter_app/helpers/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/pages/user_on_boaring/onboarding.dart';
import 'a_pages_index.dart';

class FitnessGaming extends StatefulWidget {
  static const String routeName = "/fitness_gaming";

  const FitnessGaming({Key key}) : super(key: key);

  @override
  _FitnessGamingState createState() => _FitnessGamingState();
}

class _FitnessGamingState extends State<FitnessGaming> {
  bool isUserVerified = false;
  String androidDevice;

  @override
  void initState() {
    print('Setting up the connected handler');
    final amOnline = FirebaseDatabaseUtil().rootRef.child('.info/connected');
    amOnline.onValue.listen((Event event) {
      print('EVENT has occured ${event.snapshot.value.toString()}');
    });
    AuthService.getValidUserLogged().then((loggedInUser) async {
      AndroidDeviceInfo androidDeviceInfo =
          await DeviceInfoPlugin().androidInfo;
      await FirebaseDatabase.instance
          .reference()
          .child('inventory')
          .child('android-sticks')
          .child("device-display")
          .once()
          .then((snapshot) {
        if (snapshot.value != null) {
          androidDevice = snapshot.value;
        } else {
          androidDevice = "";
        }
      });

      if (androidDevice == androidDeviceInfo.display ||
          Envirnment.isAndroidTV == true) {
        Envirnment.isAndroidTV = true;
      } else {
        Envirnment.isAndroidTV = false;
      }
      if (loggedInUser != null) {
        //flag for facebook login to check allow user's emailId directly verified
        if (loggedInUser.providerData[0].providerId == "facebook.com") {
          print("Email has been verified..");
          setState(() {
            isUserVerified = true;
          });
        } else if (loggedInUser.emailVerified) {
          print("Email has been verified..");
          setState(() {
            isUserVerified = true;
          });
        } else {
          print("Email has NOT been verified..");
          YipliUtils.goToVerificationScreen(
              loggedInUser.displayName, loggedInUser.email, loggedInUser);
        }
      } else {
        YipliUtils.goToIntroSliderPage();
      }
    });

    super.initState();
  }

  Future<bool> getMatSkippedStatus() async {
    try {
      final keyIsMatAddSkipped = 'mat_add_skipped';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(keyIsMatAddSkipped);
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool matAddSkipped;

    return (isUserVerified)
        ? FutureBuilder<bool>(
            future: getMatSkippedStatus(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return YipliLoader();
              } else {
                matAddSkipped = snapshot.data;

                return Consumer<UserModel>(
                    builder: (context, userModel, child) {
                  if (userModel.id == null) {
                    return YipliLoaderMini(
                      loadingMessage: "",
                    );
                  }

                  if (userModel.displayName == null ||
                      userModel.currentPlayerId == null) {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (timeStamp) => YipliUtils.goToUserOnboardingPage());
                  }

                  if (userModel.currentMatId == null &&
                      matAddSkipped == false) {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (timeStamp) => YipliUtils.goToUserOnboardingPage());
                  }
                  String gameName = ModalRoute.of(context).settings.arguments;
                  return YipliPageFrame(
                    toDisableFeatures: false,
                    showDrawer: true,
                    backgroundMode: YipliBackgroundMode.dark,
                    toShowBottomBar: true,
                    isBottomBarInactive: false,
                    title: Text('Fitness Gaming'),
                    child: GamesPage(gameName),
                    selectedIndex: 0,
                  );
                  //p=0, m=0
                  // if (userModel.currentPlayerId == null &&
                  //     userModel.currentMatId == null &&
                  //     matAddSkipped == false &&
                  //     playerAddSkipped == false) {
                  //   flowValue =
                  //       UserOnBoardingFlows.FLOW1; // Add Mat and player
                  // }
                  // //p!=0, m=0
                  // else if (userModel.currentMatId == null &&
                  //     matAddSkipped == false) {
                  //   flowValue =
                  //       UserOnBoardingFlows.FLOW2; // Only Add Mat
                  // }
                  // //p=0, m!=0
                  // else if (userModel.currentPlayerId == null &&
                  //     playerAddSkipped == false) {
                  //   flowValue =
                  //       UserOnBoardingFlows.FLOW3; // Only add player
                  // }
                  // //  else if (userModel.contactNo == "" &&
                  // //     phoneNumberAddSkipped == false) {
                  // //   flowValue = UserOnBoardingFlows.FLOW4;
                  // // }
                  // //p!=0, m!=0
                  // else
                  //   flowValue = UserOnBoardingFlows
                  //       .NA; //Continue with Normal flow

                  // String gameName = ModalRoute.of(context).settings.arguments;
                  // return flowValue != UserOnBoardingFlows.NA
                  //     ? UserOnBoardingFlowManager.chooseFlow(flowValue)
                  //     : YipliPageFrame(
                  //         toDisableFeatures: false,
                  //         showDrawer: true,
                  //         backgroundMode: YipliBackgroundMode.dark,
                  //         toShowBottomBar: true,
                  //         isBottomBarInactive: false,
                  //         title: Text('Fitness Gaming'),
                  //         child: GamesPage(gameName),
                  //         selectedIndex: 0,
                  //       );
                });
              }
            })
        : YipliLoader(
            backgroundColor: Theme.of(context).primaryColorLight,
            useOpaqueBackground: false,
          );
  }
}

class YipliLogoAnimatedSmall extends StatelessWidget {
  const YipliLogoAnimatedSmall({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RubberBand(
      child: Image.asset(YipliAssets.yipliLogoPath,
          fit: BoxFit.contain, height: MediaQuery.of(context).size.height / 10),
      preferences: AnimationPreferences(
        offset: Duration(seconds: 1),
        autoPlay: AnimationPlayStates.Forward,
      ),
    );
  }
}

class YipliLogoAnimatedLarge extends StatelessWidget {
  final int heightVariable;
  final GlobalKey<AnimatorWidgetState> animationKey =
      GlobalKey<AnimatorWidgetState>();

  YipliLogoAnimatedLarge({
    Key key,
    this.heightVariable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RubberBand(
      key: animationKey,
      child: GestureDetector(
          onTap: () {
            animationKey.currentState.stop();
            animationKey.currentState.forward();
          },
          child: YipliLogoLarge(heightScaleDownFactor: heightVariable)),
      preferences: AnimationPreferences(
        offset: Duration(milliseconds: 1200),
        autoPlay: AnimationPlayStates.Forward,
      ),
    );
  }
}

class YipliLogoLarge extends StatelessWidget {
  const YipliLogoLarge({
    Key key,
    @required this.heightScaleDownFactor,
  }) : super(key: key);

  final int heightScaleDownFactor;

  @override
  Widget build(BuildContext context) {
    return Image.asset(YipliAssets.yipliLogoPath,
        fit: BoxFit.contain,
        height: MediaQuery.of(context).size.height / heightScaleDownFactor);
  }
}
