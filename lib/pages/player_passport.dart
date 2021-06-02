import 'a_pages_index.dart';

class PlayerPassport extends StatefulWidget {
  static const String routeName = "/player_passport_screen";

  @override
  _PlayerPassportState createState() => _PlayerPassportState();
}

class _PlayerPassportState extends State<PlayerPassport> {
  String playerId;
  String playerName;

  String _shareCode;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

// TODO: @Roopa - implement build

    YipliButton inviteButton = new YipliButton(
      "Invite",
      Theme.of(context).primaryColorLight,
      Theme.of(context).primaryColor,
      screenSize.width / 4,
    );

    inviteButton.setClickHandler(() {
      final RenderBox box = context.findRenderObject();
      Share.share(_shareCode,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    });

    return YipliPageFrame(
        title: Text('Share Code'),
        child: Consumer<CurrentPlayerModel>(
            builder: (context, currentPlayerModel, child) {
          _shareCode = (currentPlayerModel?.player?.name ?? "") + "4545";
          return Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(25),
              child: Card(
                  color: Theme.of(context).accentColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(flex: 2, child: YipliLogoAnimatedSmall()),
                      Expanded(
                        flex: 2,
                        child: PlayerIconWithNameHorizontal(
                          name: currentPlayerModel?.player?.name ?? "",
                          playerProfileUrl:
                              currentPlayerModel?.player?.profilePicUrl ?? "",
                          iconFlex: 2,
                          nameFlex: 5,
                          iconPadding: EdgeInsets.all(20),
                          horizontalAlignment: MainAxisAlignment.center,
                          textStyle: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text("Invite Your Friends, Earn Yipli Rewards",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontWeight: FontWeight.w600))),
                      Expanded(
                        flex: 1,
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(
                                      constraints.maxHeight / 2),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      _shareCode,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .accentColor),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8.0),
                                      child: VerticalDivider(
                                        thickness: 2,
                                        color: Theme.of(context)
                                            .accentColor
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                    Icon(FontAwesomeIcons.copy,
                                        color: Theme.of(context).accentColor)
                                  ],
                                ),
                                color: Theme.of(context).primaryColorLight,
                                focusColor: androidTVFocusColor,
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: _shareCode));
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Text(
                                "Get 1000 Yipli Rewards for every friend that joins using your buddy code mentioned above.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyText2),
                          ),
                        ),
                      ),
                      Expanded(flex: 2, child: Container(child: inviteButton)),
                    ],
                  )),
            ),
          );
        }));
  }
}
