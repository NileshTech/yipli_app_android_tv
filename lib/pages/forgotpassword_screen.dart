import 'a_pages_index.dart';

class ForgotPassword extends StatelessWidget {
  static const String routeName = "/forgotpassword_screen";
  @override
  Widget build(BuildContext context) {
    return ForgotPasswordPage();
  }
}

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isLoading = false;

  void _isNotLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  String _email;
  @override
  Widget build(BuildContext context) {
    _email = ModalRoute.of(context).settings.arguments;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ModalProgressHUD(
              progressIndicator: YipliLoader(),
              inAsyncCall: _isLoading,
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
                  Text('A link to reset your password has been sent to $_email',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                  Center(
                    child: SizedBox(
                      height: screenSize.height / 20,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height / 20,
                  ),
                  Text("Didn't receive reset link?",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center),
                  InkWell(
                    focusColor: androidTVFocusColor,
                    onTap: () {
                      if (YipliUtils.appConnectionStatus ==
                          AppConnectionStatus.CONNECTED) {
                        AuthService.mobAuth
                            .sendPasswordResetEmail(email: _email)
                            .then((_) {
                          YipliUtils.showNotification(
                              context: context,
                              msg: "Link is sent to your mail",
                              type: SnackbarMessageTypes.INFO,
                              duration: SnackbarDuration.MEDIUM);

                          _isNotLoading();
                        }).catchError((err) {
                          _isNotLoading();
                        });
                      } else {
                        YipliUtils.showNotification(
                            context: context,
                            msg: "No Internet Connectivity",
                            type: SnackbarMessageTypes.ERROR,
                            duration: SnackbarDuration.MEDIUM);
                      }
                    },
                    child: Text("Resend Email",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontWeight: FontWeight.w600, color: yipliErrorRed),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: FlatButton(
                      focusColor: androidTVFocusColor,
                      child: Text(
                        'Go back to login',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(decoration: TextDecoration.underline
                                //fontFamily: 'Tri',
                                ),
                      ),
                      onPressed: () {
                        YipliUtils.goToLoginPage(_email);
                      },
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
}
