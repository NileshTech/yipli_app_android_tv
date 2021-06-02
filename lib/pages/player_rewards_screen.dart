import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animator/flutter_animator.dart' as flutterAnimations;
import 'package:flutter_app/classes/playerActivityStats.dart';
import 'package:flutter_app/classes/playerDetails.dart';
import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:flutter_app/helpers/utils.dart';
import 'package:flutter_app/page_models/current_player_model.dart';
import 'package:flutter_app/page_models/player_model.dart';
import 'package:flutter_app/pages/yipli_page_frame.dart';
import 'package:flutter_app/widget_models/game_model.dart';
import 'package:flutter_app/widgets/cards/games_icon.dart';
import 'package:flutter_app/widgets/player_list_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class PlayerRewards extends StatefulWidget {
  static const String routeName = "/player_rewards_screen";

  @override
  _PlayerRewardsState createState() => _PlayerRewardsState();
}

class _PlayerRewardsState extends State<PlayerRewards>
    with SingleTickerProviderStateMixin {
  String playerId;
  PlayerModel _playerProfileElements;
  String playerName;
  PlayerModel playerModel;
  Size screenSize;

  //widget for profile pic build
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    _playerProfileElements = ModalRoute.of(context).settings.arguments;

    if (_playerProfileElements == null) {
      print('calling rewards page with bottom navigation');
      return YipliPageFrame(
          selectedIndex: 1,
          toShowBottomBar: true,
          showDrawer: true,
          isBottomBarInactive: false,
          title: Text('Rewards'),
          child: Consumer<CurrentPlayerModel>(
            builder: (BuildContext currentContext,
                CurrentPlayerModel currentPlayer, Widget child) {
              playerModel = currentPlayer.player;

              return buildRewardsPageTile(context, playerModel);
            },
          ));
    } else {
      print('calling rewards page with from player profile');
      playerModel = _playerProfileElements;
      return YipliPageFrame(
        selectedIndex: 1,
        toShowBottomBar: false,
        showDrawer: false,
        isBottomBarInactive: false,
        title: Text('Rewards'),
        child: buildRewardsPageTile(context, _playerProfileElements),
      );
    }
  }

  Widget buildRewardsPageTile(BuildContext context, PlayerModel playerModel) {
    PlayerDetails playerTile =
        PlayerDetails.playerDetailsFromPlayerModel(playerModel);

    //below is done to convert the points in k format 1000(1k)
    var _fitnessPointsInt = NumberFormat.compact()
        .format(playerModel.activityStats.iTotalFitnessPoints);
    var _fitnessPointsString = _fitnessPointsInt.toString();

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            ///player image
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Hero(
                    tag: "profile_${playerTile.playerId}",
                    child: Material(
                      color: Theme.of(context).primaryColorDark,
                      child: PlayerListWidget(
                          playerTile, false, PlayerListWidgetMode.profileMode),
                    ),
                  ),
                )),

            ///points dosplay
            Expanded(
                flex: 2,
                child: flutterAnimations.ZoomIn(
                  child: YipliRewardPointsDisplay(
                      fontSize: Theme.of(context).textTheme.headline4.fontSize,
                      scoreString: playerModel
                              ?.activityStats?.iTotalFitnessPoints
                              ?.toString() ??
                          '0'),
                )),

            ///list display
            (playerModel?.activityStats?.gameStatistics?.length ?? 0) > 0
                ? Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Divider(
                              color: Theme.of(context).primaryColorLight,
                              height: 3,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              "Here's what you played",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Divider(
                              color: Theme.of(context).primaryColorLight,
                              height: 3,
                            ),
                          ),
                        )
                      ],
                    ))
                : Expanded(
                    flex: 1,
                    child: Container(),
                  ),
            Expanded(
              flex: 8,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16, bottom: 16),
                child:
                    (playerModel?.activityStats?.gameStatistics?.length ?? 0) >
                            0
                        ? buildListView(playerModel)
                        : PlayerNoPlayDataPlaceholder(),
              ),
            ),
          ],
        ),
        Positioned(
            bottom: 15,
            right: 15,
            child: FloatingActionButton(
                focusColor: androidTVFocusColor,
                elevation: 10,
                onPressed: playerModel.activityStats.iTotalFitnessPoints > 0
                    ? () {
                        final RenderBox box = context.findRenderObject();
                        Share.share(
                            "Guess what!! I just won $_fitnessPointsString Yipli Reward points. Why don't you join me and beat my score!\n\nhttps://playyipli.com",
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      }
                    : () {
                        YipliUtils.showNotification(
                            context: context,
                            msg:
                                "Start Yipling & come back to share your achievements.",
                            type: SnackbarMessageTypes.ERROR,
                            duration: SnackbarDuration.MEDIUM);
                      },
                child: Icon(
                  Icons.share,
                  color: Theme.of(context).primaryColor,
                ),
                backgroundColor: Theme.of(context).accentColor))
      ],
    );
  }

  ListView buildListView(PlayerModel playerModel) {
    return ListView.builder(
        itemCount:
            (playerModel?.activityStats?.gameStatistics?.length ?? 0) + 1,
        itemBuilder: (context, currentGameStatsIndex) {
          if (currentGameStatsIndex ==
              (playerModel?.activityStats?.gameStatistics?.length ?? 0)) {
            return SizedBox(
              height: ((MediaQuery.of(context).size.height - 112) / 10),
            );
          }
          return AnimationConfiguration.staggeredList(
              position: currentGameStatsIndex,
              duration: const Duration(milliseconds: 250),
              delay: Duration(milliseconds: 75),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Column(
                    children: <Widget>[
                      GameStatsCard(
                        gamesStats: playerModel.activityStats
                            .gameStatistics[currentGameStatsIndex],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}

class PlayerNoPlayDataPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text("You haven't played any games!",
              style: Theme.of(context).textTheme.subtitle1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            child: Icon(
              FontAwesomeIcons.frownOpen,
              size: 48,
            ),
          ),
          Text("Play some games and check again!",
              style: Theme.of(context).textTheme.subtitle1),
        ],
      ),
    );
  }
}

class YipliRewardPointsDisplay extends StatelessWidget {
  final String scoreString;

  final double fontSize;

  final double coinPadding;

  const YipliRewardPointsDisplay({
    Key key,
    this.scoreString,
    this.fontSize,
    this.coinPadding = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //below is done to convert the points in k format 1000(1k)
    int points = int.parse(scoreString);
    var _fitnesspointsint = NumberFormat.compact().format(points);
    var _fitnessPointsString = _fitnesspointsint.toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Align(
                alignment: Alignment.centerRight,
                child: YipliCoin(coinPadding: coinPadding))),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(_fitnessPointsString,
                style: Theme.of(context).textTheme.headline6.copyWith(
                      fontSize: fontSize,
                    )),
          ),
        ),
      ],
    );
  }
}

