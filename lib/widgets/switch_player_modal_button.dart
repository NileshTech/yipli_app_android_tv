import 'package:flutter_app/pages/a_pages_index.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'a_widgets_index.dart';

class SwitchPlayerModalButton extends StatefulWidget {
  static const String routeName = "/switch_player";
  final String playerId;
  final Size screenSize;

  SwitchPlayerModalButton({
    Key key,
    this.screenSize,
    this.playerId,
  }) : super(key: key);

  @override
  _SwitchPlayerModalButtonState createState() =>
      _SwitchPlayerModalButtonState();

  static showAndSetSwitchPlayerModal(
      CurrentPlayerModel currentPlayerModel, BuildContext context) {
    _SwitchPlayerModalButtonState.showAndSetSwitchPlayerModal(
        currentPlayerModel, context);
  }
}

class _SwitchPlayerModalButtonState extends State<SwitchPlayerModalButton> {
  bool switchPlayerSuccessful = false;

  static _playerContainer(
      BuildContext context, PlayerModel playerData, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 0.0,
        child: InkWell(
            focusColor: androidTVFocusColor,
            onTap: () async {
              if (!isCurrent) {
                print(
                    "switch player button tapped - ${playerData.name} -- ${playerData.bIsCurrentPlayer} ");
                SwitchPlayerResult result = new SwitchPlayerResult();
                result.status = SwitchPlayerStatus.SUCCESS;
                try {
                  await Users.changeCurrentPlayer(playerData.id);
                } catch (e) {
                  result.status = SwitchPlayerStatus.FAILED;
                }
                print("switch player button DONE!! ");

                Navigator.of(context).pop(result);
              }
            },
            child: PlayerIconWithNameVertical(
              name: playerData?.name ?? "",
              playerProfileUrl: playerData?.profilePicUrl ?? "",
              showBorder: isCurrent,
            )),
      ),
    );
  }

  static Future<SwitchPlayerResult> _showSwitchPlayerModal(context) {
    var _screenSize = MediaQuery.of(context).size;
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        elevation: 24.0,
        builder: (BuildContext context) {
          ///container with all the player details
          return Container(
            height: (_screenSize.height / 4),
            width: (_screenSize.width),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),

            /// column of all the players
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Text("Switch Player",
                            style: Theme.of(context).textTheme.subtitle1))),
                Expanded(
                  flex: 3,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Consumer<CurrentPlayerModel>(
                            builder: (BuildContext currentContext,
                                CurrentPlayerModel currentPlayer,
                                Widget child) {
                              return (currentPlayer == null)
                                  ? Container()
                                  : _playerContainer(
                                      context, currentPlayer.player, true);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: VerticalDivider(
                          color: Theme.of(context).accentColor,
                          indent: 20,
                          endIndent: 20,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Consumer2<AllPlayersModel, CurrentPlayerModel>(
                            builder: (BuildContext ctx,
                                AllPlayersModel allPlayers,
                                CurrentPlayerModel currentPlayer,
                                Widget child) {
                          print(
                              "Player data found at consumer! ${allPlayers.allPlayers.length}");
                          return _buildPlayersListView(
                              context, allPlayers, currentPlayer);
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(flex: 1, child: Container()),
              ],
            ),
          );
        });
  }

  static Widget _buildPlayersListView(BuildContext context,
      AllPlayersModel allPlayers, CurrentPlayerModel currentPlayer) {
    var listOfPlayersWidgets = List<Widget>();
    for (int i = 0; i < allPlayers.allPlayers.length; i++) {
      if (allPlayers.allPlayers[i].id != currentPlayer.currentPlayerId)
        listOfPlayersWidgets
            .add(_playerContainer(context, allPlayers.allPlayers[i], false));
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              horizontalOffset: 100.0,
              delay: Duration(milliseconds: 100),
              duration: Duration(milliseconds: 375),
              child: listOfPlayersWidgets[index],
            ));
      },
      itemCount: listOfPlayersWidgets.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Outside player modal for playerid :${widget.playerId}");

    return Consumer2<UserModel, CurrentPlayerModel>(
        builder: (context, userModel, currentPlayerModel, child) {
      print(
          "Inside player modal for playerid :${currentPlayerModel.player.id}");
      return GestureDetector(
          onTap: () async {
            await showAndSetSwitchPlayerModal(currentPlayerModel, context);
          },
          child: Icon(
            EvaIcons.swapOutline,
            size: 22,
          ));
    });
  }

  static Future showAndSetSwitchPlayerModal(
      CurrentPlayerModel currentPlayerModel, BuildContext context) async {
    if (currentPlayerModel.player.id == null) {
      YipliUtils.showNotification(
          context: context,
          msg: "Please add player and check again.",
          type: SnackbarMessageTypes.ERROR,
          duration: SnackbarDuration.MEDIUM);
    } else {
      print('making the sw player container open');
      SwitchPlayerResult result = await _showSwitchPlayerModal(context);
      print('printing the switch player results - $result');
      if (result != null) {
        print("Closed Modal : ${result.status}");
        if (result.status == SwitchPlayerStatus.SUCCESS) {
          YipliUtils.showNotification(
              context: context,
              msg:
                  "${currentPlayerModel.player.name} is the new active player!",
              type: SnackbarMessageTypes.SUCCESS,
              duration: SnackbarDuration.SHORT);
          //show tip on switch player for half day
          await Future.delayed(
              YipliUtils.getNotificationDuration(SnackbarDuration.SHORT)
                  .seconds);
          YipliUtils.showDailyTipForCurrentPlayer(
              context, currentPlayerModel.player.id);
        } else if (result.status == SwitchPlayerStatus.ALREADY_SAME) {
          YipliUtils.showNotification(
              context: context,
              msg: "You switched to the same player!",
              type: SnackbarMessageTypes.INFO,
              duration: SnackbarDuration.SHORT);
        } else {
          YipliUtils.showNotification(
              context: context,
              msg: "There was an error while switching the player!",
              type: SnackbarMessageTypes.WARN,
              duration: SnackbarDuration.SHORT);
        }
      }
    }
  }
}

enum SwitchPlayerStatus { SUCCESS, FAILED, ALREADY_SAME }

class SwitchPlayerResult {
  SwitchPlayerStatus status;
}

void showLoadingIndicator(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => YipliUtils.showTipOfTheDay());
}
