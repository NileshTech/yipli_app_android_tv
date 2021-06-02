import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/classes/playerDetails.dart';
import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:flutter_app/helpers/constants.dart';
import 'package:flutter_app/helpers/utils.dart';
import 'package:flutter_app/internal_models/player_onboarding_state_model.dart';
import 'package:flutter_app/page_models/allplayers_model.dart';
import 'package:flutter_app/page_models/player_model.dart';
import 'package:flutter_app/page_models/user_model.dart';
import 'package:flutter_app/pages/games_page.dart';
import 'package:flutter_app/pages/yipli_page_frame.dart';
import 'package:flutter_app/widgets/player_list_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/classes/arguments/PageArgumentsClasses.dart';

class PlayerPage extends StatefulWidget {
  static const String routeName = "/player_list_screen";
  @override
  State<StatefulWidget> createState() => new _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  List<PlayerDetails> allPlayerDetails = new List<PlayerDetails>();

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   FeatureDiscovery.discoverFeatures(
    //     context,
    //     {YipliConstants.featureDiscoveryAddNewPlayerId},
    //   );
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Consumer3<AllPlayersModel, UserModel, PlayerOnBoardingStateModel>(
        builder: (context, allPlayersModel, userModel,
            playerOnBoardingStateModel, child) {
      return YipliPageFrame(
        title: Text('Players'),
        toShowBottomBar: true,
        widgetOnAppBar: addPlayerWidgetOnAppBar(),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(
                  0, screenSize.height / 60, 0, screenSize.height * 0.008),
              child: Consumer2<AllPlayersModel, UserModel>(
                  builder: (context, allPlayersModel, userModel, child) {
                if (YipliUtils.appConnectionStatus ==
                    AppConnectionStatus.DISCONNECTED) {
                  return YipliLoaderMini(
                    loadingMessage: "Loading players..",
                  );
                }
                if (YipliUtils.appConnectionStatus ==
                        AppConnectionStatus.CONNECTED &&
                    allPlayersModel.allPlayers.length == 0) {
                  return Center(
                    child: Container(
                      child: Text(
                          'No Players added. \nAdd atleast 1 player to start playing Yipli Games.',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center),
                    ),
                  );
                }
                if (YipliUtils.appConnectionStatus ==
                        AppConnectionStatus.DISCONNECTED &&
                    allPlayersModel.allPlayers.length == 0) {
                  print(
                      'all player model length: ${allPlayersModel.allPlayers.length}');
                  return YipliLoaderMini(
                    loadingMessage: "Loading players ... ",
                  );
                } else {
                  return LayoutBuilder(builder: (context, boxConstraints) {
                    return GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(
                          allPlayersModel.allPlayers.length + 1, (index) {
                        Widget widgetToAdd;
                        if (index < allPlayersModel.allPlayers.length) {
                          PlayerModel playerToRender =
                              allPlayersModel.allPlayers[index];
                          PlayerDetails playerTile =
                              new PlayerDetails.playerDetailsFromPlayerModel(
                                  playerToRender);
                          widgetToAdd = Padding(
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 10.0, 10.0, 10.0),
                            child: Hero(
                              tag: "profile_${playerTile.playerId}",
                              child: Material(
                                color: Theme.of(context).primaryColorDark,
                                child: PlayerListWidget(
                                    playerTile,
                                    playerTile.playerId ==
                                        userModel.currentPlayerId,
                                    PlayerListWidgetMode.listMode),
                              ),
                            ),
                          );
                        } else {
                          print("Sending EMPTY BOX");
                          widgetToAdd = SizedBox(
                            height:
                                ((MediaQuery.of(context).size.height - 112) /
                                    20),
                          );
                        }
                        return AnimationConfiguration.staggeredList(
                            delay: Duration(milliseconds: 50),
                            position: index,
                            duration: const Duration(milliseconds: 300),
                            child: FadeInAnimation(
                              //delay: Duration(milliseconds: 120),

                              child: SlideAnimation(
                                  verticalOffset: 30.0, child: widgetToAdd),
                            ));
                      }),
                    );
                  });
                }
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget addPlayerWidgetOnAppBar() {
    return Consumer3<AllPlayersModel, UserModel, PlayerOnBoardingStateModel>(
      builder: (context, allPlayersModel, userModel, playerOnBoardingStateModel,
          child) {
        playerOnBoardingStateModel.addListener(() {
          if (playerOnBoardingStateModel.playerAddedState !=
              PlayerAddedState.DEFAULT) {
            YipliUtils.showNotification(
                context: context,
                msg: playerOnBoardingStateModel.playerAddedState ==
                        PlayerAddedState.NEW_PLAYER_ADDED
                    ? "New Player Added."
                    : "First player added and made default.",
                type: SnackbarMessageTypes.SUCCESS);
            playerOnBoardingStateModel.playerAddedState =
                PlayerAddedState.DEFAULT;
          }
        });
        return FlatButton(
          focusColor: androidTVFocusColor,
          onPressed: () async {
            if (YipliUtils.appConnectionStatus ==
                AppConnectionStatus.CONNECTED) {
              print(
                  "Number of players currently : ${allPlayersModel.allPlayers.length}");
              PlayerPageArguments playerArgs = new PlayerPageArguments(
                allPlayerDetails: allPlayersModel.allPlayers,
                isOnboardingFlow: false,
              );
              YipliUtils.goToPlayerOnBoardingPage(playerArgs);
            } else {
              YipliUtils.showNotification(
                  context: context,
                  msg: "Internet Connectivity is required to add new player.",
                  type: SnackbarMessageTypes.ERROR,
                  duration: SnackbarDuration.MEDIUM);
            }
          },
          child: DescribedFeatureOverlay(
            featureId: YipliConstants.featureDiscoveryAddNewPlayerId,
            tapTarget: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Add Player'),
            description: Text('\nAdd a new player to begin playing!'),
            backgroundColor: Theme.of(context).accentColor,
            contentLocation: ContentLocation.below,
            child: Icon(
              Icons.add,
              color: Theme.of(context).accentColor,
            ),
          ),
        );
      },
    );
  }
}
