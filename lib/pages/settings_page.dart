import 'package:package_info/package_info.dart';
import 'package:flutter_app/classes/envirnment.dart';
import 'a_pages_index.dart';

class SettingsPage extends StatefulWidget {
  static const String routeName = '/settings_page';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void initState() {
    super.initState();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return YipliPageFrame(
      title: Text("Settings"),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //app tour button
          // Padding(
          //   padding:
          //       const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          //   child: Container(
          //     height: screenSize.width / 8,
          //     padding: EdgeInsets.all(2.0),
          //     width: MediaQuery.of(context).size.width * .95,
          //     decoration: new BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black12,
          //           blurRadius: 20.0, // soften the shadow
          //           spreadRadius: 0.0, //extend the shadow
          //           offset: Offset(
          //             0.0, // Move to right horizontally
          //             0.75, // Move to bottom Vertically
          //           ),
          //         )
          //       ],
          //     ),
          //     child: InkWell(
          //       onTap: () {
          //         print("reset app tour pressed");
          //         FeatureDiscovery.clearPreferences(
          //           context,
          //           {
          //             YipliConstants.featureFitnessGamingId,
          //             YipliConstants.featureAdventureGamingId,
          //             YipliConstants.featureDiscoveryPlayerProfileId,
          //             YipliConstants.featureDiscoveryYipliFeedId,
          //             YipliConstants.featureDiscoverySwitchPlayerId,
          //             YipliConstants.featureDiscoveryDrawerButtonId,
          //             YipliConstants.featureDiscoveryAddNewMatId,
          //             YipliConstants.featureDiscoveryAddNewPlayerId,
          //           },
          //         );
          //         YipliUtils.initializeApp();
          //       },
          //       child: Center(
          //         child: Text(
          //           'Take app tour',
          //           style: Theme.of(context).textTheme.headline6,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          //Android Tv toggle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            child: Container(
                height: screenSize.width / 8,
                padding: EdgeInsets.all(2.0),
                width: MediaQuery.of(context).size.width * .95,
                decoration: new BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 20.0, // soften the shadow
                      spreadRadius: 0.0, //extend the shadow
                      offset: Offset(
                        0.0, // Move to right horizontally
                        0.0, // Move to bottom Vertically
                      ),
                    )
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    onTap: toggleButton,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Android TV mode',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: yTrueWhite),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: AnimatedContainer(
                                        // height: 30,
                                        // width: screenSize.width * 0.2,
                                        duration: Duration(microseconds: 1000),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          color: yipliBlack,
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            AnimatedPositioned(
                                                duration: Duration(
                                                    microseconds: 1000),
                                                curve: Curves.bounceInOut,
                                                // top: 3.0,
                                                left: Envirnment.isAndroidTV
                                                    ? 30.0
                                                    : 0.0,
                                                right: Envirnment.isAndroidTV
                                                    ? 0.0
                                                    : 30.0,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    focusColor:
                                                        androidTVFocusColor,
                                                    onTap: toggleButton,
                                                    child: AnimatedSwitcher(
                                                        duration: Duration(
                                                            microseconds: 1000),
                                                        transitionBuilder:
                                                            (Widget child,
                                                                Animation<
                                                                        double>
                                                                    animation) {
                                                          return ScaleTransition(
                                                              scale: animation,
                                                              child: child);
                                                        },
                                                        child: Envirnment
                                                                .isAndroidTV
                                                            ? Icon(
                                                                Icons
                                                                    .brightness_1_rounded,
                                                                color:
                                                                    yipliNewBlue,
                                                                key:
                                                                    UniqueKey(),
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .brightness_1_rounded,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                key:
                                                                    UniqueKey(),
                                                              )),
                                                  ),
                                                )),
                                          ],
                                        )),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                      Envirnment.isAndroidTV ? "On" : "Off",
                                      textAlign: TextAlign.center),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ),

          //app tour button
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          //   child: FlatButton(
          //       color: Theme.of(context).primaryColor,
          //       child: Text(
          //         "Take the app tour again",
          //         style: TextStyle(
          //             color: Theme.of(context).textTheme.bodyText1.color),
          //       ),
          //       onPressed: () {
          //         print("reset app tour pressed");
          //         FeatureDiscovery.clearPreferences(
          //           context,
          //           {
          //             YipliConstants.featureFitnessGamingId,
          //             YipliConstants.featureAdventureGamingId,
          //             YipliConstants.featureDiscoveryPlayerProfileId,
          //             YipliConstants.featureDiscoveryYipliFeedId,
          //             YipliConstants.featureDiscoverySwitchPlayerId,
          //             YipliConstants.featureDiscoveryDrawerButtonId,
          //             YipliConstants.featureDiscoveryAddNewMatId,
          //             YipliConstants.featureDiscoveryAddNewPlayerId,
          //           },
          //         );
          //         YipliUtils.initializeApp();
          //       }),
          // ),
          //logout button
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          //   child: FlatButton(
          //     color: Colors.red.shade900,
          //     onPressed: () {
          //       YipliUtils.goToLogoutScreen();
          //     },
          //     child: Text(
          //       "Logout",
          //       style: TextStyle(
          //           color: Theme.of(context).textTheme.bodyText1.color),
          //     ),
          //   ),
          // ),
          // reward button
          // Padding(
          //     padding:
          //         const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          //     child: FlatButton(
          //       color: Colors.blue.shade900,
          //       onPressed: () {
          //         showDialog(
          //           context: context,
          //           barrierDismissible: true,
          //           builder: (BuildContext context) => AdventureRewardPopUp(),
          //         );
          //       },
          //       child: Text(
          //         'reward card',
          //         style: TextStyle(
          //             color: Theme.of(context).textTheme.bodyText1.color),
          //       ),
          //     )),

          //reset local cache
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          //   child: FlatButton(
          //     color: Colors.amber.shade900,
          //     onPressed: () {
          //       YipliAppLocalStorage.reset().then((value) {
          //         YipliUtils.showNotification(
          //           context: context,
          //           msg: "Local app cache cleared successfully!",
          //           type: SnackbarMessageTypes.SUCCESS,
          //         );
          //       }).catchError(() {
          //         YipliUtils.showNotification(
          //           context: context,
          //           msg: "Local app cache NOT cleared!",
          //           type: SnackbarMessageTypes.ERROR,
          //         );
          //       });
          //     },
          //     child: Text(
          //       "Reset Local Cache",
          //       style: TextStyle(
          //           color: Theme.of(context).textTheme.bodyText1.color),
          //     ),
          //   ),
          // ),

          //select world
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20),
          //   child: FlatButton(
          //       color: Theme.of(context).primaryColor,
          //       child: Text(
          //         "Questioner Pages",
          //         style: TextStyle(
          //             color: Theme.of(context).textTheme.bodyText1.color),
          //       ),
          //       onPressed: () {
          //         print("Questioner Pages");
          //         YipliUtils.goToPlayerQuestioner();
          //       }),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //logout button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Container(
                  height: screenSize.width / 8,
                  padding: EdgeInsets.all(2.0),
                  width: MediaQuery.of(context).size.width * .95,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20.0, // soften the shadow
                        spreadRadius: 0.0, //extend the shadow
                        offset: Offset(
                          0.0, // Move to right horizontally
                          0.75, // Move to bottom Vertically
                        ),
                      )
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      focusColor: androidTVFocusColor,
                      onTap: () {
                        YipliUtils.goToLogoutScreen();
                      },
                      child: Center(
                        child: Text(
                          'Logout',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: yTangerine),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 2),
                child: Text("App Version : " + _packageInfo.version,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.subtitle2
                    // .copyWith(fontSize: 15),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  toggleButton() {
    setState(() {
      Envirnment.isAndroidTV = !Envirnment.isAndroidTV;
      YipliUtils.showNotification(
          duration: SnackbarDuration.LONG,
          context: context,
          msg: Envirnment.isAndroidTV == true
              ? "Gaming device set to Fitness Stick. \n If you wish to play on Phone turn off this mode."
              : "Gaming device set to Phone. \n If you wish to play on Fitness Stick turn on this mode.",
          type: SnackbarMessageTypes.INFO);
    });
  }
}
