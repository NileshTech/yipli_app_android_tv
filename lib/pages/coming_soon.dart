import 'a_pages_index.dart';

class ComingSoonPage extends StatefulWidget {
  static const String routeName = '/coming_soon';
  @override
  _ComingSoonPageState createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage> {
  @override
  Widget build(BuildContext context) {
    return YipliPageFrame(
      title: Text(
        'Coming Soon',
      ),
      child: GestureDetector(
        onTap: Navigator.of(context).pop,
        child: ComingSoonBanner(),
      ),
    );
  }
}

class ComingSoonBanner extends StatelessWidget {
  const ComingSoonBanner({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 56,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RubberBand(child: YipliLogoLarge(heightScaleDownFactor: 4)),
            ZoomIn(
              child: Image.asset("assets/images/coming_soon.png",
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
