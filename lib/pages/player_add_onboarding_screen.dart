// import 'package:flutter/cupertino.dart';

// import 'package:flutter_app/external_plgins/number_picker.dart';
// import 'package:flutter_app/helpers/helper_index.dart';
// import 'package:flutter_app/pages/user_on_boaring/user_on_boarding_final_page.dart';
// import 'package:intl/intl.dart';
// import 'a_pages_index.dart';

// class PlayerOnBoarding extends StatefulWidget {
//   static const String routeName = "/player_onboarding_screen";

//   @override
//   _PlayerOnBoardingState createState() => _PlayerOnBoardingState();
// }

// class _PlayerOnBoardingState extends State<PlayerOnBoarding> {
//   TextEditingController textEditingController = new TextEditingController();
//   String _fullName = "";
//   String _gender = "";
//   String _dob = "01-Jan-2000";
//   String _weight = 39.toString();
//   String _height = 161.toString();
//   String _profilePicUrl;
//   FileImage _profilePic;
//   PlayerDetails playerTile;
//   String _defaultPic = "assets/images/default_image_placeholder.jpg";
//   int _currentHeightValue = 162;
//   int _currentWeightValue = 40;
//   var result;
//   GlobalKey _introScreenKey = new GlobalKey();
//   bool _isButtonEnabled = true;
//   DatabaseReference pathRef;

//   String minDatetime = '01-01-1960';
//   String maxDatetime = '11-26-2020';
//   String initDatetime = '02-02-2000';
//   List<PlayerModel> allPlayersModels = new List<PlayerModel>();
//   PlayerPageArguments playerPageArguments;
//   // UserOnBoardingFlows flowValue;
//   bool bIsNewRecord = true;

//   bool bPlayerAddInProcess = false;

