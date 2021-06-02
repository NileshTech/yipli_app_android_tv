import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/database_models/database_model_index.dart';
import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:scratcher/scratcher.dart';

class GiveScratchCard extends StatefulWidget {
  final String playerId;
  final int timeRemaining;
  GiveScratchCard(this.playerId, this.timeRemaining, {Key key})
      : super(key: key);

  @override
  _GiveScratchCardState createState() => _GiveScratchCardState();
}

class _GiveScratchCardState extends State<GiveScratchCard> {
  ConfettiController _confettiController;
  bool isScratchCardCollected = false;
  int currentPoints;
  String userId;
  final scratchKey = GlobalKey<ScratcherState>();
  @override
  void initState() {
    super.initState();
    userId = AuthService.getCurrentUserId();
    _confettiController = new ConfettiController(
      duration: new Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: rewardOverlayContent(context),
        ));
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
            isScratchCardCollected == false
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
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
                        child: StatefulBuilder(
                            builder: (context, StateSetter setState) {
                          return Scratcher(
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
                            onThreshold: () {
                              isScratchCardCollected = true;
                              _confettiController.play();
                              getPlayerProfileRewardsOnScratchCard(
                                  randomFP, widget.playerId);
                            },
                            child: Container(
                              height: screenSize.height / 3,
                              width: screenSize.width / 1.5,
                              color: yipliGray.withOpacity(0.2),
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Image.asset(
                                        "assets/images/yipli_coin.png",
                                      ),
                                    ),
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
                                      child: ConfettiWidget(
                                          confettiController:
                                              _confettiController,
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
                                    Expanded(
                                      flex: 7,
                                      child: Text(
                                        "Congratulations ! $randomFP points will be added to your total fitness points !",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                : Container(
                    child: Center(
                      child: Text("Collected"),
                    ),
                  ),

            //* Suggestion text at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: FlatButton(
                focusColor: androidTVFocusColor,
                child: Text(
                  "Scratch and collect daily rewards from your inbox.",
                  style: TextStyle(
                    color: yipliWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
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
