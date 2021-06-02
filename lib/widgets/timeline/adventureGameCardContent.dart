//* This is the main widget that creates the right part of the adventure game card. Multiple widgets and functions help generate this card.
//* please read comments above each widget to understand more.

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animator/flutter_animator.dart' as flutterAnimations;
import 'package:intl/intl.dart';

import '../a_widgets_index.dart';
import '../toolTip.dart';

class AGCardRight extends StatefulWidget {
  final String chapterTitle;
  final AdventureGamingCardState adventureGamingCardState;
  final String focusActivity1;
  final String focusActivity2;
  final double chapterRating;
  final String androidUrl;
  final FitnessCards fitnessCards;

  const AGCardRight({
    Key key,
    this.chapterTitle,
    this.adventureGamingCardState,
    this.focusActivity1,
    this.focusActivity2,
    this.fitnessCards,
    this.chapterRating,
    this.androidUrl,
  }) : super(key: key);

  @override
  _AGCardRightState createState() => _AGCardRightState();
}

class _AGCardRightState extends State<AGCardRight> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: const BoxConstraints(
      //   minHeight: 40,
      //   maxHeight: 200,
      // ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0), color: primarycolor),
      child: Stack(
        children: [
          ChapterTitle(
            chapterTitle: widget.chapterTitle,
            chapterRating: widget.chapterRating,
          ),
          buildUnlockedAGRightContent(context),
        ],
      ),
    );
  }

  Widget buildUnlockedAGRightContent(context) {
    Size _screenSize = MediaQuery.of(context).size;

    switch (widget.adventureGamingCardState) {
      case AdventureGamingCardState.LOCKED:
        return Container(
          height: (40 / 592) * _screenSize.height,
        );
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 38, 0, 0),
          child: Row(
            children: [
              widget.fitnessCards,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FocusActivities(
                          focusActivity1: widget.focusActivity1,
                          focusActivity2: widget.focusActivity2),
                      PlayButton(
                          adventureGamingCardState:
                              widget.adventureGamingCardState,
                          androidUrl: "com.yipli.caveadventure"),
                      // SizedBox(
                      //   child: TypewriterAnimatedTextKit(
                      //     speed: Duration(milliseconds: 200),
                      //     onTap: () {
                      //       print("Tap Event");
                      //     },
                      //     text: [
                      //       "Coming soon ...",
                      //     ],
                      //     textStyle: TextStyle(
                      //       fontSize: 12.0,
                      //       fontFamily: "Lato",
                      //       color: yipliLogoOrange,
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //     textAlign: TextAlign.start,
                      //   ),
                      // )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
    }
    return null;
  }
}

// This class is build for animating the fitness cards
class RotationY extends StatelessWidget {
  //Degrees to rads constant
  static const double degrees2Radians = pi / 180;

  final Widget child;
  final double rotationY;

  const RotationY({Key key, @required this.child, this.rotationY = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) //These are magic numbers, just use them :)
          ..rotateY(rotationY * degrees2Radians),
        child: child);
  }
}

//* Fitness Cards Display Widget
//* This widget creates a column layout with the fitness card widget for the Adventure Gaming tile.

class FitnessCards extends StatelessWidget {
  final FitnessCardDetails card1Details;
  final FitnessCardDetails card2Details;

  const FitnessCards({
    Key key,
    this.card1Details,
    this.card2Details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        card1Details != null
            ? TweenAnimationBuilder(
                duration: Duration(milliseconds: 2500),
                curve: Curves.elasticIn,
                tween: Tween<double>(begin: 180, end: 0),
                builder: (context, value, child) {
                  return RotationY(
                    rotationY: value,
                    child: FitnessCardUI(
                      details: card1Details,
                    ),
                  );
                })
            : Container(),
        card2Details != null
            ? TweenAnimationBuilder(
                duration: Duration(milliseconds: 3000),
                curve: Curves.elasticIn,
                tween: Tween<double>(begin: 180, end: 0),
                builder: (context, value, child) {
                  return RotationY(
                    rotationY: value,
                    child: FitnessCardUI(
                      details: card2Details,
                    ),
                  );
                })
            : Container(),
      ],
    );
  }
}

//* Fitness Card Widgets. The two widgets below generate a fitness card
//* This widget creates the fitness card from the artwork that is provided.
//* Please see the artwork guidelines before using this widget.

