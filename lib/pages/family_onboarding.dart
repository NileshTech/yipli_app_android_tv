import 'package:flutter_app/external_plgins/stepper.dart';
import 'package:flutter_app/external_plgins/stepper3.dart';
import 'a_pages_index.dart';

class FamilyOnboardingPage extends StatefulWidget {
  static const String routeName = '/family_onboarding';

  @override
  _FamilyOnboardingPageState createState() => _FamilyOnboardingPageState();
}

class _FamilyOnboardingPageState extends State<FamilyOnboardingPage> {
  FileImage _profilePic;
  String _profilePicUrl;
  String _familyName = "";
  String _contactNo;
  String _location;

  var result;
  String userId;
  bool _isUploading = false;
  String _defaultPic = "assets/images/default_image_placeholder.jpg";
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController contactEditingController = new TextEditingController();
  int currentStep = 0;
  Tween<double> _scaleTween = Tween<double>(begin: 0.75, end: 0.9);

  // ignore: unused_field
  bool _isScreenLoading = false;

  @override
  void initState() {
    userId = AuthService.getCurrentUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YipliPageFrame(
      title: Text('Family Profile Setup'),
      backgroundMode: YipliBackgroundMode.dark,
      child: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            switch (orientation) {
              case Orientation.portrait:
                return _buildStepper(YipliStepperType.vertical);
              case Orientation.landscape:
                return _buildStepper(YipliStepperType.horizontal);
              default:
                throw UnimplementedError(orientation.toString());
            }
          },
        ),
      ),
    );
  }

  Widget _familyNameInput(BuildContext context) {
    return currentStep == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
                SizedBox(),
                TweenAnimationBuilder(
                  tween: _scaleTween,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 1700),
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Text(
                    "What's your family name ?",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
                TextField(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.white),
                  onChanged: (_) {
                    _familyName = textEditingController.text;
                    _familyName = _familyName.trim();
                    setState(() {
                      return _familyName;
                    });
                    print("the family name is: $_familyName");
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
                    hintText: ' Family Name',
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
                AutoSizeText.rich(
                  TextSpan(
                    text: "* Name should be more than two characters.",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: yipliGray),
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(),
              ])
        : Container();
  }

  Widget _familyProfilePic(BuildContext context, String userId) {
    print("Building the family profile image");
    return currentStep == 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TweenAnimationBuilder(
                tween: _scaleTween,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 1700),
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Text(
                  "Add your family photo",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: GestureDetector(
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Container(
                              width:
                                  YipliConstants.getProfilePicDimensionsLarge(
                                              context)
                                          .width *
                                      1.5,
                              height:
                                  YipliConstants.getProfilePicDimensionsLarge(
                                              context)
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
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              height:
                                  YipliConstants.getProfilePicDimensionsLarge(
                                              context)
                                          .height *
                                      1.5,
                              width:
                                  YipliConstants.getProfilePicDimensionsLarge(
                                              context)
                                          .width *
                                      1.5,
                              child: CircularProgressIndicator(
                                strokeWidth: 4.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(_isUploading ? 1.0 : 0)),
                              ),
                            ),
                          )
                        ],
                      ),
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
                              .child(userId)
                              .child("profile-pic-url");

                          result = await YipliUtils.profilePicOptions(
                              context,
                              sizeToUpload,
                              fileName,
                              userId,
                              _profilePicUrl,
                              pathRef);
                          if (result != null) {
                            setState(() {
                              _isUploading = true;
                            });
                            result.uploadTask.events
                                .listen((uploadTaskEvent) async {
                              String oldprofilepic;
                              oldprofilepic = _profilePicUrl;
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
                                    if (oldprofilepic != null) {
                                      FirebaseStorageUtil.profilePicsRef
                                          .child(oldprofilepic)
                                          .delete();
                                    }
                                    _isUploading = false;
                                    _profilePicUrl = fileName;
                                    _profilePic = FileImage(result.imageFile);
                                  });
                                  YipliUtils.showNotification(
                                    context: context,
                                    msg:
                                        "Picture uploaded successfully. Tap submit to save.",
                                    duration: SnackbarDuration.SHORT,
                                    type: SnackbarMessageTypes.SUCCESS,
                                  );

                                  await saveUserProfileData();
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
                              msg:
                                  "Internet Connectivity is required to change Profile.",
                              type: SnackbarMessageTypes.ERROR,
                              duration: SnackbarDuration.MEDIUM);
                        }
                      }),
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _contactNumber(BuildContext context) {
    return currentStep == 2
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                SizedBox(),
                TweenAnimationBuilder(
                  tween: _scaleTween,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 1700),
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Text(
                    "Enter your phone number",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white, fontWeight: FontWeight.normal),
                  ),
                ),
                TextField(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.white),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) {
                    _contactNo = contactEditingController.text;
                    _contactNo = _contactNo.trim();
                    setState(() {
                      return _contactNo;
                    });
                    print("the contact number is: $_contactNo");
                  },
                  controller: contactEditingController,
                  autofocus: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: yipliWhite,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Contact Number',
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
                AutoSizeText.rich(
                  TextSpan(
                    text: "Enables you to login with phone number",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: yipliGray),
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(),
              ])
        : Container();
  }

  YipliCupertinoStepper _buildStepper(YipliStepperType type) {
    final canCancel = currentStep > 0;
    final canContinue = currentStep < 3;
    return YipliCupertinoStepper(
      type: type,
      currentStep: currentStep,
      onStepTapped: (step) => setState(() => currentStep = step),
      // onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
      onStepContinue:
          canContinue ? () => setState(() => onContinuePress()) : null,
      steps: [
        _buildStep(
          title: Text('Name'),
          content: _familyNameInput(context),
          isActive: 0 == currentStep,
          isSkipButtonEnabled: false,
          icon: FontAwesomeIcons.users,
          state: 0 == currentStep
              ? YipliStepState.editing
              : 0 < currentStep
                  ? YipliStepState.complete
                  : YipliStepState.indexed,
        ),
        _buildStep(
          title: Text('Photo'),
          content: _familyProfilePic(context, userId),
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
          title: Text('Contact'),
          content: _contactNumber(context),
          icon: Icons.phone,
          isActive: 2 == currentStep,
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
      // subtitle: Text(''),
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

  void onContinuePress() {
    switch (currentStep) {
      case 0:
        _familyName.length < 2
            ? YipliUtils.showNotification(
                context: context,
                msg: "Name must be more than two characters",
                duration: SnackbarDuration.MEDIUM,
                type: SnackbarMessageTypes.ERROR,
              )
            : ++currentStep;
        break;
      case 1:
        {
          if (_profilePicUrl == null) {
            YipliUtils.showNotification(
              context: context,
              msg: "You have not added profile picture",
              duration: SnackbarDuration.MEDIUM,
              type: SnackbarMessageTypes.SUCCESS,
            );
            ++currentStep;
          } else {
            ++currentStep;
          }
          break;
        }
      case 2:
        {
          if (_contactNo != null) {
            _contactNo.trim();
          }
          if (_contactNo == null || _contactNo.length != 10) {
            YipliUtils.showNotification(
              context: context,
              msg: "Enter valid number",
              duration: SnackbarDuration.MEDIUM,
              type: SnackbarMessageTypes.SUCCESS,
            );
          }
          saveData = true;
          saveUserProfileData();
          break;
        }
    }
  }

  bool saveContact = false;
  bool saveData = false;
  Future saveUserProfileData() async {
    Function onSuccess;
    Function onFailed;
    if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
      try {
        setState(() {
          _isScreenLoading = true;
        });
        User user = FirebaseAuth.instance.currentUser;
        print(
            'Adding new Player with following details :${user.uid}  $_familyName   $_profilePicUrl ');
        if (saveContact == true) {
          UserDetails userTile = new UserDetails(
            userName: _familyName,
            userMailId: user.email,
            contactNo: _contactNo,
            userId: user.uid,
            userLocation: _location,
            profilePicUrl: _profilePicUrl,
          );
          Users newUser = new Users.createDBUserFromUserDetails(userTile);
          await newUser.persistRecord();
          YipliUtils.goToUserOnboardingPage();
        } else if (saveData == true && _contactNo == null) {
          UserDetails userTile = new UserDetails(
            userName: _familyName,
            userMailId: user.email,
            userId: user.uid,
            userLocation: _location,
            profilePicUrl: _profilePicUrl,
          );

          Users newUser = new Users.createDBUserFromUserDetails(userTile);
          await newUser.persistRecord();
          YipliUtils.goToUserOnboardingPage();
        }

        setState(() {});
        // Navigator.of(context).pushNamed(FitnessGaming.routeName);
      } catch (error) {
        setState(() {});
        print(error);
        print('Error Aaya -  user');
      }
    } else {
      YipliUtils.showNotification(
          context: context,
          msg: "No Internet Connectivity",
          type: SnackbarMessageTypes.ERROR,
          duration: SnackbarDuration.MEDIUM);
    }
    if (currentStep == 2 && _contactNo.length == 10) {
      if (await Users.isPhoneRegisteredUnderAnyUser(_contactNo)) {
        //Code to check if the phone no is a registered one.
        //If not, show msg and exit
        setState(() {
          contactEditingController.text = "";
          _contactNo = null;
          YipliUtils.showNotification(
              context: context,
              msg:
                  "This phone number is already registered with Yipli.\nTry to login with another number.",
              type: SnackbarMessageTypes.ERROR,
              duration: SnackbarDuration.LONG);
        });
      } else {
        ConfirmAction actionConfirmation =
            await YipliUtils.showPhoneVerificationDialog(
                context, _contactNo, onSuccess, onFailed);
        if (_contactNo.length == 10 &&
            actionConfirmation == ConfirmAction.YES) {
          saveContact = true;
          // addContactno(_contactNo);
          YipliUtils.goToUserOnboardingPage();
        }
      }
    }
  }
}
