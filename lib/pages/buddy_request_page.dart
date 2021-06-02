//import 'a_pages_index.dart';
//
//class BuddyRequest extends StatefulWidget {
//  static const String routeName = "/buddy_request_screen";
//  @override
//  _BuddyRequestState createState() => _BuddyRequestState();
//}
//
//class _BuddyRequestState extends State<BuddyRequest> {
//  List<BuddyDetails> currentPlayerBuddies = new List<BuddyDetails>();
//  String _passcode;
//  static String currentPlayerId = "-M-PQAfuC5jFgH4WZq5M";
//  String _playerShortDescription = " Testplayer, Intermediate  \n 25 Buddies";
//
//  String _defaultPic = "assets/images/default-profile-pic.png";
//
//  Widget _buildProfileImage() {
//    return Center(
//      child: GestureDetector(
//        onTap: () {
//          if (_defaultPic != null) {
//            YipliUtils.goToViewImageScreen(_defaultPic);
//          }
//        },
//        child: Container(
//          width: YipliConstants.getProfilePicDimensionsLarge(context).width,
//          height: YipliConstants.getProfilePicDimensionsLarge(context).height,
//          decoration: BoxDecoration(
//            color: yipliWhite,
//            image: DecorationImage(
//              fit: BoxFit.cover,
//              image: AssetImage(_defaultPic),
//            ),
//            borderRadius: BorderRadius.circular(90.0),
//            border: Border.all(
//              color: yiplilightOrange,
//              width: 3.0,
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//
//  final YipliButton sendRequestButton = new YipliButton("Send Request");
//  //Check for the comparision of the passcode in the database and in the buddieslist;
//
//  Future<Players> getPlayerFromPasscode(
//      String playerCode, Players currentPlayer) async {
//    Players playerToReturn;
//    //query database for user details
//    DatabaseReference playerCodeDb = FirebaseDatabaseUtil().playerCodeRef;
//    Query queryForPlayerCode =
//        playerCodeDb.orderByChild("player-code").equalTo(playerCode);
//    DataSnapshot fetchedPlayer = await queryForPlayerCode.once();
//    playerToReturn =
//        Players.fromSnapshot(fetchedPlayer.value, fetchedPlayer.key);
//    if (playerToReturn == null) {
//      YipliUtils.showNotification(
//          context: context,
//          msg: "Player with passcode $playerCode doesnt exist",
//          type: SnackbarMessageTypes.ERROR);
//    }
//    //list players and search if player with provided passcode exists or not
//    else {
//      // now check buddies list of current player for passcode match
//      for (int j = 0; j < currentPlayer.buddies.length; j++) {
//        Players tempPlayerDetails =
//            await Players.getPlayerDetails(currentPlayer.buddies[j].playerId);
//        if (tempPlayerDetails.buddycode == playerCode) {
//          playerToReturn = null;
//          YipliUtils.showNotification(
//              context: context,
//              msg:
//                  "Player with passcode $playerCode is already in your BuddiesList",
//              type: SnackbarMessageTypes.ERROR);
//          break;
//        }
//      }
//      if (playerToReturn != null) {
//        // send request to buddy
//        // how to send request to buddy how to pop up it in notifications bar ?
//      }
//    }
//    return playerToReturn;
//  }
//
//  Future<void> submitButtonPress(Players currentPlayer) async {
//    print("Send Request Button Pressed!");
//
//    // Players buddyPlayer = await getPlayerFromPasscode(_passcode, currentPlayer);
//
//    //Players.sendRequest(currentPlayer,buddyPlayer);
//    Navigator.pop(context);
//    //send notification here
//  }
//
//  void onSavedPasscode(String passcode) {
//    _passcode = passcode;
//    print("buddycode : $_passcode saved");
//  }
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  Widget build(BuildContext context) {
//    // Players currentPlayer = ModalRoute.of(context).settings.arguments;
//    final Size screenSize = MediaQuery.of(context).size;
//    sendRequestButton.setClickHandler(submitButtonPress);
//    YipliTextInput _passcodeInput = new YipliTextInput(
//        "Code",
//        "Buddycode",
//        Icons.code,
//        false,
//        YipliValidators.validateName,
//        onSavedPasscode,
//        _passcode);
//
//    return Scaffold(
//      body: Stack(
//        children: <Widget>[
//          //list tile of all the player data
//          Container(
//            child: Column(
//              children: <Widget>[
//                SizedBox(
//                  height: screenSize.height / 13,
//                ),
//                _buildProfileImage(),
//                Padding(
//                  padding: EdgeInsets.symmetric(vertical: 2.0),
//                  child: Text(
//                    _playerShortDescription, //${currentPlayer.name}, ${currentPlayer.expertiseLevel} \n ${currentPlayer.buddies.length}",
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontSize: 10,
//                      color: yiplidarkblue,
//                      fontWeight: FontWeight.bold,
//                      fontFamily: 'Hippo',
//                      letterSpacing: 0.8,
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//
//          Center(
//            child: Column(
//              children: <Widget>[
//                SizedBox(
//                  height: YipliConstants.getProfilePicDimensionsLarge(context)
//                          .height *
//                      2,
//                ),
//                Padding(
//                  padding: EdgeInsets.symmetric(vertical: 10.0),
//                  child: Text(
//                    "Please enter the buddy secret code to add buddy",
//                    textAlign: TextAlign.center,
//                    style: TextStyle(
//                      fontSize: 20,
//                      color: yiplidarkblue,
//                      fontWeight: FontWeight.bold,
//                      fontFamily: 'Hippo',
//                      letterSpacing: 0.8,
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Container(
//                    decoration: BoxDecoration(
//                      color: yiplidarkblue.withOpacity(0.95),
//                      border: Border.all(
//                        color: yiplidarkblue,
//                        width: 1.0,
//                      ),
//                      borderRadius: BorderRadius.circular(40.0),
//                    ),
//                    padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
//                    height: screenSize.height / 3,
//                    child: Center(
//                      child: SingleChildScrollView(
//                        child: Column(
//                          children: <Widget>[
//                            // SizedBox(height: screenSize.height / 80),
//                            _passcodeInput,
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//                SizedBox(
//                  height: screenSize.height / 15,
//                ),
//                sendRequestButton,
//              ],
//            ),
//          ),
//          //Profile picture
//        ],
//      ),
//    );
//  }
//}
