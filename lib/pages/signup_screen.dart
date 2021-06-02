import 'package:flutter_app/widgets/text_input.dart' as Inputs;

import 'a_pages_index.dart';

AuthService authService;

class SignUp extends StatelessWidget {
  static const String routeName = "/signup_screen";
  @override
  Widget build(BuildContext context) {
    return SignUpPage();
  }
}

class SignUpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static String _name = "";
  static String _email = "";
  static String _password = "";
  Inputs.YipliTextInput nameInput;
  Inputs.YipliTextInput emailInput;

  bool _saving = false;

  Inputs.YipliTextInput passwordInput;
  YipliButton signUpButton;

  Future<void> onSignUpPress() async {
    setState(() {
      isSignupButtonPressed = true;
      _saving = true;
    });
    User signedUpUser = await validateAndRegister();

    setState(() {
      _saving = false;
    });
    if (signedUpUser != null) {
      // YipliUtils.initializeApp();
      YipliUtils.goToVerificationScreen(_name, _email, signedUpUser);
    } else {
      //@TODO Add error for signup!

    }
  }

  static void onNameSaved(String name) {
    _name = name;
    print('Name $name saved');
  }

  static void onEmailSaved(String email) {
    _email = email;
    print('Email $email saved');
  }

  static void onPasswordSaved(String password) {
    _password = password;
    print('Password $password saved');
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<User> validateAndRegister() async {
    final FormState form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      if (YipliUtils.appConnectionStatus == AppConnectionStatus.CONNECTED) {
        form.save();
        print("Signing up user! with loader");
        try {
          User newUser = await authService.signUpUser(_name, _email, _password);
          print("New user created with userId ${newUser.uid}");
          print("Signed up user!");
          return newUser;
        } catch (exp, stackTrace) {
          print('Error Aala');
          print(stackTrace.toString());

          print("Error code is : ${exp.code}");
          switch (exp.code) {
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
            case "email-already-in-use":
            case "ERROR_CREDENTIAL_ALREADY_IN_USE":
              YipliUtils.showNotification(
                  context: context,
                  msg:
                      "This credential is already associated with a different user account.\nLogin using the same account.",
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
              print("Signup failed. Exception : ${exp.code}");
              YipliUtils.showNotification(
                  context: context,
                  msg:
                      "There was an error logging you in at the moment. If error persists, please contact Yipli Support.",
                  type: SnackbarMessageTypes.ERROR);

              break;
          }
          return null;
        } finally {}
      } else {
        YipliUtils.showNotification(
            context: context,
            msg: "No Internet Connectivity",
            type: SnackbarMessageTypes.ERROR,
            duration: SnackbarDuration.MEDIUM);
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    authService = new AuthService();
    isSignupButtonPressed = false;
  } // our default setting is to login, and we should switch to creating an account when the user chooses to

  _SignUpPageState();

  bool isSignupButtonPressed;

  String validateNameAfterSignupPress(String value) {
    if (!isSignupButtonPressed)
      return null;
    else
      return YipliValidators.validateName(value);
  }

  String validateEmailAfterSignupPress(String value) {
    if (!isSignupButtonPressed)
      return null;
    else
      return YipliValidators.validateEmail(value);
  }

  String validatePasswordAfterSignupPress(String value) {
    if (!isSignupButtonPressed)
      return null;
    else if (value.length < 1)
      return 'Enter valid password';
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    nameInput = new Inputs.YipliTextInput(
        "Enter your Full name",
        "Name",
        FontAwesomeIcons.user,
        false,
        validateNameAfterSignupPress,
        onNameSaved,
        null,
        true,
        null,
        Theme.of(context).primaryColorLight);

    emailInput = new Inputs.YipliTextInput(
        "Enter your Email",
        "Email",
        FontAwesomeIcons.at,
        false,
        validateEmailAfterSignupPress,
        onEmailSaved,
        null,
        true,
        null,
        Theme.of(context).primaryColorLight);

    passwordInput = new Inputs.YipliTextInput(
        "Choose a password with min 6 characters",
        "Password",
        FontAwesomeIcons.lock,
        true, //obscure text is true to have it in encrypted form,value gets change based on visibilty icon
        validatePasswordAfterSignupPress,
        onPasswordSaved,
        null,
        true,
        null,
        Theme.of(context).primaryColorLight,
        null,
        true //password visibility is handled by YipliTextInput itself
        );

    final Size screenSize = MediaQuery.of(context).size;

    signUpButton = new YipliButton("Sign Up", null, null, screenSize.width / 3);
    signUpButton.setClickHandler(onSignUpPress);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: ModalProgressHUD(
          progressIndicator: YipliLoader(),
          inAsyncCall: _saving,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: "yipli-logo",
                    child: YipliLogoAnimatedLarge(
                      heightVariable: 5,
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      height: screenSize.height / 20,
                    ),
                  ),
                  Text(
                    'Register with Yipli',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SingleChildScrollView(child: _buildTextFields(context)),
                  _buildButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// login email details, and password
  Widget _buildTextFields(BuildContext context) {
    return Container(
      //height: screenSize.height / 2,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        //autovalidate: true,
        child: Column(
          children: <Widget>[
            // nameInput,
            emailInput,
            passwordInput,
          ],
        ),
      ),
    );
  }

//  signup buttons
  Widget _buildButtons(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: screenSize.height / 60),
                signUpButton,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      focusColor: androidTVFocusColor,
                      child: Text(
                        'Already have account? Log in.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(decoration: TextDecoration.underline),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/login_screen');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
