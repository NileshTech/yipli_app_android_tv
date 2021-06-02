import 'package:flutter_app/pages/a_pages_index.dart';

import 'a_widgets_index.dart';

class NotPageFound extends StatefulWidget {
  static const String routeName = "/no_page_found";

  @override
  _NotPageFoundState createState() => _NotPageFoundState();
}

class _NotPageFoundState extends State<NotPageFound> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return YipliPageFrame(
        showDrawer: true,
        title: Text(
          'No page found',
        ),
        child: Center(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0,bottom: 50),
                  child: SizedBox(
                    height: 0.15 * screenSize.height,
                    child: Hero(
                      tag: "yipli-logo",
                      child: YipliLogoAnimatedSmall(),
                    ),
                  ),
                ),
                Text(
                  'No page found',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontWeight: FontWeight.w800,
                        color: yipliLogoOrange,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Icon(FontAwesomeIcons.sadTear, size: 40.0),
                ),
              ],
            ),
          ),
        ));
  }
}
