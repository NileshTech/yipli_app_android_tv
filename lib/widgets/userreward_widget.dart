import 'a_widgets_index.dart';

class UserRewardTile extends StatelessWidget {
  final String userRewardText;
  final IconData userRewardIcon;

  UserRewardTile(
    this.userRewardText,
    this.userRewardIcon,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  color: yipliGreen,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                height: 100,
                width: 130,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            userRewardIcon,
                            color: IconTheme.of(context).color,
                            size: 40.0,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            userRewardText,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    ])),
            //trade and share
            Container(
              decoration: BoxDecoration(
                color: yipliGreen,
                borderRadius: BorderRadius.circular(40.0),
              ),
              height: 50,
              width: 180,
              child: Row(children: <Widget>[
                Row(
                  children: <Widget>[
                    FlatButton.icon(
                      focusColor: androidTVFocusColor,
                      onPressed: () {},
                      icon: Icon(Icons.thumb_up,
                          color: IconTheme.of(context).color, size: 20.0),
                      label: Text(
                        'Trade',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  color: Theme.of(context).primaryColorLight,
                  width: 0.1,
                ),
                Row(
                  children: <Widget>[
                    FlatButton.icon(
                      focusColor: androidTVFocusColor,
                      onPressed: () {},
                      icon: Icon(Icons.share,
                          color: IconTheme.of(context).color, size: 20.0),
                      label: Text(
                        'Share',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ));
  }
}
