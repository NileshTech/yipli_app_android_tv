import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_app/pages/player_onboarding.dart';
import 'package:flutter_app/pages/family_onboarding.dart';
import 'package:flutter_app/pages/signin_with_phone.dart';
import 'package:flutter_app/pages/user_on_boaring/onboarding.dart';
import 'package:flutter_app/services/dnyamic-link-service.dart';
import 'device_check_for_responsive_ui/responsive_value.dart';
import 'device_check_for_responsive_ui/responsive_wrapper.dart';
import 'helpers/helper_index.dart';
import 'pages/a_pages_index.dart';
// import 'package:rive_splash_screen/rive_splash_screen.dart';

///NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5

ThemeData _buildYipliTheme() {
  final ThemeData base = ThemeData.light();
  final ThemeData yipliTheme = base.copyWith(
    backgroundColor: appbackgroundcolor,
    accentColor: accentcolor,
    primaryColor: primarycolor,
    primaryColorLight: justwhite,
    unselectedWidgetColor: primarycolor,
    primaryColorDark: appbackgroundcolor,
    disabledColor: justwhite,
    buttonColor: accentcolor,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: accentcolor,
    ),
    scaffoldBackgroundColor: justwhite,
    iconTheme: IconThemeData(color: accentcolor),
    textTheme: TextTheme(
      headline5: base.textTheme.headline5.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      subtitle1: base.textTheme.subtitle1.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      subtitle2: base.textTheme.subtitle2.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      bodyText2: base.textTheme.bodyText2.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      bodyText1: base.textTheme.bodyText1.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      button: base.textTheme.button.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      caption: base.textTheme.caption.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      overline: base.textTheme.overline.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline4: base.textTheme.headline4.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline3: base.textTheme.headline3.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline2: base.textTheme.headline2.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline1: base.textTheme.headline1.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
      headline6: base.textTheme.headline6.copyWith(
        color: justwhite,
        fontFamily: 'Lato',
      ),
    ),
  );

  return yipliTheme;
}

const double iPadProTab_Width = 2048;

void main() {
  /*initializeApp(
      apiKey: "AIzaSyA6j97oUtRMB8Cp9JPC8c__Hwc9oW3ByPM",
      authDomain: "yipli-project.firebaseapp.com",
      databaseURL: "https://yipli-project.firebaseio.com",
      projectId: "yipli-project",
      storageBucket: "yipli-project.appspot.com");*/

  String flare = "assets/flare/yipli_rive.flr";
  timeDilation = 1.0;

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(YipliApp(flare: flare));
  });
}

class YipliApp extends StatefulWidget {
  const YipliApp({
    Key key,
    @required this.flare,
  }) : super(key: key);

  final String flare;

  @override
  _YipliAppState createState() => _YipliAppState();
}

