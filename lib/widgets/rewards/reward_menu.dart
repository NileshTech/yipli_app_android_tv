import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/helpers/color_scheme.dart';
import 'package:flutter_app/helpers/utils.dart';
import 'package:flutter_app/page_models/reward_model.dart';
import 'package:flutter_app/pages/games_page.dart';
import 'package:flutter_app/widgets/rewards_list_item.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

const String GOLD_REWARD_TITLE = "Gold";
const String GOLD_REWARD_INFO =
    "Play for 15+ min in a day to earn 10k extra fitness points.";
const String SILVER_REWARD_TITLE = "Silver";
const String SILVER_REWARD_INFO =
    "Burn 25+ calories in a day to earn 10k extra fitness points.";
const String PLATINUM_REWARD_TITLE = "Platinum";
const String PLATINUM_REWARD_INFO =
    "Play for 30+ min in a day to earn 25k extra fitness points.";
const String DIAMOND_REWARD_TITLE = "Diamond";
const String DIAMOND_REWARD_INFO =
    "Burn 75+ calories in a day to earn 25k extra fitness points.";
const String NO_REWARD_FOUND_INFO =
    "No rewards found. Play more games to unlock exciting rewards.";

class RewardMenuWidget extends StatefulWidget {
  final String currentPlayerId;

  const RewardMenuWidget(this.currentPlayerId, {Key key}) : super(key: key);

  @override
  _RewardMenuWidgetState createState() => _RewardMenuWidgetState();
}

class _RewardMenuWidgetState extends State<RewardMenuWidget> {
  int totalRewardedPoints = 0;
  @override
  void initState() {
    super.initState();
  }

  //Information about special rewards to show to new player
  Widget rewardInfoTile(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Divider(thickness: 2, color: yipliBlack),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: yipliBlack,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: yipliErrorRed,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          content,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewardsModel>(
      create: (rewardsModelCtx) {
        RewardsModel rewardsModel =
            RewardsModel.initialize(widget.currentPlayerId);
        return rewardsModel;
      },
      child: Consumer<RewardsModel>(
        builder: (rewardsModelConsumerCtx, rewardsModel, child) {
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

            //No rewards found UI with pop-up infoabout our special rewards
            return Center(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NO_REWARD_FOUND_INFO,
                        style: Theme.of(context).textTheme.headline6.copyWith(),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        focusColor: androidTVFocusColor,
                        child: Icon(Icons.info, color: yipliGray),
                        onTap: () {
                          showGeneralDialog(
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionBuilder: (
                                context,
                                a1,
                                a2,
                                widget,
                              ) {
                                return Transform.scale(
                                  scale: a1.value,
                                  child: Opacity(
                                    opacity: a1.value,
                                    child: AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      shape: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
                                      title: Container(
                                        child: Text(
                                          "How to earn \nSpecial Rewards",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                color: Theme.of(context)
                                                    .accentColor,
                                              ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      content: Container(
                                        height: _screenSize.height / 3,
                                        child: SingleChildScrollView(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          child: Column(
                                            children: [
                                              rewardInfoTile(GOLD_REWARD_TITLE,
                                                  GOLD_REWARD_INFO),
                                              rewardInfoTile(
                                                  PLATINUM_REWARD_TITLE,
                                                  PLATINUM_REWARD_INFO),
                                              rewardInfoTile(
                                                  SILVER_REWARD_TITLE,
                                                  SILVER_REWARD_INFO),
                                              rewardInfoTile(
                                                  DIAMOND_REWARD_TITLE,
                                                  DIAMOND_REWARD_INFO),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              transitionDuration: Duration(milliseconds: 200),
                              barrierDismissible: true,
                              barrierLabel: '',
                              context: context,
                              pageBuilder:
                                  (context, animation1, animation2) {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            //Mian UI for collecting Special rewards earned by user.
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ListView.builder(
                    itemCount: rewardsModel.allRewards.length,
                    itemBuilder: (rewardsListCtx, currentIndex) {
                      totalRewardedPoints += int.parse(
                          rewardsModel.allRewards[currentIndex].rewards);
                      print("rewards ponits addition : " +
                          totalRewardedPoints.toString());
                      Widget widgetToAdd = (currentIndex <
                              rewardsModel.allRewards.length)
                          ? RewardListItem(
                              desc: rewardsModel.allRewards[currentIndex].desc,
                              title:
                                  rewardsModel.allRewards[currentIndex].title,
                              rewards:
                                  rewardsModel.allRewards[currentIndex].rewards,
                              timestamp: rewardsModel
                                  .allRewards[currentIndex].timestamp,
                              playerId: widget.currentPlayerId,
                              rewardId: rewardsModel
                                  .allRewards[currentIndex].rewardId,
                            )
                          : SizedBox(
                              height:
                                  ((MediaQuery.of(context).size.height - 112) /
                                      6));

                      return AnimationConfiguration.staggeredList(
                          delay: Duration(milliseconds: 120),
                          position: currentIndex,
                          duration: const Duration(milliseconds: 600),
                          child: SlideAnimation(
                            //delay: Duration(milliseconds: 120),
                            verticalOffset: 50.0,
                            child: FadeInAnimation(child: widgetToAdd),
                          ));
                    }),
              ),
            );
          }
        },
      ),
    );
  }
}