class FitnessCardDetails {
  final String fitnessCardImgPath;

  FitnessCardDetails({
    this.fitnessCardImgPath,
  });
}

class FitnessCardUI extends StatelessWidget {
  final FitnessCardDetails details;
  const FitnessCardUI({
    Key key,
    this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return ShowTooltip(
      toolTipText: 'Player Activity Rewards Card',
      child: Container(
        decoration: ShapeDecoration(
          shape: PolygonBorder(
            sides: 6,
            borderRadius: 6.0,
            //border: BorderSide(color: Color(0xFF404040), width: 3),
          ),
        ),
        height: (75 / 592) * _screenSize.height,
        child: ClipPolygon(
          boxShadows: [
            PolygonBoxShadow(color: appbackgroundcolor, elevation: 9.0)
          ],
          child: FadeInImage(
            placeholder: AssetImage('assets/images/imageloading.png'),
            fadeInDuration: Duration(milliseconds: 100),
            height: (75 / 592) * _screenSize.height,
            image: FirebaseImage(
              "${FirebaseStorageUtil.fitnessCards}/${details.fitnessCardImgPath}",
            ),
          ),
          sides: 6,
          borderRadius: 6,
        ),
      ),
    );
  }
}

//* Adventure gaming Left Card for unlocked state

class AGCardLeft extends StatelessWidget {
  const AGCardLeft({
    Key key,
    @required this.adventureGamingCardState,
    @required this.cardImagePath,
    this.coinsToCollect,
    this.xpToCollect,
  }) : super(key: key);

  final AdventureGamingCardState adventureGamingCardState;
  final String cardImagePath;
  final int coinsToCollect;
  final int xpToCollect;

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    List<Widget> list = buildAGCardLeftUnlockedContent(context);
    return Stack(
      //* This is the root container that maintains the height of the widget.
      children: ([
        Container(
          // constraints: const BoxConstraints(
          //   minHeight: 130,
          //   maxHeight: 200,
          // ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: primarycolor,
          ),
          child: Column(
            children: [
              ShowTooltip(
                toolTipText: 'Player class preview',
                child: Container(
                  height: (130 / 592) * _screenSize.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.centerLeft,
                      image: FirebaseImage(
                        "${FirebaseStorageUtil.adventureStory}/chapters/$cardImagePath",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ])
        ..addAll(list),
    );
  }

  List<Widget> buildAGCardLeftUnlockedContent(context) {
    Size _screenSize = MediaQuery.of(context).size;
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.LOCKED:
        return [];
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return [
          //* This container has the gradient that goes on top of the artwork

          Container(
            height: (140 / 592) * _screenSize.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  primarycolor,
                  primarycolor.withOpacity(0.1),
                ],
                stops: [0.2, 0.9],
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
          ),
          Container(
            height: (200 / 592) * _screenSize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: YipliUtils.getBorderColorForCardState(
                    adventureGamingCardState),
                width: 3,
              ),
            ),
          ),
          ShowTooltip(
            toolTipText: 'Player class preview',
            child: XPandFitnessPoints(
              adventureGamingCardState: adventureGamingCardState,
              coinsToCollect: coinsToCollect,
              xpToCollect: xpToCollect,
            ),
          ),
        ];
    }
    return null;
  }
}

//* Left card for locked state

class AGCardLeftLocked extends StatelessWidget {
  const AGCardLeftLocked({
    Key key,
    @required this.adventureGamingCardState,
    @required this.cardImagePath,
    this.coinsToCollect,
    this.xpToCollect,
  }) : super(key: key);

  final AdventureGamingCardState adventureGamingCardState;
  final String cardImagePath;
  final int coinsToCollect;
  final int xpToCollect;

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Container(
      // constraints: const BoxConstraints(
      //   minHeight: 80,
      //   maxHeight: 200,
      // ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: primarycolor,
      ),
      child: Column(
        children: [
          Container(
            height: (80 / 592) * _screenSize.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                alignment: Alignment.centerLeft,
                image: FirebaseImage(
                  "${FirebaseStorageUtil.adventureStory}/chapters/$cardImagePath", //@TODO - Do it till adventure gaming folder - currently it is till story level
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildAGCardLeftUnlockedContent() {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.LOCKED:
        return [];
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return [
          //* This container has the gradient that goes on top of the artwork

          Container(
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  primarycolor,
                  primarycolor.withOpacity(0.1),
                ],
                stops: [0.2, 0.9],
              ),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
          ),
          XPandFitnessPoints(
            adventureGamingCardState: adventureGamingCardState,
            coinsToCollect: coinsToCollect,
            xpToCollect: xpToCollect,
          ),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: YipliUtils.getBorderColorForCardState(
                    adventureGamingCardState),
                width: 3,
              ),
            ),
          )
        ];
    }
    return null;
  }
}

