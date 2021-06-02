import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'a_widgets_index.dart';

enum PlayerListWidgetMode { listMode, profileMode }

class PlayerListWidget extends StatefulWidget {
  final PlayerDetails playerTile;
  final bool bIsCurrentPlayer;
  final PlayerListWidgetMode mode;
  final bool bIsPlayerProfileFromBottomNav;

  PlayerListWidget(this.playerTile, this.bIsCurrentPlayer, this.mode,
      {this.bIsPlayerProfileFromBottomNav = false});

  @override
  _PlayerListWidgetState createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  GlobalKey<State<StatefulWidget>> _drawerKey;

  Future<void> deleteButtonPress(PlayerDetails playerTile) async {
    print("Delete player Pressed!");
    try {
      Players newPlayer =
          new Players.createDBPlayerFromPlayerDetails(playerTile);
      await newPlayer.deleteRecord();
      Navigator.pop(context);
      YipliUtils.goToPlayersPage();
    } catch (error) {
      print(error);
      print('Error : Delete player');
    }
  }

  Future<void> makeDefaultPlayer(String currentPlayerId) async {
    print("Make Default player Pressed!");
    try {
      await Users.changeCurrentPlayer(currentPlayerId);
      //Utils.goToHomeScreen();
    } catch (error) {
      print(error);
      print('Error : Make Default player');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int points = 0;

    //below is done to convert the points in k format 1000(1k)
    try {
      points = int.parse(widget.playerTile.activityStats.strTotalFitnessPoints);
    } catch (e) {
      print('error from saurabh phone - ${e.toString()}');
    }

    var _fitnesspointsint = NumberFormat.compact().format(points);

    return GestureDetector(
      // focusColor: androidTVFocusColor,
      onTap: Envirnment.isAndroidTV == true
          ? () {}
          : () {
              //print("MODE: ${widget.mode}");
              if (widget.mode == PlayerListWidgetMode.listMode) {
                YipliUtils.goToPlayerProfile(widget.playerTile);
              } else {
                YipliUtils.goToViewImageScreen(widget.playerTile.profilePicUrl);
              }
            },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    alignment: Alignment.center,
                    image: YipliUtils.getProfilePicImage(
                        widget.playerTile.profilePicUrl),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: (widget.bIsCurrentPlayer)
                      ? Border.all(
                          width: 2, color: Theme.of(context).accentColor)
                      : null,
                  gradient: LinearGradient(
                    transform: GradientRotation(pi / 2),
                    // EEE,0; 818181,46; 383838,76;222,86; 101010,93;000, 100
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xFF101010).withOpacity(0.8),
//                      Color(0xFF383838).withOpacity(0.46),
//                      Color(0xFF101010).withOpacity(0.93),
                      Color(0xFF000000),
                    ],
                    stops: [0, 0.2, 0.6, 1],
                  )),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          widget.playerTile.playerName,
                          style: Theme.of(context).textTheme.headline6,
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            top: 4,
                            right: 4.0,
                          ),
                          child: YipliCoin(
                            coinPadding: 0.0,
                          ),
                        ),
                        Text(
                          _fitnesspointsint,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
                child: (widget.mode == PlayerListWidgetMode.listMode)
                    ? Positioned(
                        top: 0,
                        right: 0,
                        child: widget.bIsCurrentPlayer
                            ? buildActivePlayerIndicator()
                            : buildDrawerButton(widget.playerTile),
                      )
                    : (widget.mode == PlayerListWidgetMode.profileMode)
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: FlatButton.icon(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                focusColor: androidTVFocusColor,
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                                label: Text(""),
                                onPressed: () {
                                  YipliUtils.goToEditPlayersPage(
                                      PlayerProfileArguments(
                                          widget.playerTile,
                                          widget
                                              .bIsPlayerProfileFromBottomNav));
                                }),
                          )
                        : Container(
                            child: SizedBox(height: 0),
                          )),
          ],
        ),
      ),
    );
  }

  Widget buildActivePlayerIndicator() {
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: [
    //     Icon(
    //       Icons.trip_origin,
    //       color: yipliLogoOrange,
    //       //size: _screenSize.width / 30,
    //     ),
    //     SizedBox(
    //       width: 10,
    //     ),
    //     Text(
    //       "Active",
    //       style: Theme.of(context).textTheme.caption.copyWith(
    //             fontWeight: FontWeight.bold,
    //             color: yipliLogoOrange,
    //           ),
    //     ),
    //   ],
    // );
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Theme(
        data: ThemeData(
          canvasColor: yipliBlack.withOpacity(0.5),
        ),
        child: Chip(
          label: Text(
            "Active",
            style: Theme.of(context).textTheme.caption.copyWith(shadows: [
              Shadow(
                blurRadius: 25.0,
                color: yipliBlack,
                offset: Offset(3.0, 3.0),
              )
            ], fontWeight: FontWeight.bold),
          ),
          shape: StadiumBorder(side: BorderSide(width: 2, color: yipliNewBlue)),
          // backgroundColor: Theme.of(context).accentColor,
        ),
      ),
    );
  }

  Widget buildDrawerButton(PlayerDetails playerTile) {
    _drawerKey = new GlobalKey();
    return Material(
      color: Colors.transparent,
      child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          focusColor: androidTVFocusColor,
          //splashColor: Colors.transparent,
          onTap: () {
            print("Opening drawer!");
            dynamic state = _drawerKey.currentState;
            state.showButtonMenu();
          },
          child: buildPopupMenuButton(playerTile)),
    );
  }

  PopupMenuButton<int> buildPopupMenuButton(PlayerDetails playerTile) {
    return PopupMenuButton<int>(
      key: _drawerKey,
      //Todo @Ameet - Transition to be changed
      icon: FaIcon(
        FontAwesomeIcons.ellipsisV,
        size: 20.0,
        color: Theme.of(context).primaryColorLight,
      ),

      elevation: 24,
      color: Theme.of(context).primaryColor,
      offset: Offset.fromDirection(1.5708, 120.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      itemBuilder: (context) {
        List<PopupMenuItem<int>> listOfPopupMenuItems = [];
        if (!widget.bIsCurrentPlayer)
          listOfPopupMenuItems.addAll([
            PopupMenuItem(
              value: 1,
              child: PlayerPopUpMenu(
                tileText: 'Activate',
                onTap: () {
                  Navigator.pop(context);
                  YipliUtils.showNotification(
                      context: context,
                      msg: "${playerTile.playerName} is the new active player!",
                      type: SnackbarMessageTypes.SUCCESS);

                  makeDefaultPlayer(widget.playerTile.playerId);
                },
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: PlayerPopUpMenu(
                tileText: 'Remove',
                onTap: () {
                  var alertBox = AlertDialog(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 10),
                        child: Center(child: YipliLogoAnimatedSmall()),
                      ),
                    ),
                    content: Container(
                      child: Text(
                          "All records for ${widget.playerTile.playerName} will be lost"
                          "\n\nAre you sure you want to delete ${widget.playerTile.playerName}",
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.start),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        focusColor: androidTVFocusColor,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      FlatButton(
                        focusColor: androidTVFocusColor,
                        child: Text(
                          "Okay",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          deleteButtonPress(widget.playerTile);
                          Navigator.pop(context);
                          YipliUtils.showNotification(
                              context: context,
                              msg:
                                  "${playerTile.playerName} successfully removed!",
                              type: SnackbarMessageTypes.SUCCESS);
                        },
                      ),
                    ],
                  );

                  showDialog(
                    context: context,
                    //child: alertBox,
                    builder: (_) {
                      return alertBox;
                    },
                    barrierDismissible: true,
                  );
                },
              ),
            ),
          ]);
        return listOfPopupMenuItems;
      },
    );
  }
}
