import 'dart:io';

import 'package:device_apps/device_apps.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/classes/InterAppCommunicationArguments.dart';
import 'package:flutter_app/classes/envirnment.dart';
import 'package:flutter_app/database_models/database_model_index.dart';
import 'package:flutter_app/helpers/helper_index.dart';
import 'package:flutter_app/helpers/utils.dart';
import 'package:flutter_app/page_models/current_mat_model.dart';
import 'package:flutter_app/page_models/current_player_model.dart';
import 'package:flutter_app/page_models/user_model.dart';
import 'package:flutter_app/widgets/cards/games_icon.dart';
import 'package:open_appstore/open_appstore.dart';
import 'package:provider/provider.dart';
import 'package:device_info/device_info.dart';

Tween<double> _scaleTween = Tween<double>(begin: 0.9, end: 1.0);

class GamesDisplayListItem extends StatefulWidget {
  final String description;
  final String intensity;
  final String name;
  final String imageLink;
  final double rating;
  final String iosURL;
  final String androidURL;
  final String windowsURL;
  String gameToAutoLaunch;
  final String dynamiclink;
  GamesDisplayListItem({
    Key key,
    this.description,
    this.intensity,
    this.name,
    this.imageLink,
    this.rating,
    this.iosURL,
    this.androidURL,
    this.windowsURL,
    this.gameToAutoLaunch,
    this.dynamiclink,
  }) : super(key: key);

  @override
  _GamesDisplayListItemState createState() => _GamesDisplayListItemState();
}

class _GamesDisplayListItemState extends State<GamesDisplayListItem> {
  //Todo : Remove this when IOS games apps are uploaded to App store
  bool isGameLaunchenbled = false;

  Query gameLaunchForIOSCheck = FirebaseDatabaseUtil()
      .rootRef
      .child("inventory")
      .child("yipli-app")
      .child("ios")
      .child("games-launch");

  Future deviceInfo() async {
    AndroidDeviceInfo androidDeviceInfo = await DeviceInfoPlugin().androidInfo;

    print("device info: \n" +
        "device androidId: " +
        androidDeviceInfo.androidId +
        "device info: \n" +
        "device type: " +
        androidDeviceInfo.type +
        "device info: \n" +
        "device model: " +
        androidDeviceInfo.model +
        "\n" +
        "device brand: " +
        androidDeviceInfo.brand +
        "\n" +
        "device display: " +
        androidDeviceInfo.display +
        "\n" +
        "device id: " +
        androidDeviceInfo.id +
        "\n" +
        "device manufacturer: " +
        androidDeviceInfo.manufacturer +
        "\n" +
        "device product: " +
        androidDeviceInfo.product);
    return androidDeviceInfo;
  }

