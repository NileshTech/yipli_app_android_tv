import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_animator/flutter_animator.dart' as flutterAnimations;
import 'package:flutter_app/database_models/adventure-gaming/adventure_gaming_data.dart';
import 'package:flutter_app/database_models/adventure-gaming/database-interface.dart';
import 'package:flutter_app/page_models/reward_model.dart';
import 'package:flutter_app/pages/player_rewards_page.dart';
import 'package:flutter_app/widgets/adventure_gaming_playerprofile_widget.dart';
import 'package:flutter_app/widgets/analytics/player_analytics_view.dart';
import 'package:flutter_app/widgets/timeline/adventureGameCardContent.dart';
import 'package:intl/intl.dart';

import 'a_pages_index.dart';

// Used for controlling whether the user is viewing or edthe profile
enum FormType { view, edit }

class PlayerProfilePage extends StatefulWidget {
  static const String routeName = "/player_profile_page";
  final bool toShowDrawer;
  final bool toShowBottomBar;
  final bool toShowSwitchPlayerButton;

  const PlayerProfilePage({
    Key key,
    this.toShowDrawer = false,
    this.toShowBottomBar = false,
    this.toShowSwitchPlayerButton = false,
  }) : super(key: key);

  @override
  _PlayerProfileState createState() => _PlayerProfileState();
}

