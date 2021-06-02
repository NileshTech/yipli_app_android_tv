import 'package:flutter_app/classes/classes_index.dart';

import 'a_pages_index.dart';

class WorldSelectionPage extends StatefulWidget {
  static const String routeName = "/world_selection";
  @override
  _WorldSelectionPageState createState() => _WorldSelectionPageState();
}

class _WorldSelectionPageState extends State<WorldSelectionPage> {
  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    return YipliPageFrame(
      selectedIndex: 1,
      toShowBottomBar: true,
      showDrawer: true,
      isBottomBarInactive: false,
      title: Text('Adventure Worlds'),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: SizedBox()),
            Expanded(
              flex: 3,
              child: Container(
                width: _screenSize.width * 0.9,
                child: RaisedButton(
                  focusColor: androidTVFocusColor,
                  color: appbackgroundcolor,
                  elevation: 5.0,
                  onPressed: () {
                    YipliUtils.navigatorKey.currentState
                        .pushReplacementNamed(AdventureGaming.routeName);
                  },
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: yipliLogoOrange),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Text('Cave Adventure World',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Theme.of(context).primaryColorLight)),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(
              flex: 3,
              child: Container(
                width: _screenSize.width * 0.9,
                child: RaisedButton(
                  focusColor: androidTVFocusColor,
                  color: appbackgroundcolor,
                  elevation: 5.0,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: yipliLogoOrange),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('World 2',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Theme.of(context).primaryColorLight)),
                  ),
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            Expanded(
              flex: 3,
              child: Container(
                width: _screenSize.width * 0.9,
                child: RaisedButton(
                  focusColor: androidTVFocusColor,
                  color: appbackgroundcolor,
                  elevation: 5.0,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: yipliLogoOrange),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('World 3',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Theme.of(context).primaryColorLight)),
                  ),
                ),
              ),
            ),
            Expanded(flex: 4, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
