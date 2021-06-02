import 'package:flutter_app/pages/user_on_boaring/user_on_boarding_final_page.dart';
import 'package:flutter_app/pages/user_on_boaring/user_on_boarding_player_add_page.dart';

import 'a_pages_index.dart';

enum MatValidation {
  NO_ERROR,
  INVALID_NICKNAME,
  INVALID_MAC_ADDRESS,
  MAC_ADDRESS_ALREADY_ADDED
}

class AddNewMatPage extends StatefulWidget {
  static const String routeName = "/add_new_mat";
  @override
  _AddNewMatPageState createState() => _AddNewMatPageState();
}

class _AddNewMatPageState extends State<AddNewMatPage> {
  MatPageArguments matPageArgs = new MatPageArguments();

  String _macAddress;
  String _nickName;
  String _mName;
  GlobalKey<FormState> _addNewMatFormKey;
  YipliTextInput macAddressTextInput;
  final YipliButton addMatButton = new YipliButton("Add");
  bool _saving = false;
  bool isOnboardingFlow = false;
  Future<void> addMatButtonPress() async {
    print("Add mat Press!");

    final FormState form = _addNewMatFormKey.currentState;
    if (_addNewMatFormKey.currentState.validate()) {
      if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
        form.save();
        setState(() {
          isAddButtonPressed = true;
          _saving = true;
        });

        print("Add mat user!");
        try {
          FirebaseDatabaseUtil util = FirebaseDatabaseUtil();
          DataSnapshot usersMatData =
              await util.rootRef.child(MatsModel.getModelRef()).once();
          print(usersMatData.value);
          MatValidation matValidationResult = await validateNewMatForUser(
              _macAddress, _nickName, usersMatData.value);
          switch (matValidationResult) {
            case MatValidation.NO_ERROR:
              MatModel newUserMat = MatModel.create(
                  registeredOn: new DateTime.now(),
                  status: "Active",
                  macAddress: _macAddress,
                  macName: _mName,
                  displayName: _nickName);
              String matId = await newUserMat.persist();
              Users.changeCurrentMat(matId);

              //handling routing when add new mat is called from onboarding flow and from mats page
              isOnboardingFlow == true
                  ? YipliUtils.goToUserOnboardingPage()
                  : YipliUtils.goToHomeScreen();

              YipliUtils.showNotification(
                  context: context,
                  msg: "Mat successfully added.",
                  type: SnackbarMessageTypes.SUCCESS);
              break;
            case MatValidation.INVALID_NICKNAME:
              YipliUtils.showNotification(
                  context: context,
                  msg: "Oops! That name's taken. Choose another name",
                  type: SnackbarMessageTypes.WARN);
              break;
            case MatValidation.INVALID_MAC_ADDRESS:
              YipliUtils.showNotification(
                  context: context,
                  msg:
                      "That Mac Address seems wrong. Try again or call support",
                  type: SnackbarMessageTypes.WARN);
              break;
            case MatValidation.MAC_ADDRESS_ALREADY_ADDED:
              YipliUtils.showNotification(
                  context: context,
                  msg: "This Mat is already registered with another nickname!",
                  type: SnackbarMessageTypes.WARN);
              break;
          }
        } catch (error) {
          print(error);
          print('Error Aala - Add mat');
        } finally {
          setState(() {
            _saving = false;
          });
        }
      } else {
        YipliUtils.showNotification(
            context: context,
            msg: "No Internet Connectivity",
            type: SnackbarMessageTypes.ERROR,
            duration: SnackbarDuration.MEDIUM);
      }
    }
  }

  bool isAddButtonPressed;

  @override
  void initState() {
    super.initState();
    addMatButton.setClickHandler(addMatButtonPress);
    _addNewMatFormKey = GlobalKey<FormState>();
    isAddButtonPressed = false;
    super.initState();
  }

  String validateMacAddressAfterAddButtonPress(String value) {
    if (!isAddButtonPressed)
      return null;
    else {
      print("Validating mac!");
      Pattern pattern = r'^([A-F0-9]*)$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value.replaceAll(":", "")))
        return 'Enter valid mac address!';
      else
        return null;
    }
  }

  String validateNameAfterAddButtonPress(String value) {
    if (!isAddButtonPressed)
      return null;
    else if (value.length < 3)
      return 'Please enter more than 2 charaters';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    matPageArgs = ModalRoute.of(context).settings.arguments;
    if (matPageArgs == null) {
      isOnboardingFlow = false;
      _macAddress = null;
    } else {
      isOnboardingFlow = matPageArgs.isOnboardingFlow;
      if (matPageArgs.macAddress != null) _macAddress = matPageArgs.macAddress;
    }
    _nickName = _nickName ?? "";

    macAddressTextInput = YipliTextInput(
        '00:00:00:00:00:00',
        'MAC Address',
        Icons.computer,
        false,
        validateMacAddressAfterAddButtonPress,
        this.onSavedMacAddress,
        _macAddress,
        _macAddress == null,
        null,
        null,
        MacAddressTextFormatter());
    return ModalProgressHUD(
      inAsyncCall: _saving,
      progressIndicator: YipliLoader(),
      child: YipliPageFrame(
        title: Text('Add Mat'),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20),
            child: Form(
              key: _addNewMatFormKey,
              autovalidateMode: AutovalidateMode.always,
              //  autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Transform.rotate(
                        angle: -pi / 2,
                        child: Padding(
                          padding: EdgeInsets.all(28.0),
                          child: Image.asset(
                            YipliConstants.matIconFile,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: macAddressTextInput,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: YipliTextInput(
                              'e.g. My Yipli Mat',
                              'Mat Nickname',
                              Icons.loyalty,
                              false,
                              validateNameAfterAddButtonPress,
                              // YipliValidators.validateName,
                              onSavedMatNickname,
                              null,
                              true,
                              null),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(flex: 1, child: Container()),
                            Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 28.0),
                                  child: addMatButton,
                                )),
                            Expanded(flex: 1, child: Container()),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSavedMacAddress(String macAddressFromInput) {
    _macAddress = macAddressFromInput;
    print("Mac address $_macAddress saved");
  }

  void onSavedMatNickname(String nickNameFromInput) {
    _nickName = nickNameFromInput;
    print('_nickName $_nickName saved');
  }

  Future<MatValidation> validateNewMatForUser(String macAddress,
      String nickName, LinkedHashMap<dynamic, dynamic> value) async {
    bool isValidMacAddress = await validateMacAddress(macAddress);
    if (!isValidMacAddress) return MatValidation.INVALID_MAC_ADDRESS;
    try {
      if (value != null) {
        for (var currentMat in value.values) {
          String currentMatAddress = currentMat["mac-address"];
          if (currentMatAddress == macAddress)
            return MatValidation.MAC_ADDRESS_ALREADY_ADDED;
          String currentMatNickname = currentMat["display-name"];
          if (currentMatNickname == nickName)
            return MatValidation.INVALID_NICKNAME;
        }
      }
      return MatValidation.NO_ERROR;
    } catch (exception) {
      print("Exception!!!");
      print(exception);
      return MatValidation.INVALID_MAC_ADDRESS;
    }
  }

  Future<bool> validateMacAddress(String macAddress) async {
    DataSnapshot matFoundInInventory = await FirebaseDatabaseUtil()
        .matsInventoryRef
        .orderByChild("mac-address")
        .equalTo(macAddress)
        .once();
    print("Found valid mac address: ${matFoundInInventory.value}");

    LinkedHashMap macNameEntryInDB = matFoundInInventory.value;
    for (var faq in macNameEntryInDB.entries) {
      _mName = faq.value['mac-name'];
      break;
    }

    print(_mName);

    return (matFoundInInventory.value != null);
  }
}

class MacAddressTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    //
    String newTextValue = newValue.text;
    String stringMaskPattern = "AA:AA:AA:AA:AA:AA";
    String sanitizedValue = newTextValue.replaceAll(":", "");
    String subMask = stringMaskPattern.substring(
        0, getMastPatternIndex(sanitizedValue.length));
    var stringMask = StringMask(subMask);
    print(
        "Submask: $subMask -- $sanitizedValue -- ${stringMask.apply(sanitizedValue)}");
    // 0123456789A0
    String newValueTextToReplace = stringMask.apply(sanitizedValue);
    return newValue.copyWith(
      text: newValueTextToReplace.toUpperCase(),
      selection: TextSelection.collapsed(offset: newValueTextToReplace.length),
    );
  }

  int getMastPatternIndex(int length) {
    print("Current Length: $length");
    int returnValue = length;
    switch (length) {
      case 1:
      case 2:
        returnValue = length;
        break;
      case 3:
      case 4:
        returnValue = length + 1;
        break;
      case 5:
      case 6:
        returnValue = length + 2;
        break;
      case 7:
      case 8:
        returnValue = length + 3;
        break;
      case 9:
      case 10:
        returnValue = length + 4;
        break;
      case 11:
      case 12:
        returnValue = length + 5;
        break;
      case 13:
        returnValue = 17;
        break;
      default:
        return 0;
    }
    print("Returned Length - $returnValue");
    return returnValue;
  }
}
