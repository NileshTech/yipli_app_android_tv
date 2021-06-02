import 'package:flutter_app/classes/classes_index.dart';
import 'package:flutter_app/database_models/adventure-gaming/adventure-gaming-video-watched.dart';
import 'package:flutter_app/database_models/adventure-gaming/database-interface.dart';
import 'package:flutter_app/pages/a_pages_index.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'a_widgets_index.dart';

class AdventurePlayerProfileWidget extends StatelessWidget {
  final int playerClassesComplete;
  final int playerTotalCollectedCoins;
  final int playerTotalCollectedXp;
  final double averagePlayerRating;
  final double progressPercentage;

  const AdventurePlayerProfileWidget({
    Key key,
    this.playerClassesComplete,
    this.playerTotalCollectedCoins,
    this.playerTotalCollectedXp,
    this.averagePlayerRating,
    this.progressPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;

    return Consumer<CurrentPlayerModel>(
        builder: (context, currentPlayerModel, child) {
      if (currentPlayerModel == null) return YipliLoader();
      PlayerProgressDatabaseHandler playerProgressDatabaseHandler =
          PlayerProgressDatabaseHandler(playerModel: currentPlayerModel.player);

      return AdventureGamingVideoWatchedValidator(
          playerModel: currentPlayerModel.player,
          builder: (context, hasWatchedVideoSnapshot) {
            // check if the player has watched the video if yes show the player details else show no subscription widget
            if (!(hasWatchedVideoSnapshot?.data ?? false)) {
              return Card(
                color: Colors.transparent,
                margin: EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                )),
                child: Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'You have not started your Adventure Gaming Journey.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: yipliLogoBlue,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Icon(
                              FontAwesomeIcons.sadTear,
                              size: 50.0,
                              color: yipliLogoBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return Card(
              color: Theme.of(context).primaryColorLight.withOpacity(.1),
              margin: EdgeInsets.only(top: 2.0, left: 2.0, right: 2.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              )),
              child: Column(
                children: [
                  //player class complete - row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Text(
                            '$playerClassesComplete',
                            style: Theme.of(context)
                                .textTheme
                                .headline3
                                .copyWith(color: yipliLogoOrange),
                          ),
                        ),
                        Text(
                          'Classes Completed',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),

                  //player average rating widget
                  RatingBar(
                    unratedColor: appbackgroundcolor,
                    itemSize: 0.1 * _screenSize.width,
                    initialRating: averagePlayerRating,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 0.1 * _screenSize.width,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating - rating);
                    },
                  ),
                  //player total Points and Xp collected - row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 60.0,
                              height: 60.0,
                              child: YipliCoin(coinPadding: 0.0),
                            ),
                            Text(
                              '$playerTotalCollectedCoins',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: yipliLogoOrange),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Image.asset(
                                "assets/images/xp_coin.png",
                                fit: BoxFit.contain,
                                height: 50.0,
                              ),
                            ),
                            Text(
                              '$playerTotalCollectedXp',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: yipliLogoOrange),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    });
  }
}