//* Focus Activities/Speciality Text Widget

class FocusActivities extends StatelessWidget {
  final String focusActivity1;
  final String focusActivity2;

  const FocusActivities({
    Key key,
    this.focusActivity1,
    this.focusActivity2,
  })  : assert(focusActivity1 != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: ShowTooltip(
        toolTipText: 'Players class focus exercises',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Text(
                "FOCUS ACTIVITIES",
                style: Theme.of(context)
                    .textTheme
                    .overline
                    .copyWith(color: yipliLogoOrange)
                    .copyWith(letterSpacing: 0),
              ),
            ),
            Text(
              focusActivity1,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(letterSpacing: 0.2),
            ),
            Text(
              focusActivity2,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(letterSpacing: 0.2),
            ),
          ],
        ),
      ),
    );
  }
}

//* Rating widget.

class RatingStars extends StatelessWidget {
  final double chapterRating;
  const RatingStars({
    Key key,
    this.chapterRating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return RatingBar(
      unratedColor: primarycolor,
      itemSize: (12 / 592) * _screenSize.height,
      initialRating: chapterRating,
      direction: Axis.horizontal,
      allowHalfRating: true,
      ignoreGestures: true,
      itemCount: 5,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
        size: (5 / 592) * _screenSize.height,
      ),
      onRatingUpdate: (rating) {
        print('rating - $rating');
      },
    );
  }
}

//* Chapter Title Widget

class ChapterTitle extends StatelessWidget {
  final String chapterTitle;
  final double chapterRating;

