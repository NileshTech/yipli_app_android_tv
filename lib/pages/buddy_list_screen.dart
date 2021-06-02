//import 'a_pages_index.dart';
//
//class BuddyPage extends StatefulWidget {
//  static const String routeName = "/buddy_list_screen";
//
//  @override
//  State<StatefulWidget> createState() => new _BuddyPageState();
//}
//
//class _BuddyPageState extends State<BuddyPage> {
//  List<PlayerDetails> allPlayerDetails = new List<PlayerDetails>();
//
//  @override
//  Widget build(BuildContext context) {
//    Players currentPlayer = ModalRoute.of(context).settings.arguments;
//    final Size screenSize = MediaQuery.of(context).size;
//    return Scaffold(
//      body: Stack(
//        children: <Widget>[
//          Container(
//            padding: EdgeInsets.fromLTRB(
//                0, screenSize.height / 7.2, 0, screenSize.height / 10),
//            child: FutureBuilder(
//              future: Players.getBuddies(currentPlayer),
//              builder: (context, playersSnap) {
//                var currentConnectionState =
//                    playersSnap.connectionState.toString();
//                var currentData = playersSnap.data.toString();
//                print("player:: $currentConnectionState -- $currentData");
//                if (playersSnap.connectionState != ConnectionState.done &&
//                    !playersSnap.hasData) {
//                  return YipliLoader();
//                }
//
//                if (playersSnap.data ==
//                    null) // && playersSnap.connectionState == ConnectionState.done && playersSnap.hasData)
//                {
//                  print('PlayersData is Null');
//                  return Center(
//                    child: Container(
//                      child: Text('No Buddy is added.',
//                          style: TextStyle(
//                              fontWeight: FontWeight.bold, fontSize: 28.0),
//                          textAlign: TextAlign.center),
//                    ),
//                  );
//                }
//                return ListView.builder(
//                    //padding: const EdgeInsets.all(8),
//                    itemCount: playersSnap.data.length,
//                    itemBuilder: (context, index) {
//                      Players playerToRender = playersSnap.data[index];
//                      PlayerDetails playerTile =
//                          new PlayerDetails.playerDetailsFromDBPlayer(
//                              playerToRender);
//                      print(
//                          "Adding new player to the list : ${playerTile.playerName}");
//                      allPlayerDetails.add(
//                          playerTile); // Adding playerDetails in list to pass on to AddPlayerPage for validation.
//                      return PlayerListWidget(
//                        playerTile,
//                        playerTile.bIsCurrentPlayer,
//                        PlayerListWidgetMode.listMode,
//                      );
//                    });
//              },
//            ),
//          ),
//          Column(
//            mainAxisAlignment: MainAxisAlignment.end,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(2.0),
//                child: FlatButton.icon(
//                  onPressed: () {
//                    print(
//                        "Number of Buddies currently : ${allPlayerDetails.length}");
//                    YipliUtils.goToBuddyRequestPage(currentPlayer);
//                  },
//                  icon: Icon(
//                    Icons.add,
//                    color: yiplilightOrange,
//                    size: 30.0,
//                  ),
//                  label: Padding(
//                    padding: const EdgeInsets.all(4.0),
//                    child: Text(
//                      'Send Buddy Request',
//                      style: TextStyle(
//                        color: yiplilightOrange,
//                        fontSize: 22.0,
//                        fontWeight: FontWeight.bold,
//                        letterSpacing: 1.0,
//                        fontFamily: 'Zero',
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//}
