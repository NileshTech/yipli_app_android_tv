import 'package:flutter_app/widgets/pop_up_for_rewards/pop_up_widget.dart';

import 'a_widgets_index.dart';
import 'package:intl/intl.dart';
import 'package:flare_flutter/flare_actor.dart';

class RewardListItem extends StatefulWidget {
  static const String routeName = "/reward_list_menu";
  RewardListItem({
    this.title,
    this.desc,
    this.rewards,
    this.rewardId,
    this.timestamp,
    this.playerId,
  }) : super();
  final String playerId;
  final String title;
  final String desc;
  final String rewards;
  final String rewardId;
  final String timestamp;

  @override
  _RewardListItemState createState() => _RewardListItemState();
}

class _RewardListItemState extends State<RewardListItem>
    with TickerProviderStateMixin {
  String userId;
  int currentPoints;
  PopUpMessageForRewardsCollection popUpMessage =
      PopUpMessageForRewardsCollection(
    titleText: "Congartulations",
    subTitleText: "Rewards added to your total fitness points",
    buttonText: "OK",
    imagePath: "assets/images/yipli_coin.png",
  );

  @override
  void initState() {
    userId = AuthService.getCurrentUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _screenSize = MediaQuery.of(context).size;
    int rewards = int.parse(widget.rewards);
    var rewardsFromDB = NumberFormat.compact().format(rewards);
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              FlipCard(
                key: cardKey,
                flipOnTouch: false,
                front: InkWell(
                  focusColor: androidTVFocusColor,
                  onTap: () {
                    cardKey.currentState.toggleCard();
                  },
                  child: AnimatedContainer(
                    curve: Curves.bounceIn,
                    duration: Duration(seconds: 1),
                    decoration: BoxDecoration(
                      color: yipliBlack,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context)
                            .accentColor, // red as border color
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/yipli_coin.png",
                                  height: _screenSize.height / 20,
                                ),
                                Text(rewardsFromDB == null
                                    ? ""
                                    : rewardsFromDB.toString())
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    "Added on ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                          color: yipliWhite,
                                        ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    widget.timestamp == null
                                        ? ""
                                        : widget.timestamp,
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                          color: yipliWhite,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  focusColor: androidTVFocusColor,
                                  onTap: () {
                                    cardKey.currentState.toggleCard();
                                  },
                                  child: Icon(
                                    FontAwesomeIcons.infoCircle,
                                    color: yipliGray,
                                    size: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RaisedButton(
                                  focusColor: androidTVFocusColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: yipliNewBlue),
                                  ),
                                  color: yipliNewBlue,
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) =>
                                            popUpMessage);
                                    String playerId = widget.playerId;
                                    currentPoints = rewards;
                                    getPlayerProfileRewards(
                                        currentPoints, playerId);
                                    removeRewardPointsFromInbox(playerId);
                                  },
                                  child: Text(
                                    "Get",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                          color: yipliWhite,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                back: InkWell(
                  focusColor: androidTVFocusColor,
                  onTap: () {
                    cardKey.currentState.toggleCard();
                  },
                  child: Container(
                      height: _screenSize.height / 8,
                      decoration: BoxDecoration(
                        color: yipliBlack,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).accentColor,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).accentColor,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 15,
                            child: InkWell(
                              focusColor: androidTVFocusColor,
                              onTap: () {
                                cardKey.currentState.toggleCard();
                              },
                              child: Icon(
                                Icons.close,
                                color: yipliGray,
                                size: 14,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: FlareActor("assets/flare/trophy.flr",
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                    animation: "trophy_success"),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      widget.desc,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: yipliBlack,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: yipliErrorRed, // red as border color
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Text(
                  widget.title == null ? "" : widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getPlayerProfileRewards(int pointsToBeUpdated, String currentPlayerId) async {
    DatabaseReference getPlyerFitnessPoints;
    getPlyerFitnessPoints = FirebaseDatabase.instance
        .reference()
        .child("profiles")
        .child("users")
        .child(userId)
        .child("players")
        .child(currentPlayerId)
        .child("activity-statistics")
        .child("total-fitness-points");
    DataSnapshot playerFitnessPoints = await getPlyerFitnessPoints.once();

    int playerDBPoints = playerFitnessPoints.value;

    int totalFitnessPoints = playerDBPoints + pointsToBeUpdated;

    Future<bool> currentFitnessPoints = FirebaseDatabase.instance
        .reference()
        .child("profiles")
        .child("users")
        .child(userId)
        .child("players")
        .child(currentPlayerId)
        .child("activity-statistics")
        .update({"total-fitness-points": totalFitnessPoints});

    return currentFitnessPoints;
  }

  removeRewardPointsFromInbox(String currentPlayerId) {
    FirebaseDatabaseUtil()
        .rootRef
        .child("inbox")
        .child(userId)
        .child(currentPlayerId)
        .child("special-rewards")
        .child(widget.rewardId)
        .remove();
    return print("Reward added to total fitness points...!");
  }
}
