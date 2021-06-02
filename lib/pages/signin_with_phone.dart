import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_app/helpers/utils.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'a_pages_index.dart';

AuthService authService;

//Button display string constants
const String GET_OTP_STR = "Get OTP";
const String RESEND_OTP_STR = "Resend OTP";

class SignInWithPhone extends StatefulWidget {
  static const String routeName = "/signin_with_phone_screen";

  @override
  _SignInWithPhoneState createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SignInPage());
  }
}

class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
          _timer.cancel();
        }
      });
    });
  }

  GlobalKey<FormState> _formKey;
  String contactno = "";
  String otpCode = "";
  YipliTextInput contactNoInput;
  bool bIsTandCChecked = true;
  Function onSuccess;
  Function onFailed;
  YipliButton oTPButton;

  YipliTextInput otpInput;
  YipliTextInput timeOutotpInput;
  bool showResendOTPOption = false;
  bool clearOTP = false;
  bool isGenerateOTPPressed;
  bool isLoginPressed;

  bool displayTimer = false;
  Function onPressed;

  Future<void> onGetOTPPress() async {
    //validation of phone
    try {
      if (contactno.length > 10 || contactno.length < 10) {
        //show error snack bar msg
        YipliUtils.showNotification(
            context: context,
            msg: "Enter valid phone number to proceed",
            type: SnackbarMessageTypes.ERROR);
      } else if (!await Users.isPhoneRegisteredUnderAnyUser(contactno)) {
        //Code to check if the phone no is a registered one.
        //If not, show msg and exit
        YipliUtils.showNotification(
            context: context,
            msg:
                "This phone number is not registered with Yipli.\nTry to login with email.",
            type: SnackbarMessageTypes.ERROR,
            duration: SnackbarDuration.LONG);
      } else {
        print('Generate OTP button pressed');
        setState(() {
          isGenerateOTPPressed = true;
          displayTimer = true;
          _startTimerForOTP();
        });
        YipliUtils.showNotification(
            context: context,
            msg: "OTP has been sent on your mobile number.",
            type: SnackbarMessageTypes.INFO,
            duration: SnackbarDuration.LONG);
        await YipliUtils.getPhoneOtp(context, contactno, onSuccess, onFailed);
      }
    } catch (e) {
      YipliUtils.showNotification(
          context: context,
          msg: "Please try after some time",
          type: SnackbarMessageTypes.ERROR,
          duration: SnackbarDuration.LONG);
    }
  }

  void onSavedContactNo(String contactNo) {
    contactno = contactNo;
    print("Contact $contactno saved");
  }

  void onSavedcode(String code) {
    otpCode = code;

    print("Contact $code saved");
  }

  void timeOutOnSavedcode(String x) {
    otpCode = "code";

    print("Contact  saved");
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
    authService = new AuthService();
    isGenerateOTPPressed = false;
    isLoginPressed = false;
    contactno = "";
  } // our default setting is to login, and we should switch to creating an account when the user chooses to

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String validateLengthAfterGetOTPPress(String value) {
    if (!isGenerateOTPPressed)
      return null;
    else if (value.length < 10 || value.length > 10)
      return 'Enter valid Phone number';
    else
      return null;
  }

  String validateOTPAfterLoginPress(String value) {
    if (!isLoginPressed)
      return null;
    else if (value.length < 6 || value.length > 6)
      return 'Enter valid OTP';
    else
      return null;
  }

  Widget _buildOTPInputWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: otpInput,
    );
  }

  @override
  Widget build(BuildContext context) {
    contactNoInput = new YipliTextInput(
      "",
      "Contact Number",
      Icons.phone,
      false,
      validateLengthAfterGetOTPPress,
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
    timeOutotpInput = new YipliTextInput(
      "One Time Passcode",
      "Enter your OTP here",
      Icons.security,
      false,
      YipliValidators.validateOTP,
      timeOutOnSavedcode,
      null,
      true,
      TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: displayTimer == false
            ? _getOtpView(context)
            : _enterOtpAndLoginView(context),
      ),
    );
  }

  Widget _getOtpView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Hero(
                tag: "yipli-logo",
                child: YipliLogoAnimatedSmall(),
              ),
              //SizedBox(),
              Text(
                'Login with phone number',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildInputTextField(context),
              _buildOTPButton(context),
              _goToLoginPageButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _enterOtpAndLoginView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(
                tag: "yipli-logo",
                child: YipliLogoAnimatedSmall(
                    //heightVariable: 5,
                    ),
              ),
              Text(
                'Login with phone',
                style: Theme.of(context).textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildInputTextField(context),
              _buildOTPInputWidget(context),
              _buildLoginWithOtpButton(context),
              _buildCountDownTimer(
                  context), //Not UI element. Only used for starting the timer.
              SizedBox(
                height: 20,
              ),
              _buildValidityDisplayTimer(context),
              _buildBackOption(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildValidityDisplayTimer(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("valid for :",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: yipliGray)),
        Text(
          " $_counter",
          style:
              Theme.of(context).textTheme.headline6.copyWith(color: yipliGray),
        ),
      ],
    );
  }

  Widget _buildInputTextField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: contactNoInput,
      ),
    );
  }

  Widget _goToLoginPageButton(BuildContext context) {
    return FlatButton(
      focusColor: androidTVFocusColor,
      child: Text(
        'Back to login page',
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(decoration: TextDecoration.underline),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/login_screen');
      },
    );
  }

  Widget _buildOTPButton(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    oTPButton = new YipliButton(
        isGenerateOTPPressed ? RESEND_OTP_STR : GET_OTP_STR,
        null,
        null,
        screenSize.width / 3);
    oTPButton.setClickHandler(onGetOTPPress);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
      child: oTPButton,
    );
  }

  Widget _buildLoginWithOtpButton(BuildContext context) {
    return RaisedButton(
        focusColor: androidTVFocusColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          'Login',
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.w600,
              ),
        ),
        onPressed: () async {
          isLoginPressed = true;
          await authService.phoneNumberSignIn(
              context, YipliUtils.smsVerificationCode, otpCode);
        });
  }

  Widget _buildCountDownTimer(BuildContext context) {
    return SlideCountdownClock(
        duration: Duration(seconds: 60),
        slideDirection: SlideDirection.Down,
        textStyle: TextStyle(
          fontSize: 0,
        ),
        onDone: () async {
          setState(() {
            displayTimer = false;
            isGenerateOTPPressed = true;
          });
        });
  }

  Widget _buildBackOption(BuildContext context) {
    return FlatButton(
      focusColor: androidTVFocusColor,
      child: Text(
        'Back',
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(decoration: TextDecoration.underline),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/signin_with_phone_screen');
      },
    );
  }
}