class YipliCoin extends StatelessWidget {
  const YipliCoin({
    Key key,
    this.coinPadding = 0.0,
  }) : super(key: key);

  final double coinPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: coinPadding, top: coinPadding, left: 5, right: 5),
      child: Image.asset(
        "assets/images/yipli_coin.png",
        fit: BoxFit.contain,
      ),
    );
  }
}

class GameStatsCard extends StatefulWidget {
  final GameStats gamesStats;

  const GameStatsCard({Key key, this.gamesStats}) : super(key: key);

  @override
  _GameStatsCardState createState() => _GameStatsCardState();
}

class _GameStatsCardState extends State<GameStatsCard> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GameModel>(
      create: (context) {
        GameModel gameModel = new GameModel();
        gameModel.initialize(widget.gamesStats.gameId);
        return gameModel;
      },
      child: Consumer<GameModel>(
        builder: (context, gameModel, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Container(
              height: (MediaQuery.of(context).size.height - 112) / 6,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: gameModel.iconImgUrl != null
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child:
                                    GameIcon(imageLink: gameModel.iconImgUrl))
                            : Container(),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: Text(
                                gameModel?.name ?? "",
                                //overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: Center(
                                  child: YipliRewardPointsDisplay(
                                    fontSize: 16,
                                    coinPadding: 16.0,
                                    scoreString:
                                        widget.gamesStats.fitnessPoints,
                                  ),
                                )),
                                Expanded(
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Icon(
                                            FontAwesomeIcons.stopwatch,
                                            color: IconTheme.of(context).color,
                                            size: 16,
                                          ),
                                        ),
                                        Text(
                                          "${(int.parse(widget.gamesStats.duration) / 60).round().toString()} min.",
                                          softWrap: true,
                                          //overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle1
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
