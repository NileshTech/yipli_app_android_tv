import 'package:device_info/device_info.dart';

import 'a_pages_index.dart';

AuthService authService;

class Login extends StatelessWidget {
  static const String routeName = "/login_screen";
  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _counter = 60;
  Timer _timer;

  void _startTimerForOTP() {
    _counter = 60;
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter > 0) {
          _counter--;
        } else {
          displayTimer = false;
          isOTPSent = false;
          _timer.cancel();
        }
      });
    });
  }

  bool bIsTandCChecked = false;

  GlobalKey<FormState> _formKey;

  YipliTextInput emailorPhoneInput;

  YipliTextInput passwordInput;

  YipliTextInput otpInput;
  bool showLoginButton;
  bool showPasswordInput;
  bool showOTPInput;
  bool displayTimer;
  String storedString; //Used to store string when next button is pressed
  Function onSuccess;
  Function onFailed;

  Future<void> onLogInPress() async {
    print('login button pressed');

    setState(() {
      isLoginButtonPressed = true;
      _saving = true;
    });
    {
      {
        print("LOGIN Up Press!");

        final FormState form = _formKey.currentState;
        if (isOTPSent == true && validateOTPAfterLoginPress(otpCode) == null) {
          await authService.phoneNumberSignIn(
              context, YipliUtils.smsVerificationCode, otpCode);
        } else if (_formKey.currentState.validate()) {
          if (bIsTandCChecked == true) {
            if (YipliUtils.appConnectionStatus ==
                AppConnectionStatus.CONNECTED) {
              form.save();
              print("Logging in user!");

              try {
                print(_emailOrPhoneStr + " -- " + _password);
                setState(() {
                  _saving = true;
                });

                User loggedInUser =
                    await authService.emailSignIn(_emailOrPhoneStr, _password);

                setState(() {
                  _saving = false;
                });

                if (loggedInUser != null) {
                  YipliUtils.initializeApp();
                } else {
                  print("Invalid - ");
                }
              } catch (e) {
                setState(() {
                  _saving = false;
                });
                print(e);
                switch (e.code) {
                  case "ERROR_INVALID_CREDENTIAL":
                  case "invalid-credential":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The supplied auth credential is malformed or has expired.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_INVALID_EMAIL":
                  case "invalid-email":
                    YipliUtils.showNotification(
                        context: context,
                        msg: "The email address is badly formatted.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_WRONG_PASSWORD":
                  case "invalid-password":
                  case "wrong-password":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The password is invalid or the user does not have a password.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_REQUIRES_RECENT_LOGIN":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "This operation is sensitive and requires recent authentication. Log in again before retrying this request.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
                  case "invalid-credential":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_EMAIL_ALREADY_IN_USE":
                  case "ERROR_CREDENTIAL_ALREADY_IN_USE":
                  case "email-already-exists":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "This credential is already associated with a different user account.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_USER_DISABLED":
                  case "invalid-disabled-field":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The user account has been disabled by an administrator.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  case "ERROR_USER_NOT_FOUND":
                  case "user-not-found":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "There is no user record corresponding to this identifier. The user may have been deleted.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                  default:
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "There was an error logging you in at the moment. If error persists, please contact Yipli Support.",
                        type: SnackbarMessageTypes.ERROR);

                    break;
                }
                print('Error - Login');
              }
            } else {
              YipliUtils.showNotification(
                  context: context,
                  msg: "No Internet Connectivity",
                  type: SnackbarMessageTypes.ERROR,
                  duration: SnackbarDuration.MEDIUM);
            }
          } else {
            showTermsAndConditionsAlert();
          }
        }
      }
    }
    setState(() {
      _saving = false;
    });
  }

  Future<void> onNextButtonPressed() async {
    if (YipliValidators.validateEmail(_emailOrPhoneStr) == null) {
      if (!await Users.isEmailRegisteredUnderAnyUser(_emailOrPhoneStr)) {
        setState(() {
          YipliUtils.showNotification(
              context: context,
              msg:
                  "This email  is not registered with Yipli.\nRegister your email first",
              type: SnackbarMessageTypes.ERROR,
              duration: SnackbarDuration.LONG);
        });
      } else {
        setState(() {
          showPasswordInput = true;
          showLoginButton = true;
          storedString = _emailOrPhoneStr;
        });
      }
    } else if (YipliValidators.validatePhoneNumberLength(_emailOrPhoneStr) ==
        null) {
      if (!await Users.isPhoneRegisteredUnderAnyUser(_emailOrPhoneStr)) {
        //Code to check if the phone no is a registered one.
        //If not, show msg and exit
        setState(() {
          YipliUtils.showNotification(
              context: context,
              msg:
                  "This phone number is not registered with Yipli.\nTry to login with email.",
              type: SnackbarMessageTypes.ERROR,
              duration: SnackbarDuration.LONG);
        });
      } else {
        print('Generate OTP button pressed');
        setState(() {
          displayTimer = true;
          showLoginButton = true;
          showOTPInput = true;
          storedString = _emailOrPhoneStr;
          _startTimerForOTP();
        });
        YipliUtils.showNotification(
            context: context,
            msg: "OTP has been sent on your mobile number.",
            type: SnackbarMessageTypes.INFO,
            duration: SnackbarDuration.LONG);
        await YipliUtils.getPhoneOtp(
            context, _emailOrPhoneStr, onSuccess, onFailed);
        isOTPSent = true;
        // isLoginButtonPressed = true;
      }
    } else {
      YipliUtils.showNotification(
          context: context,
          msg: "Enter valid email/phone number",
          type: SnackbarMessageTypes.ERROR);
    }
  }

  void onEmailSaved(String email) {
    _emailOrPhoneStr = email;
    print('Email $email saved');
    if (showLoginButton == true) {
      if (email != storedString) {
        setState(() {
          showLoginButton = false;
          storedString = "";
          showOTPInput = false;
          showPasswordInput = false;
          displayTimer = false;
        });
      }
    }
  }

  static void onPasswordSaved(String password) {
    _password = password;
    print('Password $password saved');
  }

  void onSavedContactNo(String contactNo) {
    contactno = contactNo;
    print("Contact $contactno saved");
  }

  YipliButton logInButton;
  YipliButton nextButton;
  YipliTextInput contactNoInput;
  String contactno = "";
  void onSignUpPress() async {
    if (bIsTandCChecked == true) {
      print('signup button pressed');
      setState(() {
        _saving = true;
      });
      {
        print("LOGIN -- ON Sign Up Press!");
        Navigator.of(context).pushNamed('/signup_screen');
      }
      setState(() {
        _saving = false;
      });
    } else {
      showTermsAndConditionsAlert();
    }
  }

  YipliButton signUpButton;

  @override
  void initState() {
    //Call the Class constructor and initialize the object
    _formKey = GlobalKey<FormState>();
    authService = new AuthService();
    isLoginButtonPressed = false;
    super.initState();
  }

  static String _emailOrPhoneStr = "";
  static String _password = "";
  String otpCode = "";
  bool isLoginButtonPressed;
  bool isOTPSent;
  bool _saving = false;
  bool _isLoading = false;
  void onSavedcode(String code) {
    otpCode = code;
    print("Contact $code saved");
  }

  String validateOTPAfterLoginPress(String value) {
    if (!isLoginButtonPressed)
      return null;
    else if (value.length < 6 || value.length > 6)
      return 'Enter valid OTP';
    else
      return null;
  }

  Widget _buildValidityDisplayTimer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("valid for :",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: yipliGray)),
          Text(
            " $_counter",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: yipliErrorRed),
          ),
        ],
      ),
    );
  }

  bool wasEmailFromArgsRead = false;
  @override
  Widget build(BuildContext context) {
    String emailfromargs = ModalRoute.of(context).settings.arguments;
    setState(() {
      if (emailfromargs != null && wasEmailFromArgsRead == false) {
        _emailOrPhoneStr = emailfromargs;
        showLoginButton = true;
        showPasswordInput = true;
        showOTPInput = false;
        displayTimer = false;
        storedString = emailfromargs;
        wasEmailFromArgsRead = true;
      }
    });
    final Size screenSize = MediaQuery.of(context).size;
    signUpButton = new YipliButton("Register",
        Theme.of(context).primaryColorLight, Theme.of(context).primaryColor);
    signUpButton.setClickHandler(onSignUpPress);
    emailorPhoneInput = new YipliTextInput(
      "",
      "Email or Phone no.",
      FontAwesomeIcons.at,
      false,
      null,
      onEmailSaved,
      _emailOrPhoneStr,
      true,
      null,
    );

    passwordInput = new YipliTextInput(
      "",
      "Password",
      FontAwesomeIcons.lock,
      true,
      null,
      onPasswordSaved,
      null,
      true,
      null,
      null,
      null,
      true, //forpasswordfield
    );

    contactNoInput = new YipliTextInput(
      "",
      "Contact Number",
      Icons.phone,
      false,
      null,
      onSavedContactNo,
      null,
      true,
      TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
    );
    contactNoInput.addWhitelistingTextFormatter(
        FilteringTextInputFormatter.allow(
            RegExp(r"^\d{1,10}|\d{0,5}\.\d{1,2}$")));
    otpInput = new YipliTextInput(
      "",
      "Enter your OTP here",
      Icons.security,
      false,
      validateOTPAfterLoginPress,
      onSavedcode,
      null,
      true,
      TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
    );
    logInButton = new YipliButton(
      "Login",
      null,
      null,
      screenSize.width / 4,
    );
    nextButton = new YipliButton(
      "Login",
      null,
      null,
      screenSize.width / 4,
    );
    logInButton.setClickHandler(onLogInPress);
    nextButton.setClickHandler(onNextButtonPressed);
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: ModalProgressHUD(
            inAsyncCall: _saving,
            progressIndicator: YipliLoader(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        primarycolor,
                        appbackgroundcolor,
                      ],
                      stops: [0.4, 0.7],
                    ),
                  ),
                ),
                Platform.isAndroid
                    ? SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 0.05 * screenSize.height,
                                  child: Container(),
                                ),
                                SizedBox(
                                  height: 0.1 * screenSize.height,
                                  child: Hero(
                                    tag: "yipli-logo",
                                    child: YipliLogoAnimatedSmall(),
                                  ),
                                ),
                                SizedBox(
                                  height: 0.02 * screenSize.height,
                                  child: Container(),
                                ),
                                SizedBox(
                                    height: 0.15 * screenSize.height,
                                    child: showLoginButton != true
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: buildFacebookButton(
                                                      screenSize, context)),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: buildGoogleButton(
                                                      screenSize, context))
                                            ],
                                          )
                                        : SizedBox(height: 0)),
                                SizedBox(
                                  height: showOTPInput == true
                                      ? 0.4 * screenSize.height
                                      : 0.3 * screenSize.height,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildTextFields(context),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 0.05 * screenSize.height,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              child: showLoginButton != true
                                                  ? buildRegisterLink(context)
                                                  : SizedBox(height: 0))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 0.05 * screenSize.height,
                                ),
                                SizedBox(
                                    height: 0.05 * screenSize.height,
                                    child:
                                        buildTermsAndConditionsLink(context)),
                                SizedBox(
                                    height: 0.05 * screenSize.height,
                                    child: buildPrivacyPolicyLink(context)),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Platform.isIOS
                        ? SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 0.05 * screenSize.height,
                                      child: Container(),
                                    ),
                                    SizedBox(
                                      height: 0.15 * screenSize.height,
                                      child: Hero(
                                        tag: "yipli-logo",
                                        child: YipliLogoAnimatedSmall(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.15 * screenSize.height,
                                      child: Container(),
                                    ),
                                    SizedBox(
                                      height: 0.3 * screenSize.height,
                                      child: _buildTextFields(context),
                                    ),
                                    SizedBox(
                                      height: 0.1 * screenSize.height,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                                child:
                                                    buildRegisterLink(context)),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                                child: buildForgotPasswordLink(
                                                    context)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: 0.05 * screenSize.height,
                                        child: buildTermsAndConditionsLink(
                                            context)),
                                    SizedBox(
                                        height: 0.05 * screenSize.height,
                                        child: buildPrivacyPolicyLink(context)),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 0.05 * screenSize.height,
                                      child: Container(),
                                    ),
                                    SizedBox(
                                      height: 0.15 * screenSize.height,
                                      child: Hero(
                                        tag: "yipli-logo",
                                        child: YipliLogoAnimatedSmall(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.02 * screenSize.height,
                                      child: Container(),
                                    ),
                                    SizedBox(
                                        height: 0.2 * screenSize.height,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            buildFacebookButton(
                                                screenSize, context),
                                            buildGoogleButton(
                                                screenSize, context)
                                          ],
                                        )),
                                    SizedBox(
                                      height: 0.3 * screenSize.height,
                                      child: _buildTextFields(context),
                                    ),
                                    SizedBox(
                                      height: 0.1 * screenSize.height,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                                child:
                                                    buildRegisterLink(context)),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Container(
                                                child: buildForgotPasswordLink(
                                                    context)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height: 0.05 * screenSize.height,
                                        child: buildTermsAndConditionsLink(
                                            context)),
                                    SizedBox(
                                        height: 0.05 * screenSize.height,
                                        child: buildPrivacyPolicyLink(context)),
                                  ],
                                ),
                              ),
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFields(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            emailorPhoneInput,
            showLoginButton == true
                ? showPasswordInput == true
                    ? passwordInput
                    : otpInput
                : SizedBox(height: 0),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: showLoginButton == true
                    ? buildLoginButtonWithOptions(context)
                    : nextButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center buildTermsAndConditionsLink(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Theme(
            data: Theme.of(context)
                .copyWith(unselectedWidgetColor: Theme.of(context).accentColor),
            child: Checkbox(
              checkColor: Theme.of(context).primaryColorLight,
              activeColor: Theme.of(context).accentColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: bIsTandCChecked,
              onChanged: (value) {
                setState(() {
                  bIsTandCChecked = value;
                });
              },
            ),
          ),
          FlatButton(
            focusColor: androidTVFocusColor,
            padding: EdgeInsets.all(0),
            child: Text(
              'Terms and Conditions',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).accentColor,
                  ),
            ),
            onPressed: () async {
              const url = 'https://playyipli.com/termsconditions.html';
              if (await canLaunch(url)) {
                await launch(url, forceSafariVC: false);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
        ],
      ),
    );
  }

  Center buildPrivacyPolicyLink(BuildContext context) {
    return Center(
      child: FlatButton(
        focusColor: androidTVFocusColor,
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 10.0, 2.0),
        child: Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                decoration: TextDecoration.none,
                color: Theme.of(context).accentColor,
              ),
        ),
        onPressed: () async {
          const url = 'https://playyipli.com/privacypolicy.html';
          if (await canLaunch(url)) {
            await launch(url, forceSafariVC: false);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
  }

  Widget buildRegisterLink(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(SignUp.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('New to Yipli? Register',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: yipliWhite, decoration: TextDecoration.underline)),
      ),
    );
  }

  Widget buildForgotPasswordLink(BuildContext ctxt) {
    return GestureDetector(
      onTap: () {
        if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
          AuthService.mobAuth
              .sendPasswordResetEmail(email: _emailOrPhoneStr)
              .then((_) {
            YipliUtils.goToForgotPasswordPage(_emailOrPhoneStr);
          }).catchError((err) {
            YipliUtils.showNotification(
                context: context,
                msg: "Something went wrong. Try after some time.",
                type: SnackbarMessageTypes.ERROR,
                duration: SnackbarDuration.MEDIUM);
          });
        } else {
          YipliUtils.showNotification(
              context: context,
              msg: "No Internet Connectivity",
              type: SnackbarMessageTypes.ERROR,
              duration: SnackbarDuration.MEDIUM);
        }
      },
      child: Text('Forgot Password?',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Theme.of(context).accentColor,
              )),
    );
  }

  Widget buildResendOTPText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onNextButtonPressed();
      },
      child: displayTimer == false
          ? Text('Resend OTP',
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Theme.of(context).accentColor,
                  ))
          : Container(),
    );
  }

  Widget buildLoginButtonWithOptions(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      showPasswordInput == true
          ? buildForgotPasswordLink(context)
          : displayTimer == true
              ? buildOTPwithTimer(context)
              : buildResendOTPText(context),
      logInButton,
    ]);
  }

  Widget buildOTPwithTimer(BuildContext context) {
    return displayTimer == true
        ? _buildValidityDisplayTimer(context)
        : Container();
  }

  GestureDetector buildGoogleButton(Size screenSize, BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColorLight),
        child: Container(
          width: screenSize.height / 22,
          height: screenSize.height / 22,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/Google.png"),
                fit: BoxFit.cover),
          ),
        ),
      ),
      onTap: () async {
        if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
          if (bIsTandCChecked == true) {
            print('google sign in');
            setState(() {
              _saving = true;
            });
            await AuthService.googleSignIn(context);
            setState(() {
              _saving = false;
            });
          } else {
            showTermsAndConditionsAlert();
          }
        } else {
          YipliUtils.showNotification(
              context: context,
              msg: "No Internet Connectivity",
              type: SnackbarMessageTypes.ERROR,
              duration: SnackbarDuration.MEDIUM);
        }
      },
    );
  }

  /// facebook button on login screen
  GestureDetector buildFacebookButton(Size screenSize, BuildContext context) {
    return GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColorLight),
          child: Container(
            width: screenSize.height / 22,
            height: screenSize.height / 22,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/Facebook.png"),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        onTap: () async {
          print('Facebook sign in');

          if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
            if (bIsTandCChecked == true) {
              try {
                setState(() {
                  _saving = true;
                });
                await authService.facebookSignIn(context);
                setState(() {
                  _saving = false;
                });
              } catch (error) {
                print("== Error Code ==" + error.code);
                setState(() {
                  _saving = false;
                });
                switch (error.code) {
                  case "account-exists-with-different-credential":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The email used to login has been used using a different account. Please try Google or Email login.",
                        type: SnackbarMessageTypes.WARN);
                    break;
                  case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The email used to login has been used using a different account. Please try Google or Email login.",
                        type: SnackbarMessageTypes.WARN);
                    break;
                  case "invalid-credential":
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "The email used to login has been used using a different account. Please try Google or Email login.",
                        type: SnackbarMessageTypes.WARN);
                    break;
                  default:
                    YipliUtils.showNotification(
                        context: context,
                        msg:
                            "There was an error logging using Facebook. Please try again in some time.",
                        type: SnackbarMessageTypes.ERROR);
                    break;
                }
              }
            } else {
              showTermsAndConditionsAlert();
            }
          } else {
            YipliUtils.showNotification(
                context: context,
                msg: "No Internet Connectivity",
                type: SnackbarMessageTypes.ERROR,
                duration: SnackbarDuration.MEDIUM);
          }
        });
  }

  void showTermsAndConditionsAlert() {
    YipliUtils.showNotification(
        context: context,
        msg: "Please accept Terms & Conditions.",
        type: SnackbarMessageTypes.ERROR);
  }
}
