import 'package:flutter_app/database_models/adventure-gaming/adventure-gaming-video-watched.dart';
import 'package:flutter_app/database_models/adventure-gaming/adventure_gaming_data.dart';
import 'package:flutter_app/database_models/adventure-gaming/class.dart';
import 'package:flutter_app/database_models/adventure-gaming/database-interface.dart';
import 'package:flutter_app/database_models/adventure-gaming/progress_stat.dart';
import 'package:flutter_app/page_models/FitnessCardsModel.dart';
import 'package:flutter_app/widgets/a_widgets_index.dart';
import 'package:flutter_app/widgets/timeline/adventureGameCardContent.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'a_pages_index.dart';

class AdventureGaming extends StatefulWidget {
  static const String routeName = "/adventure_gaming";
  @override
  _AdventureGamingState createState() => _AdventureGamingState();
}

class _AdventureGamingState extends State<AdventureGaming> {
  double _progressPercentage = 3 / 10;

  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    return ChangeNotifierProvider<FitnessCardsModel>(
      create: (context) {
        FitnessCardsModel fitnessCardsModel = new FitnessCardsModel();
        fitnessCardsModel.initialize();
        print("Returned fitnessCardsModel");
        return fitnessCardsModel;
      },
      child: Consumer<CurrentPlayerModel>(
        builder: (context, currentPlayerModel, child) {
          if (currentPlayerModel == null) return YipliLoader();

          PlayerProgressDatabaseHandler playerProgressDatabaseHandler =
              PlayerProgressDatabaseHandler(
                  playerModel: currentPlayerModel.player);
          return AdventureGamingVideoWatchedValidator(
              playerModel: currentPlayerModel.player,
              builder: (context, hasWatchedVideoSnapshot) {
                if (hasWatchedVideoSnapshot.connectionState ==
                    ConnectionState.waiting) return Container();
                if (!(hasWatchedVideoSnapshot?.data ?? false)) {
                  WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) => YipliUtils.goToStartJourney());
                  return Container();
                }
                return YipliPageFrame(
                    selectedIndex: 1,
                    toShowBottomBar: true,
                    showDrawer: true,
                    isBottomBarInactive: false,
                    title: Text('Adventure Gaming'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: _screenSize.width * 0.015,
                      ),
                      child: StreamBuilder<AdventureGamingData>(
                          stream: playerProgressDatabaseHandler
                              .getWorldAndPlayerProgressDataStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData &&
                                snapshot.connectionState !=
                                    ConnectionState.waiting) {
                              print(
                                  'printing snapshot data - ${snapshot.data}');

                              AdventureGamingData adventureGamingData =
                                  snapshot.data;
                              _progressPercentage = adventureGamingData
                                      .playerProgress.currentIndex /
                                  adventureGamingData.world.storyline.length;
                              print('player progress- $_progressPercentage');

                              return Column(
                                children: [
                                  //commenting all worlds tab from top od the adventure gaming apge
                                  // FlatButton(
                                  //   color: appbackgroundcolor,
                                  //   onPressed: () {
                                  //     YipliUtils.navigatorKey.currentState
                                  //         .pushReplacementNamed(
                                  //             WorldSelectionPage.routeName);
                                  //   },
                                  //   child: Text('All Worlds',
                                  //       style: Theme.of(context)
                                  //           .textTheme
                                  //           .subtitle2
                                  //           .copyWith(
                                  //             color: yipliLogoOrange,
                                  //             decoration:
                                  //                 TextDecoration.underline,
                                  //           )),
                                  // ),
                                  SizedBox(
                                    height: (60 / 592) * _screenSize.height,
                                    child: AdventureGamingProgressIndicator(
                                      titleText:
                                          "Welcome to ${adventureGamingData.world.name}!",
                                      progressPercentage: _progressPercentage,
                                      currentClass: (adventureGamingData
                                              .playerProgress.currentIndex) +
                                          1,
                                      totalClass: adventureGamingData
                                          .world.storyline.length,
                                    ),
                                  ),
                                  SizedBox(
                                    height: (4 / 592) * _screenSize.height,
                                    child: Container(),
                                  ),
                                  PlayAnimation(
                                    duration: 2000.milliseconds,
                                    delay: 200.milliseconds,
                                    tween: 25.0.tweenTo(0.0),
                                    builder: (context, child, value) {
                                      return Transform.translate(
                                        offset: Offset(0, value),
                                        child: child,
                                      );
                                    },
                                    child: SizedBox(
                                      height: (560 / 592) * _screenSize.height,
                                      child: ScrollablePositionedList.builder(
                                        itemCount: adventureGamingData
                                            .world.storyline.length,
                                        initialScrollIndex: adventureGamingData
                                            .playerProgress.currentIndex,
                                        initialAlignment: 0.1,
                                        physics:
                                            AlwaysScrollableScrollPhysics(),
                                        itemBuilder: (context, chapterIndex) {
                                          print(
                                              "length = ${adventureGamingData.world.storyline.length}");
                                          ProgressStat currentProgressStat;
                                          String classRef;

                                          //* Previous classes
                                          if (chapterIndex <
                                              adventureGamingData.playerProgress
                                                  .currentIndex) {
                                            print(
                                                'chapter index - $chapterIndex');
                                            currentProgressStat =
                                                adventureGamingData
                                                        ?.playerProgress
                                                        ?.progressStats
                                                        ?.elementAt(
                                                            chapterIndex) ??
                                                    null;

                                            classRef = adventureGamingData
                                                .playerProgress
                                                .progressStats[chapterIndex]
                                                .classRef;

                                            return StreamBuilder<
                                                    AdventureGamingClassDetails>(
                                                stream: playerProgressDatabaseHandler
                                                    .getClassDetailsStreamForClassRef(
                                                        classRef),
                                                builder: (context, snapshot) {
                                                  AdventureGamingClassDetails
                                                      adventureGamingClassDetails =
                                                      snapshot.data;
                                                  if (snapshot.data == null) {
                                                    print(
                                                        'printing snapshot data  for details- ${snapshot.data}');

                                                    return YipliLoaderMini(
                                                        loadingMessage:
                                                            'Load you adventure');
                                                  }
                                                  return Consumer<
                                                          FitnessCardsModel>(
                                                      builder: (context,
                                                          fitnessCardsModel,
                                                          child) {
                                                    if (fitnessCardsModel
                                                            .allFitnessCards
                                                            .length ==
                                                        0) {
                                                      return Container();
                                                    }
                                                    return buildAdventureGameCard(
                                                        chapterRating:
                                                            (currentProgressStat)
                                                                    ?.rating ??
                                                                0.0,
                                                        fitnessCard1ImgPath:
                                                            fitnessCardsModel.allFitnessCards.length > 0
                                                                ? fitnessCardsModel
                                                                    .allFitnessCards[
                                                                        adventureGamingData.world.storyline[chapterIndex].fitnessCards[
                                                                            0]]
                                                                    .imgUrl
                                                                : null,
                                                        fitnessCard2ImgPath: fitnessCardsModel
                                                                    .allFitnessCards
                                                                    .length >
                                                                0
                                                            ? adventureGamingData
                                                                        .world
                                                                        .storyline[
                                                                            chapterIndex]
                                                                        .fitnessCards
                                                                        .length >
                                                                    1
                                                                ? fitnessCardsModel
                                                                    .allFitnessCards[adventureGamingData.world.storyline[chapterIndex].fitnessCards[1]]
                                                                    .imgUrl
                                                                : null
                                                            : null,
                                                        focusActivity1: adventureGamingClassDetails.battleZone.playerAction,
                                                        focusActivity2: adventureGamingClassDetails.challengeZone.playerAction,
                                                        coinsToCollect: adventureGamingClassDetails.minimumFp,
                                                        xpToCollect: adventureGamingClassDetails.minimumXp,
                                                        cardState: getStateForIndex(currentChapterIndex: chapterIndex, currentPlayerIndex: adventureGamingData.playerProgress.currentIndex),
                                                        isFirst: chapterIndex == 0,
                                                        isLast: chapterIndex == adventureGamingData.world.storyline.length - 1,
                                                        chapterTitle: adventureGamingData.world.storyline[chapterIndex].chapterTitle,
                                                        cardImagePath: adventureGamingData.world.storyline[chapterIndex].artworkImageUrl,
                                                        androidUrl: adventureGamingData.world.androidUrl);
                                                  });
                                                });
                                          }
                                          //* Current class
                                          else if (chapterIndex ==
                                              adventureGamingData.playerProgress
                                                  .currentIndex) {
                                            currentProgressStat =
                                                new ProgressStat(
                                                    chapterRef:
                                                        adventureGamingData
                                                            .playerProgress
                                                            .nextClassRef,
                                                    classRef:
                                                        adventureGamingData
                                                            .playerProgress
                                                            .nextClassRef,
                                                    c: 0,
                                                    fp: 0,
                                                    count: 0,
                                                    rating: 0.0,
                                                    t: 0);

                                            classRef = adventureGamingData
                                                .playerProgress.nextClassRef;
                                          }
                                          //* Future class doesn't need special handling
                                          return buildClassesCard(
                                              playerProgressDatabaseHandler,
                                              classRef,
                                              currentProgressStat,
                                              adventureGamingData,
                                              chapterIndex);
                                        },
                                        itemScrollController:
                                            itemScrollController,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (snapshot.hasError) {
                              print(
                                  'snap shot from adventure - ${snapshot.error}');

                              Future.delayed(200.milliseconds)
                                  .then((value) => YipliUtils.goToHomeScreen());

                              return Container();
                            }

                            return Container();
                          }),
                    ));
              });
        },
      ),
    );
  }