class _PlayerProfileState extends State<PlayerProfilePage>
    with SingleTickerProviderStateMixin {
  PlayerDetails _playerProfileElements;

  double opacity = 0.0;
  int lastPlayedTimestampForPlayer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // PlayerModel playerModel = currentPlayer.player;
    _playerProfileElements = ModalRoute.of(context).settings.arguments;

    //If _playerProfileElements is null, that means, current players profile page is called
    if (_playerProfileElements == null ||
        _playerProfileElements.activityStats == null) {
      print('calling profile page with bottom navigation');

      return Consumer<CurrentPlayerModel>(builder: (BuildContext currentContext,
          CurrentPlayerModel currentPlayer, Widget child) {
        PlayerModel playerModel = currentPlayer.player;

        return YipliPageFrame(
          selectedIndex: 2,
          toShowBottomBar: true,
          showDrawer: true,
          isBottomBarInactive: false,
          widgetOnAppBar: notificationIcon(context, currentPlayer.player.id),
          title: Text('Player Profile'),
          child: buildProfilePageTile(context, playerModel, screenSize,
              currentPlayer, lastPlayedTimestampForPlayer,
              bIsPlayerProfileFromBottomNav: true),
        );
      });
    } else {
      //If _playerProfileElements is not null, that means,
      //players profile page is called from player list screen
      lastPlayedTimestampForPlayer =
          _playerProfileElements.activityStats.iLastPlayedTimestamp;
      print('calling profile page from player profile - from drawer');

      /// calling profile page from player profile
      return ChangeNotifierProvider<PlayerModel>(create: (context) {
        print(
            "Game session Returned player model _playerProfileElements --> ${_playerProfileElements.playerId}");
        PlayerModel playerModel =
            PlayerModel(playerid: _playerProfileElements.playerId);
        playerModel.initialize();
        return playerModel;
      }, child: Consumer2<PlayerModel, CurrentPlayerModel>(
          builder: (context, playerModel, currentPlayerModel, child) {
        print(
            "Game session Returned player model player model --> ${playerModel.id}");

        var changeNotifierProxyProvider = buildProfilePageTile(
            context,
            playerModel,
            screenSize,
            currentPlayerModel,
            lastPlayedTimestampForPlayer);
        return YipliPageFrame(
            selectedIndex: 2,
            toShowBottomBar: false,
            showDrawer: false,
            widgetOnAppBar:
                notificationIcon(context, _playerProfileElements.playerId),
            title: Text('Player Profile'),
            child: changeNotifierProxyProvider);
      }));
    }
  }

  // PlayerInbox Icon
  Widget notificationIcon(BuildContext context, String playerId) {
    return ChangeNotifierProvider<RewardsModel>(
      create: (rewardsModelCtx) {
        RewardsModel rewardsModel = RewardsModel.initialize(playerId);
        return rewardsModel;
      },
      child: Consumer<RewardsModel>(builder: (context, rewardsModel, child) {
        if (YipliUtils.appConnectionStatus ==
            AppConnectionStatus.DISCONNECTED) {
          return YipliLoaderMini(
            loadingMessage: "Loading Rewards ... ",
          );
        }
        if (YipliUtils.appConnectionStatus ==
                AppConnectionStatus.DISCONNECTED &&
            rewardsModel.allRewards.length == 0) {
          print('Reward length: ${rewardsModel.allRewards.length}');
          return YipliLoaderMini(
            loadingMessage: "Loading Rewards ... ",
          );
        }

        if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED &&
            rewardsModel.allRewards.length == 0) {
          final Size _screenSize = MediaQuery.of(context).size;
          return Container(
            width: 100,
            alignment: Alignment.topRight,
            child: InkWell(
              focusColor: androidTVFocusColor,
              onTap: Platform.isAndroid
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RewardsPage(playerId),
                        ),
                      );
                    }
                  : () {},
              child: FlareActor(
                "assets/flare/notification_new.flr",
                fit: BoxFit.cover,
                animation: "Untitled",
              ),
            ),
          );
        } else {
          return Container(
            width: 100,
            alignment: Alignment.topRight,
            child: InkWell(
              focusColor: androidTVFocusColor,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RewardsPage(playerId),
                  ),
                );
              },
              child: FlareActor(
                "assets/flare/notification_new.flr",
                fit: BoxFit.cover,
                animation: "inbox",
              ),
            ),
          );
        }
      }),
    );
  }

  buildProfilePageTile(
      BuildContext context,
      PlayerModel playerModel,
      Size screenSize,
      CurrentPlayerModel currentPlayerModel,
      int lastPlayedTimestampForPlayer,
      {bool bIsPlayerProfileFromBottomNav = false}) {
    print(
        'player last player session ${playerModel.activityStats.iLastPlayedTimestamp}');
    //below is done to convert the points in k format 1000(1k)
    var _fitnessPointsInt = NumberFormat.compact()
        .format(playerModel?.activityStats?.iTotalFitnessPoints ?? 0);
    var _fitnessPointsString = _fitnessPointsInt.toString();
    PlayerDetails playerTile =
        new PlayerDetails.playerDetailsFromPlayerModel(playerModel);
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ///player image
            SizedBox(
              height: YipliUtils.getImageHeight(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "profile_${playerTile.playerId}",
                  child: Material(
                    color: Theme.of(context).primaryColorDark,
                    child: PlayerListWidget(
                      playerTile,
                      false,
                      PlayerListWidgetMode.profileMode,
                      bIsPlayerProfileFromBottomNav:
                          bIsPlayerProfileFromBottomNav,
                    ),
                  ),
                ),
              ),
            ),
            _buildPlayerProfileDetails(
                context,
                screenSize,
                playerModel,
                currentPlayerModel,
                _playerProfileElements == null
                    ? currentPlayerModel.currentPlayerId
                    : _playerProfileElements.playerId,
                lastPlayedTimestampForPlayer)
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerProfileDetails(
      BuildContext context,
      Size screenSize,
      PlayerModel playerModel,
      CurrentPlayerModel currentPlayerModel,
      String playerIdFromArguments,
      int lastPlayedTimestampForPlayer) {
    PlayerProgressDatabaseHandler playerProgressDatabaseHandler =
        PlayerProgressDatabaseHandler(playerModel: currentPlayerModel.player);
    return (playerModel?.activityStats?.iTotalFitnessPoints ?? 0) != 0 ||
            (playerModel?.activityStats?.iLastPlayedTimestamp ?? 0) != 0
        ? Column(
            children: <Widget>[
              /// heading for analytics - fitness report
              PlayerProfileDivider(
                dividerColor: Theme.of(context).accentColor,
                dividerIconColor: Theme.of(context).accentColor,
                dividerIcon: EvaIcons.barChart2, //FontAwesomeIcons.signal,
                dividerText: "Fitness Report", //Text("Fitness Report"),
                dividerTextColor: Theme.of(context).accentColor,
                sizedBoxHeight: 50,
              ),

              ///container with bar and pie chart
              Container(
                //  height: screenSize.height * 400 / 683,
                child: SizedBox(
                  width: screenSize.width,
                  height: screenSize.height * 460 / 683,
                  child: PlayerAnalyticsView(
                      playerIdFromArguments, lastPlayedTimestampForPlayer),
                  //child: ComingSoonBanner()
                ),
              ),

              /// heading for analytics - achievements
              PlayerProfileDivider(
                dividerColor: Theme.of(context).accentColor,
                dividerIconColor: Theme.of(context).accentColor,
                dividerIcon: EvaIcons.gift,
                dividerText: "Achievements",
                dividerTextColor: Theme.of(context).accentColor,
                sizedBoxHeight: 50,
              ),

              ///displaying yipli points
              SizedBox(
                height: screenSize.height * 70 / 683,
                child: Center(
                  child: flutterAnimations.ZoomIn(
                    child: YipliRewardPointsDisplay(
                        fontSize:
                            Theme.of(context).textTheme.headline5.fontSize,
                        scoreString: playerModel
                                ?.activityStats?.iTotalFitnessPoints
                                ?.toString() ??
                            '0'),
                  ),
                ),
              ),

              ///game list display
              (playerModel?.activityStats?.gameStatistics?.length ?? 0) > 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Here's what you played",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, bottom: 5),
                  child: (playerModel?.activityStats?.gameStatistics?.length ??
                              0) >
                          0
                      ? buildListView(screenSize, playerModel)
                      : PlayerNoPlayDataPlaceholder(),
                ),
              ),

              /*   /// adventure gaming divider
              PlayerProfileDivider(
                dividerColor: Theme.of(context).accentColor,
                dividerIconColor: Theme.of(context).accentColor,
                dividerIcon: FontAwesomeIcons.hiking,
                dividerText: "Adventure gaming",
                dividerTextColor: Theme.of(context).accentColor,
                sizedBoxHeight: 50,
              ),
              // SizedBox(width: 200, height: 400, child: ComingSoonBanner()),

              StreamBuilder<AdventureGamingData>(
                  stream: playerProgressDatabaseHandler
                      .getWorldAndPlayerProgressDataStream(),
                  builder: (context, snapshot) {
                    AdventureGamingData adventureGamingData = snapshot.data;
                    if (snapshot.hasData == null) {
                      return YipliLoaderMini(
                        loadingMessage: 'Loading adventure gaming stats..',
                      );
                    }

                    return AdventurePlayerProfileWidget(
                      playerClassesComplete:
                          (adventureGamingData?.playerProgress?.currentIndex ??
                                  0) +
                              1,
                      playerTotalCollectedCoins:
                          adventureGamingData?.playerProgress?.totalFp ?? 0,
                      playerTotalCollectedXp:
                          adventureGamingData?.playerProgress?.totalFp ?? 0,
                      averagePlayerRating:
                          (adventureGamingData?.playerProgress?.averageRating ??
                                  0)
                              .toDouble(),
                    );
                    
                  }),
              //  advGamingBadgeBuilder(context, screenSize, playerModel, currentPlayerModel),*/
              SizedBox(
                height: screenSize.height * 0.1,
              ),
            ],
          )
        : PlayerNoPlayDataPlaceholder();
  }

  Widget advGamingBadgeBuilder(BuildContext context, Size screenSize,
      PlayerModel playerModel, CurrentPlayerModel currentPlayerModel) {
    PlayerProgressDatabaseHandler playerProgressDatabaseHandler =
        PlayerProgressDatabaseHandler(playerModel: currentPlayerModel.player);
    return StreamBuilder<AdventureGamingData>(
        stream:
            playerProgressDatabaseHandler.getWorldAndPlayerProgressDataStream(),
        builder: (context, snapshot) {
          AdventureGamingData adventureGamingData = snapshot.data;
          if (snapshot.hasData == null) {
            return YipliLoaderMini(
              loadingMessage: 'Loading adventure gaming stats..',
            );
          }
          return Container(
            height: 200,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Theme.of(context).primaryColor,
              child: GridView.count(
                // crossAxisCount is the number of columns
                crossAxisCount: 3,
                // This creates two columns with two items in each column
                children: List.generate(3, (index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FitnessCards(),
                    ),
                  );
                }),
              ),
            ),
          );
        });
  }
}

