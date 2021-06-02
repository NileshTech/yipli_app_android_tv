import 'package:flutter_app/helpers/helper_index.dart';
import 'package:flutter_app/pages/a_pages_index.dart';

import 'a_widgets_index.dart';

class NoNetworkPage extends StatefulWidget {
  static const String routeName = "/no_network_page";

  @override
  _NoNetworkPageState createState() => _NoNetworkPageState();
}

class _NoNetworkPageState extends State<NoNetworkPage>
    with SingleTickerProviderStateMixin {
  bool _checkConnection = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _checkConnection,
      progressIndicator: YipliLoader(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //yipli logo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    height: 0.15 * screenSize.height,
                    child: Hero(
                      tag: "yipli-logo",
                      child: YipliLogoAnimatedSmall(),
                    ),
                  ),
                ),
                //no connection found animation
                PlayAnimation<double>(
                    curve: Curves.bounceOut,
                    duration: 1000.milliseconds,
                    tween: (0.0).tweenTo(1.0),
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: Text(
                          'No Internet Connection found.\nPlease connect to the internet and check again!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5.copyWith(
                                fontWeight: FontWeight.w800,
                                color: yipliLogoOrange,
                              ),
                        ),
                      );
                    }),
                // retry floating action button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: FloatingActionButton(
                    focusColor: androidTVFocusColor,
                    elevation: 10,
                    onPressed: () {
                      if (YipliUtils.appConnectionStatus ==
                          AppConnectionStatus.CONNECTED) {
                        YipliUtils.navigatorKey.currentState
                            .pushReplacementNamed(FitnessGaming.routeName);
                      } else {
                        setState(() {
                          _checkConnection = true;
                        });
                        YipliUtils.navigatorKey.currentState
                            .pushReplacementNamed(NoNetworkPage.routeName);
                      }
                    },
                    child: Icon(
                      FontAwesomeIcons.redo,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
