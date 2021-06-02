import 'package:flutter_app/widgets/player_questioner_widget.dart';

import 'a_pages_index.dart';

class PlayerQuestioner extends StatefulWidget {
  static const String routeName = '/player_questioner';
  @override
  _PlayerQuestionerState createState() => _PlayerQuestionerState();
}

class _PlayerQuestionerState extends State<PlayerQuestioner> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tell us how fit you are?',
                          style: Theme.of(context).textTheme.headline4.copyWith(
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ],
                    ),
                  ),
                  PlayerQuestionerWidget(
                    buttonText: 'I lose my breath at floors of staircase',
                  ),
                  PlayerQuestionerWidget(
                    buttonText:
                        'I occasionally exercise enough to break a sweat',
                  ),
                  PlayerQuestionerWidget(
                    buttonText: 'I exercise regularly - at least twice a week',
                  ),
                  PlayerQuestionerWidget(
                    buttonText: 'I am dedicated to fitness and train most days',
                  ),
                  PlayerQuestionerWidget(
                    buttonText: 'Oh trust me. I am really fit',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Next',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).primaryColorLight,
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    focusColor: androidTVFocusColor,
                    onPressed: () {},
                    color: yipliLogoBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(right: 10.0, top: 20.0),
                child: IconButton(
                  focusColor: androidTVFocusColor,
                  icon: Icon(
                    FontAwesomeIcons.timesCircle,
                    color: yipliLogoOrange,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