/// share button widget on app bar
Widget shareButton(
  BuildContext context,
  PlayerModel playerModel,
  Size screenSize,
) {
  var _fitnessPointsInt = NumberFormat.compact()
      .format(playerModel?.activityStats?.iTotalFitnessPoints ?? 0);

  var _fitnessPointsString = _fitnessPointsInt.toString();
  return FlatButton(
    focusColor: androidTVFocusColor,
    onPressed: (playerModel?.activityStats?.iTotalFitnessPoints ?? 0) > 0
        ? () {
            final RenderBox box = context.findRenderObject();
            if (_fitnessPointsString == null) {
              Share.share(
                  "Guess what!! I just won 0 Yipli Reward points. Why don't you join me and beat my score!\n\nhttps://playyipli.com",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            } else {
              Share.share(
                  "Guess what!! I just won $_fitnessPointsString Yipli Reward points. Why don't you join me and beat my score!\n\nhttps://playyipli.com",
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            }
          }
        : () {
            YipliUtils.showNotification(
                context: context,
                msg: "Start Yipling & come back to share your achievements.",
                type: SnackbarMessageTypes.ERROR,
                duration: SnackbarDuration.MEDIUM);
          },
    child: Icon(
      EvaIcons.paperPlaneOutline,
      //Icons.share,
      color: Theme.of(context).accentColor,
    ),
  );
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
                      color: yipliLogoOrange,
                    )),
          ),
        ),
      ],
    );
  }
}

