//this Page is not in use

//TODO: remove this code
import 'package:intl/intl.dart';
import 'a_pages_index.dart';

class PlayerAdd extends StatefulWidget {
  static const String routeName = "/player_add_screen";

  @override
  _PlayerAddState createState() => _PlayerAddState();
}

class _PlayerAddState extends State<PlayerAdd> {
  String _playerId = "";
  String _profilePicUrl = "";
  String _fullName;
  String _gender;
  String _dob;
  String _weight;
  String _height;
  List<PlayerModel> allPlayersModels = new List<PlayerModel>();

  bool bIsNewRecord = true;
  GlobalKey<FormState> _addNewPlayerFormKey;
  final YipliButton addPlayerButton = new YipliButton("Add Player");
  FileImage _profilePic;

  Future<void> submitButtonPress() async {
    print("Submit player Pressed!");

    final FormState form = _addNewPlayerFormKey.currentState;
    if (_addNewPlayerFormKey.currentState.validate()) {
      form.save();
      print("Add player");
      //Check If the player Name already exist under the same user.
      bool bIsPlayerNameDuplicate = false;
      if (allPlayersModels.length > 0) {
        for (int iCount = 0; iCount < allPlayersModels.length; iCount++) {
          if (_fullName.toLowerCase() ==
              allPlayersModels[iCount].name.toLowerCase()) {
            bIsPlayerNameDuplicate = true;
            break;
          }
        }
      }
      if (bIsPlayerNameDuplicate == true) {
        YipliUtils.showNotification(
            context: context,
            msg:
                "Player name already exists. Choose some other name for the player.",
            type: SnackbarMessageTypes.ERROR);
      } else {
        try {
          User user = FirebaseAuth.instance.currentUser;
          print(
              'Adding new Player with following details :${user.uid}  $_fullName $_dob $_gender $_weight $_height');
          PlayerDetails playerTile = new PlayerDetails(
            dob: _dob,
            playerId: _playerId,
            userId: user.uid,
            playerName: _fullName,
            gender: _gender,
            height: _height,
            weight: _weight,
            profilePic: _profilePic,
          );

          Players newPlayer =
              new Players.createDBPlayerFromPlayerDetails(playerTile);
          String newPlayerIdFromDB = await newPlayer.persistNewRecord();

          print("************** Making default ********");

          print("Allplayers length = ${allPlayersModels.length}");
          if (allPlayersModels.length == 0) {
            await Users.changeCurrentPlayer(newPlayerIdFromDB);
            YipliUtils.goToHomeScreen();
          } else {
            Navigator.of(context).pop();
            YipliUtils.showNotification(
                context: context,
                msg: "New Player Added",
                type: SnackbarMessageTypes.SUCCESS);
          }
        } catch (error) {
          print(error);
          print('Error Aaya - Add player');
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addPlayerButton.setClickHandler(submitButtonPress);
    _addNewPlayerFormKey = GlobalKey<FormState>();
  }

  Widget _buildProfileImage(BuildContext context, String playerIdFromArgs,
      String profilePicUrlFromArgs) {
    print("Building the player profile image");
    return Center(
      child: GestureDetector(
        child: Container(
          width: YipliConstants.getProfilePicDimensionsLarge(context).width,
          height: YipliConstants.getProfilePicDimensionsLarge(context).height,
          decoration: BoxDecoration(
            color: yipliWhite,
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.pink.withOpacity(0.35), BlendMode.dstATop),
                fit: BoxFit.cover,
                image: _profilePic == null
                    ? AssetImage("assets/images/default_image_placeholder.jpg")
                    : _profilePic),
            borderRadius: BorderRadius.circular(
                YipliConstants.getProfilePicDimensionsLarge(context).height),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 3.0,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.photo_camera,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        onTap: () {
          DatabaseReference pathRef = FirebaseDatabaseUtil()
              .rootRef
              .child("profiles")
              .child("users")
              .child(FirebaseAuth.instance.currentUser.uid)
              .child("players")
              .child(playerIdFromArgs)
              .child("profile-pic-url");
          YipliUtils.getImage(context, profilePicUrlFromArgs, pathRef)
              .then((image) {
            if (image != null) {
              setState(() {
                print("Setting the new player profilePic internally");
                _profilePic = FileImage(image);
              });
            }
          });
        },
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

  //date picker
  DateTime selectedDate; //= DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dob = DateFormat('dd-MMM-yyyy').format(selectedDate);
        print('dob=$_dob');
      });
  }

  @override
  Widget build(BuildContext context) {
    allPlayersModels = ModalRoute.of(context).settings.arguments;

    print("Recieved ${allPlayersModels.length} players in add player screen");

    final Size screenSize = MediaQuery.of(context).size;
    YipliTextInput _nameInput = new YipliTextInput(
        "Name",
        "Full name*",
        Icons.account_circle,
        false,
        YipliValidators.validateName,
        onSavedFullName,
        _fullName);
    YipliTextInput _weightInput = new YipliTextInput(
        "Weight",
        "Weight(kgs)",
        Icons.call_to_action,
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
        Icons.equalizer,
        false,
        YipliValidators.validateHeight,
        onSavedHeight,
        _height);
    _heightInput.inputType = TextInputType.numberWithOptions(decimal: true);
    _heightInput.addWhitelistingTextFormatter(FilteringTextInputFormatter.allow(
        RegExp(r"^\d{1,5}|\d{0,5}\.\d{1,2}$")));

    return YipliPageFrame(
      selectedIndex: 0,
      title: Text('Player Profile'),
      child: Stack(
        children: <Widget>[
          Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: YipliConstants.getProfilePicDimensionsLarge(context)
                          .height *
                      0.68,
                ),
                Form(
                  key: _addNewPlayerFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                      height: screenSize.height / 2,
                      child: Center(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              _nameInput,
                              SizedBox(height: screenSize.height / 80),
                              //gender radio button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Icon(
                                        Icons.wc,
                                        color: yipliWhite,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioButtonGroup(
                                      orientation:
                                          GroupedButtonsOrientation.HORIZONTAL,
                                      margin: const EdgeInsets.only(left: 12.0),
                                      activeColor: yiplilightOrange,
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
                                          .bodyText2
                                          .copyWith(
                                            fontFamily: 'Tri',
                                          ),
                                      picked: _gender,
                                      itemBuilder: (Radio rb, Text txt, int i) {
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: Icon(
                                      Icons.assignment_ind,
                                      color: yipliWhite,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: Text(
                                      'DOB: ',
                                      style: TextStyle(
                                        color: yipliWhite,
                                        fontFamily: 'Tri',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      (selectedDate != null)
                                          ? "${selectedDate.toLocal()}"
                                              .split(' ')[0]
                                          : (_dob != null)
                                              ? _dob
                                              : "",
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1.0),
                                    child: RaisedButton(
                                      focusColor: androidTVFocusColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: BorderSide(color: yipliWhite)),
                                      color: yipliWhite,
                                      onPressed: () => _selectDate(context),
                                      child: Text(
                                        'Select',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenSize.height / 80),
                              _weightInput,
                              SizedBox(height: screenSize.height / 80),
                              _heightInput,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.height / 15,
                ),
                addPlayerButton,
              ],
            ),
          ),
          //Profile picture
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: screenSize.height * 0.001,
                ),
                _buildProfileImage(context, _playerId, _profilePicUrl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
