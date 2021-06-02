import 'package:flutter_app/classes/classes_index.dart';
import 'package:flutter_app/classes/ProfilePicCaptureAndUploadResult.dart';
import 'package:intl/intl.dart';

import 'a_pages_index.dart';

class PlayerEditProfile extends StatefulWidget {
  static const String routeName = "/playeredit_profile_screen";

  @override
  _PlayerEditProfileState createState() => _PlayerEditProfileState();
}

class _PlayerEditProfileState extends State<PlayerEditProfile> {
  String _playerId;
  String _profilePicUrl;
  String _fullName;
  String _gender;
  String _dob;
  String _weight;
  String _height;
  String _defaultPic = "assets/images/default_image_placeholder.jpg";
  bool _bIsCurrentPlayer;
  ActivityStats _activityStats;

  bool _isScreenLoading = false;
  GlobalKey<FormState> _addNewPlayerFormKey;
  final YipliButton submitButton = new YipliButton("Save");
  FileImage _profilePic;
  var result;
  bool _isUploading = false;

  Future<void> submitButtonPress(
      PlayerProfileArguments playerProfileArguments) async {
    print("Submit player Pressed!");
    final FormState form = _addNewPlayerFormKey.currentState;
    if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
      if (_addNewPlayerFormKey.currentState.validate()) {
        form.save();
        try {
          User user = FirebaseAuth.instance.currentUser;
          print(
              'Updating Player with following details :${user.uid}  $_fullName ${DateFormat('MM-dd-yyyy').format(new DateFormat('dd-MMM-yyyy').parse(_dob))} $_gender $_weight $_height');
          PlayerDetails playerTile = new PlayerDetails(
            dob: DateFormat('MM-dd-yyyy').format(new DateFormat('dd-MMM-yyyy')
                .parse(
                    _dob)), //this is done to send dob in format mm/dd/yyyy to the backend
            playerId: _playerId,
            userId: user.uid,
            playerName: _fullName,
            gender: _gender,
            height: _height,
            weight: _weight,
            profilePicUrl: _profilePicUrl,
            profilePic: _profilePic,
            bIsCurrentPlayer: _bIsCurrentPlayer,
            activityStats: _activityStats,
          );

          Players newPlayer =
              new Players.createDBPlayerFromPlayerDetails(playerTile);
          await newPlayer.persistRecord();
          if (playerProfileArguments.bIsPlayerProfileFromBottomNav) {
            Navigator.of(context).pop(); //Pop out the current Edit players page
            Navigator.of(context)
                .pop(); //Pop out the player profile page as it has oudated values
            YipliUtils.goToPlayerProfileBottomNavigation();
          } else {
            Navigator.of(context).pop(); //Pop out the current Edit players page
            Navigator.of(context)
                .pop(); //Pop out the player profile page as it has oudated values
            YipliUtils.goToPlayerProfile(playerTile);
          }
          //Go again to the player profile page with new values.
        } catch (error) {
          print(error);
          print('Error Aaya - Add player');
        }
      }
    } else {
      YipliUtils.showNotification(
          context: context,
          msg: "No Internet Connectivity",
          type: SnackbarMessageTypes.ERROR,
          duration: SnackbarDuration.MEDIUM);
    }
  }

  Future savePlayerProfilePic() async {
    try {
      setState(() {
        _isScreenLoading = true;
      });
      User user = FirebaseAuth.instance.currentUser;
      print('Adding new Player with following details :$_playerId ');

      PlayerDetails playerTile = new PlayerDetails(
        userId: user.uid,
        playerId: _playerId,
        profilePicUrl: _profilePicUrl,
      );

      Players newPlayer =
          new Players.createDBPlayerFromPlayerDetails(playerTile);
      await newPlayer.persistProfilePic();
      setState(() {
        _isScreenLoading = false;
      });
    } catch (error) {
      setState(() {
        _isScreenLoading = false;
      });
      print(error);
      print('Error Aaya -  user');
    }
  }

  @override
  void initState() {
    super.initState();
    _addNewPlayerFormKey = GlobalKey<FormState>();
  }

  Widget _buildProfileImage(BuildContext context, String playerFromArgs,
      String profilePicUrlFromArgs) {
    print("Building the player profile image");
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: GestureDetector(
            child: Stack(children: <Widget>[
              Center(
                child: Container(
                  width: YipliConstants.getProfilePicDimensionsLarge(context)
                      .width,
                  height: YipliConstants.getProfilePicDimensionsLarge(context)
                      .height,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.pink.withOpacity(0.35), BlendMode.dstATop),
                      fit: BoxFit.cover,
                      image: _profilePicUrl == null || _profilePicUrl == ""
                          ? AssetImage(_defaultPic)
                          : _profilePic == null
                              ? FirebaseImage(
                                  "${FirebaseStorageUtil.profilepics}/$_profilePicUrl")
                              : _profilePic,
                    ),
                    borderRadius: BorderRadius.circular(
                        YipliConstants.getProfilePicDimensionsLarge(context)
                            .height),
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3.0,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.photo_camera,
                      color: IconTheme.of(context).color,
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
            ]),
            onTap: () async {
              if (YipliUtils.appConnectionStatus ==
                  AppConnectionStatus.CONNECTED) {
                var fileName = Uuid().v4();
                print("FILENAME : $fileName");
                Size sizeToUpload = new Size(512, 512);
                if (result != null) {
                  result.uploadTask.cancel();
                }

                DatabaseReference pathRef = FirebaseDatabaseUtil()
                    .rootRef
                    .child("profiles")
                    .child("users")
                    .child(FirebaseAuth.instance.currentUser.uid)
                    .child("players")
                    .child(_playerId)
                    .child("profile-pic-url");
                result = await YipliUtils.profilePicOptions(
                    context,
                    sizeToUpload,
                    fileName,
                    playerFromArgs,
                    profilePicUrlFromArgs,
                    pathRef);
                print("PROFILEPIC: $profilePicUrlFromArgs");

                if (result != null) {
                  setState(() {
                    _isUploading = true;
                  });
                  result.uploadTask.events.listen((uploadTaskEvent) async {
                    String oldprofilepic;
                    oldprofilepic = profilePicUrlFromArgs;
                    print("OLDURL:$oldprofilepic");
                    switch (uploadTaskEvent.type) {
                      case StorageTaskEventType.resume:
                        break;
                      case StorageTaskEventType.progress:
                        setState(() {
                          _isUploading = true;
                        });

                        break;
                      case StorageTaskEventType.pause:
                        break;
                      case StorageTaskEventType.success:
                        setState(() {
                          //query to delete old profile pic
                          if (oldprofilepic != null) {
                            FirebaseStorageUtil.profilePicsRef
                                .child(oldprofilepic)
                                .delete();
                          }

                          _isUploading = false;
                          _profilePicUrl = fileName;
                          _profilePic = FileImage(result.imageFile);
                        });
                        print("profilepic url'$_profilePicUrl'");
                        YipliUtils.showNotification(
                          context: context,
                          msg:
                              "Picture uploaded successfully. Tap submit to save.",
                          duration: SnackbarDuration.SHORT,
                          type: SnackbarMessageTypes.SUCCESS,
                        );
                        await savePlayerProfilePic();
                        break;
                      case StorageTaskEventType.failure:
                        setState(() {
                          _isUploading = false;
                        });

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
              } else {
                YipliUtils.showNotification(
                    context: context,
                    msg: "Internet Connectivity is required to change Profile.",
                    type: SnackbarMessageTypes.ERROR,
                    duration: SnackbarDuration.MEDIUM);
              }
            }),
      ),
    );
  }

  //OnSaved Functions for al the Input fields
  void onSavedFullName(String fullName) {
    _fullName = fullName;
    print("FullName : $_fullName saved");
  }

  void onSavedAge(String dob) {
    _dob = dob;
    print("Dob : $_dob saved");
  }

  void onSavedGender(String gender) {
    _gender = gender;
    print("Gender $_gender saved");
  }

  void onSavedWeight(String weight) {
    _weight = weight;
    print("Weight: $_weight saved");
  }

  void onSavedHeight(String height) {
    _height = height;
    print("Height: $_height saved");
  }

  Future<Null> _selectDate(BuildContext context) async {
    await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          final theme = CupertinoTheme.of(context);
          final textTheme = theme.textTheme.copyWith(
              dateTimePickerTextStyle: TextStyle(
                  color: Theme.of(context).accentColor, fontSize: 20.0));
          return Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height / 3,
            child: Stack(
              children: <Widget>[
                CupertinoTheme(
                  data: theme.copyWith(
                      textTheme: textTheme,
                      // barBackgroundColor: Theme.of(context).primaryColor,
                      brightness: Brightness.dark,
                      scaffoldBackgroundColor: Theme.of(context).primaryColor),
                  child: CupertinoDatePicker(
                    backgroundColor: Theme.of(context).primaryColor,
                    onDateTimeChanged: (DateTime newDate) {
                      _dob = DateFormat('dd-MMM-yyyy').format(newDate);
                    },
                    maximumDate: new DateTime(2018, 12, 30),
                    minimumYear: 1960,
                    maximumYear: 2018,
                    minuteInterval: 1,
                    initialDateTime: new DateTime(2000, 1, 1),
                    mode: CupertinoDatePickerMode.date,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Material(
                    type: MaterialType.transparency,
                    child: IconButton(
                        focusColor: androidTVFocusColor,
                        icon: Icon(
                          FontAwesomeIcons.check,
                        ),
                        onPressed: () {
                          setState(() {
                            print('dob=$_dob');
                          });
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  bool isDatachanged = false;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    PlayerProfileArguments playerProfileArguments =
        ModalRoute.of(context).settings.arguments;
    submitButton.setClickHandler(() {
      submitButtonPress(playerProfileArguments);
    });
    _bIsCurrentPlayer = playerProfileArguments.playerDetails.bIsCurrentPlayer;
    _activityStats = playerProfileArguments.playerDetails.activityStats;

    if (playerProfileArguments?.playerDetails != null) {
      _profilePicUrl =
          _profilePicUrl ?? playerProfileArguments.playerDetails.profilePicUrl;
      _playerId = _playerId ?? playerProfileArguments.playerDetails.playerId;
      _fullName = _fullName ?? playerProfileArguments.playerDetails.playerName;
      _gender = _gender ?? playerProfileArguments.playerDetails.gender;
      _dob = _dob ?? playerProfileArguments.playerDetails.dob;
      _weight = _weight ?? playerProfileArguments.playerDetails.weight;
      _height = _height ?? playerProfileArguments.playerDetails.height;
      _profilePic =
          _profilePic ?? playerProfileArguments.playerDetails.profilePic;
    } else {
      print("No arguments found for editing profile");
    }

    if (_profilePicUrl == playerProfileArguments.playerDetails.profilePicUrl &&
        _fullName == playerProfileArguments.playerDetails.playerName &&
        _gender == playerProfileArguments.playerDetails.gender &&
        _dob == playerProfileArguments.playerDetails.dob &&
        _weight == playerProfileArguments.playerDetails.weight &&
        _height == playerProfileArguments.playerDetails.height &&
        _profilePic == playerProfileArguments.playerDetails.profilePic) {
      isDatachanged = false;
    } else {
      isDatachanged = true;
    }
    YipliTextInput _nameInput = new YipliTextInput(
        "Name",
        "Full name",
        Icons.account_circle,
        false,
        YipliValidators.validateName,
        onSavedFullName,
        _fullName);
    YipliTextInput _weightInput = new YipliTextInput(
        "Weight",
        "Weight(kgs)",
        FontAwesomeIcons.weight,
        false,
        YipliValidators.validateWeight,
        onSavedWeight,
        _weight);
    _weightInput.inputType = TextInputType.numberWithOptions(decimal: true);

    _weightInput.addWhitelistingTextFormatter(FilteringTextInputFormatter.allow(
        RegExp(r"^\d{1,5}|\d{0,5}\.\d{1,2}$")));
    YipliTextInput _heightInput = new YipliTextInput(
        "Height",
        "Height(cms)",
        FontAwesomeIcons.rulerVertical,
        false,
        YipliValidators.validateHeight,
        onSavedHeight,
        _height);

    _heightInput.inputType = TextInputType.numberWithOptions(decimal: true);
    _heightInput.addWhitelistingTextFormatter(FilteringTextInputFormatter.allow(
        RegExp(r"^\d{1,5}|\d{0,5}\.\d{1,2}$")));

    return YipliPageFrame(
      title: Text('Edit Profile'),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              //list tile of all the player data
              Column(
                children: <Widget>[
                  SizedBox(
                    height: YipliConstants.getProfilePicDimensionsLarge(context)
                            .height *
                        0.80,
                  ),
                  Form(
                    key: _addNewPlayerFormKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          width: screenSize.width * 0.9,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          height: screenSize.height / 2,

                          ///container with details
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: screenSize.height / 80),
                                  _nameInput,
                                  SizedBox(height: screenSize.height / 80),
                                  //gender radio button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 22),
                                        child: Icon(
                                          FontAwesomeIcons.venusMars,
                                          size: 16,
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      Theme(
                                        data: Theme.of(context).copyWith(
                                            unselectedWidgetColor: yipliWhite),
                                        child: RadioButtonGroup(
                                          orientation: GroupedButtonsOrientation
                                              .HORIZONTAL,
                                          margin: EdgeInsets.only(left: 12.0),
                                          activeColor:
                                              Theme.of(context).accentColor,
                                          onSelected: (String selected) =>
                                              setState(() {
                                            _gender = selected;
                                          }),
                                          labels: <String>[
                                            "Male",
                                            "Female",
                                            "Other"
                                          ],
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                          picked: _gender,
                                          itemBuilder:
                                              (Radio rb, Text txt, int i) {
                                            return Row(
                                              children: <Widget>[
                                                rb,
                                                txt,
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenSize.height / 80),
                                  //DOB selector
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 22),
                                        child: Icon(
                                          FontAwesomeIcons.birthdayCake,
                                          size: 16,
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 22),
                                        child: InkWell(
                                          onTap: () => _selectDate(context),
                                          child: Text(
                                            _dob,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                    color: Theme.of(context)
                                                        .primaryColorLight),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenSize.height / 80),
                                  _weightInput,
                                  SizedBox(height: screenSize.height / 80),
                                  _heightInput,
                                  SizedBox(height: screenSize.height / 100),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height / 15),
                  isDatachanged ? submitButton : Container(),
                ],
              ),
              //Profile picture
              Container(
                child: ModalProgressHUD(
                  inAsyncCall: _isScreenLoading,
                  progressIndicator: YipliLoader(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: screenSize.height / 400,
                      ),
                      _buildProfileImage(
                          context,
                          playerProfileArguments.playerDetails.playerId,
                          playerProfileArguments.playerDetails.profilePicUrl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
