import 'a_pages_index.dart';

class Logout extends StatefulWidget {
  static const String routeName = "/logout";

  Logout({Key key}) : super(key: key);

  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  bool _loggingOut;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _loggingOut,
        progressIndicator: YipliLoader(),
        child: Container());
  }

  @override
  void initState() {
    super.initState();
    _loggingOut = true;
    AuthService.signOut().then((_) {
      setState(() {
        _loggingOut = false;
      });
      YipliUtils.initializeApp();
    });
  }
}
