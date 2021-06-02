// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/helpers/color_scheme.dart';
// import 'package:flutter_app/widgets/buttons.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:just_audio/just_audio.dart';

// import '../a_pages_index.dart';

// class UserOnBoardingFinalPage extends StatefulWidget {
//   static const String routeName =
//       '/user_on_boarding_final_page'; //f=flow,p=page
//   UserOnBoardingFinalPage({Key key}) : super(key: key);

//   @override
//   _UserOnBoardingFinalPageState createState() =>
//       _UserOnBoardingFinalPageState();
// }

// class _UserOnBoardingFinalPageState extends State<UserOnBoardingFinalPage>
//     with WidgetsBindingObserver {
//   void onLetsPlayButtonPress() {
//     _audioPlayer.dispose();
//     YipliUtils.goToHomeScreen();
//   }

//   AudioPlayer _audioPlayer;

//   ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: [
//     AudioSource.uri(
//       Uri.parse(YipliConstants.AudioAssetDirPath + "wellDonYouAreAllSet.mp3"),
//     ),
//     AudioSource.uri(
//       Uri.parse(
//           YipliConstants.AudioAssetDirPath + "YipliHasAnExtensiveLibrary.mp3"),
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
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
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
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     YipliButton letsPlayButton;
//     letsPlayButton = new YipliButton(
//       "Let's Play",
//       null,
//       null,
//       screenSize.width / 3,
//     );
//     letsPlayButton.setClickHandler(onLetsPlayButtonPress);
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
//                     if (state?.sequence?.isEmpty ?? true)
//                       return YipliLoaderMini();
//                     // print("Calling Play AudioSource");
//                     _audioPlayer.play();
//                     bool selected = false;
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Container(
//                             width: 120,
//                             height: 120,
//                             child: Align(
//                               alignment: Alignment.center,
//                               // child: Image.asset(YipliAssets.yipliLogoPath),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.topCenter,
//                             child: Text(
//                               'Well Done!\n You are all set to start playing.',
//                               style: Theme.of(context).textTheme.headline5,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Align(
//                             alignment: Alignment.topCenter,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(15.0),
//                               child: Image.asset(
//                                 "assets/images/girl_with_mat.png",
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Align(
//                             alignment: Alignment.topCenter,
//                             child: Text(
//                               "Explore the huge library of Yipli games.",
//                               style: Theme.of(context).textTheme.headline6,
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                         letsPlayButton
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