  const ChapterTitle({Key key, this.chapterTitle, this.chapterRating});
  // : assert(chapterTitle != null),
  //   super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Container(
      height: (36 / _screenSize.height) * _screenSize.height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: appbackgroundcolor.withOpacity(0.5),
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
        color: Color(0xFF404040),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: flutterAnimations.FadeInRight(
                child: ShowTooltip(
                  toolTipText: 'Player class title',
                  child: Text(
                    chapterTitle,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: ShowTooltip(
                  toolTipText: 'Player current class rating',
                  child: RatingStars(
                    chapterRating: chapterRating,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//* Play Button widget

class PlayButton extends StatelessWidget {
  final AdventureGamingCardState adventureGamingCardState;
  final String androidUrl;

  const PlayButton({
    Key key,
    this.adventureGamingCardState,
    this.androidUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return Consumer3<UserModel, CurrentPlayerModel, CurrentMatModel>(builder:
        (context, userModel, currentPlayerModel, currentMatModel, child) {
      if (currentPlayerModel == null) return YipliLoader();

      PlayerProgressDatabaseHandler playerProgressDatabaseHandler =
          PlayerProgressDatabaseHandler(playerModel: currentPlayerModel.player);
      return StreamBuilder<AdventureGamingData>(
          stream: playerProgressDatabaseHandler
              .getWorldAndPlayerProgressDataStream(),
          builder: (context, snapshot) {
            AdventureGamingData adventureGamingData = snapshot.data;
            return Container(
              height: (42 / 592) * MediaQuery.of(context).size.height,
              width: (100 / 360) * MediaQuery.of(context).size.width,
              child: RaisedButton(
                focusColor: androidTVFocusColor,
                color: YipliUtils.getButtonColor(adventureGamingCardState),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  YipliUtils.getIconForButton(adventureGamingCardState),
                  size: 24,
                  color: justwhite,
                ),
                onPressed: () {
                  //temporary placeholder for adventure gaming launch.
                  //TODO: Remove after lunching the Adventure Games
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0.0,
                            backgroundColor: Colors.transparent,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(3.0, 3.0),
                                      blurRadius: 10.0,
                                      spreadRadius: 5.0,
                                      color: yipliNewBlue,
                                    ),
                                  ],
                                  border: Border.all(
                                      color: yipliNewBlue,
                                      width: 3,
                                      style: BorderStyle.solid)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize
                                      .min, // To make the card compact
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: RubberBand(
                                          child: YipliLogoLarge(
                                              heightScaleDownFactor: 4)),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: ZoomIn(
                                        child: Image.asset(
                                          "assets/images/coming_soon.png",
                                        ),
                                      ),
                                    ),

                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       top: 20.0, left: 10.0, right: 10.0),
                                    //   child: Container(
                                    //     child: SizedBox(
                                    //       height: 0.1 *
                                    //           MediaQuery.of(context).size.width,
                                    //       child: Hero(
                                    //         tag: "yipli-logo",
                                    //         child: YipliLogoAnimatedSmall(),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    //* adventure content/text
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });

                  //TODO:Comment out this code after releasing Adventure Gaming.
                  //TODO: Pass Mat Tutorial done argument.

                  // InterAppCommunicationArguments args;
                  // print(
                  //     "Launching Game with Arguments adventure gaming: ${userModel.id}, ${currentPlayerModel.currentPlayerId}  ${currentMatModel.mat.matId} , chapIdx- ${adventureGamingData.playerProgress.currentIndex}");
                  // try {
                  //   args = new InterAppCommunicationArguments(
                  //       uId: userModel.id,
                  //       pId: currentPlayerModel.currentPlayerId,
                  //       pName: currentPlayerModel.player.name,
                  //       pDOB: currentPlayerModel.player.dob,
                  //       pHt: currentPlayerModel.player.height,
                  //       pWt: currentPlayerModel.player.weight,
                  //       pPicUrl: currentPlayerModel.player.profilePicUrl,
                  //       mId: currentMatModel.mat.matId,
                  //       mMac: currentMatModel.mat.macAddress,
                  //       agpIdx: adventureGamingData.playerProgress.currentIndex,
                  //       chapIdx:
                  //           adventureGamingData.playerProgress.currentIndex);
                  // } catch (e) {
                  //   print("Error of arg!!!");
                  //   print(e);
                  // }

                  // print("Play pressed! Sending arguments : ${args.toJson()}");
                  // YipliUtils.openAppWithArgs(androidUrl, args.toJson());
                },
              ),
            );
          });
    });
  }
}

//* Experience Points (XP) and Fitness Points widget

class XPandFitnessPoints extends StatelessWidget {
  final int coinsToCollect;
  final int xpToCollect;
  final AdventureGamingCardState adventureGamingCardState;
  const XPandFitnessPoints({
    Key key,
    this.adventureGamingCardState,
    this.coinsToCollect,
    this.xpToCollect,
  }) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    //below is done to convert the points in k format 1000(1k)
    var _fitnessPointsAdventureGamingInt =
        NumberFormat.compact().format(coinsToCollect);
    var _fitnessPointsAdventureGamingString =
        _fitnessPointsAdventureGamingInt.toString();

    //below is done to convert the points in k format 1000(1k)
    var _xpAdventureGamingInt = NumberFormat.compact().format(xpToCollect);
    var _xpAdventureGamingString = _xpAdventureGamingInt.toString();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 1500),
                      curve: Curves.elasticIn,
                      tween: Tween<double>(begin: 180, end: 0),
                      builder: (context, value, child) {
                        return RotationY(
                          rotationY: value,
                          child: ShowTooltip(
                            toolTipText: 'Yipli fitness coins',
                            child: Image.asset(
                              "assets/images/yipli_coin.png",
                              fit: BoxFit.contain,
                              height: (24 / 592) * _screenSize.height,
                            ),
                          ),
                        );
                      }),
                ),
                Text(_fitnessPointsAdventureGamingString)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 2000),
                      curve: Curves.elasticIn,
                      tween: Tween<double>(begin: 180, end: 0),
                      builder: (context, value, child) {
                        return RotationY(
                          rotationY: value,
                          child: ShowTooltip(
                            toolTipText: 'Yipli experience points',
                            child: Image.asset(
                              "assets/images/xp_coin.png",
                              fit: BoxFit.contain,
                              height: (24 / 592) * _screenSize.height,
                            ),
                          ),
                        );
                      }),
                ),
                Text(_xpAdventureGamingString)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
