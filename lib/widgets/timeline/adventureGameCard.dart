import '../a_widgets_index.dart';
import 'adventureGameCardContent.dart';

class AdventureGameCard extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final AdventureGamingCardState adventureGamingCardState;
  final String cardImagePath;
  final String chapterTitle;
  final int coinsToCollect;
  final int xpToCollect;
  final String focusActivity1;
  final String focusActivity2;
  final double chapterRating;
  final String androidUrl;

  final FitnessCards fitnessCards;

  const AdventureGameCard({
    Key key,
    @required this.isFirst,
    @required this.chapterTitle,
    @required this.cardImagePath,
    @required this.adventureGamingCardState,
    @required this.isLast,
    @required this.coinsToCollect,
    @required this.xpToCollect,
    @required this.focusActivity1,
    @required this.androidUrl,
    this.focusActivity2,
    this.fitnessCards,
    this.chapterRating,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      alignment: TimelineAlign.manual,
      lineXY: 0.3,

      //* The circle avatar of artwork on the left of the timeline

      startChild: Padding(
        padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
        child: Stack(
          children: [
            buildAGLeftContent(),
            YipliUtils.getImageLockedOverlay(adventureGamingCardState),
          ],
        ),
      ),

      //* The lines of the timeline widget are colored based on the state of the card.

      beforeLineStyle: LineStyle(
        color: YipliUtils.getButtonColor(adventureGamingCardState),
        thickness: 1,
      ),

      afterLineStyle: LineStyle(
        color: YipliUtils.getButtonColor(adventureGamingCardState),
        thickness: 1,
      ),
      indicatorStyle: IndicatorStyle(
        width: 25,
        color: appbackgroundcolor,
        iconStyle: IconStyle(
          iconData: YipliUtils.getIconForCardState(adventureGamingCardState),
          color: YipliUtils.getColorForCardState(adventureGamingCardState),
          fontSize: 20,
        ),
      ),

      //* This stack has a container that adventureGameCardContent Widget (see that widget to edit the contents.)
      //* The locked state widget is based on the card state.

      endChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
        child: Stack(
          children: [
            AGCardRight(
              adventureGamingCardState: adventureGamingCardState,
              chapterTitle: chapterTitle,
              focusActivity1: focusActivity1,
              focusActivity2: focusActivity2,
              fitnessCards: fitnessCards,
              chapterRating: chapterRating,
              androidUrl: androidUrl,
            ),

            //* The locked state overlay of the GameCard widget.

            YipliUtils.getLockedOverlay(adventureGamingCardState),

            //*The play game button - icons & button color are set programtically based on the state of the card.

            //_showButton(adventureGamingCardState)
          ],
        ),
      ),
    );
  }

  Widget buildAGLeftContent() {
    switch (adventureGamingCardState) {
      case AdventureGamingCardState.PLAYED:
      case AdventureGamingCardState.NEXT:
        return AGCardLeft(
          adventureGamingCardState: adventureGamingCardState,
          cardImagePath: cardImagePath,
          coinsToCollect: coinsToCollect,
          xpToCollect: xpToCollect,
        );

      case AdventureGamingCardState.LOCKED:
        return AGCardLeftLocked(
            adventureGamingCardState: adventureGamingCardState,
            cardImagePath: cardImagePath);
    }
    return null;
  }
}
