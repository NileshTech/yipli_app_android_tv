import 'a_pages_index.dart';

class VerificationScreenInput {
  final String email;
  final String displayName;
  User loggedInUser;

  VerificationScreenInput({this.loggedInUser, this.email, this.displayName});
}

class VerificationScreen extends StatefulWidget {
  static const String routeName = "/email_verification_screen";

  @override
  State<StatefulWidget> createState() => new _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  static final auth = FirebaseAuth.instance;
  static User user;
  static Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  YipliButton resendButton;

  @override
  Widget build(BuildContext context) {
    VerificationScreenInput inputArgs =
        ModalRoute.of(context).settings.arguments;
    Size screenSize = MediaQuery.of(context).size;
    resendButton =
        new YipliButton('Resend Email', null, null, screenSize.width / 3);

    resendButton.setClickHandler(() {
      print('send Verftn email pressed');

      inputArgs.loggedInUser.sendEmailVerification();
      YipliUtils.showNotification(
          context: context,
          msg: "Email for verification sent for the above email.");
    });

    print('inputArgs - $inputArgs');

    return YipliPageFrame(
      showDrawer: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 1, child: YipliLogoAnimatedSmall()),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: Container(
                child: Column(
                  children: [
                    Text(
                      'Verification email has been sent to',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      inputArgs.email,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: FutureBuilder<bool>(
                        future: YipliUtils.checkEmailVerified(),
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            Users newUser = new Users(
                                AuthService.firebaseUser.uid,
                                [],
                                [],
                                "",
                                inputArgs.email,
                                inputArgs.displayName);
                            newUser.persist().then((_) {
                              YipliUtils.initializeApp();
                            });
                          }
                          return Column(
                            children: [
                              Expanded(
                                child: YipliLoader(
                                  radius: 20,
                                  dotRadius: 8.0,
                                  useOpaqueBackground: true,
                                  backgroundColor: appbackgroundcolor,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                      'Waiting for you to verify email...'),
                                ),
                              )
                            ],
                          );
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [resendButton],
                    ),
                  ),
                  //
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FlatButton(
                          focusColor: androidTVFocusColor,
                          child: Text(
                            'Back to Log in.',
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
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