class _YipliAppState extends State<YipliApp> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire

  @override
  Widget build(BuildContext context) {
    //* Show error message if initialization failed
    if (_error) {
      print('Error on main page is - $_error');
      (YipliUtils.appConnectionStatus == AppConnectionStatus.DISCONNECTED)
          ? NoNetworkPage()
          : NotPageFound();
    }

    final botToastBuilder = BotToastInit();

    //* checking if the app is online or offline

    YipliUtils.manageAppConnectivity(context);
    return MultiProvider(
      child: FeatureDiscovery(
        child: FutureBuilder<List>(
            future: YipliAppInitializer.initialize(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return (YipliUtils.appConnectionStatus ==
                        AppConnectionStatus.DISCONNECTED)
                    ? NoNetworkPage()
                    : NotPageFound();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                print(
                    "Last App Opened from Local Storage: ${YipliAppLocalStorage.getData(YipliConstants.lastOpenedDateTime)}");
                return LayoutBuilder(builder: (context, constraints) {
                  return OrientationBuilder(builder: (context, orientation) {
                    return Shortcuts(
                      shortcuts: <LogicalKeySet, Intent>{
                        LogicalKeySet(LogicalKeyboardKey.select):
                            ActivateIntent(),
                      },
                      child: MaterialApp(
                        builder: (context, child) {
                          Size screenSize = MediaQuery.of(context).size;
                          return Platform.isIOS
                              ? screenSize.width == iPadProTab_Width
                                  ? ResponsiveWrapper.builder(
                                      ResponsiveConstraints(child: child),
                                      maxWidth:
                                          MediaQuery.of(context).size.width,
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                      defaultScale: true,
                                      breakpoints: [
                                        // ignore: invalid_use_of_visible_for_testing_member
                                        ResponsiveBreakpoint(
                                            breakpoint: 400,
                                            name: DESKTOP,
                                            autoscale: true,
                                            scaleFactor: 1),
                                      ],
                                    )
                                  : ResponsiveWrapper.builder(
                                      ResponsiveConstraints(child: child),
                                      maxWidth:
                                          MediaQuery.of(context).size.width,
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      defaultScale: true,
                                      breakpoints: [
                                        // ignore: invalid_use_of_visible_for_testing_member
                                        ResponsiveBreakpoint(
                                            breakpoint: 650,
                                            name: DESKTOP,
                                            autoscale: true,
                                            scaleFactor: 1),
                                      ],
                                    )
                              : screenSize.width < screenSize.height
                                  ? ResponsiveWrapper.builder(
                                      ResponsiveConstraints(child: child),
                                      maxWidth: 1280,
                                      minWidth: 480,
                                      defaultScale: true,
                                      breakpoints: [
                                        // ignore: invalid_use_of_visible_for_testing_member
                                        ResponsiveBreakpoint(
                                            breakpoint: 275,
                                            name: MOBILE,
                                            autoscale: true,
                                            scaleFactor: 0.8),
                                        ResponsiveBreakpoint(
                                            breakpoint: 350,
                                            name: MOBILE,
                                            autoscale: true,
                                            scaleFactor: 1.0),

                                        ResponsiveBreakpoint(
                                            breakpoint: 950,
                                            name: TABLET,
                                            autoscale: true,
                                            scaleFactor: 1.2),
                                        ResponsiveBreakpoint(
                                            breakpoint: 1000,
                                            name: DESKTOP,
                                            autoscale: true,
                                            scaleFactor: 0.8),
                                      ],
                                      background:
                                          Container(color: Color(0xFFF5F5F5)),
                                    )
                                  : ResponsiveWrapper.builder(
                                      ResponsiveConstraints(child: child),
                                      maxWidth:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      minWidth: 1000,
                                      defaultScale: true,
                                      breakpoints: [
                                        // ignore: invalid_use_of_visible_for_testing_member
                                        ResponsiveBreakpoint(
                                            breakpoint: 650,
                                            name: DESKTOP,
                                            autoscale: true,
                                            scaleFactor: 0.8),
                                      ],
                                    );

                          // ResponsiveWrapper.builder(
                          //   ResponsiveConstraints(child: child),
                          //   maxWidth: 1280,
                          //   minWidth: 480,
                          //   defaultScale: true,
                          //   breakpoints: [
                          //     // ignore: invalid_use_of_visible_for_testing_member
                          //     ResponsiveBreakpoint(
                          //         breakpoint: 275,
                          //         name: MOBILE,
                          //         autoscale: true,
                          //         scaleFactor: 0.8),
                          //     ResponsiveBreakpoint(
                          //         breakpoint: 350,
                          //         name: MOBILE,
                          //         autoscale: true,
                          //         scaleFactor: 1.0),

                          //     ResponsiveBreakpoint(
                          //         breakpoint: 950,
                          //         name: TABLET,
                          //         autoscale: true,
                          //         scaleFactor: 1.2),
                          //     ResponsiveBreakpoint(
                          //         breakpoint: 1000,
                          //         name: DESKTOP,
                          //         autoscale: true,
                          //         scaleFactor: 0.8),
                          //   ],
                          //   background: Container(color: Color(0xFFF5F5F5)),
                          // );
                        },
                        theme: _buildYipliTheme(),
                        debugShowCheckedModeBanner: false,
                        color: _buildYipliTheme().primaryColor,
                        title: 'Yipli',
                        onGenerateRoute: (settings) {
                          switch (settings.name) {
                            case ForgotPassword.routeName:
                              return PageTransition(
                                child: ForgotPassword(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case Login.routeName:
                              return PageTransition(
                                child: Login(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case SignUp.routeName:
                              return PageTransition(
                                child: SignUp(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case UserProfile.routeName:
                              return PageTransition(
                                child: UserProfile(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case UserEditProfile.routeName:
                              return PageTransition(
                                child: UserEditProfile(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case PlayerPage.routeName:
                              return PageTransition(
                                child: PlayerPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case PlayerEditProfile.routeName:
                              return PageTransition(
                                child: PlayerEditProfile(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            // case PlayerRewards.routeName:
                            //   return PageTransition(
                            //     child: PlayerRewards(),
                            //     type: PageTransitionType.fade,
                            //     duration: Duration(milliseconds: 375),
                            //     settings: settings,
                            //   );
                            //   break;
                            case PlayerPassport.routeName:
                              return PageTransition(
                                child: PlayerPassport(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;

                            case RegisterMatPage.routeName:
                              return PageTransition(
                                child: RegisterMatPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case AddNewMatPage.routeName:
                              return PageTransition(
                                child: AddNewMatPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case MatMenuPage.routeName:
                              return PageTransition(
                                child: MatMenuPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case Logout.routeName:
                              return PageTransition(
                                child: Logout(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case ViewImage.routeName:
                              return PageTransition(
                                child: ViewImage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case PlayerAdd.routeName:
                              return PageTransition(
                                child: PlayerAdd(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case ComingSoonPage.routeName:
                              return PageTransition(
                                child: ComingSoonPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case IntroScreen.routeName:
                              return PageTransition(
                                child: IntroScreen(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case VerificationScreen.routeName:
                              return PageTransition(
                                child: VerificationScreen(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;

                            case FitnessGaming.routeName:
                              if (!DynamicLinkService.isexecuted)
                                DynamicLinkService().handleDynamicLinks();

                              return PageTransition(
                                child: FitnessGaming(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );

                              break;
                            case FaqListScreen.routeName:
                              return PageTransition(
                                child: FaqListScreen(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case ExcerciseListScreen.routeName:
                              return PageTransition(
                                child: ExcerciseListScreen(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;

                            case PlayerProfilePage.routeName:
                              return PageTransition(
                                child: PlayerProfilePage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case AdventureGaming.routeName:
                              return PageTransition(
                                child: AdventureGaming(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case RemotePlay.routeName:
                              return PageTransition(
                                child: RemotePlay(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case StartJourney.routeName:
                              return PageTransition(
                                child: StartJourney(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case YipliFeed.routeName:
                              return PageTransition(
                                child: YipliFeed(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case SettingsPage.routeName:
                              return PageTransition(
                                child: SettingsPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case NoNetworkPage.routeName:
                              return PageTransition(
                                child: NoNetworkPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case WorldSelectionPage.routeName:
                              return PageTransition(
                                child: WorldSelectionPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case UserOnboardingPage.routeName:
                              return PageTransition(
                                child: UserOnboardingPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                            case PlayerOnboardingPage.routeName:
                              return PageTransition(
                                child: PlayerOnboardingPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;

                            case PlayerQuestioner.routeName:
                              return PageTransition(
                                child: PlayerQuestioner(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;

                            case FamilyOnboardingPage.routeName:
                              return PageTransition(
                                child: FamilyOnboardingPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;

                            case PlayerOnboardingPage.routeName:
                              return PageTransition(
                                child: PlayerOnboardingPage(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;

                            case SignInWithPhone.routeName:
                              return PageTransition(
                                child: SignInWithPhone(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;

                            default:
                              return PageTransition(
                                child: NotPageFound(),
                                type: PageTransitionType.fade,
                                duration: Duration(milliseconds: 375),
                                settings: settings,
                              );
                              break;
                          }
                        },
                        navigatorKey: YipliUtils.navigatorKey,
                        home: FitnessGaming(),

                        // Padding(
                        //   padding: const EdgeInsets.all(45.0),
                        //   child: FitnessGaming(),
                        // SplashScreen.callback(
                        //   isLoading: false,
                        //   fit: BoxFit.contain,
                        //   name: widget.flare,
                        //   startAnimation: 'yipliflare',
                        //   loopAnimation: 'yipliflare',
                        //   backgroundColor: yipliBlack,
                        //   onSuccess: (data) {
                        //     YipliUtils.navigatorKey.currentState
                        //         .pushReplacementNamed(
                        //             FitnessGaming.routeName);
                        //   },
                        //   onError: (error, stacktrace) {
                        //     YipliUtils.navigatorKey.currentState
                        //         .pushReplacementNamed(
                        //             FitnessGaming.routeName);
                        //   },
                        // ),
                        // ),
                      ),
                    );
                  });
                });
              } else {
                return MaterialApp(
                  color: appbackgroundcolor,
                  home: Center(
                    child: YipliLoaderMini(
                      loadingMessage: 'Loading Yipli App',
                    ),
                  ),
                );
              }
            }),
      ),
      providers: [
        ChangeNotifierProvider<PlayerOnBoardingStateModel>(
          create: (context) {
            PlayerOnBoardingStateModel playerOnBoardingStateModel =
                new PlayerOnBoardingStateModel();
            return playerOnBoardingStateModel;
          },
        ),
        ChangeNotifierProvider<UserModel>(
          create: (BuildContext context) {
            UserModel currentUser = new UserModel();
            currentUser.initialize();
            return currentUser;
          },
        ),
        ChangeNotifierProxyProvider<UserModel, CurrentPlayerModel>(
            create: (playerModelCtx) {
          CurrentPlayerModel currentPlayerModel = new CurrentPlayerModel();

          print("Returned CURRENT player model - MAIN");
          return currentPlayerModel;
        }, update:
                (updateCurrentPlayerModelCtx, currentUser, currentPlayerModel) {
          currentPlayerModel.currentPlayerId = currentUser.currentPlayerId;
          currentPlayerModel.initialize();
          return currentPlayerModel;
        }),
        ChangeNotifierProxyProvider<UserModel, AllPlayersModel>(
            create: (allPlayersModelCtx) {
          AllPlayersModel allPlayersModel = new AllPlayersModel();
          print("Returned ALL player model - MAIN");
          return allPlayersModel;
        }, update: (updateAllPlayerModelCtx, currentUser, allPlayersModel) {
          allPlayersModel.initialize();
          return allPlayersModel;
        }),
        ChangeNotifierProxyProvider<UserModel, MatsModel>(
            create: (matsModelCtx) {
          MatsModel matsModel = new MatsModel.initialize();
          print("Returned ALL player model - MAIN");
          return matsModel;
        }, update: (updateAllPlayerModelCtx, currentUser, matsModel) {
          matsModel = new MatsModel.initialize();
          return matsModel;
        }),
        ChangeNotifierProxyProvider<UserModel, CurrentMatModel>(
            create: (currentMatModelCtx) {
          CurrentMatModel currentMatModel = CurrentMatModel(null);
          return currentMatModel;
        }, update: (updateAllPlayerModelCtx, currentUser, currentMatModel) {
          currentMatModel.currentMatId = currentUser.currentMatId;
          return currentMatModel;
        }),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