  @override
  Widget build(BuildContext context) {
    bool isInstalled = false;
    print("${Envirnment.isAndroidTV}");
    return FutureBuilder(
        future: deviceInfo(),
        builder: (context, snapshot1) {
          return FutureBuilder(
              future: DeviceApps.isAppInstalled(widget.androidURL),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (Platform.isAndroid) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                }
                // Works only for android.
                // For IOS, we will be showing only the play button.
                // For that, in case of IOS, we will hardcode the 'isInstalled' flag with true.
                if (Platform.isIOS) {
                  isInstalled = true;
                } else if (Platform.isAndroid) {
                  isInstalled = snapshot.data;
                }

                //Todo : Remove the StreamBuilder once all IOS games apps are uploaded to App store
                return StreamBuilder<Event>(
                    stream: gameLaunchForIOSCheck.onValue,
                    builder: (context, event) {
                      if (Platform.isAndroid) {
                        isGameLaunchenbled = true;
                      } else if (Platform.isIOS) {
                        if (!event.hasData) {
                          return Container();
                        } else
                          isGameLaunchenbled = event.data.snapshot.value;
                      }

                      return Consumer3<UserModel, CurrentPlayerModel,
                              CurrentMatModel>(
                          builder: (context, userModel, currentPlayerModel,
                              currentMatModel, child) {
                        if (widget.androidURL?.toLowerCase() ==
                            widget.gameToAutoLaunch?.toLowerCase()) {
                          //Handling game auto launching from dynamic link without recognizing the tap
                          //This is called when game is not launched through yipli app.
                          onGamePlayTap(currentMatModel, currentPlayerModel,
                              userModel, context);
                        }
                        if (widget.iosURL?.toLowerCase() ==
                            widget.gameToAutoLaunch?.toLowerCase()) {
                          //Handling game auto launching from dynamic link without recognizing the tap
                          //This is called when game is not launched through yipli app.
                          onGamePlayTap(currentMatModel, currentPlayerModel,
                              userModel, context);
                        }

                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TweenAnimationBuilder(
                            tween: _scaleTween,
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 750),
                            builder: (context, scale, child) {
                              return Transform.scale(
                                  scale: scale, child: child);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  // flex: 6,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        focusColor: androidTVFocusColor,
                                        onTap: () {
                                          //Todo : IsGameInstalled not handled for now, as No download/Play icons are shown
                                          isGameLaunchenbled == true
                                              ? onGamePlayTap(
                                                  currentMatModel,
                                                  currentPlayerModel,
                                                  userModel,
                                                  context)
                                              : print(
                                                  "This feature is disabled");
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: GameIcon(
                                                imageLink: widget.imageLink),
                                          ),
                                        )),
                                  ),
                                ),
                                // Expanded(
                                //   // flex: 5,
                                //   child: FlatButton.icon(
                                //       focusColor: yipliGreen.withOpacity(0.7),
                                //       label: Text(""),
                                //       // GameIcon(imageLink: widget.imageLink),
                                //       icon:
                                //           GameIcon(imageLink: widget.imageLink),
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(18.0),
                                //       ),
                                //       // color: Colors.green,
                                //       // textColor: Colors.white,
                                //       onPressed: () {
                                //         isGameLaunchenbled == true
                                //             ? onGamePlayTap(
                                //                 currentMatModel,
                                //                 currentPlayerModel,
                                //                 userModel,
                                //                 context)
                                //             : print("This feature is disabled");
                                //       }),
                                // ),
                                // Expanded(
                                //   flex: 1,
                                //   child: Padding(
                                //     padding: const EdgeInsets.all(1.0),
                                //     child: Container(
                                //       child: Text(
                                //         widget.name,
                                //         textAlign: TextAlign.center,
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .subtitle1
                                //             .copyWith(
                                //               fontWeight: FontWeight.w800,
                                //             ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        );
                      });
                    });
              });
        });
  }
  /*
    This function is called manually / automatically depending on a condition.

    If user launched any Yipli game directly, he will be redirected to Yipli app, and the game will be auto launched.
    In that case this function will be called without a tap.

    Else this function will be called whenever user taps the play button.
  */

  onGamePlayTap(
    currentMatModel,
    currentPlayerModel,
    userModel,
    context,
  ) async {
    try {
      if (currentMatModel.mat.macAddress == null) {
        print('currentMatModel is null');
        return YipliUtils.showNotification(
            context: context,
            msg: "Register your Yipli MAT to play.\nGo to Menu -> My Mats",
            type: SnackbarMessageTypes.ERROR,
            duration: SnackbarDuration.LONG);
      } else if (currentPlayerModel == null) {
        print('currentPlayerModel is null');
        return YipliUtils.showNotification(
            context: context,
            msg: "Add player to play.\nGo to Menu -> Players",
            type: SnackbarMessageTypes.ERROR,
            duration: SnackbarDuration.LONG);
      } else {
        InterAppCommunicationArguments argsToBePassedToGame;

        //TODO : remove this later if not needed.
        //print("Launching Game with Arguments: ${currentPlayerModel.player.name} ${currentPlayerModel.player.dob} ${currentPlayerModel.player.height} ${currentPlayerModel.player.weight} ${currentMatModel.mat.matId} ${currentMatModel.mat.macAddress} ${currentPlayerModel.player.isMatTutDone}");

        //TODO: this arguments are for android tv builds, In future we need this to be controlled from setiings page
        argsToBePassedToGame = new InterAppCommunicationArguments(
            uId: userModel.id,
            pId: currentPlayerModel.player.id,
            mId: currentMatModel.mat.matId,
            mName: currentMatModel.mat.macName,
            tv: Envirnment.isAndroidTV ? "1" : "0");

        print(
            "Play pressed! Sending arguments : ${argsToBePassedToGame.toJson().toString()}");

        //WidgetsBinding is used to handle the exception of setstate while the widget is building
        WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
              //Clearing the value to avoid relaunching of the game again and again with the same dynamic link.
              widget.gameToAutoLaunch = "";

              //Todo: Remove this later. This was working code.
              //YipliUtils.openAppWithArgs(widget.androidURL, args.toJson());

              YipliUtils.openAppWithDynamicLink(widget.dynamiclink +
                  "?" +
                  YipliUtils.convertInterAppArgsToDynamicLinkArgString(
                      argsToBePassedToGame));
            }));
      }
    } catch (e) {
      print("Exception in onGamePlayTap : ");
      print(e);
    }
  }
}
