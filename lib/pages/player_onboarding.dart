import 'package:flutter/cupertino.dart';

import 'package:flutter_app/external_plgins/number_picker.dart';
import 'package:flutter_app/external_plgins/stepper.dart';
import 'package:flutter_app/external_plgins/stepper3.dart';
import 'package:intl/intl.dart';
import 'a_pages_index.dart';

class PlayerOnboardingPage extends StatefulWidget {
  static const String routeName = '/player_onboarding';
  @override
  _PlayerOnboardingPageState createState() => _PlayerOnboardingPageState();
}

class _PlayerOnboardingPageState extends State<PlayerOnboardingPage> {
  FileImage _profilePic;
  String _profilePicUrl;
  String _playerName = "";
  String _playerId;
  String _dob = "01-Jan-2000";
  String _gender = "";
  bool _isUploading = false;
  String _weight = 39.toString();
  String _height = 161.toString();
  int _currentWeightValue = 40;
  int _currentHeightValue = 162;
  var result;
  String userId;

  String _defaultPic = "assets/images/default_image_placeholder.jpg";
  YipliTextInput contactNoInput;
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController contactEditingController = new TextEditingController();
  int currentStep = 0;
  List<PlayerModel> allPlayersModels = new List<PlayerModel>();
  PlayerPageArguments playerPageArguments;
  bool savePlayerDataButtonEnabled = true;
  @override
  void initState() {
    userId = AuthService.getCurrentUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    playerPageArguments = ModalRoute.of(context).settings.arguments;
    allPlayersModels = playerPageArguments.allPlayerDetails == null
        ? new List<PlayerModel>()
        : playerPageArguments.allPlayerDetails;
    return Consumer<PlayerOnBoardingStateModel>(
        builder: (context, playerOnBoardingStateModel, child) {
      playerOnBoardingStateModel.isInProgress = true;
      return YipliPageFrame(
        title: Text('Add Player'),
        backgroundMode: YipliBackgroundMode.dark,
        child: SafeArea(
          child: OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              switch (orientation) {
                case Orientation.portrait:
                  return _buildStepper(
                      YipliStepperType.vertical, playerOnBoardingStateModel);

                case Orientation.landscape:
                  return _buildStepper(
                      YipliStepperType.horizontal, playerOnBoardingStateModel);
                default:
                  throw UnimplementedError(orientation.toString());
              }
            },
          ),
        ),
      );
    });
  }

  Widget _playerNameInput(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(),
          TextField(
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: yipliWhite),
            onChanged: (_) {
              _playerName = textEditingController.text;
              _playerName = _playerName.trim();
              setState(() {
                return _playerName;
              });
              print("the player name is: $_playerName");
            },
            controller: textEditingController,
            autofocus: false,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: yipliWhite,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: '  Enter player name',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: yipliGray),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: yipliNewBlue,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(),
          _genderInput(context),
        ]);
  }

  Widget _playerProfilePic(BuildContext context, String userId) {
    print("Building the player profile image");
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text(
        "Add your photo",
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
      ),
      GestureDetector(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: YipliConstants.getProfilePicDimensionsLarge(context)
                          .width *
                      1.5,
                  height: YipliConstants.getProfilePicDimensionsLarge(context)
                          .height *
                      1.5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: _profilePicUrl == null
                          ? AssetImage(_defaultPic)
                          : _profilePic == null
                              ? FirebaseImage(
                                  "${FirebaseStorageUtil.profilepics}/$_profilePicUrl")
                              : _profilePic,
                    ),
                    borderRadius: BorderRadius.circular(90.0),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3.0,
                    ),
                  ),
                  child: Container(
                    child: Center(
                      child: Icon(
                        Icons.photo_camera,
                        color: IconTheme.of(context).color,
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  height: YipliConstants.getProfilePicDimensionsLarge(context)
                      .height,
                  width: YipliConstants.getProfilePicDimensionsLarge(context)
                      .width,
                  child: CircularProgressIndicator(
                    strokeWidth: 4.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context)
                        .primaryColorLight
                        .withOpacity(_isUploading ? 1.0 : 0)),
                  ),
                ),
              )
            ],
          ),
          onTap: () async {
            var fileName = Uuid().v4();
            print("FILENAME : $fileName");
            Size sizeToUpload = new Size(512, 512);
            if (result != null) {
              result.uploadTask.cancel();
            }

// New user is not having playerid,profilepicurl and pathref so passing null initially
            result = await YipliUtils.profilePicOptions(
                context, sizeToUpload, fileName, null, null, null);
            if (result != null) {
              setState(() {
                _profilePic = FileImage(result.imageFile);
              });
              result.uploadTask.events.listen((uploadTaskEvent) {
                switch (uploadTaskEvent.type) {
                  case StorageTaskEventType.resume:
                    break;
                  case StorageTaskEventType.progress:
                    break;
                  case StorageTaskEventType.pause:
                    break;
                  case StorageTaskEventType.success:
                    setState(() {
                      _profilePicUrl = fileName;
                      _profilePic = FileImage(result.imageFile);
                    });

                    YipliUtils.showNotification(
                      context: context,
                      msg: "Profile Picture set.",
                      duration: SnackbarDuration.SHORT,
                      type: SnackbarMessageTypes.SUCCESS,
                    );

                    break;
                  case StorageTaskEventType.failure:
                    YipliUtils.showNotification(
                      context: context,
                      msg: "Picture upload failed. Please retry.",
                      duration: SnackbarDuration.SHORT,
                      type: SnackbarMessageTypes.ERROR,
                    );
                    break;
                }
              });
            }
          }),
    ]);
  }

  Widget _genderInput(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(unselectedWidgetColor: Theme.of(context).accentColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Select one',
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: yipliWhite),
          ),
          RadioButtonGroup(
            orientation: GroupedButtonsOrientation.VERTICAL,
            activeColor: Theme.of(context).accentColor,
            onSelected: (String selected) => setState(() {
              _gender = selected;
            }),
            labels: <String>["Male", "Female", "Other"],
            labelStyle: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: yipliWhite),
            picked: _gender,
            itemBuilder: (Radio rb, Text txt, int i) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  rb,
                  txt,
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dobWidget(BuildContext context) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: Text('DOB')),
                Expanded(flex: 4, child: dataPicker(context)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget dataPicker(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final textTheme = theme.textTheme.copyWith(
        dateTimePickerTextStyle:
            TextStyle(color: Theme.of(context).accentColor, fontSize: 15.0));
    return Container(
      height: MediaQuery.of(context).size.height / 8,
      child: CupertinoTheme(
        data: theme.copyWith(
          textTheme: textTheme,
          brightness: Brightness.dark,
        ),
        child: CupertinoDatePicker(
          onDateTimeChanged: (DateTime newDate) {
            _dob = DateFormat('dd-MMM-yyyy').format(newDate);
            setState(() {
              print('dob=$_dob');
            });
          },
          maximumDate: new DateTime(2018, 12, 30),
          minimumYear: 1960,
          maximumYear: 2018,
          minuteInterval: 1,
          initialDateTime: new DateTime(2000, 1, 1),
          mode: CupertinoDatePickerMode.date,
        ),
      ),
    );
  }

  Widget _buildHeight(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: yipliWhite, // highlted color
          textTheme: Theme.of(context).textTheme.copyWith(
                headline5: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: yipliWhite, fontSize: 12),
              )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "Ht (cms)",
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NumberPicker.integer(
                initialValue: _currentHeightValue,
                minValue: 20,
                maxValue: 200,
                onChanged: (newValue) => setState(() {
                  _currentHeightValue = newValue;

                  _height = _currentHeightValue.toString();
                }),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildWeight(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          accentColor: yipliWhite, // highlted color
          textTheme: Theme.of(context).textTheme.copyWith(
                headline5: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: yipliWhite, fontSize: 12),
              )),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              "Wt (kg)",
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NumberPicker.integer(
                initialValue: _currentWeightValue,
                minValue: 20,
                maxValue: 200,
                onChanged: (newValue) => setState(() {
                  _currentWeightValue = newValue;
                  _weight = _currentWeightValue.toString();
                }),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  YipliCupertinoStepper _buildStepper(YipliStepperType type,
      PlayerOnBoardingStateModel playerOnBoardingStateModel) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 3;
    return YipliCupertinoStepper(
      type: type,
      currentStep: currentStep,
      onStepTapped: (step) => setState(() => currentStep = step),
      onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
      onStepContinue: canContinue
          ? () => onContinuePress(playerOnBoardingStateModel)
          // ? () => setState(() => onContinuePress(playerOnBoardingStateModel))
          : null,
      steps: [
        // for (var i = 0; i < 3; ++i)
        _buildStep(
          title: Text('Name & Gender'),
          content: _playerNameInput(context),
          isActive: 0 == currentStep,
          isSkipButtonEnabled: false,
          icon: FontAwesomeIcons.pencilAlt,
          state: 0 == currentStep
              ? YipliStepState.editing
              : 0 < currentStep
                  ? YipliStepState.complete
                  : YipliStepState.indexed,
        ),

        _buildStep(
          title: Text('Profile Pic'),
          content: _playerProfilePic(context, userId),
          isActive: 1 == currentStep,
          isSkipButtonEnabled: true,
          icon: FontAwesomeIcons.camera,
          state: 1 == currentStep
              ? YipliStepState.editing
              : 1 < currentStep
                  ? YipliStepState.complete
                  : YipliStepState.indexed,
        ),

        _buildStep(
          title: Text('Personal Details'),
          content: _personalDetailsWidget(context),
          isActive: 2 == currentStep,
          icon: FontAwesomeIcons.newspaper,
          isSkipButtonEnabled: true,
          state: 2 == currentStep
              ? YipliStepState.editing
              : 2 < currentStep
                  ? YipliStepState.complete
                  : YipliStepState.indexed,
        ),
      ],
    );
  }

  Widget _personalDetailsWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _dobWidget(context)),
        Expanded(flex: 1, child: Divider(thickness: 0.5, color: yipliGray)),
        Expanded(flex: 2, child: _buildHeight(context)),
        Expanded(flex: 1, child: Divider(thickness: 0.5, color: yipliGray)),
        Expanded(flex: 2, child: _buildWeight(context)),
      ],
    );
  }

  YipliStep _buildStep({
    Widget title,
    Widget content,
    YipliStepState state = YipliStepState.indexed,
    bool isActive = false,
    bool isSkipButtonEnabled = false,
    IconData icon,
  }) {
    return YipliStep(
      title: title,
      subtitle: Text(''),
      state: state,
      isActive: isActive,
      // isSkipButtonEnabled: isSkipButtonEnabled,
      icon: icon,
      content: LimitedBox(
        maxWidth: 300,
        maxHeight: 300,
        child: content,
      ),
    );
  }

  void onContinuePress(
      PlayerOnBoardingStateModel playerOnBoardingStateModel) async {
    switch (currentStep) {
      case 0:

        //Name Length check
        if (_playerName.length < 2) {
          YipliUtils.showNotification(
            context: context,
            msg: "Name must be more than two characters",
            duration: SnackbarDuration.MEDIUM,
            type: SnackbarMessageTypes.ERROR,
          );
          return;
        }

        //Name duplication check
        if (allPlayersModels.length > 0) {
          for (int iCount = 0; iCount < allPlayersModels.length; iCount++) {
            //Check for duplicate name
            if (_playerName.toLowerCase() ==
                allPlayersModels[iCount].name.toLowerCase()) {
              YipliUtils.showNotification(
                  context: context,
                  msg: "Name already exists. Choose another name.",
                  type: SnackbarMessageTypes.ERROR);
              return;
            }
          }
        }
        //Gender filled? check
        if (_gender == "") {
          YipliUtils.showNotification(
            context: context,
            msg: "You have not selected gender",
            duration: SnackbarDuration.MEDIUM,
            type: SnackbarMessageTypes.ERROR,
          );
          return;
        }

        //None of the validaions failed, so goto next step.
        setState(() {
          ++currentStep;
        });
        break;

      case 1:
        if (_profilePicUrl == null) {
          YipliUtils.showNotification(
            context: context,
            msg: "You have not added profile picture",
            duration: SnackbarDuration.MEDIUM,
            type: SnackbarMessageTypes.SUCCESS,
          );
        }
        setState(() {
          ++currentStep;
        });

        break;

      case 2:
        if (savePlayerDataButtonEnabled == true) {
          savePlayerDataButtonEnabled = false;
          await saveUserProfileData(playerOnBoardingStateModel);
          savePlayerDataButtonEnabled = true;
          playerPageArguments.isOnboardingFlow == true
              ? YipliUtils.goToUserOnboardingPage()
              : YipliUtils.goToPlayersPage();
        } else {
          YipliUtils.showNotification(
            context: context,
            msg: "Player addition is in progress",
            duration: SnackbarDuration.MEDIUM,
            type: SnackbarMessageTypes.ERROR,
          );
        }
        break;
    }
  }

  Future saveUserProfileData(
      PlayerOnBoardingStateModel playerOnBoardingStateModel) async {
    String user = AuthService.getCurrentUserId();

    // print(
    //     'Adding new Player with following details :$user  $_playerName ${DateFormat('MM-dd-yyyy').format(new DateFormat('dd-MMM-yyyy').parse(_dob))} $_gender $_weight $_height');
    PlayerDetails playerTile = new PlayerDetails(
      dob: DateFormat('MM-dd-yyyy').format(new DateFormat('dd-MMM-yyyy').parse(
          _dob)), //this is done to send dob in format mm/dd/yyyy to the backend
      userId: user,
      playerName: _playerName,
      gender: _gender,
      height: _height,
      weight: _weight,
      profilePic: _profilePic,
    );
    if (currentStep == 2) {
      playerOnBoardingStateModel.isInProgress = true;
      try {
        Players newPlayer =
            new Players.createDBPlayerFromPlayerDetails(playerTile);

        newPlayer.persistNewRecord().then((newPlayerIdFromDB) async {
          //Tip of the day shared prefs is filled for current player
          YipliUtils.doNotShowDailyTipForRecentlyAddedPlayer(newPlayerIdFromDB);
          playerOnBoardingStateModel.isInProgress = false;

          _playerId = newPlayerIdFromDB;
          if (allPlayersModels.length == 0) {
            print("******* Making default ********");
            await Users.changeCurrentPlayer(newPlayerIdFromDB);
            playerOnBoardingStateModel.playerAddedState =
                PlayerAddedState.FIRST_PLAYER_ADDED;
          } else {
            playerOnBoardingStateModel.playerAddedState =
                PlayerAddedState.NEW_PLAYER_ADDED;
            YipliUtils.showNotification(
                context: context,
                msg: "New player added.",
                type: SnackbarMessageTypes.INFO,
                duration: SnackbarDuration.MEDIUM);
          }
        });
      } catch (e) {
        print('Exception:' + e.message);
        playerOnBoardingStateModel.isInProgress = false;
      }
    }
  }
}
