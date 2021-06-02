import 'package:flutter_app/database_models/adventure-gaming/adventure-gaming-video-watched.dart';
import 'package:flutter_app/pages/excercise_list_screen.dart';
import 'package:flutter_app/pages/player_profile_page.dart';
import 'package:flutter_app/pages/remote_play.dart';
import 'package:flutter_app/pages/user_profile.dart';
import 'package:flutter_app/widgets/timeline/startJourney.dart';
// import 'package:upgrader/upgrader.dart';
import 'a_pages_index.dart';

enum YipliBackgroundMode { light, dark }

class YipliPageFrame extends StatefulWidget {
  const YipliPageFrame({
    Key key,
    this.child,
    this.selectedIndex = 0,
    this.toShowTabBar = false,
    this.tabBar,
    this.tabsCount = 1,
    this.title,
    this.toShowBottomBar = false,
    this.backgroundMode = YipliBackgroundMode.dark,
    this.showDrawer = false,
    this.isBottomBarInactive = true,
    this.toDisableFeatures = true,
    this.widgetOnAppBar,
  })  : assert(selectedIndex != null,
            "Please select some bottombar index to show."),
        super(key: key);

  final YipliBackgroundMode backgroundMode;
  final Widget child;
  final bool isBottomBarInactive;
  final int selectedIndex;
  final bool showDrawer;
  final TabBar tabBar;
  final int tabsCount;
  final Widget title;
  final bool toDisableFeatures;
  final bool toShowBottomBar;
  final bool toShowTabBar;
  final Widget widgetOnAppBar;

  @override
  _YipliPageFrameState createState() => _YipliPageFrameState();
}

