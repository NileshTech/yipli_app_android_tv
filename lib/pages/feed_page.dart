import 'a_pages_index.dart';

class YipliFeed extends StatefulWidget {
  static const String routeName = "/yipli_feed";
  @override
  _YipliFeedState createState() => _YipliFeedState();
}

class _YipliFeedState extends State<YipliFeed> {
  @override
  Widget build(BuildContext context) {
    return YipliPageFrame(
      selectedIndex: 3,
      toShowBottomBar: true,
      showDrawer: true,
      isBottomBarInactive: false,
      title: Text('Yipli Feed'),
      child: Container(
        child: ComingSoonBanner(),
      ),
    );
  }
}
