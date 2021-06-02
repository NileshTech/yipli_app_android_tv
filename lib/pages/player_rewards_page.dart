import 'package:confetti/confetti.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/a_pages_index.dart';
import 'package:flutter_app/widgets/rewards/reward_menu.dart';
import 'package:intl/intl.dart';
import 'package:scratcher/scratcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';

class RewardsPage extends StatefulWidget {
  static const String routeName = "/rewards_page";
  final String playerId;

  RewardsPage(this.playerId, {Key key}) : super(key: key);

  @override
  _RewardsPageState createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage>
    with SingleTickerProviderStateMixin {
  int fitnessPoints;
  int collectedSpecialRewards;
  int totalFitnessPoints;
  String userId;
  int dailyRewards;
  bool isScratchCardCollected = false;
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  int rewards;
  int remainingTimerForScratchCard;
  ConfettiController _confettiController;
  int rewardLastShownTime;
  final scratchKey = GlobalKey<ScratcherState>();
  int diffBetweenNextReward = 86400000;

  @override
  void initState() {
    userId = AuthService.getCurrentUserId();
    super.initState();
    _confettiController = new ConfettiController(
      duration: new Duration(seconds: 1),
    );
  }

  Future<bool> isScratchCardToBeShown(playerId) async {
    final keyIsDailyRewardShownToPlayer = 'Daily_Rewards_' + playerId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int rewardLastShownTime = prefs.getInt(keyIsDailyRewardShownToPlayer);

    if (rewardLastShownTime == null ||
        (currentTime - (rewardLastShownTime)) > diffBetweenNextReward) {
      return Future.value(true);
    }

    remainingTimerForScratchCard =
        (((diffBetweenNextReward - (currentTime - rewardLastShownTime)) / 1000)
            .round());

    return Future.value(false);
  }

  //main Page UI of inbox page
  @override
  Widget build(BuildContext context) {
    return YipliPageFrame(
      title: Text('Inbox'),
      child: rewardPageBuild(context, widget.playerId),
      widgetOnAppBar: coins(context),
    );
  }

  //UI of placehoders for scratch card and special rewards
  Widget rewardPageBuild(BuildContext context, String playerId) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<bool>(
          future: isScratchCardToBeShown(widget.playerId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return YipliLoaderMini(
                loadingMessage: "validating...",
              );
            } else if (snapshot.data == true &&
                isScratchCardCollected == false) {
              Future.delayed(
                      YipliUtils.getNotificationDuration(SnackbarDuration.SHORT)
                          .seconds)
                  .then((value) => showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) =>
                          giveScratchCard(context, playerId)));
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: isScratchCardCollected == false && snapshot.data == true
                      ? 2
                      : 3,
                  child:
                      isScratchCardCollected == false && snapshot.data == true
                          ? PlayAnimation<double>(
                              curve: Curves.decelerate,
                              duration: 1000.milliseconds,
                              tween: (0.0).tweenTo(1.0),
                              builder: (context, child, value) {
                                return Transform.scale(
                                  scale: value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: yipliBlack,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).accentColor,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: yipliNewDarkBlue,
                                          offset: Offset(0.0, 1.0),
                                          blurRadius: 10.0,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                          "Collect daily rewards from scratch card shown"),
                                    ),
                                  ),
                                );
                              })
                          : scratchCardTimerPlaceholder(context),
                ),
                Expanded(
                  flex: 2,
                  child: PlayerProfileDivider(
                    dividerColor: Theme.of(context).accentColor,
                    dividerIconColor: Theme.of(context).accentColor,
                    dividerIcon: EvaIcons.gift,
                    dividerText: "Special Rewards",
                    dividerTextColor: Theme.of(context).accentColor,
                  ),
                ),
                Expanded(
                  flex: 16,
                  child: PlayAnimation<double>(
                      curve: Curves.decelerate,
                      duration: 1000.milliseconds,
                      tween: (0.0).tweenTo(1.0),
                      builder: (context, child, value) {
                        return Transform.scale(
                          scale: value,
                          child: RewardMenuWidget(widget.playerId),
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }

  Widget giveScratchCard(BuildContext context, String playerId) {
    return Dialog(
        insetAnimationDuration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: PlayAnimation<double>(
            curve: Curves.decelerate,
            duration: 1000.milliseconds,
            tween: (0.0).tweenTo(1.0),
            builder: (context, child, value) {
              return Transform.scale(
                scale: value,
                child: rewardOverlayContent(context),
              );
            })

        // rewardOverlayContent(context),
        );
  }

  rewardOverlayContent(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Random rnd = new Random();
    int minFP = 1000, maxFP = 5000;
    int randomFP = minFP + rnd.nextInt(maxFP - minFP);
    print("$randomFP is in the range of $minFP and $maxFP");
    //* Background container - Shadow settings for the overlay are here.

    return Container(
      decoration: BoxDecoration(
          color: yipliBlack, //Theme.of(context).primaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: yipliLogoBlue.withOpacity(.4),
              width: 1,
              style: BorderStyle.solid)),

      //* This column contains all the visual elements under scratach
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // To make the card compact
          children: <Widget>[
            //* ScratchCard Image

            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: yipliBlue,
                      offset: Offset(0.0, 1.0),
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child:
                    StatefulBuilder(builder: (context, StateSetter setState) {
                  return PlayAnimation<double>(
                      curve: Curves.decelerate,
                      duration: 1000.milliseconds,
                      tween: (0.0).tweenTo(1.0),
                      builder: (context, child, value) {
                        return Transform.scale(
                          scale: value,
                          child: Stack(
                            children: [
                              Scratcher(
                                key: scratchKey,
                                brushSize: 100,
                                threshold: 75,
                                image: Image.asset(
                                  'assets/images/scratch.png',
                                  fit: BoxFit.fill,
                                ),
                                onChange: (value) {
                                  print(
                                      '====Random Daily Reward : $randomFP =====');
                                },
                                onThreshold: () async {
                                  isScratchCardCollected = true;
                                  _confettiController.play();

                                  getPlayerProfileRewardsOnScratchCard(
                                      randomFP, widget.playerId);
                                  print(
                                      'rewardLastShownTime - $rewardLastShownTime');

                                  scratchKey.currentState.progress = 100;
                                },
                                child: Container(
                                  height: screenSize.height / 3,
                                  color: yipliGray.withOpacity(0.2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Text(
                                              '$randomFP',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Center(
                                            child: Text(
                                              "Congratulations ! $randomFP points will be added to your total fitness points !",
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: ConfettiWidget(
                                    confettiController: _confettiController,
                                    blastDirectionality:
                                        BlastDirectionality.explosive,
                                    particleDrag: 0.05,
                                    emissionFrequency: 0.05,
                                    numberOfParticles: 25,
                                    gravity: 0.05,
                                    shouldLoop: false,
                                    colors: [
                                      Colors.red,
                                      Colors.blue,
                                    ]),
                              ),
                            ],
                          ),
                        );
                      });
                }),
              ),
            ),

            //* Suggestion text at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: InkWell(
                child: Container(
                  child: Text(
                    "Scratch and collect daily rewards from your inbox.",
                    style: TextStyle(
                      color: yipliWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () async {
                  if (isScratchCardCollected == false) {
                    return null;
                  } else {
                    final keyIsDailyRewardShownToPlayer =
                        'Daily_Rewards_' + widget.playerId;
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setInt(keyIsDailyRewardShownToPlayer,
                        new DateTime.now().millisecondsSinceEpoch);
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //getting current fitness points to show in appBar of inbox page
  Widget fitnessPointsOfCurrentPlayer(
      BuildContext context, String currentPlayerId) {
    Query currentFitnessPoints = FirebaseDatabase.instance
        .reference()
        .child("profiles")
        .child("users")
        .child(userId)
        .child("players")
        .child(currentPlayerId)
        .child("activity-statistics");

    return StreamBuilder<Event>(
      stream: currentFitnessPoints.onValue,
      builder: (context, event) {
        if ((event.connectionState == ConnectionState.waiting) ||
            event.hasData == null)
          return YipliLoaderMini(loadingMessage: 'Loading Reward Page');

        if (event.data.snapshot.value != null) {
          fitnessPoints = event.data.snapshot.value['total-fitness-points'];
          var rewards = NumberFormat.compact().format(fitnessPoints);

          return Text(
            rewards.toString(),
            style: TextStyle(
              color: yipliGray,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return Text("0");
        }
      },
    );
  }

  //UI for the Fitness points in the appBar
  Widget coins(BuildContext context) {
    //Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: 100,
      alignment: Alignment.topRight,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Image.asset(
              "assets/images/yipli_coin.png",
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: fitnessPointsOfCurrentPlayer(context, widget.playerId),
            ),
          ),
        ],
      ),
    );
  }

  //UI to show Timer
  Widget scratchCardTimerPlaceholder(BuildContext context) {
    print("_start : $remainingTimerForScratchCard");
    remainingTimerForScratchCard = remainingTimerForScratchCard - 10;
    return PlayAnimation<double>(
        curve: Curves.decelerate,
        duration: 1000.milliseconds,
        tween: (0.0).tweenTo(1.0),
        builder: (context, child, value) {
          return Transform.scale(
            scale: value,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: yipliBlack,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).accentColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: yipliNewDarkBlue,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 16.0, 5.0, 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Text("Unlocks in : "),
                          ),
                          Row(
                            children: [
                              SlideCountdownClock(
                                  duration: Duration(
                                      days: 0,
                                      seconds: remainingTimerForScratchCard),
                                  slideDirection: SlideDirection.Down,
                                  separator: ':',
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  onDone: () async {
                                    final keyIsDailyRewardShownToPlayer =
                                        'Daily_Rewards_' + widget.playerId;
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs
                                        .remove(keyIsDailyRewardShownToPlayer);

                                    setState(() {});
                                  }),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 100,
                  right: 100,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: yipliNewBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock, color: yipliWhite, size: 15),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: Text(
                                "Daily Rewards",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  getPlayerProfileRewardsOnScratchCard(
      int currentPoints, String playerId) async {
    DatabaseReference getPlyerFitnessPoints;
    getPlyerFitnessPoints = FirebaseDatabase.instance
        .reference()
        .child("profiles")
        .child("users")
        .child(userId)
        .child("players")
        .child(playerId)
        .child("activity-statistics")
        .child("total-fitness-points");
    DataSnapshot playerFitnessPoints = await getPlyerFitnessPoints.once();

    int playerDBPoints =
        playerFitnessPoints.value == null ? 0 : playerFitnessPoints.value;
    int totalPlayersFitnessPoints;

    playerDBPoints != null
        ? totalPlayersFitnessPoints = playerDBPoints + currentPoints
        : totalPlayersFitnessPoints = currentPoints;

    Future<bool> currentFitnessPoints = FirebaseDatabase.instance
        .reference()
        .child("profiles")
        .child("users")
        .child(userId)
        .child("players")
        .child(playerId)
        .child("activity-statistics")
        .update({"total-fitness-points": totalPlayersFitnessPoints});

    return currentFitnessPoints;
  }
}