class _YipliPageFrameState extends State<YipliPageFrame>
    with TickerProviderStateMixin {
  AnimationController drawerProgress;
  GlobalKey<EnsureVisibleState> ensureKey;

  GlobalKey<State<StatefulWidget>> _drawerKey;
  static var _pageOptions;

  int _selectedPage = 0;

  @override
  void initState() {
    _selectedPage = widget.selectedIndex;
    if (!widget.toDisableFeatures) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print("Discover karu!");
        FeatureDiscovery.discoverFeatures(
          context,
          {
            YipliConstants.featureDiscoveryDrawerButtonId,
            YipliConstants.featureFitnessGamingId,
            YipliConstants.featureAdventureGamingId,
            YipliConstants.featureDiscoveryPlayerProfileId,
            YipliConstants.featureDiscoveryYipliFeedId,
            YipliConstants.featureDiscoverySwitchPlayerId,
          },
        );
      });
    }
    super.initState();
  }

  void checkFeaturesAndShow(BuildContext context) {}

  Widget buildDrawerButton(UserModel userModel) {
    drawerProgress =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _drawerKey = new GlobalKey();
    return InkWell(
      focusColor: androidTVFocusColor,
      splashColor: Colors.transparent,
      onTap: () {
        print("Opening drawer!");
        dynamic state = _drawerKey.currentState;
        drawerProgress.forward();
        state.showButtonMenu();
      },
      child: IgnorePointer(child: buildPopupMenuButton(userModel)),
    );
  }

  ///menu items
  PopupMenuButton<int> buildPopupMenuButton(UserModel userModel) {
    Size screenSize = MediaQuery.of(context).size;

    // default assumption is everything is complete.
    bool isProfileSetupComplete = true;
    bool isFamilySetupComplete = true;
    bool isFirstPlayerAdded = true;
    bool isFirstMatAdded = true;

    if (userModel.displayName == null ||
        userModel.contactNo == null ||
        userModel.profilePicUrl == null) {
      isFamilySetupComplete = false;
      isProfileSetupComplete = false;
    }

    if (userModel.currentMatId == null) {
      isFirstMatAdded = false;
      isProfileSetupComplete = false;
    }

    if (userModel.currentPlayerId == null) {
      isFirstPlayerAdded = false;
      isProfileSetupComplete = false;
    }

    return PopupMenuButton<int>(
      // padding: const EdgeInsets.all(1.0),
      key: _drawerKey,
      //Todo @Ameet - Transition to be changed
      icon: isProfileSetupComplete == true
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: () {},
                focusColor: androidTVFocusColor,
                child: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  color: IconTheme.of(context).color,
                  progress: drawerProgress,
                ),
              ),
            )
          : Stack(
              children: [
                AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  color: IconTheme.of(context).color,
                  progress: drawerProgress,
                ),
                Icon(
                  Icons.brightness_1_sharp,
                  color: yipliErrorRed,
                  size: 8,
                ),
              ],
            ),
      elevation: 24,
      color: Theme.of(context).primaryColor,
      offset: Offset.fromDirection(1.5708, 120.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      onSelected: (selected) {
        drawerProgress.reverse();
      },
      onCanceled: () {
        drawerProgress.reverse();
      },
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 0,
            child: DrawTile(
                tileText: 'My family',
                iconWidget: isFamilySetupComplete == true
                    ? Icon(
                        FontAwesomeIcons.users,
                        size: screenSize.width * 0.05,
                        color: Theme.of(context).accentColor,
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Icon(Icons.brightness_1_sharp,
                                color: yipliErrorRed,
                                size: screenSize.width * 0.02),
                          ),
                          Icon(
                            FontAwesomeIcons.users,
                            size: screenSize.width * 0.05,
                            color: Theme.of(context).accentColor,
                          ),
                        ],
                      ),
                targetRoute: UserProfile.routeName)),
        PopupMenuItem(
            value: 1,
            child: DrawTile(
                tileText: 'Players',
                iconWidget: isFirstPlayerAdded == true
                    ? Icon(
                        FontAwesomeIcons.running,
                        size: screenSize.width * 0.05,
                        color: Theme.of(context).accentColor,
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Icon(Icons.brightness_1_sharp,
                                color: yipliErrorRed,
                                size: screenSize.width * 0.02),
                          ),
                          Icon(
                            FontAwesomeIcons.running,
                            size: screenSize.width * 0.05,
                            color: Theme.of(context).accentColor,
                          ),
                        ],
                      ),
                targetRoute: PlayerPage.routeName)),
        PopupMenuItem(
            value: 2,
            child: DrawTile(
                tileText: 'My Mats',
                iconWidget: isFirstMatAdded == true
                    ? Icon(
                        Icons.stay_current_landscape,
                        size: screenSize.width * 0.05,
                        color: Theme.of(context).accentColor,
                      )
                    : Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 2.0),
                            child: Icon(Icons.brightness_1_sharp,
                                color: yipliErrorRed,
                                size: screenSize.width * 0.02),
                          ),
                          Icon(
                            Icons.stay_current_landscape,
                            size: screenSize.width * 0.05,
                            color: Theme.of(context).accentColor,
                          ),
                        ],
                      ),
                targetRoute: MatMenuPage.routeName)),
        PopupMenuItem(
          value: 3,
          child: DrawTile(
              tileText: 'FAQs',
              iconWidget: Icon(
                Icons.message,
                size: screenSize.width * 0.05,
                color: Theme.of(context).accentColor,
              ),
              targetRoute: FaqListScreen.routeName),
        ),
        // PopupMenuItem(
        //   value: 5,
        //   child: DrawTile(
        //       tileText: 'Exercises',
        //       tileIcon: Icons.explore,
        //       targetRoute: ExcerciseListScreen.routeName),
        // ),

        PopupMenuItem(
          value: 4,
          child: DrawTile(
              tileText: 'PC Play',
              iconWidget: Icon(
                Icons.computer_sharp,
                size: screenSize.width * 0.05,
                color: Theme.of(context).accentColor,
              ),
              targetRoute: userModel.currentPlayerId != null
                  ? RemotePlay.routeName
                  : null),
        ),
        PopupMenuItem(
          value: 5,
          child: DrawTile(
              shouldReplaceViewStack: true,
              tileText: 'Settings',
              iconWidget: Icon(
                FontAwesomeIcons.cog,
                size: screenSize.width * 0.05,
                color: Theme.of(context).accentColor,
              ),
              targetRoute: SettingsPage.routeName),
        ),
      ],
    );
  }

  ///bottom navigation bar
  Widget buildBottomNavigationBar() {
    var currentPlayerModel = Provider.of<CurrentPlayerModel>(context);
    return ClipRRect(
      borderRadius:
          BorderRadius.vertical(bottom: Radius.circular(20), top: Radius.zero),
      child: AdventureGamingVideoWatchedValidator(
          playerModel: currentPlayerModel.player,
          builder: (context, hasPlayerWatchedVideoSnapshot) {
            return BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: _selectedPage,
              unselectedItemColor:
                  Theme.of(context).primaryColorLight.withOpacity(0.6),
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: widget.isBottomBarInactive
                  ? Theme.of(context).primaryColorLight.withOpacity(0.6)
                  : yipliLogoOrange,
              onTap: (int index) {
                if (currentPlayerModel.currentPlayerId != null) {
                  setState(() {
                    if (_selectedPage != index) {
                      print('selected page - $_selectedPage');
                      if (index == 1 &&
                          hasPlayerWatchedVideoSnapshot.connectionState !=
                              ConnectionState.waiting) {
                        String pageOptionForRouting =
                            (hasPlayerWatchedVideoSnapshot?.data ?? false)
                                ? AdventureGaming.routeName
                                : StartJourney.routeName;
                        _pageOptions[1] = pageOptionForRouting;
                        YipliUtils.goToRoute(
                          pageOptionForRouting,
                          true,
                        );
                      }
                      if (index != 4) {
                        _selectedPage = index;
                        YipliUtils.goToRoute(_pageOptions[index], true);
                      } else
                        SwitchPlayerModalButton.showAndSetSwitchPlayerModal(
                            currentPlayerModel, context);
                    } else {
                      if (widget.isBottomBarInactive) {
                        if (index != 4)
                          YipliUtils.goToRoute(_pageOptions[index], true);
                      }
                      print('Not changing the tab');
                    }
                  });
                } else
                  YipliUtils.showNotification(
                      context: context,
                      msg: "Please add player and check again.",
                      type: SnackbarMessageTypes.ERROR,
                      duration: SnackbarDuration.MEDIUM);
              },
              items: [
                ///BNBI - fitness gaming
                BottomNavigationBarItem(
                  icon:
                      // DescribedFeatureOverlay(
                      //     contentLocation: ContentLocation.above,
                      //     featureId: YipliConstants.featureFitnessGamingId,
                      //     tapTarget: const Icon(FontAwesomeIcons.gamepad),
                      //     title: Text('Yipli Player Fitness gaming'),
                      //     description:
                      //         Text('Here you would see your Fitness games!'),
                      //     backgroundColor: Theme.of(context).accentColor,
                      //     child:

                      Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.gamepad,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Games',
                        style: Theme.of(context)
                            .textTheme
                            .overline
                            .copyWith(letterSpacing: 0),
                      ),
                    ],
                  ),

                  // ),
                  label: ('Games'),
                ),

                ///BNBI - adventure gaming
                BottomNavigationBarItem(
                  icon:
                      //  DescribedFeatureOverlay(
                      //     contentLocation: ContentLocation.above,
                      //     featureId: YipliConstants.featureAdventureGamingId,
                      //     tapTarget: const Icon(FontAwesomeIcons.hiking),
                      //     title: Text('Yipli Player Adventure gaming'),
                      //     description: Text(
                      //         'Here you would see your adventure gaming journey!'),
                      //     backgroundColor: Theme.of(context).accentColor,
                      //     child:
                      Column(
                    children: [
                      Icon(
                        FontAwesomeIcons.hiking,
                      ),
                      SizedBox(height: 2),
                      Text('Adventure',
                          style: Theme.of(context)
                              .textTheme
                              .overline
                              .copyWith(letterSpacing: 0)),
                    ],
                    // )
                  ),
                  label: 'Adventure Gaming',
                ),

                ///BNBI - place holder
                BottomNavigationBarItem(icon: Container(), label: ""),

                ///BNBI - yipli feed
                BottomNavigationBarItem(
                  icon:
                      // DescribedFeatureOverlay(
                      //     contentLocation: ContentLocation.above,
                      //     featureId: YipliConstants.featureDiscoveryYipliFeedId,
                      //     tapTarget: const Icon(FontAwesomeIcons.list),
                      //     title: Text('Yipli Feed'),
                      //     description: Text('Here you would find Yipli Feed!'),
                      //     backgroundColor: Theme.of(context).accentColor,
                      //     child:
                      Column(
                    children: [
                      Icon(EvaIcons.list),
                      SizedBox(height: 2),
                      Text('Feed',
                          style: Theme.of(context)
                              .textTheme
                              .overline
                              .copyWith(letterSpacing: 0))
                    ],
                    // )
                  ),
                  label: 'Yipli Feed',
                ),

                ///BNBI - switch player
                BottomNavigationBarItem(
                    label: 'Switch Player',
                    icon: Consumer2<UserModel, CurrentPlayerModel>(
                      builder: (BuildContext currentContext,
                          UserModel currentUser,
                          CurrentPlayerModel currentPlayerModel,
                          Widget child) {
                        return
                            // DescribedFeatureOverlay(
                            //     featureId:
                            //         YipliConstants.featureDiscoverySwitchPlayerId,
                            //     tapTarget: Icon(
                            //       EvaIcons.swapOutline,
                            //     ),
                            //     title: Text('Switch Player'),
                            //     description: Text(
                            //         'Tap here to switch the current player!'),
                            //     backgroundColor: Theme.of(context).accentColor,
                            //     child:
                            Column(
                          children: [
                            Icon(
                              EvaIcons.swapOutline,
                            ),
                            SizedBox(height: 2),
                            Text('Switch',
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(letterSpacing: 0))
                          ],
                        );

                        //                      SwitchPlayerModalButton(
                        //                        screenSize: screenSize,
                        //                        playerId: currentUser.currentPlayerId,
                        //                      ),
                        // );
                      },
                    )),
              ],
            );
          }),
    );
  }

  getTitleWidget(BuildContext context, Widget title) {
    if (title is Text) {
      return Text(title.data,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Theme.of(context).accentColor));
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    _pageOptions = [
      FitnessGaming.routeName, // index = 0
      "", // index = 1
      PlayerProfilePage.routeName, // index = 2 hidden
      YipliFeed.routeName, //index = 3
      //SwitchPlayerModalButton.routeName //index = 4
    ];

    checkFeaturesAndShow(context);
    var currentPlayerModel = Provider.of<CurrentPlayerModel>(context);
    bool hasParentPage = Navigator.of(context).canPop();
    print("YipliPageFrame for ${widget.title} -- $hasParentPage");
    return DefaultTabController(
      length: widget.tabsCount,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            centerTitle: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            backgroundColor: appbackgroundcolor,
            title: getTitleWidget(context, widget.title),
            leading: widget.showDrawer
                ?
                // DescribedFeatureOverlay(
                // featureId: YipliConstants.featureDiscoveryDrawerButtonId,
                // tapTarget: Icon(Icons.menu),
                // title: Text('Add new Mats and Players'),
                // description: Text(
                //     '\nUnder Menu go to \'My Mats\' to add a new mat\n\nAnd then go to \'Players\' to add a new player '),
                // backgroundColor: Theme.of(context).accentColor,
                // child:
                Consumer<UserModel>(builder: (context, userModel, child) {
                    if (userModel.id == null) {
                      return YipliLoaderMini(
                        loadingMessage: "",
                      );
                    }

                    return buildDrawerButton(userModel);
                  })
                // )
                : (hasParentPage
                    ? IconButton(
                        // focusColor: androidTVFocusColor,
                        icon: Icon(Icons.arrow_back),
                        color: yipliWhite,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    : null),
            actions: <Widget>[
              widget.widgetOnAppBar != null
                  ? (widget.widgetOnAppBar)
                  : Container()
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: Container(
                // height: MediaQuery.of(context).size.height * 0.75,
                child: widget.child),
          ),
          // Stack(
          //   children: <Widget>[
          //     Container(
          //       color: (widget.backgroundMode == YipliBackgroundMode.light)
          //           ? Theme.of(context).primaryColorLight
          //           : Theme.of(context).backgroundColor,
          //     ),
          //     widget.child,
          //   ],
          // ),
          bottomNavigationBar: (widget.toShowBottomBar)
              ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          transform: GradientRotation(pi / 2),
                          // EEE,0; 818181,46; 383838,76;222,86; 101010,93;000, 100
                          colors: [
                            Color(0xFF101010).withOpacity(0.0),
                            Color(0xFF101010).withOpacity(0.0),
                            Color(0xFF000000),
                            Color(0xFF101010)
                          ],
                          stops: [0, 0.3, 0.6, 1],
                        )),
                      ),
                    ),
                    BottomAppBar(
                      shape: CircularNotchedRectangle(),
                      notchMargin: 4,
                      color: Colors.transparent,
                      clipBehavior: Clip.antiAlias,
                      child: buildBottomNavigationBar(),
                    ),
                  ],
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: (widget.toShowBottomBar)
              ? Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.47),
                  child: Material(
                      type: MaterialType.transparency,
                      child: Ink(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _selectedPage == 2
                                    ? yipliLogoOrange
                                    : Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(0.7),
                                width: 3.0),
                            shape: BoxShape.circle,
                          ),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.17,
                            width: MediaQuery.of(context).size.width * 0.17,
                            child: FloatingActionButton(
                              // focusColor: androidTVFocusColor,
                              backgroundColor: appbackgroundcolor,
                              heroTag: 'bottom-bar-profile-pic',
                              onPressed: Envirnment.isAndroidTV == true
                                  ? () {
                                      YipliUtils.showNotification(
                                          duration: SnackbarDuration.LONG,
                                          context: context,
                                          msg:
                                              "This feature is not supported on Fitness Stick App for now.\n Please use Phone App for this feature.",
                                          type: SnackbarMessageTypes.INFO);
                                    }
                                  : () {
                                      print(
                                          'printing selected page on pressed');

                                      if (currentPlayerModel.currentPlayerId !=
                                          null) {
                                        YipliUtils.navigatorKey.currentState
                                            .pushReplacementNamed(
                                                PlayerProfilePage.routeName);
                                      } else {
                                        YipliUtils.showNotification(
                                            context: context,
                                            msg:
                                                "Please add player and check again.",
                                            type: SnackbarMessageTypes.ERROR,
                                            duration: SnackbarDuration.MEDIUM);
                                      }
                                    },
                              child: Consumer<CurrentPlayerModel>(
                                builder: (context, currentPlayerModel, child) {
                                  return YipliUtils.getProfilePicImageIcon(
                                      context,
                                      currentPlayerModel.player.profilePicUrl,
                                      _selectedPage == 2);
                                },
                              ),
                            ),
                          ))))
              : null,
        ),
      ),
    );
  }
}
