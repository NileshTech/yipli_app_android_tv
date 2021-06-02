import 'package:intl/intl.dart';

import 'a_widgets_index.dart';

class FamilyLeaderBoardWidget extends StatefulWidget {
  final double dProfilePicWidth;
  final double dProfilePicHeight;
  final String stPlayerImage;
  final Color dBorderColor;
  final String stPlayerName;
  final int dPlayerPoints;
  final bool bShowIcon;
  final IconData iPlayerCrown;
  final Color iPlayerCrownColor;
  final int intPlayerImageFlex;
  final int intIconFlex;
  final int intPlayerRank;
  final Color playerRankBackgroundColor;
  final Color playerRankBorderColor;
  final Color playerRankTextColor;
  final double dPlayerRankWidth;
  final double dPlayerRankHeight;
  final Color playerImageBorderColor;

  FamilyLeaderBoardWidget({
    this.dProfilePicWidth,
    this.dProfilePicHeight,
    this.stPlayerImage,
    this.dBorderColor,
    this.stPlayerName,
    this.dPlayerPoints,
    this.bShowIcon = false,
    this.iPlayerCrown,
    this.iPlayerCrownColor,
    this.intPlayerImageFlex,
    this.intIconFlex,
    this.intPlayerRank,
    this.playerRankBorderColor,
    this.playerRankTextColor,
    this.dPlayerRankWidth,
    this.dPlayerRankHeight,
    this.playerRankBackgroundColor,
    this.playerImageBorderColor,
  });

  @override
  _FamilyLeaderBoardWidgetState createState() =>
      _FamilyLeaderBoardWidgetState();
}

class _FamilyLeaderBoardWidgetState extends State<FamilyLeaderBoardWidget>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //below is done to convert the points in k format 1000(1k)
    var _fitnesspointsint = NumberFormat.compact().format(widget.dPlayerPoints);
    var _fitnessPointsString = _fitnesspointsint.toString();
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: widget.intPlayerImageFlex,
                child: Stack(
                  children: <Widget>[
                    ///image container
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        width: widget.dProfilePicWidth,
                        height: widget.dProfilePicHeight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: widget.stPlayerImage == null ||
                                    widget.stPlayerImage == ""
                                ? AssetImage(
                                    "assets/images/placeholder_image.png")
                                : FirebaseImage(
                                    "${FirebaseStorageUtil.profilepics}/${widget.stPlayerImage}"),
                          ),
                          borderRadius: BorderRadius.circular(90.0),
                          border: Border.all(
                            color: widget.playerImageBorderColor,
                            width: 4.0,
                          ),
                        ),
                      ),
                    ),

                    ///rank container
                    Positioned(
                      bottom: 2.0,
                      right: 2.0,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Center(
                            child: Text(
                          '${widget.intPlayerRank}',
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                              color: widget.playerRankTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.width / 34),
                        )),
                        width: widget.dPlayerRankWidth,
                        height: widget.dPlayerRankHeight,
                        decoration: BoxDecoration(
                          color: widget.playerRankBackgroundColor,
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  widget.stPlayerName,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  softWrap: true,
                ),
              ),
              Flexible(
                flex: 1,
                child: PlayAnimation<double>(
                    curve: Curves.decelerate,
                    duration: 1000.milliseconds,
                    tween: (0.0).tweenTo(1.0),
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 25.0,
                              height: 25.0,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: YipliCoin(coinPadding: 0.0)),
                            ),
                            Text(_fitnessPointsString,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                      fontSize: 12,
                                    )),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: PlayAnimation<double>(
              curve: Curves.decelerate,
              duration: 700.milliseconds,
              tween: (0.0).tweenTo(1.0),
              builder: (context, child, value) {
                return Transform.scale(
                  scale: value,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: widget.bShowIcon
                        ? Transform.rotate(
                            angle: pi / 30,
                            child: Icon(
                              widget.iPlayerCrown,
                              color: widget.iPlayerCrownColor,
                            ),
                          )
                        : Container(),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
