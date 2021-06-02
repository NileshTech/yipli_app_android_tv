import 'a_widgets_index.dart';

class PlayerQuestionerWidget extends StatefulWidget {
  PlayerQuestionerWidget({
    this.buttonText,
  }) : super();
  final String buttonText;
  bool isSelected = false;

  @override
  _PlayerQuestionerWidgetState createState() => _PlayerQuestionerWidgetState();
}

class _PlayerQuestionerWidgetState extends State<PlayerQuestionerWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: RaisedButton(
        focusColor: androidTVFocusColor,
        color: appbackgroundcolor,
        elevation: 5.0,
        onPressed: () {
          setState(() {
            widget.isSelected = true;
          });
        },
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: widget.isSelected ? yipliLogoOrange : yipliLogoBlue),
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Text(widget.buttonText,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Theme.of(context).primaryColorLight)),
        ),
      ),
    );
  }
}
