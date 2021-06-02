import 'package:flutter/material.dart';
import 'package:flutter_app/database_models/remote_code.dart';
import 'package:flutter_app/page_models/user_model.dart';
import 'package:flutter_app/pages/a_pages_index.dart';
import 'package:flutter_app/pages/yipli_page_frame.dart';
import 'package:random_string/random_string.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

const String INITIAL_TEXT_FOR_CODE_GENERATION = 'Generate code to play on PC ';
const String INITIAL_NO_CODE_PLACEHOLDER = '------';
const String INITIAL_TEXT_INSTRUCTION_FOR_GENERATED_CODE =
    "Enter this code in your Yipli PC app to start playing.";
const String TEXT_AFTER_EXPIRY_OF_CODE =
    'PC play code is expired. Please generate the code again.';
const String TEXT_FOR_ERROR_IN_GENERATING_CODE =
    'Error in generating code, please try again later..';
const String TEXT_FOR_SNACKBAR_AFTER_EXPRINING_CODE =
    'PC play code is expired.';

class RemotePlay extends StatefulWidget {
  static const String routeName = "/remote_play";

  @override
  RemotePlayState createState() => RemotePlayState();
}

class RemotePlayState extends State<RemotePlay> {
  Size screenSize;
  String initialTextForCode = INITIAL_NO_CODE_PLACEHOLDER;
  String initialMessage = INITIAL_TEXT_FOR_CODE_GENERATION;
  var _codeExpiryTime;
  YipliButton codeButton;
  bool generateCodeButtonPressed = false;
  bool bIsCodeValid = true;
  String userId;
  RemoteCode remoteCodeObject = new RemoteCode();
  var currenTimestamp;
  int oneDayDurationInMilliSeconds = 86400000;
  int dbTimestamp;

  //Button to generate code
  void onGenerateCodeButtonPressed() async {
    String generatedCode = randomNumeric(6).toString();
    setState(() {
      generateCodeButtonPressed = true;
      bIsCodeValid = true;
      initialMessage = INITIAL_TEXT_INSTRUCTION_FOR_GENERATED_CODE;
      initialTextForCode = generatedCode;
      initialMessage = INITIAL_TEXT_FOR_CODE_GENERATION;
    });
    if (!await remoteCodeObject.persistNewRemoteCode(userId, generatedCode)) {
      YipliUtils.showNotification(
          context: context,
          msg: TEXT_FOR_ERROR_IN_GENERATING_CODE,
          type: SnackbarMessageTypes.ERROR);
    }
  }

  //Timer UI to show user whether code is expired or not.
  Widget codeTimerPlaceholderWidget(BuildContext context) {
    _codeExpiryTime =
        (_codeExpiryTime / 1000).toInt(); // converting milliseconds to seconds
    print("_start : $_codeExpiryTime");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.timer, color: yipliNewBlue),
        ),
        Text("Valid for "),
        SlideCountdownClock(
            duration: Duration(days: 0, seconds: _codeExpiryTime),
            slideDirection: SlideDirection.Down,
            separator: ':',
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            onDone: () {
              YipliUtils.showNotification(
                  context: context,
                  msg: TEXT_FOR_SNACKBAR_AFTER_EXPRINING_CODE,
                  type: SnackbarMessageTypes.WARN);
              setState(() {
                generateCodeButtonPressed = false;
                bIsCodeValid = false;
                initialTextForCode = INITIAL_NO_CODE_PLACEHOLDER;
                initialMessage = TEXT_AFTER_EXPIRY_OF_CODE;
              });
            }),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("sec",
              style: TextStyle(
                  color: yipliLogoOrange, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    print('remote play page called');

    codeButton = new YipliButton(
      "Generate Code",
      null,
      null,
      screenSize.width / 3,
    );
    codeButton.setClickHandler(onGenerateCodeButtonPressed);

    return Consumer<UserModel>(builder: (context, userModel, child) {
      userId = userModel.id;
      return FutureBuilder(
        future: remoteCodeObject.getRemoteCodeFromDB(userModel.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && bIsCodeValid) {
            currenTimestamp = DateTime.now().millisecondsSinceEpoch;

            //condition checking for timer whether code is expired or not.
            if ((snapshot.data.remoteCode != null) &&
                (oneDayDurationInMilliSeconds >
                    currenTimestamp - snapshot.data.timestamp)) {
              dbTimestamp = snapshot.data.timestamp;
              _codeExpiryTime = (oneDayDurationInMilliSeconds -
                  (currenTimestamp - dbTimestamp));
              initialMessage = INITIAL_TEXT_INSTRUCTION_FOR_GENERATED_CODE;
              initialTextForCode = snapshot.data.remoteCode.toString();
              //Flags to control the UI messages and layout
              generateCodeButtonPressed = true;
              bIsCodeValid = true;
            } else {
              //Flags to control the UI messages and layout
              generateCodeButtonPressed = false;
              bIsCodeValid = false;
              initialTextForCode = INITIAL_NO_CODE_PLACEHOLDER;
              initialMessage = TEXT_AFTER_EXPIRY_OF_CODE;
            }
          }
          return YipliPageFrame(
            toShowBottomBar: true,
            title: Text('Remote Play'),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              initialMessage,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        generateCodeButtonPressed == false
                            ? initialTextForCode
                            : snapshot.data.remoteCode.toString(),
                        style: TextStyle(
                          color: yipliLogoOrange,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            child: generateCodeButtonPressed == false
                                ? codeButton
                                : codeTimerPlaceholderWidget(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
