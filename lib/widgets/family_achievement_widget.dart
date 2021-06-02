import 'package:intl/intl.dart';

import 'a_widgets_index.dart';

class FamilyAchievementWidget extends StatelessWidget {
  final String mainHeadingText;
  final String playerImage;
  final String playerName;
  final Color picBorderColor;

  final String bodyText;
  final IconData achievementIcon;
  final Color achievementIconColor;
  final double achievementIconSize;
  final int playerFitnessPoints;
  final int playerCalories;
  final int playerTotalDuration;
  final String backCardInfo;
  final String backMainHeadingText;
  final bool dataAvailable;
  final int playerExperiencePoints;

  final Duration animationDelay;

  FamilyAchievementWidget(
      {this.mainHeadingText,
      this.playerImage,
      this.picBorderColor,
      this.bodyText,
      this.achievementIcon,
      this.achievementIconColor,
      this.achievementIconSize,
      this.playerName,
      this.playerFitnessPoints,
      this.playerCalories,
      this.playerTotalDuration,
      this.backCardInfo,
      this.backMainHeadingText,
      this.dataAvailable = false,
      this.playerExperiencePoints,
      this.animationDelay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        front: buildPlayerFrontCard(context),
        //back information card
        back: Card(
          margin: EdgeInsets.all(2.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0))),
          color: Theme.of(context).primaryColorLight.withOpacity(.1),
          child: Column(
            children: <Widget>[
              ///close icon back card
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Icon(
                            FontAwesomeIcons.times,
                            color: yipliGray,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            achievementIcon,
                            color: achievementIconColor,
                            size: 20,
                          ),
                        ),
                        Flexible(
                          child: Text(backMainHeadingText,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      fontSize: 16.0, color: yipliLogoOrange)),
                        ),
                      ],
                    ),
                    Center(
                        child: new Row(children: <Widget>[
                      new Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8),
                          child: new Text(backCardInfo,
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                      ),
                    ]))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPlayerFrontCard(BuildContext context) {
    //below is done to convert the points in k format 1000(1k)
    var _fitnesspointsint = NumberFormat.compact().format(playerFitnessPoints);
    var _fitnessPointsString = _fitnesspointsint.toString();

    //below is done to convert the points in k format 1000(1k)
    var _playerCaloriesint = NumberFormat.compact().format(playerCalories);
    var _playerCaloriesString = _playerCaloriesint.toString();

    // "${(int.parse(widget?.gamesStats?.duration ?? '0') / 60).round().toString()} min."
    var _playerDurationString =
        ((playerTotalDuration ?? 0) / 60).round().toString();
    //below is done to convert the points in k format 1000(1k)
    var _experiencePointsInt =
        NumberFormat.compact().format(playerExperiencePoints);
    var _experiencePointsString = _experiencePointsInt.toString();

    return dataAvailable
        ? Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Stack(
                  children: [
                    Card(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(.1),
                      margin: EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        //column containg player info fp, xp, cal, duration
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                ///player achievement details icon
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    //row for icon and calories
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Icon(
                                            FontAwesomeIcons.dumbbell,
                                            size: 14.0,
                                          ),
                                        ),
                                        Text('$_playerCaloriesString Cal',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(fontSize: 14.0)),
                                      ],
                                    ),
                                    //row for icon and time taken
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Icon(
                                            FontAwesomeIcons.solidClock,
                                            size: 14.0,
                                          ),
                                        ),
                                        Text("$_playerDurationString min.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(fontSize: 14.0)),
                                      ],
                                    ),
                                  ],
                                ),

                                ///player achievement details icon - right side
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    //row for icon and Fp
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('$_fitnessPointsString',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(fontSize: 14.0)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.0),
                                          child: SizedBox(
                                            width: 25.0,
                                            height: 25.0,
                                            child: YipliCoin(coinPadding: 0.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //row for icon and Xp
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text('$_experiencePointsString',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                .copyWith(fontSize: 14.0)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6.0),
                                          child: SizedBox(
                                            width: 16.0,
                                            height: 16.0,
                                            child: Image.asset(
                                              "assets/images/xp_coin.png",
                                              fit: BoxFit.contain,
                                              height: 40.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: PlayAnimation<double>(
                                  curve: Curves.decelerate,
                                  duration: 1000.milliseconds,
                                  delay: animationDelay,
                                  tween: (0.0).tweenTo(1.0),
                                  builder: (context, child, value) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Icon(
                                              achievementIcon,
                                              color: achievementIconColor,
                                              size: achievementIconSize,
                                            ),
                                          ),
                                          Text(mainHeadingText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  .copyWith(
                                                      fontSize: 18.0,
                                                      color: Theme.of(context)
                                                          .primaryColorLight)),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, right: 10.0),
                          child: Icon(
                            FontAwesomeIcons.infoCircle,
                            color: yipliGray,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: YipliConstants.getProfilePicDimensionsSmall(
                                  context)
                              .width,
                          height: YipliConstants.getProfilePicDimensionsSmall(
                                  context)
                              .height,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: playerImage == null || playerImage == ""
                                  ? AssetImage(
                                      "assets/images/placeholder_image.png")
                                  : FirebaseImage(
                                      "${FirebaseStorageUtil.profilepics}/$playerImage"),
                            ),
                            borderRadius: BorderRadius.circular(90.0),
                            border: Border.all(
                              color: picBorderColor,
                              width: 3.0,
                            ),
                          ),
                        ),

                        //player name
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(playerName,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(fontSize: 18.0)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Card(
                    color: Theme.of(context).primaryColorLight.withOpacity(.1),
                    margin: EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0))),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                achievementIcon,
                                color: achievementIconColor,
                                size: 20,
                              ),
                            ),
                            Text(mainHeadingText,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(
                                        fontSize: 18.0,
                                        color: Theme.of(context)
                                            .primaryColorLight)),
                          ],
                        ),
                        Text("No player data found!",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: yipliLogoOrange)),
                      ],
                    ))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0, right: 10.0),
                    child: Icon(
                      FontAwesomeIcons.infoCircle,
                      color: yipliGray,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
