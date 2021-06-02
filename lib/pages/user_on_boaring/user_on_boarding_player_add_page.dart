// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/classes/arguments/PageArgumentsClasses.dart';
// import 'package:flutter_app/classes/userOnBoardingFlow.dart';
// import 'package:flutter_app/helpers/color_scheme.dart';
// import 'package:flutter_app/helpers/utils.dart';
// import 'package:flutter_app/widgets/buttons.dart';
// import 'package:flutter_app/widgets/confirmation_box/confirmation_widget.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../a_pages_index.dart';

// const PLAYER_ADD_TITLE = "Let's add a player";
// const PLAYER_ADD_INSTRUCTION =
//     'You need atleast 1 Player \n to start Yipli Gaming !';

// class UserOnBoardingPlayerAddPage extends StatefulWidget {
//   static const String routeName =
//       '/user_on_boarding_player_add_page'; //f=flow,p=page

//   @override
//   _UserOnBoardingPlayerAddPageState createState() =>
//       _UserOnBoardingPlayerAddPageState();
// }

// class _UserOnBoardingPlayerAddPageState
//     extends State<UserOnBoardingPlayerAddPage> with WidgetsBindingObserver {
//   void onNextPress() {
//     _audioPlayer.dispose();
//     YipliUtils.goToPlayerOnBoardingPage(
//         new PlayerPageArguments(allPlayerDetails: null));
//   }

//   AudioPlayer _audioPlayer;

//   ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: [
//     AudioSource.uri(
//       Uri.parse(YipliConstants.AudioAssetDirPath + "YouAreJustFewStepAway.mp3"),
//     ),
//     AudioSource.uri(
//       Uri.parse(YipliConstants.AudioAssetDirPath + "letsAddAPlayer.mp3"),
//     ),
//   ]);
//   @override
//   void initState() {
//     super.initState();
//     _audioPlayer = AudioPlayer();
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.black,
//     ));
//     _initAudioPlayer();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   _initAudioPlayer() async {
//     final session = await AudioSession.instance;
//     await session.configure(AudioSessionConfiguration.speech());
//     try {
//       await _audioPlayer.setAudioSource(_playlist);
//       print('Audio source loaded');
//     } catch (e) {
//       // catch load errors: 404, invalid url ...
//       print("An error occured in audio source setting : $e");
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       //stop audio player
//       _audioPlayer.pause();
//     } else {
//       _audioPlayer.play();
//       print(state.toString());
//     }
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     YipliButton nextButton;

//     //yipli 'Process Cancel Confirmation' widget.
//     ProcessCancelConfirmationDialog exitConfirmationDialog =
//         ProcessCancelConfirmationDialog(
//       titleText: "Exit Setup ?",
//       subTitleText: "If you exit you can't use Yipli",
//       buttonText: "Continue Setting-Up",
//       pressToExitText: "Skip for now",
//     );
//     exitConfirmationDialog.setClickHandler(() {
//       _audioPlayer.dispose();
//       YipliUtils.goToHomeScreen();
//       YipliUtils.showNotification(
//           context: context,
//           msg: "No player added.\nAdd player from Menu -> Players.",
//           type: SnackbarMessageTypes.ERROR,
//           duration: SnackbarDuration.LONG);
//     });
//     nextButton = new YipliButton(
//       "Next",
//       null,
//       null,
//       screenSize.width / 5,
//     );
//     nextButton.setClickHandler(onNextPress);
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Container(
//             decoration: BoxDecoration(
//                 border: Border.all(
//                   color: yipliNewBlue,
//                   width: 1,
//                 ),
//                 borderRadius: BorderRadius.all(Radius.circular(10))),
//             child: Padding(
//               padding: const EdgeInsets.all(15.0),
//               child: StreamBuilder<SequenceState>(
//                   stream: _audioPlayer.sequenceStateStream,
//                   builder: (context, snapshot) {
//                     final state = snapshot.data;
//                     if (state?.sequence?.isEmpty ?? true) return SizedBox();
//                     // print("Calling Play AudioSource");
//                     _audioPlayer.play();
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text("Step",
//                                 textAlign: TextAlign.center,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyText1
//                                     .copyWith(color: yipliGray)),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Text("2",
//                                     textAlign: TextAlign.center,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText2
//                                         .copyWith(fontWeight: FontWeight.w600)),
//                                 Text(" / 2",
//                                     textAlign: TextAlign.center,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText1
//                                         .copyWith(color: yipliGray)),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: Text(
//                               PLAYER_ADD_TITLE,
//                               style: Theme.of(context).textTheme.headline5,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Expanded(
//                                 child: Icon(FontAwesomeIcons.running),
//                               ),
//                               Expanded(
//                                 child: Text(PLAYER_ADD_INSTRUCTION,
//                                     textAlign: TextAlign.center,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .headline6
//                                         .copyWith(color: yipliGray)),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.bottomCenter,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 InkWell(
//                                   onTap: () async {
//                                     SharedPreferences prefs =
//                                         await SharedPreferences.getInstance();
//                                     prefs.setBool('player_add_skipped', true);
//                                     showDialog(
//                                         context: context,
//                                         barrierDismissible: false,
//                                         builder: (BuildContext context) =>
//                                             exitConfirmationDialog);
//                                   },
//                                   child: Text(
//                                     'Not now',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText2
//                                         .copyWith(color: yipliErrorRed),
//                                   ),
//                                 ),
//                                 nextButton,
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