Widget buildListView(Size screenSize, PlayerModel playerModel) {
  return Column(
    children: List.generate(
        (playerModel?.activityStats?.gameStatistics?.length ?? 0) + 1,
        (currentGameStatsIndex) {
      if (currentGameStatsIndex ==
          (playerModel?.activityStats?.gameStatistics?.length ?? 0)) {
        return SizedBox(
          height: (screenSize.height - 112) /
              10, //((MediaQuery.of(context).size.height - 112) / 10),
        );
      }
      return GameStatsCard(
        gamesStats:
            playerModel.activityStats.gameStatistics[currentGameStatsIndex],
      );
    }),
  );
}

class GamePlayedInfoCard extends StatefulWidget {
  final GameStats gamesStats;

  const GamePlayedInfoCard({Key key, this.gamesStats}) : super(key: key);

  @override
  _GamePlayedInfoCardState createState() => _GamePlayedInfoCardState();
}

class _GamePlayedInfoCardState extends State<GamePlayedInfoCard> {
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
                                    coinPadding: 10.0,
                                    scoreString:
                                        widget?.gamesStats?.fitnessPoints ?? 0,
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
                                          "${(int.parse(widget?.gamesStats?.duration ?? '0') / 60).round().toString()} min.",
                                          //"${getDisplayTime(widget.gamesStats.duration)}",
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

  String getDisplayTime(String inputTime) {
    int decimals = 2;
    int fac = pow(10, decimals);
    int iTime = int.parse(inputTime);

    if (iTime == null) {
      return '0 min.';
    }
    if (iTime < 60) {
      return '$iTime sec.';
    } else if (iTime >= 60 && iTime < 3600) {
      double d = (iTime / 60 * fac).round() / fac;
      return '$d min.';
    } else if (iTime >= 3600) {
      double d = (iTime / 3600 * fac).round() / fac;
      return '$d hr.';
    }
  }
}
