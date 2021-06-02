import 'package:flutter_app/pages/family_onboarding.dart';
import 'package:flutter_app/pages/player_onboarding.dart';
import 'package:flutter_app/widgets/confirmation_box/confirmation_widget.dart';
import '../a_pages_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

const ADD_MAT_SKIPP_INSTRUCRION = "Mat is needed for Yipli gaming";

class UserOnboardingPage extends StatefulWidget {
  static const String routeName = '/user_on_boarding_page';

  // UserOnboardingPage(UserOnBoardingFlows flowValue, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _OnboardingScreenState();
}

class _OnboardingScreenState extends State<UserOnboardingPage> {
  // YipliBigButton addFamilyProfile;

  YipliButton addMat;
  YipliButton doneButton;
  YipliButton addPlayer;
  bool isMatAdded = false;
  bool isPlayerAdded = false;
  bool isFamilyNameAdded = false;
  Tween<double> _scaleTween = Tween<double>(begin: 0.75, end: 1.2);

  @override
  void initState() {
    super.initState();
    _startTimerForBlinkingIcon();
  }

  bool iconColored = false;
  Timer _timer;
  void _startTimerForBlinkingIcon() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(milliseconds: 550), (timer) {
      setState(() {
        iconColored = !iconColored;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    bool _saving = false;

    ProcessCancelConfirmationDialog exitConfirmationDialog =
        ProcessCancelConfirmationDialog(
      titleText: "Skip Mat set up ?",
      subTitleText: ADD_MAT_SKIPP_INSTRUCRION,
      buttonText: "Cancel",
      pressToExitText: "Skip for now",
    );

    exitConfirmationDialog.setClickHandler(() {
      YipliUtils.goToHomeScreen();
      YipliUtils.showNotification(
          context: context,
          msg: "No Mat added.\nAdd Mat from Menu -> My Mats.",
          type: SnackbarMessageTypes.ERROR,
          duration: SnackbarDuration.LONG);
    });
    doneButton = new YipliButton('Next', null, null, screenSize.width / 2);
    doneButton.setClickHandler(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('mat_add_skipped', true);
      isMatAdded == false
          ? showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => exitConfirmationDialog)
          : YipliUtils.goToHomeScreen();
    });
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
            child: ModalProgressHUD(
          progressIndicator: YipliLoader(),
          inAsyncCall: _saving,
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Consumer2<UserModel, AllPlayersModel>(
                  builder: (context, userModel, allPlayerDetails, snapshot) {
                PlayerPageArguments playerArgs = new PlayerPageArguments(
                    allPlayerDetails: allPlayerDetails.allPlayers,
                    isOnboardingFlow: true);
                if (userModel.id == null) {
                  return YipliLoaderMini(
                    loadingMessage: "Getting started...",
                  );
                }
                if (userModel.currentMatId != null) {
                  isMatAdded = true;
                } else
                  isMatAdded = false;

                if (userModel.currentPlayerId != null) {
                  isPlayerAdded = true;
                } else
                  isPlayerAdded = false;

                if (userModel.displayName != null) {
                  isFamilyNameAdded = true;
                } else
                  isFamilyNameAdded = false;
                // if (isMatAdded && isPlayerAdded && isFamilyNameAdded) {
                //   _timer.cancel();
                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                //     YipliUtils.goToHomeScreen();
                //     YipliUtils.showNotification(
                //       context: context,
                //       msg: "All set to Start Gaming !!",
                //       duration: SnackbarDuration.MEDIUM,
                //       type: SnackbarMessageTypes.INFO,
                //     );
                //   });
                // }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Welcome to Yipli',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                        color: Theme.of(context).accentColor,
                                        fontWeight: FontWeight.normal),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TweenAnimationBuilder(
                                tween: _scaleTween,
                                curve: Curves.bounceInOut,
                                duration: Duration(milliseconds: 1700),
                                builder: (context, scale, child) {
                                  return Transform.scale(
                                      scale: scale, child: child);
                                },
                                child: Text(
                                  'Getting Started',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      .copyWith(
                                          color: yipliWhite,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Quick few steps before your fitness gaming experience',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(
                                        color: yipliGray,
                                        fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: YipliUtils.buildOnboardingStyleButton(
                                context,
                                icon: FontAwesomeIcons.users,
                                textColor: isFamilyNameAdded == true
                                    ? yipliNewBlue
                                    : Theme.of(context).primaryColorLight,
                                buttonColor: isFamilyNameAdded == true
                                    ? yipliGray
                                    : Theme.of(context).accentColor,
                                iconColor: isFamilyNameAdded == true
                                    ? yipliNewBlue
                                    : iconColored == true
                                        ? yipliOrange
                                        : yipliWhite,
                                text: "Set up Family profile",
                                onTappedFunction: () {
                                  isFamilyNameAdded == true
                                      ? YipliUtils.showNotification(
                                          context: context,
                                          msg:
                                              "Your Family profile is already set up.",
                                          duration: SnackbarDuration.MEDIUM,
                                          type: SnackbarMessageTypes.INFO,
                                        )
                                      : YipliUtils.gotoFamilyOnBoarding();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: YipliUtils.buildOnboardingStyleButton(
                                  context,
                                  icon: FontAwesomeIcons.running,
                                  textColor: isPlayerAdded == true
                                      ? yipliNewBlue
                                      : Theme.of(context).primaryColorLight,
                                  buttonColor: isPlayerAdded == true
                                      ? yipliGray
                                      : Theme.of(context).accentColor,
                                  iconColor: isPlayerAdded == true
                                      ? yipliNewBlue
                                      : iconColored == true &&
                                              isPlayerAdded != true
                                          ? yipliOrange
                                          : yipliWhite,
                                  text: "Add first Player",
                                  onTappedFunction: () {
                                isPlayerAdded == true
                                    ? YipliUtils.showNotification(
                                        context: context,
                                        msg: "You have already added a Player",
                                        duration: SnackbarDuration.MEDIUM,
                                        type: SnackbarMessageTypes.INFO,
                                      )
                                    : YipliUtils.goToPlayerOnBoardingPage(
                                        playerArgs);
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: YipliUtils.buildOnboardingStyleButton(
                                  context,
                                  icon: Icons.stay_current_landscape,
                                  textColor: isMatAdded == true
                                      ? yipliNewBlue
                                      : Theme.of(context).primaryColorLight,
                                  buttonColor: isMatAdded == true
                                      ? yipliGray
                                      : Theme.of(context).accentColor,
                                  iconColor: isMatAdded == true
                                      ? yipliNewBlue
                                      : iconColored == true
                                          ? yipliOrange
                                          : yipliWhite,
                                  text: "Add my first Mat",
                                  onTappedFunction: () {
                                isMatAdded == true
                                    ? YipliUtils.showNotification(
                                        context: context,
                                        msg: "You have already added a Mat",
                                        duration: SnackbarDuration.MEDIUM,
                                        type: SnackbarMessageTypes.INFO,
                                      )
                                    : YipliUtils.gotoRegisterMatPage(
                                        isOnboardingFlow: true);
                              }),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _goToLoginPageButton(context),
                                isFamilyNameAdded == true &&
                                        isPlayerAdded == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: doneButton,
                                      )
                                    : Container(
                                        height: 0,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]);
              })),
        )));
  }
}

Widget _goToLoginPageButton(BuildContext context) {
  return FlatButton(
    focusColor: androidTVFocusColor,
    child: Text(
      'Sign Out',
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(decoration: TextDecoration.none, color: yipliErrorRed),
    ),
    onPressed: () {
      Navigator.of(context).pushNamed('/login_screen');
    },
  );
}
