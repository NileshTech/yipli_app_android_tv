import 'a_widgets_index.dart';

class PlayerIconWithNameVertical extends StatelessWidget {
  final String playerProfileUrl;
  final String name;
  final bool showBorder;

  final int iconFlex;
  final int nameFlex;

  const PlayerIconWithNameVertical({
    Key key,
    this.playerProfileUrl,
    this.name,
    this.iconFlex = 5,
    this.nameFlex = 2,
    this.showBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: iconFlex,
          child: YipliUtils.getPlayerProfilePicIconWithoutConstraints(
              context, playerProfileUrl, showBorder),
        ),
        Expanded(
          flex: nameFlex,
          child: Center(
            child: Text(
              name?.substring(
                      0,
                      (name?.indexOf(" ") ?? 0) == -1
                          ? null
                          : (name?.indexOf(" ") ?? 0)) ??
                  "",
              //overflow: TextOverflow.fade,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        )
      ],
    );
  }
}

class PlayerIconWithNameHorizontal extends StatelessWidget {
  final String playerProfileUrl;
  final String name;
  final MainAxisAlignment horizontalAlignment;
  final EdgeInsets iconPadding;
  final EdgeInsets textPadding;
  final int iconFlex;
  final int nameFlex;

  final TextStyle textStyle;

  const PlayerIconWithNameHorizontal({
    Key key,
    this.playerProfileUrl,
    this.name,
    this.iconFlex = 5,
    this.nameFlex = 2,
    this.horizontalAlignment,
    this.iconPadding = const EdgeInsets.all(0),
    this.textPadding = const EdgeInsets.all(0),
    @required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: horizontalAlignment,
      children: <Widget>[
        Flexible(
          flex: iconFlex,
          child: Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: iconPadding,
                child: YipliUtils.getPlayerProfilePicIconWithoutConstraints(
                    context, playerProfileUrl),
              ),
            ),
          ),
        ),
        Flexible(
          flex: nameFlex,
          child: Padding(
            padding: textPadding,
            child: Text(
              name,
              style: textStyle,
            ),
          ),
        )
      ],
    );
  }
}