  Widget buildClassesCard(
      PlayerProgressDatabaseHandler playerProgressDatabaseHandler,
      String classRef,
      ProgressStat currentProgressStat,
      AdventureGamingData adventureGamingData,
      int chapterIndex) {
    if (classRef == null) {
      return buildAdventureGameCard(
          chapterRating: (currentProgressStat)?.rating ?? 0.0,
          fitnessCard1ImgPath: null,
          fitnessCard2ImgPath: null,
          focusActivity1: null,
          focusActivity2: null,
          coinsToCollect: null,
          xpToCollect: null,
          cardState: getStateForIndex(
              currentChapterIndex: chapterIndex,
              currentPlayerIndex:
                  adventureGamingData.playerProgress.currentIndex),
          isFirst: chapterIndex == 0,
          isLast:
              chapterIndex == adventureGamingData.world.storyline.length - 1,
          chapterTitle:
              adventureGamingData.world.storyline[chapterIndex].chapterTitle,
          cardImagePath:
              adventureGamingData.world.storyline[chapterIndex].artworkImageUrl,
          androidUrl: adventureGamingData.world.androidUrl);
    }

    return StreamBuilder<AdventureGamingClassDetails>(
        stream: playerProgressDatabaseHandler
            .getClassDetailsStreamForClassRef(classRef),
        builder: (context, snapshot) {
          AdventureGamingClassDetails adventureGamingClassDetails =
              snapshot.data;
          if (snapshot.data == null) {
            print('printing snapshot data  for details- ${snapshot.data}');

            return Container();
          }
          return Consumer<FitnessCardsModel>(
              builder: (context, fitnessCardsModel, child) {
            if (fitnessCardsModel.allFitnessCards.length == 0) {
              return Container();
            }
            return buildAdventureGameCard(
                chapterRating: (currentProgressStat)?.rating ?? 0.0,
                fitnessCard1ImgPath: getFitnessCardImagePath(
                    fitnessCardsModel, adventureGamingData, chapterIndex),
                fitnessCard2ImgPath: getFitnessCard2ImgPath(
                    fitnessCardsModel, adventureGamingData, chapterIndex),
                focusActivity1:
                    adventureGamingClassDetails.battleZone.playerAction,
                focusActivity2:
                    adventureGamingClassDetails.challengeZone.playerAction,
                coinsToCollect: adventureGamingClassDetails.minimumFp,
                xpToCollect: adventureGamingClassDetails.minimumXp,
                cardState: getStateForIndex(
                    currentChapterIndex: chapterIndex,
                    currentPlayerIndex:
                        adventureGamingData.playerProgress.currentIndex),
                isFirst: chapterIndex == 0,
                isLast: chapterIndex ==
                    adventureGamingData.world.storyline.length - 1,
                chapterTitle: adventureGamingData
                    .world.storyline[chapterIndex].chapterTitle,
                cardImagePath: adventureGamingData
                    .world.storyline[chapterIndex].artworkImageUrl,
                androidUrl: adventureGamingData.world.androidUrl);
          });
        });
  }