//   //Birth day picker widget
//   Widget dataPicker(BuildContext context) {
//     final theme = CupertinoTheme.of(context);
//     final textTheme = theme.textTheme.copyWith(
//         dateTimePickerTextStyle:
//             TextStyle(color: Theme.of(context).accentColor, fontSize: 20.0));
//     return Container(
//       height: MediaQuery.of(context).size.height / 4,
//       child: CupertinoTheme(
//         data: theme.copyWith(
//           textTheme: textTheme,
//           brightness: Brightness.dark,
//         ),
//         child: CupertinoDatePicker(
//           onDateTimeChanged: (DateTime newDate) {
//             _dob = DateFormat('dd-MMM-yyyy').format(newDate);
//             setState(() {
//               print('dob=$_dob');
//             });
//           },
//           maximumDate: new DateTime(2018, 12, 30),
//           minimumYear: 1960,
//           maximumYear: 2018,
//           minuteInterval: 1,
//           initialDateTime: new DateTime(2000, 1, 1),
//           mode: CupertinoDatePickerMode.date,
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileImage(BuildContext context) {
//     print("Building the player profile image");
//     return GestureDetector(
//         child: Icon(
//           FontAwesomeIcons.camera,
//           size: Theme.of(context).textTheme.headline4.fontSize,
//           color: Theme.of(context).primaryColor,
//         ),
//         onTap: () async {
//           var fileName = Uuid().v4();
//           print("FILENAME : $fileName");
//           Size sizeToUpload = new Size(512, 512);
//           if (result != null) {
//             result.uploadTask.cancel();
//           }

// // New user is not having playerid,profilepicurl and pathref so passing null initially
//           result = await YipliUtils.profilePicOptions(
//               context, sizeToUpload, fileName, null, null, null);
//           if (result != null) {
//             setState(() {
//               _profilePic = FileImage(result.imageFile);
//             });
//             result.uploadTask.events.listen((uploadTaskEvent) {
//               switch (uploadTaskEvent.type) {
//                 case StorageTaskEventType.resume:
//                   break;
//                 case StorageTaskEventType.progress:
//                   break;
//                 case StorageTaskEventType.pause:
//                   break;
//                 case StorageTaskEventType.success:
//                   setState(() {
//                     _profilePicUrl = fileName;
//                     _profilePic = FileImage(result.imageFile);
//                   });

//                   YipliUtils.showNotification(
//                     context: context,
//                     msg: "Profile Picture set.",
//                     duration: SnackbarDuration.SHORT,
//                     type: SnackbarMessageTypes.SUCCESS,
//                   );

//                   break;
//                 case StorageTaskEventType.failure:
//                   YipliUtils.showNotification(
//                     context: context,
//                     msg: "Picture upload failed. Please retry.",
//                     duration: SnackbarDuration.SHORT,
//                     type: SnackbarMessageTypes.ERROR,
//                   );
//                   break;
//               }
//             });
//           }
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     playerPageArguments = new PlayerPageArguments();
//     playerPageArguments = ModalRoute.of(context).settings.arguments;
//     // flowValue = playerPageArguments.flowValue;
//     allPlayersModels = playerPageArguments.allPlayerDetails == null
//         ? new List<PlayerModel>()
//         : playerPageArguments.allPlayerDetails;
//     print("Recieved  players in add player screen");
//     Size screenSize = MediaQuery.of(context).size;

//     ///name
//     PageViewModel pageViewModel1 = new PageViewModel(
//       decoration: PageDecoration(
//         pageColor: Theme.of(context).backgroundColor,
//         titleTextStyle: Theme.of(context).textTheme.headline5,
//       ),
//       title: "What can we call you?",
//       bodyWidget: SingleChildScrollView(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: TextField(
//                   style: Theme.of(context).textTheme.bodyText2,
//                   onChanged: (_) {
//                     _fullName = textEditingController.text;
//                     _fullName = _fullName.trim();
//                     setState(() {
//                       return _fullName;
//                     });
//                     print("the player name is: $_fullName");
//                   },
//                   controller: textEditingController,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Theme.of(context).primaryColorLight,
//                       ),
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     hintText: 'Player Name',
//                     hintStyle: Theme.of(context).textTheme.bodyText2,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: screenSize.height / 40,
//               ),
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Icon(
//                       FontAwesomeIcons.smileWink,
//                       color: IconTheme.of(context).color,
//                     ),
//                     AutoSizeText.rich(
//                       TextSpan(
//                           text:
//                               "Name should be more than two characters.\nBe creative and don't enter duplicate names.",
//                           style: Theme.of(context).textTheme.caption),
//                       maxLines: 4,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ]),
//             ]),
//       ),
//       image: Center(
//         child: Image.asset(
//           "assets/images/Name.png",
//           height: screenSize.height / 1,
//           width: screenSize.width,
//         ),
//       ),
//     );

//     ///gender
//     PageViewModel pageViewModel2 = new PageViewModel(
//       decoration: PageDecoration(
//         pageColor: Theme.of(context).backgroundColor,
//         titleTextStyle: Theme.of(context).textTheme.headline6,
//       ),
//       title: '',
//       bodyWidget: Column(
//         children: [
//           Padding(
//             padding:
//                 EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
//             child: Container(
//               // height: MediaQuery.of(context).size.height * 0.2,
//               child: Image.asset(
//                 "assets/images/Gender.png",
//                 height: screenSize.height / 4,
//                 width: screenSize.width * 0.7,
//               ),
//             ),
//           ),
//           Padding(
//             padding:
//                 EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Theme(
//                   data: Theme.of(context).copyWith(
//                       unselectedWidgetColor: Theme.of(context).accentColor),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Tell us your gender',
//                           style: Theme.of(context).textTheme.headline5),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       RadioButtonGroup(
//                         orientation: GroupedButtonsOrientation.HORIZONTAL,
//                         activeColor: Theme.of(context).accentColor,
//                         onSelected: (String selected) => setState(() {
//                           _gender = selected;
//                         }),
//                         labels: <String>["Male", "Female"],
//                         labelStyle: Theme.of(context).textTheme.subtitle1,
//                         picked: _gender,
//                         itemBuilder: (Radio rb, Text txt, int i) {
//                           return Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: <Widget>[
//                               rb,
//                               txt,
//                             ],
//                           );
//                         },
//                       ),
//                       RadioButtonGroup(
//                         orientation: GroupedButtonsOrientation.HORIZONTAL,
//                         activeColor: Theme.of(context).accentColor,
//                         onSelected: (String selected) => setState(() {
//                           _gender = selected;
//                         }),
//                         labels: <String>["Non-binary"],
//                         labelStyle: Theme.of(context).textTheme.subtitle1,
//                         picked: _gender,
//                         itemBuilder: (Radio rb, Text txt, int i) {
//                           return Row(
//                             mainAxisSize: MainAxisSize.max,
//                             children: <Widget>[
//                               rb,
//                               txt,
//                             ],
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );

//     ///Age
//     final theme = Theme.of(context);
//     PageViewModel pageViewModel3 = new PageViewModel(
//       decoration: PageDecoration(
//         pageColor: Theme.of(context).backgroundColor,
//         titleTextStyle: Theme.of(context).textTheme.headline5,
//       ),
//       title: "",
//       bodyWidget: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Center(
//               child: Image.asset(
//                 "assets/images/Age.png",
//                 height: screenSize.height / 4,
//                 width: screenSize.width * 0.7,
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Tell us your age.\nIt will be a secret, Yipli promise.',
//             style: Theme.of(context).textTheme.headline6,
//             textAlign: TextAlign.center,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 dataPicker(context),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   "DOB : " + _dob,
//                   style: Theme.of(context).textTheme.subtitle1,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );

//     ///height weight
//     PageViewModel pageViewModel4 = new PageViewModel(
//       decoration: PageDecoration(
//         pageColor: Theme.of(context).backgroundColor,
//         titleTextStyle: Theme.of(context).textTheme.headline5,
//       ),
//       title: "",
//       bodyWidget: Column(
//         children: [
//           Center(
//             child: Image.asset(
//               YipliAssets.yipliAddPlayerSliderImage_02,
//               height: screenSize.height / 4,
//               width: screenSize.width * 0.7,
//             ),
//           ),
//           SizedBox(height: 20),
//           Text(
//             "Don't be shy!!",
//             style: Theme.of(context).textTheme.headline5,
//           ),
//           Container(
//             width: screenSize.width * 0.9,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Theme(
//                     data: theme.copyWith(
//                         accentColor: Colors.white, // highlted color
//                         textTheme: theme.textTheme.copyWith(
//                           headline5: theme.textTheme.headline5.copyWith(
//                               color: Theme.of(context).primaryColorLight,
//                               fontSize: 12),
//                         )),
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(
//                           height: 20,
//                         ),
//                         new NumberPicker.integer(
//                           initialValue: _currentWeightValue,
//                           minValue: 20,
//                           maxValue: 200,
//                           onChanged: (newValue) => setState(() {
//                             _currentWeightValue = newValue;
//                             _weight = _currentWeightValue.toString();
//                           }),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Row(
//                           children: [
//                             new Text(
//                               "Weight",
//                               style: Theme.of(context).textTheme.subtitle1,
//                             ),
//                             new Text(
//                               "(kg)",
//                               style: Theme.of(context).textTheme.subtitle1,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   Theme(
//                     data: theme.copyWith(
//                         accentColor: Colors.white, // highlted color
//                         textTheme: theme.textTheme.copyWith(
//                           headline5: theme.textTheme.headline5.copyWith(
//                               color: Theme.of(context).primaryColorLight,
//                               fontSize: 12),
//                         )),
//                     child: Column(
//                       children: <Widget>[
//                         SizedBox(
//                           height: 20,
//                         ),
//                         new NumberPicker.integer(
//                           initialValue: _currentHeightValue,
//                           minValue: 20,
//                           maxValue: 200,
//                           onChanged: (newValue) => setState(() {
//                             _currentHeightValue = newValue;
//                             _height = _currentHeightValue.toString();
//                           }),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Row(
//                           children: [
//                             new Text(
//                               "Height",
//                               style: Theme.of(context).textTheme.subtitle1,
//                             ),
//                             new Text(
//                               "(cms)",
//                               style: Theme.of(context).textTheme.subtitle1,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     ///Profile Pic
//     PageViewModel pageViewModel5 = new PageViewModel(
//       decoration: PageDecoration(
//         pageColor: Theme.of(context).backgroundColor,
//         titleTextStyle: Theme.of(context).textTheme.headline5,
//       ),
//       title: '',
//       bodyWidget: InkWell(
//         onTap: () async {
//           var fileName = Uuid().v4();
//           print("FILENAME : $fileName");
//           Size sizeToUpload = new Size(512, 512);
//           if (result != null) {
//             result.uploadTask.cancel();
//           }

//           result = await YipliUtils.profilePicOptions(context, sizeToUpload,
//               fileName, playerTile.playerId, playerTile.profilePicUrl, pathRef);
//           if (result != null) {
//             setState(() {
//               _profilePic = FileImage(result.imageFile);
//             });
//             result.uploadTask.events.listen((uploadTaskEvent) {
//               switch (uploadTaskEvent.type) {
//                 case StorageTaskEventType.resume:
//                   break;
//                 case StorageTaskEventType.progress:
//                   break;
//                 case StorageTaskEventType.pause:
//                   break;
//                 case StorageTaskEventType.success:
//                   setState(() {
//                     _profilePicUrl = fileName;
//                     _profilePic = FileImage(result.imageFile);
//                   });
//                   YipliUtils.showNotification(
//                     context: context,
//                     msg: "Profile Picture set.",
//                     duration: SnackbarDuration.SHORT,
//                     type: SnackbarMessageTypes.SUCCESS,
//                   );

//                   break;
//                 case StorageTaskEventType.failure:
//                   YipliUtils.showNotification(
//                     context: context,
//                     msg: "Picture upload failed. Please retry.",
//                     duration: SnackbarDuration.SHORT,
//                     type: SnackbarMessageTypes.ERROR,
//                   );
//                   break;
//               }
//             });
//           }
//         },
//         child: Column(
//           children: [
//             Text(
//               'Choose your profile pic',
//               style: Theme.of(context).textTheme.headline5,
//             ),
//             Container(
//               height: screenSize.height / 4,
//               width: screenSize.width * 0.7,
//               child: Center(
//                 child: Text(
//                   'Hi,\n$_fullName',
//                   style: Theme.of(context)
//                       .textTheme
//                       .headline4
//                       .copyWith(color: yipliNewBlue),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             Stack(children: <Widget>[
//               Center(
//                 child: Container(
//                     width: screenSize.width,
//                     height: screenSize.height / 4,
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         image: DecorationImage(
//                             image: _profilePic == null
//                                 ? AssetImage(_defaultPic)
//                                 : _profilePic,
//                             fit: BoxFit.cover))),
//               ),
//               Container(
//                 width: screenSize.width,
//                 height: screenSize.height / 4,
//                 child: _buildProfileImage(context),
//               ),
//             ]),
//           ],
//         ),
//       ),
//     );

//     ///information
//     PageViewModel pageViewModel6 = new PageViewModel(
//       decoration: PageDecoration(
//         pageColor: Theme.of(context).backgroundColor,
//         titleTextStyle: Theme.of(context).textTheme.headline5,
//       ),
//       title: "",
//       bodyWidget: Column(
//         children: [
//           Image.asset(
//             "assets/images/Information.png",
//             height: screenSize.height / 4,
//             width: screenSize.width * 0.7,
//           ),
//           Text(
//             'You are all set!',
//             style: Theme.of(context).textTheme.headline5,
//           ),
//           SizedBox(height: 20),
//           Stack(
//             children: <Widget>[
//               Container(
//                   width: screenSize.width,
//                   height: screenSize.height / 4,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       image: DecorationImage(
//                           image: _profilePic == null
//                               ? AssetImage(
//                                   "assets/images/default_image_placeholder.jpg")
//                               : _profilePic,
//                           fit: BoxFit.cover))),
//               Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: LinearGradient(
//                       transform: GradientRotation(pi / 2),
//                       // EEE,0; 818181,46; 383838,76;222,86; 101010,93;000, 100
//                       colors: [
//                         Colors.transparent,
//                         Colors.transparent,
//                         Color(0xFF101010).withOpacity(0.8),
//                         Color(0xFF000000),
//                       ],
//                       stops: [0, 0.2, 0.6, 1],
//                     )),
//               ),
//               Container(
//                 width: screenSize.width,
//                 height: screenSize.height / 4,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient: LinearGradient(
//                       transform: GradientRotation(pi / 2),
//                       colors: [
//                         Colors.transparent,
//                         Colors.transparent,
//                         Color(0xFF000000),
//                       ],
//                       stops: [0, 0.2, 1],
//                     )),
//                 child: Column(
//                   children: <Widget>[
//                     Flexible(flex: 2, child: Container()),
//                     Flexible(
//                         flex: 1,
//                         child: Column(
//                           children: <Widget>[
//                             Flexible(
//                               flex: 1,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(horizontal: 16.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: <Widget>[
//                                     (Text(
//                                       _fullName,
//                                       style:
//                                           Theme.of(context).textTheme.headline6,
//                                     ))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Flexible(
//                               flex: 1,
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(2, 0, 6, 8),
//                                 child: Row(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     children: <Widget>[
//                                       ///DOB
//                                       Flexible(
//                                         flex: 2,
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.end,
//                                           children: <Widget>[
//                                             Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 4),
//                                               child: FaIcon(
//                                                 FontAwesomeIcons.birthdayCake,
//                                                 size: 14,
//                                                 color: Theme.of(context)
//                                                     .primaryColorLight,
//                                               ),
//                                             ),
//                                             (Text(_dob)),
//                                           ],
//                                         ),
//                                       ),

//                                       ///gender
//                                       Flexible(
//                                           flex: 2,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                             children: <Widget>[
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: 4,
//                                                 ),
//                                                 child: Icon(
//                                                   FontAwesomeIcons.venusMars,
//                                                   size: 14,
//                                                   color: Theme.of(context)
//                                                       .primaryColorLight,
//                                                 ),
//                                               ),
//                                               (Text(_gender)),
//                                             ],
//                                           )),

//                                       ///weight
//                                       Flexible(
//                                           flex: 1,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                             children: <Widget>[
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: 4,
//                                                 ),
//                                                 child: Icon(
//                                                   FontAwesomeIcons.weight,
//                                                   size: 14,
//                                                   color: Theme.of(context)
//                                                       .primaryColorLight,
//                                                 ),
//                                               ),
//                                               (Text(_weight)),
//                                             ],
//                                           )),

//                                       ///height
//                                       Flexible(
//                                           flex: 1,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                             children: <Widget>[
//                                               Padding(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: 2,
//                                                 ),
//                                                 child: Icon(
//                                                   FontAwesomeIcons
//                                                       .rulerVertical,
//                                                   size: 14,
//                                                   color: Theme.of(context)
//                                                       .primaryColorLight,
//                                                 ),
//                                               ),
//                                               (Text(_height)),
//                                             ],
//                                           )),
//                                     ]),
//                               ),
//                             ),
//                           ],
//                         ))
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );

//     List<PageViewModel> listofPageViewModel = new List<PageViewModel>();
//     listofPageViewModel.add(pageViewModel1); //name
//     listofPageViewModel.add(pageViewModel5); //profilepic
//     listofPageViewModel.add(pageViewModel2); //gender
//     listofPageViewModel.add(pageViewModel3); // age
//     listofPageViewModel.add(pageViewModel4); // height weight
//     listofPageViewModel.add(pageViewModel6); //details

//     return SafeArea(
//       child: ModalProgressHUD(
//         inAsyncCall: bPlayerAddInProcess,
//         progressIndicator: YipliLoader(),
//         child: WillPopScope(
//           onWillPop: () async => false,
//           child: Consumer<PlayerOnBoardingStateModel>(
//               builder: (context, playerOnBoardingStateModel, child) {
//             //playerOnBoardingStateModel.isInProgress = true;
//             return Stack(
//               children: <Widget>[
//                 IntroductionScreen(
//                   freeze: true,
//                   key: _introScreenKey,
//                   pages: listofPageViewModel,
//                   animationDuration: 4,
//                   onSkip: () {
//                     YipliUtils
//                         .goToPlayersPage(); // You can also override onSkip callback
//                   },
//                   showNextButton: true,
//                   showSkipButton: true,
//                   skip: FlatButton(
//                     onPressed: () {
//                       IntroductionScreenState screenState =
//                           _introScreenKey.currentState;
//                       PageController pageController = screenState.controller;
//                       print("Last page was : ");
//                       print(pageController.page.toString());
//                       pageController.previousPage(
//                           curve: Curves.bounceInOut,
//                           duration: Duration(milliseconds: 100));
//                     },
//                     child: Text("Back",
//                         style: Theme.of(context).textTheme.bodyText2.copyWith(
//                               fontWeight: FontWeight.w600,
//                             )),
//                   ),
//                   next: GestureDetector(
//                     onDoubleTap: () {
//                       YipliUtils.showNotification(
//                           context: context,
//                           msg: "Do not double tap",
//                           type: SnackbarMessageTypes.WARN);
//                     },
//                     child: FlatButton(
//                       onPressed: () {
//                         IntroductionScreenState screenState =
//                             _introScreenKey.currentState;
//                         PageController pageController = screenState.controller;
//                         print("current page is : ");
//                         print(pageController.page.toString());

//                         if (validateInput(pageController)) {
//                           pageController.nextPage(
//                               curve: Curves.bounceInOut,
//                               duration: Duration(milliseconds: 100));
//                         }
//                         FocusScope.of(context).requestFocus(FocusNode());
//                       },
//                       child: Text("Next",
//                           style: Theme.of(context).textTheme.bodyText2.copyWith(
//                                 fontWeight: FontWeight.w600,
//                               )),
//                     ),
//                   ),
//                   done: Text("Done",
//                       style: Theme.of(context).textTheme.bodyText2.copyWith(
//                             fontWeight: FontWeight.w600,
//                           )),
//                   onDone: _isButtonEnabled == false
//                       ? () {
//                           print('done button is disabled');
//                         }
//                       : () async {
//                           setState(() {
//                             SystemChannels.textInput
//                                 .invokeMethod('TextInput.hide');
//                             _isButtonEnabled = false;
//                             bPlayerAddInProcess = true;
//                           });
//                           if (await YipliUtils.getNetworkConnectivityStatus() ==
//                               true) {
//                             //_isButtonEnabled = false;
//                             print("Done player Pressed!");
//                             print("Add player");

//                             String user = AuthService.getCurrentUserId();

//                             print(
//                                 'Adding new Player with following details :$user  $_fullName ${DateFormat('MM-dd-yyyy').format(new DateFormat('dd-MMM-yyyy').parse(_dob))} $_gender $_weight $_height');
//                             PlayerDetails playerTile = new PlayerDetails(
//                               dob: DateFormat('MM-dd-yyyy').format(
//                                   new DateFormat('dd-MMM-yyyy').parse(
//                                       _dob)), //this is done to send dob in format mm/dd/yyyy to the backend
//                               userId: user,
//                               playerName: _fullName,
//                               gender: _gender,
//                               height: _height,
//                               weight: _weight,
//                               profilePic: _profilePic,
//                             );
//                             try {
//                               Players newPlayer =
//                                   new Players.createDBPlayerFromPlayerDetails(
//                                       playerTile);

//                               newPlayer
//                                   .persistNewRecord()
//                                   .then((newPlayerIdFromDB) async {
//                                 YipliUtils
//                                     .doNotShowDailyTipForRecentlyAddedPlayer(
//                                         newPlayerIdFromDB);
//                                 playerOnBoardingStateModel.isInProgress = false;

//                                 if (allPlayersModels.length == 0) {
//                                   print("******* Making default ********");
//                                   await Users.changeCurrentPlayer(
//                                       newPlayerIdFromDB);
//                                   playerOnBoardingStateModel.playerAddedState =
//                                       PlayerAddedState.FIRST_PLAYER_ADDED;
//                                 } else {
//                                   playerOnBoardingStateModel.playerAddedState =
//                                       PlayerAddedState.NEW_PLAYER_ADDED;
//                                   YipliUtils.showNotification(
//                                       context: context,
//                                       msg: "New player added.",
//                                       type: SnackbarMessageTypes.ERROR,
//                                       duration: SnackbarDuration.MEDIUM);
//                                 }
//                               });
//                               // switch (flowValue) {
//                                 case UserOnBoardingFlows.FLOW1:
//                                   //Call page 2 of flow 1
//                                   Navigator.of(context).pushNamed(
//                                       UserOnBoardingFinalPage.routeName);
//                                   break;
//                                 case UserOnBoardingFlows.FLOW2:
//                                   // Error condition
//                                   //Call page 2 of flow 2

//                                   break;
//                                 case UserOnBoardingFlows.FLOW3:
//                                   //Call page 3 (Final page)
//                                   Navigator.of(context).pushNamed(
//                                       UserOnBoardingFinalPage.routeName);
//                                   break;
//                                 case UserOnBoardingFlows.NA:
//                                 default:
//                                   Navigator.of(context).pop();
//                                   break;
//                               }
//                             } catch (error) {
//                               playerOnBoardingStateModel.isInProgress = false;
//                               setState(() {
//                                 _isButtonEnabled = true;
//                                 bPlayerAddInProcess = false;
//                               });

//                               print('enabling done button');
//                               print(error);
//                               print('Error - Add player');
//                             }
//                           } else {
//                             setState(() {
//                               _isButtonEnabled = true;
//                               bPlayerAddInProcess = false;
//                             });

//                             print('enabling done button');
//                             YipliUtils.showNotification(
//                                 context: context,
//                                 msg:
//                                     "Internet Connectivity is required to add new player.",
//                                 type: SnackbarMessageTypes.ERROR,
//                                 duration: SnackbarDuration.MEDIUM);
//                           }
//                         },
//                   dotsDecorator: DotsDecorator(
//                       size: const Size.square(6.0),
//                       activeSize: const Size(12.0, 6.0),
//                       activeColor: Theme.of(context).accentColor,
//                       color: Theme.of(context).primaryColorLight,
//                       spacing: const EdgeInsets.symmetric(horizontal: 3.0),
//                       activeShape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25.0))),
//                 ),
//                 Positioned(
//                   top: 15,
//                   right: 15,
//                   child: Material(
//                     color: Colors.transparent,
//                     child: IconButton(
//                       onPressed: () {
//                         var alertBox = AlertDialog(
//                           elevation: 10.0,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0)),
//                           backgroundColor: Theme.of(context).primaryColor,
//                           title: Center(
//                             child: Container(
//                               padding: EdgeInsets.only(left: 5, right: 10),
//                               child: Center(child: YipliLogoAnimatedSmall()),
//                             ),
//                           ),
//                           content: Container(
//                             child: Text(
//                                 "Are you sure you want to skip the add player process?",
//                                 style: Theme.of(context).textTheme.bodyText2,
//                                 textAlign: TextAlign.start),
//                           ),
//                           actions: <Widget>[
//                             FlatButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: Theme.of(context).textTheme.bodyText2,
//                               ),
//                             ),
//                             FlatButton(
//                               child: Text(
//                                 "Okay",
//                                 style: Theme.of(context).textTheme.bodyText2,
//                               ),
//                               onPressed: () {
//                                 playerOnBoardingStateModel.isInProgress = false;
//                                 Navigator.of(context).pop();
//                                 Navigator.of(context).pop();
//                                 YipliUtils.showNotification(
//                                     context: context,
//                                     msg: "No player added.",
//                                     type: SnackbarMessageTypes.ERROR);
//                                 //   YipliUtils.replaceWithPlayersPage();
//                               },
//                             ),
//                           ],
//                         );

//                         showDialog(
//                           context: context,
//                           //child: alertBox,
//                           builder: (_) {
//                             return alertBox;
//                           },
//                           barrierDismissible: true,
//                         );
//                       },
//                       icon: Icon(
//                         Icons.cancel,
//                         color: yipliErrorRed,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           }),
//         ),
//       ),
//     );
//   }

//   bool validateInput(PageController pageController) {
//     if (pageController.page == 0.0) {
//       ///full name validation
//       if (_fullName.length < 3) {
//         print("Freezing state");

//         // Full Name Validation
//         YipliUtils.showNotification(
//             context: context,
//             msg: "Player name too short. Please enter more than 2 charaters.",
//             type: SnackbarMessageTypes.ERROR);
//         return false;
//       } else {
//         // Name input is valid
//         if (allPlayersModels.length > 0) {
//           for (int iCount = 0; iCount < allPlayersModels.length; iCount++) {
//             //Check for duplicate name
//             if (_fullName.toLowerCase() ==
//                 allPlayersModels[iCount].name.toLowerCase()) {
//               YipliUtils.showNotification(
//                   context: context,
//                   msg: "Name already exists. Choose another name.",
//                   type: SnackbarMessageTypes.ERROR);
//               return false;
//             }
//           }
//         }
//       }
//     }

//     if (pageController.page == 1.0) {
//       ///profilepic validation

// //      if (_profilePic == null) {
// //        YipliUtils.showNotification(
// //            context: context,
// //            msg: "Please set your Yipli Pic.",
// //            type: SnackbarMessageTypes.ERROR);
// //        return false;
// //      }
//     }

//     if (pageController.page == 2.0) {
//       ///gender validation
//       if ((_gender == null) || (_gender == "")) {
//         // Full Name Validation
//         YipliUtils.showNotification(
//             context: context,
//             msg: "Please select gender.",
//             type: SnackbarMessageTypes.ERROR);
//         return false;
//       }
//     }

//     if (pageController.page == 3.0) {
//       ///dob validation
//       if ((_dob == null) || (_dob == "")) {
//         // Full Name Validation
//         YipliUtils.showNotification(
//             context: context,
//             msg: "Please select your date of birth.",
//             type: SnackbarMessageTypes.ERROR);
//         return false;
//       }
//     }

//     if (pageController.page == 4.0) {
//       ///weight height validation
//       if ((_height == null) ||
//           (_height == "") ||
//           (_weight == null) ||
//           (_weight == "")) {
//         // Full Name Validation
//         YipliUtils.showNotification(
//             context: context,
//             msg: "Please set your height and weight.",
//             type: SnackbarMessageTypes.ERROR);
//         return false;
//       }
//     }

//     print(
//         ' User entered : $_fullName $_profilePicUrl $_dob $_gender $_weight $_height');

//     return true;
//   }
// }
