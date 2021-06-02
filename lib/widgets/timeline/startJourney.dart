import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/database_models/adventure-gaming/database-interface.dart';
import 'package:flutter_app/pages/a_pages_index.dart';
import 'package:flutter_app/widgets/a_widgets_index.dart';
import 'package:supercharged/supercharged.dart';
import 'package:video_player/video_player.dart';

class StartJourney extends StatefulWidget {
  static const String routeName = "/startJourney";
  const StartJourney({Key key}) : super(key: key);

  @override
  _StartJourneyState createState() => _StartJourneyState();
}

class _StartJourneyState extends State<StartJourney> {
  VideoPlayerController _controller;

  bool _isLoadingScreen;

  @override
  void initState() {
    super.initState();
    try {
      _controller =
          VideoPlayerController.asset('assets/videos/journey/intro.webm')
            ..initialize().then((_) {
              // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
              setState(() {});
            });
    } catch (e) {
      print('unhandled exception - $e');
    }

    _controller.play();
    _controller.setLooping(true);
    _controller.setVolume(0.0);
    _isLoadingScreen = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('start journey printing');
    var startButton = YipliButton(
      "Start Journey",
      yipliLogoBlue,
      justwhite,
      (size.width * 0.8),
    );

    //* Add check hasSubscribed here before user is directed to AdvGaming page
    startButton.setClickHandler(() async {
      //* Add logic for setting up the player for Adventure Gaming
      setState(() {
        _isLoadingScreen = true;
      });
      CurrentPlayerModel currentPlayerModel =
          Provider.of<CurrentPlayerModel>(context, listen: false);
      if ((currentPlayerModel?.player) != null) {
        final DatabaseHandlerResponse databaseHandlerResponse =
            await PlayerProgressDatabaseHandler(
                    playerModel: currentPlayerModel.player)
                .startJourneyForPlayer();
        setState(() {
          _isLoadingScreen = false;
        });
        print('database handler response - $databaseHandlerResponse');
        switch (databaseHandlerResponse.statusCode) {
          case DatabaseHandlerStatusCode.SUCCESS:
            /*
            var localStorageKeyForPlayer =
                YipliUtils.getLocalStorageKeyForPlayer(
                    currentPlayerModel.player.id);
            //String data = YipliAppLocalStorage.getData(localStorageKeyForPlayer);
            PlayerLocalData currentPlayerData =
                PlayerLocalData(playerId: currentPlayerModel.player.id);

            await YipliAppLocalStorage.putData(
                localStorageKeyForPlayer, currentPlayerData.toJson());
            */
            YipliUtils.gotoAdventureGaming();
            break;
          case DatabaseHandlerStatusCode.FAIL:
            // TODO: Handle this case.
            YipliUtils.goToHomeScreen();

            break;
        }
      }
      //* Go to Adventure Gaming
    });

    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: _controller.value.initialized
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller.value.size?.width ?? 0,
                        height: _controller.value.size?.height ?? 0,
                        child: VideoPlayer(_controller),
                      ),
                    ),
                  )
                : Container(
                    color: appbackgroundcolor,
                    child: YipliLoader(),
                  ),
          ),

          //* Gradient over the background video

          Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  appbackgroundcolor.withOpacity(0.8),
                  appbackgroundcolor.withOpacity(0.1),
                ],
                stops: [0.2, 0.8],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedFadeUpText(),
              _controller.value.initialized
                  ? Padding(
                      padding: const EdgeInsets.all(25.0), child: startButton)
                  : Container(),
            ],
          ),
          ModalProgressHUD(inAsyncCall: _isLoadingScreen, child: Container()),
          Positioned(
            right: 10,
            top: 20,
            child: IconButton(
              focusColor: androidTVFocusColor,
              icon: Icon(
                FontAwesomeIcons.timesCircle,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                YipliUtils.navigatorKey.currentState
                    .pushReplacementNamed(FitnessGaming.routeName);
              },
            ),
          ),
        ],
      ),
    );
  }
}

//* Creates the animated text widget that changes the text input every 3 seconds
//* To change the text displayed, change the <screenTextList> content below.

class AnimatedFadeUpText extends StatefulWidget {
  AnimatedFadeUpText({
    Key key,
  }) : super(key: key);

  @override
  _AnimatedFadeUpTextState createState() => _AnimatedFadeUpTextState();
}

class _AnimatedFadeUpTextState extends State<AnimatedFadeUpText> {
  String screenText = "";

  int pos = 0;

  List<String> screenTextList = [
    "Welcome to Adventure Gaming",
    "Workouts can be fun too",
    "Start your journey today!"
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 8),
        child: FadeInUp(
          key: UniqueKey(),
          preferences: AnimationPreferences(
            duration: 1000.milliseconds,
            animationStatusListener: (status) {
              switch (status) {
                case AnimationStatus.completed:
                  Timer(1200.milliseconds, () {
                    setState(() {
                      screenText = screenTextList[pos];
                      pos = pos > 2 ? 0 : pos + 1;
                      pos = pos == 3 ? null : pos;
                    });
                  });
                  break;
                case AnimationStatus.dismissed:

                case AnimationStatus.forward:

                case AnimationStatus.reverse:
                  break;
              }
            },
          ),
          child: Text(
            screenText,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.w900, color: yipliLogoOrange),
          ),
        ),
      ),
    );
  }
}
