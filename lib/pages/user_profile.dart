import 'package:flutter_app/database_models/adventure-gaming/adventure_gaming_data.dart';
import 'package:flutter_app/database_models/adventure-gaming/database-interface.dart';
import 'package:flutter_app/widgets/a_widgets_index.dart';

import 'a_pages_index.dart';

// Used for controlling whether the user is viewing or editing the profile
enum FormType { view, edit }
enum PerformanceDuration { week, month }

class UserProfile extends StatefulWidget {
  static const String routeName = "/user_profile";

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final YipliButton gotoPlayersButton = YipliButton("Go to Players");

  final double coinPadding = 0.0;
  @override
  void initState() {
    gotoPlayersButton.setClickHandler(onGotoPlayersPress);
    super.initState();
  }

  void onGotoPlayersPress() {
    YipliUtils.goToPlayersPage();
  }

  ///most consistent - player who came and played for all 3-4 weeks
  @override
  Widget build(BuildContext context) {
    String userId = AuthService.getCurrentUserId();
    DateTime dateOfLastMonth = Jiffy(DateTime.now()).subtract(months: 1);

    /// this is for most consistent player
    Query mostConsistentPlayerDBRef = FirebaseDatabaseUtil()
        .rootRef
        .child("user-stats")
        .child(userId)
        .child("m")
        .child(dateOfLastMonth.year.toString())
        .child((dateOfLastMonth.month - 1).toString())
        .orderByChild("tdp")
        .limitToLast(1);

    /// this is for Last month player
    Query playerOfTheLastMonthDBRef = FirebaseDatabaseUtil()
        .rootRef
        .child("user-stats")
        .child(userId)
        .child("m")
        .child(dateOfLastMonth.year.toString())
        .child((dateOfLastMonth.month - 1).toString())
        .orderByChild("fp")
        .limitToLast(1);

    DateTime dateOfLastWeek = Jiffy(DateTime.now()).subtract(weeks: 1);
    int dateOfLastWeekNo = Jiffy(dateOfLastWeek).week;

    /// this is for Last week player
    Query playerOfTheLastWeekDBRef = FirebaseDatabaseUtil()
        .rootRef
        .child("user-stats")
        .child(userId)
        .child("w")
        .child(dateOfLastWeek.year.toString())
        .child(dateOfLastWeekNo.toString())
        .orderByChild("fp")
        .limitToLast(1);

    return YipliPageFrame(
      toShowBottomBar: true,
      selectedIndex: 0,
      title: Text(
        'Family Profile',
      ),
      child: Consumer2<UserModel, AllPlayersModel>(
          builder: (context, userModel, allPlayerModel, child) {
        Size screenSize = MediaQuery.of(context).size;
        print("Total players are : ${allPlayerModel.allPlayers.length} ");
        if (userModel.currentPlayerId == null ||
            allPlayerModel.allPlayers.length == null) {
          return YipliLoaderMini(
            loadingMessage: "Loading Family Profile ... ",
          );
        } else {
          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 8, right: 8),
              child: Container(
                height: MediaQuery.of(context).size.height * 1.6,
                child: Consumer2<AllPlayersModel, CurrentPlayerModel>(builder:
                    (context, allPlayerModel, currentPlayerModel, child) {
                  PlayerProgressDatabaseHandler playerProgressDatabaseHandler =
                      PlayerProgressDatabaseHandler(
                          playerModel: currentPlayerModel.player);
                  if (allPlayerModel == null)
                    return YipliLoaderMini(
                      loadingMessage: 'Loading..',
                    );

                  dynamic listOfAllPlayers = List();

                  allPlayerModel.allPlayers.forEach((element) {
                    listOfAllPlayers.add({
                      "fp": (element?.activityStats?.iTotalFitnessPoints ?? 0),
                      "player": element
                    });
                  });
                  listOfAllPlayers.sort((a, b) {
                    // print("printing a and b : ${a["fp"]} & ${b["fp"]}");
                    int bFp = b["fp"];
                    int aFp = a["fp"];
                    return bFp - aFp;
                  });
                  print('${listOfAllPlayers.length}');

                  return Column(
                    children: <Widget>[
                      ///expanded for image and other details
                      SizedBox(
                        height: YipliUtils.getImageHeight(context),
                        child: GestureDetector(
                          onTap: () {
                            YipliUtils.goToViewImageScreen(
                              userModel.profilePicUrl,
                            );
                          },

                          ///Stack for the user image
                          child: Stack(
                            children: <Widget>[
                              ///user profile
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          alignment: Alignment.topCenter,
                                          image: YipliUtils.getProfilePicImage(
                                              userModel.profilePicUrl),
                                          fit: BoxFit.cover))),

                              ///gradient provided
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      transform: GradientRotation(pi / 2),
                                      // EEE,0; 818181,46; 383838,76;222,86; 101010,93;000, 100
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Color(0xFF101010).withOpacity(0.7),
                                        Color(0xFF000000),
                                      ],
                                      stops: [0, 0.2, 0.8, 1],
                                    )),
                              ),

                              ///number of mats and player
                              Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 40.0,
                                    ),
                                    child: PlayAnimation<double>(
                                        curve: Curves.decelerate,
                                        duration: 1500.milliseconds,
                                        tween: (0.0).tweenTo(1.0),
                                        builder: (context, child, value) {
                                          return Transform.scale(
                                            scale: value,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Consumer<AllPlayersModel>(
                                                  builder: (context,
                                                      allplayermodel, build) {
                                                    return ProfileInfoTile(
                                                        "${allplayermodel.allPlayers.length}",
                                                        FontAwesomeIcons
                                                            .running,
                                                        'Player');
                                                  },
                                                ),
                                                Container(
                                                    height: 40,
                                                    child: VerticalDivider(
                                                      width: 10.0,
                                                      thickness: 2.0,
                                                      color: Theme.of(context)
                                                          .primaryColorLight,
                                                    )),
                                                Consumer<MatsModel>(
                                                  builder: (context,
                                                      allMatModel, build) {
                                                    //   print("No of mats : ${allMatModel.allMats.length}");
                                                    return ProfileInfoTile(
                                                      '${allMatModel.allMats.length}',
                                                      FontAwesomeIcons
                                                          .clipboard,
                                                      'Mats',
                                                      iconRotateAngle: -pi / 2,
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  )),

                              ///display name of the family
                              Positioned(
                                  left: 0,
                                  bottom: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      userModel?.displayName ?? '',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  )),

                              ///edit button
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                    focusColor: androidTVFocusColor,
                                    icon: Icon(
                                      Icons.edit,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                    onPressed: () {
                                      YipliUtils.goToEditUserScreen(userModel);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ///expanded for family leader board
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Card(
                            color: Theme.of(context)
                                .primaryColorLight
                                .withOpacity(.1),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            margin: EdgeInsets.all(2.0),
                            child: Column(
                              children: <Widget>[
                                // ///Family Leaderboard text
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 8.0, left: 8.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: <Widget>[
                                //       Padding(
                                //         padding: const EdgeInsets.only(right:8.0),
                                //         child: Icon(
                                //           FontAwesomeIcons.trophy,
                                //           color: Theme.of(context).accentColor,
                                //           size: 22.0,
                                //         ),
                                //       ),
                                //       Text(
                                //         'Leaderboard',
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .headline6
                                //             .copyWith(
                                //             color: Theme.of(context)
                                //                 .accentColor),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                ///top player
                                ///2nd and 3rd player
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        ///2nd rank player on leader board
                                        (listOfAllPlayers.length >= 2)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: FamilyLeaderBoardWidget(
                                                  bShowIcon: false,
                                                  intPlayerRank: 2,
                                                  dPlayerRankWidth:
                                                      screenSize.width / 22,
                                                  dPlayerRankHeight:
                                                      screenSize.width / 22,
                                                  playerRankBackgroundColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  playerRankBorderColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  playerRankTextColor:
                                                      Theme.of(context)
                                                          .primaryColorLight,
                                                  playerImageBorderColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  intPlayerImageFlex: 1,
                                                  dProfilePicWidth: YipliConstants
                                                          .getProfilePicDimensionsSmall(
                                                              context)
                                                      .width,
                                                  dProfilePicHeight: YipliConstants
                                                          .getProfilePicDimensionsSmall(
                                                              context)
                                                      .height,
                                                  stPlayerImage:
                                                      listOfAllPlayers[1]
                                                                  ['player']
                                                              ?.profilePicUrl ??
                                                          null,
                                                  stPlayerName:
                                                      listOfAllPlayers[1]
                                                                  ['player']
                                                              ?.name ??
                                                          '',
                                                  dPlayerPoints:
                                                      listOfAllPlayers[1]
                                                              ['fp'] ??
                                                          0,
                                                ),
                                              )
                                            : Container(),

                                        ///1st rank player on leader board
                                        (listOfAllPlayers.length >= 1)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: FamilyLeaderBoardWidget(
                                                  bShowIcon: true,
                                                  intIconFlex: 1,
                                                  iPlayerCrownColor:
                                                      Color(0xFFFFC610),
                                                  intPlayerRank: 1,
                                                  playerRankBackgroundColor:
                                                      yipliLogoOrange,
                                                  playerRankBorderColor: Theme
                                                          .of(context)
                                                      .primaryColor, // yipliLogoOrange,
                                                  playerRankTextColor:
                                                      Theme.of(context)
                                                          .primaryColorLight,
                                                  playerImageBorderColor:
                                                      yipliLogoOrange,
                                                  dPlayerRankWidth:
                                                      screenSize.width / 16,
                                                  dPlayerRankHeight:
                                                      screenSize.width / 16,
                                                  iPlayerCrown:
                                                      FontAwesomeIcons.crown,
                                                  intPlayerImageFlex: 4,
                                                  dProfilePicWidth: YipliConstants
                                                          .getProfilePicDimensionsLarge(
                                                              context)
                                                      .width,
                                                  dProfilePicHeight: YipliConstants
                                                          .getProfilePicDimensionsLarge(
                                                              context)
                                                      .height,
                                                  stPlayerImage:
                                                      listOfAllPlayers[0]
                                                                  ['player']
                                                              ?.profilePicUrl ??
                                                          null,
                                                  stPlayerName:
                                                      listOfAllPlayers[0]
                                                                  ['player']
                                                              ?.name ??
                                                          '',
                                                  dPlayerPoints:
                                                      listOfAllPlayers[0]
                                                              ['fp'] ??
                                                          0,
                                                ),
                                              )
                                            : Container(
                                                child: Center(
                                                    child: Text(
                                                        'No players found!')),
                                              ),

                                        ///3rd rank player on leader board
                                        (listOfAllPlayers.length >= 3)
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10.0),
                                                child: FamilyLeaderBoardWidget(
                                                  bShowIcon: false,
                                                  intPlayerRank: 3,
                                                  dPlayerRankWidth:
                                                      screenSize.width / 22,
                                                  dPlayerRankHeight:
                                                      screenSize.width / 22,
                                                  playerRankBackgroundColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  playerRankBorderColor:
                                                      Theme.of(context)
                                                          .accentColor,
                                                  playerRankTextColor:
                                                      Theme.of(context)
                                                          .primaryColorLight,
                                                  playerImageBorderColor: Theme
                                                          .of(context)
                                                      .primaryColor, //Theme.of(context).accentColor,
                                                  intPlayerImageFlex: 1,
                                                  dProfilePicWidth: YipliConstants
                                                          .getProfilePicDimensionsSmall(
                                                              context)
                                                      .width,
                                                  dProfilePicHeight: YipliConstants
                                                          .getProfilePicDimensionsSmall(
                                                              context)
                                                      .height,
                                                  stPlayerImage:
                                                      listOfAllPlayers[2]
                                                                  ['player']
                                                              ?.profilePicUrl ??
                                                          null,
                                                  stPlayerName:
                                                      listOfAllPlayers[2]
                                                                  ['player']
                                                              ?.name ??
                                                          '',
                                                  dPlayerPoints:
                                                      listOfAllPlayers[2]
                                                              ['fp'] ??
                                                          0,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),

                                /// Top Players of the family text
                                Center(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 20.0),
                                    child: PlayAnimation<double>(
                                        curve: Curves.decelerate,
                                        duration: 1000.milliseconds,
                                        tween: (0.0).tweenTo(1.0),
                                        builder: (context, child, value) {
                                          return Transform.scale(
                                            scale: value,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    FontAwesomeIcons
                                                        .certificate,
                                                    color: yipliLogoOrange,
                                                    size: 20,
                                                  ),
                                                ),
                                                Text('Top players your family',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                            fontSize: 18.0)),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      ///Most consistent player card
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<Event>(
                            stream: mostConsistentPlayerDBRef.onValue,
                            builder: (context, event) {
                              if (event.connectionState ==
                                  ConnectionState.waiting)
                                return Container(
                                    child: Center(child: Text("Loading..")));
                              PlayerModel mostConsistentPlayer =
                                  processEventForWinningPlayer(
                                      event, allPlayerModel);
                              // print('most consis - ${(mostConsistentPlayer).profilePicUrl}');
                              print(
                                  'hello snapshot - ${(event?.data?.snapshot?.value?.values ?? [
                                        {'fp': 0}
                                      ]).elementAt(0)['fp']}');
                              return StreamBuilder<AdventureGamingData>(
                                  stream: playerProgressDatabaseHandler
                                      .getWorldAndPlayerProgressDataStream(),
                                  builder: (context, snapshot) {
                                    if (event.connectionState ==
                                        ConnectionState.waiting)
                                      return Container(
                                          child:
                                              Center(child: Text("Loading..")));
                                    return FamilyAchievementWidget(
                                      animationDelay: 600.milliseconds,
                                      dataAvailable:
                                          (event?.data?.snapshot?.value ??
                                                  null) !=
                                              null,
                                      playerName:
                                          mostConsistentPlayer?.name ?? "",
                                      mainHeadingText:
                                          'Consistent player of last month',

                                      playerImage:
                                          mostConsistentPlayer?.profilePicUrl ??
                                              '',
                                      bodyText:
                                          'Player Name was regular for\n3 weeks this month.',

                                      picBorderColor: yipliLogoOrange,
                                      achievementIcon: FontAwesomeIcons.award,
                                      achievementIconColor: yipliLogoOrange,
                                      achievementIconSize: 20.0,
                                      playerCalories: (event?.data?.snapshot
                                                  ?.value?.values ??
                                              [
                                                {'c': 0}
                                              ])
                                          .elementAt(0)['c'],
                                      playerFitnessPoints: (event?.data
                                                  ?.snapshot?.value?.values ??
                                              [
                                                {'fp': 0}
                                              ])
                                          .elementAt(0)['fp'],
                                      playerExperiencePoints: snapshot
                                              ?.data?.playerProgress?.totalFp ??
                                          0, //adventureGamingData?.playerProgress?.totalFp ?? 0,
                                      playerTotalDuration: (event?.data
                                                  ?.snapshot?.value?.values ??
                                              [
                                                {'d': 0}
                                              ])
                                          .elementAt(0)['d'],
                                      backMainHeadingText:
                                          'How to become most consistent player?',
                                      backCardInfo:
                                          'Play Daily to achieve the Most consistent player award.',
                                    );
                                  });
                            }),
                      ),

                      ///player of the month
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<Event>(
                            stream: playerOfTheLastWeekDBRef.onValue,
                            builder: (context, event) {
                              if (event.connectionState ==
                                  ConnectionState.waiting)
                                return Container(
                                    child: Center(child: Text("Loading..")));
                              PlayerModel playerOfTheLastWeek =
                                  processEventForWinningPlayer(
                                      event, allPlayerModel);

                              return StreamBuilder<AdventureGamingData>(
                                  stream: playerProgressDatabaseHandler
                                      .getWorldAndPlayerProgressDataStream(),
                                  builder: (context, snapshot) {
                                    if (event.connectionState ==
                                        ConnectionState.waiting)
                                      return Container(
                                          child:
                                              Center(child: Text("Loading..")));
                                    return FamilyAchievementWidget(
                                        animationDelay: 800.milliseconds,
                                        dataAvailable: (event
                                                    ?.data?.snapshot?.value ??
                                                null) !=
                                            null,
                                        playerName:
                                            playerOfTheLastWeek?.name ?? '',
                                        mainHeadingText:
                                            'Player of the last month',
                                        playerImage: playerOfTheLastWeek
                                                ?.profilePicUrl ??
                                            '',
                                        bodyText:
                                            'Player Name was regular for\n3 weeks this month.',
                                        picBorderColor: yipliLogoOrange,
                                        achievementIcon:
                                            FontAwesomeIcons.trophy,
                                        achievementIconColor: yipliLogoOrange,
                                        achievementIconSize: 20.0,
                                        playerCalories: (event?.data?.snapshot
                                                    ?.value?.values ??
                                                [
                                                  {'c': 0}
                                                ])
                                            .elementAt(0)['c'],
                                        playerFitnessPoints: (event?.data
                                                    ?.snapshot?.value?.values ??
                                                [
                                                  {'fp': 0}
                                                ])
                                            .elementAt(0)['fp'],
                                        playerExperiencePoints: snapshot?.data
                                                ?.playerProgress?.totalFp ??
                                            0, //adventureGamingData?.playerProgress?.totalFp ?? 0,
                                        playerTotalDuration: (event?.data
                                                    ?.snapshot?.value?.values ??
                                                [
                                                  {'d': 0}
                                                ])
                                            .elementAt(0)['d'],
                                        backMainHeadingText:
                                            'How to become player of last month?',
                                        backCardInfo:
                                            'Earn the highest Fitness Points to become Player of the last month');
                                  });
                            }),
                      ),

                      ///player of the week
                      Expanded(
                        flex: 3,
                        child: StreamBuilder<Event>(
                            stream: playerOfTheLastMonthDBRef.onValue,
                            builder: (context, event) {
                              if (event.connectionState ==
                                  ConnectionState.waiting)
                                return Container(
                                    child: Center(child: Text("Loading..")));
                              PlayerModel playerOfTheLastMonth =
                                  processEventForWinningPlayer(
                                      event, allPlayerModel);

                              return StreamBuilder<AdventureGamingData>(
                                  stream: playerProgressDatabaseHandler
                                      .getWorldAndPlayerProgressDataStream(),
                                  builder: (context, snapshot) {
                                    if (event.connectionState ==
                                        ConnectionState.waiting)
                                      return Container(
                                          child:
                                              Center(child: Text("Loading..")));
                                    return FamilyAchievementWidget(
                                        animationDelay: 1000.milliseconds,
                                        dataAvailable:
                                            (event?.data?.snapshot?.value ??
                                                    null) !=
                                                null,
                                        playerName:
                                            playerOfTheLastMonth?.name ?? '',
                                        mainHeadingText:
                                            'Player of the last week',
                                        playerImage: playerOfTheLastMonth
                                                ?.profilePicUrl ??
                                            '',
                                        bodyText:
                                            'Player Name was regular for\n3 weeks this month.',
                                        picBorderColor: yipliLogoOrange,
                                        achievementIcon: FontAwesomeIcons.medal,
                                        achievementIconColor: yipliLogoOrange,
                                        achievementIconSize: 20.0,
                                        playerCalories: (event?.data?.snapshot
                                                    ?.value?.values ??
                                                [
                                                  {'c': 0}
                                                ])
                                            .elementAt(0)['c'],
                                        playerFitnessPoints: (event?.data
                                                    ?.snapshot?.value?.values ??
                                                [
                                                  {'fp': 0}
                                                ])
                                            .elementAt(0)['fp'],
                                        playerExperiencePoints: snapshot?.data
                                                ?.playerProgress?.totalFp ??
                                            0, //adventureGamingData?.playerProgress?.totalFp ?? 0,
                                        playerTotalDuration: (event?.data
                                                    ?.snapshot?.value?.values ??
                                                [
                                                  {'d': 0}
                                                ])
                                            .elementAt(0)['d'],
                                        backMainHeadingText:
                                            'How to become player of last week?',
                                        backCardInfo:
                                            'Earn the highest Fitness Points to become Player of the last week');
                                  });
                            }),
                      ),

                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  );
                }),
              ),
            ),
          );
        }
      }),
    );
  }

  PlayerModel processEventForWinningPlayer(
      AsyncSnapshot<Event> event, AllPlayersModel allPlayerModel) {
    print('print snapdata - ${((event?.data?.snapshot?.value?.keys ?? [
          null
        ]) as Iterable).elementAt(0)}');
    String mostConsistentPlayerId =
        (event?.data?.snapshot?.value?.keys ?? [null]).elementAt(0);
    PlayerModel mostConsistentPlayer = null;
    if (mostConsistentPlayerId != null)
      allPlayerModel.allPlayers.forEach((element) {
        if (element.id == mostConsistentPlayerId) {
          mostConsistentPlayer = element;
        }
      });
    return mostConsistentPlayer;
  }
}
