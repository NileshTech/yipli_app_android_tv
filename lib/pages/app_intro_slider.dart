import 'a_pages_index.dart';

class IntroScreenState extends State<IntroScreen> {
  Slide _buildSlide(String title, String description, String imageAssetLocation,
      Color bgColor, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return new Slide(
      title: title,
      styleTitle: Theme.of(context)
          .textTheme
          .headline5
          .copyWith(fontWeight: FontWeight.bold),
      description: description,
      marginDescription:
          EdgeInsets.only(top: screenSize.height * 0.55, left: 20, right: 20),
      styleDescription: Theme.of(context).textTheme.headline6,
      backgroundImage: imageAssetLocation,
      backgroundOpacity: 0.7,
      backgroundColor: bgColor,
      backgroundImageFit: BoxFit.cover,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void onDonePress() {
    // Do what you want
    YipliUtils.goToLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    List<Slide> slides = new List();
    slides.addAll([
      _buildSlide(
          "",
          "The Ultimate Fitness Gaming Console",
          "assets/images/NewSliderImages/Slider1.jpg",
          Theme.of(context).backgroundColor,
          context),
      _buildSlide(
          "",
          "Transforming screen time to Fitness time",
          "assets/images/NewSliderImages/Slider2.jpg",
          Theme.of(context).backgroundColor,
          context),
      _buildSlide(
          "",
          "Experience gaming like never before",
          "assets/images/NewSliderImages/Slider3.jpg",
          Theme.of(context).backgroundColor,
          context),
    ]);
    return new IntroSlider(
      slides: slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onDonePress,
      colorDot: yipliWhite,
      colorActiveDot: yipliNewBlue,
    );
  }
}

class IntroScreen extends StatefulWidget {
  static const String routeName = "/app_intro_slider";
  IntroScreen({Key key}) : super(key: key);

  @override
  IntroScreenState createState() => new IntroScreenState();
}