  String getFitnessCard2ImgPath(FitnessCardsModel fitnessCardsModel,
      AdventureGamingData adventureGamingData, int chapterIndex) {
    return fitnessCardsModel.allFitnessCards.length > 0
        ? adventureGamingData
                    .world.storyline[chapterIndex].fitnessCards.length >
                1
            ? fitnessCardsModel
                .allFitnessCards[adventureGamingData
                    .world.storyline[chapterIndex].fitnessCards[1]]
                .imgUrl
            : null
        : null;
  }

  String getFitnessCardImagePath(FitnessCardsModel fitnessCardsModel,
      AdventureGamingData adventureGamingData, int chapterIndex) {
    return fitnessCardsModel.allFitnessCards.length > 0
        ? fitnessCardsModel
            .allFitnessCards[adventureGamingData
                .world.storyline[chapterIndex].fitnessCards[0]]
            .imgUrl
        : null;
  }

  AdventureGameCard buildAdventureGameCard(
      {chapterRating,
      fitnessCard1ImgPath,
      fitnessCard2ImgPath,
      focusActivity1,
      focusActivity2,
      coinsToCollect,
      xpToCollect,
      cardState,
      isFirst,
      isLast,
      chapterTitle,
      cardImagePath,
      androidUrl}) {
    return AdventureGameCard(
      chapterRating: chapterRating,
      fitnessCards: FitnessCards(
        card1Details: FitnessCardDetails(
          fitnessCardImgPath: fitnessCard1ImgPath,
        ),
        card2Details: fitnessCard2ImgPath == null
            ? null
            : FitnessCardDetails(
                fitnessCardImgPath: fitnessCard2ImgPath,
              ),
      ),
      focusActivity1: focusActivity1,
      focusActivity2: focusActivity2,
      coinsToCollect: coinsToCollect,
      xpToCollect: xpToCollect,
      adventureGamingCardState: cardState,
      isFirst: isFirst,
      isLast: isLast,
      chapterTitle: chapterTitle,
      cardImagePath: cardImagePath,
      androidUrl: androidUrl,
    );
  }

  getStateForIndex({int currentChapterIndex, int currentPlayerIndex}) {
    if (currentChapterIndex > currentPlayerIndex)
      return AdventureGamingCardState.LOCKED;
    if (currentChapterIndex == currentPlayerIndex)
      return AdventureGamingCardState.NEXT;
    if (currentChapterIndex < currentPlayerIndex)
      return AdventureGamingCardState.PLAYED;
  }
}
