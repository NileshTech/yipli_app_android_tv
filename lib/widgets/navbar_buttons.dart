import 'a_widgets_index.dart';

// ignore: must_be_immutable
class NavBarButton extends StatelessWidget {
  final String navbarText;
  final IconData navbarIcon;
  Function onPressed;

  NavBarButton(
    this.navbarText,
    this.navbarIcon,
  );

  void setClickHandler(Function onPressed) {
    this.onPressed = onPressed;
  }

  String getButtonText() {
    return this.navbarText;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10.0,
          ),
          Icon(
            navbarIcon,
            size: 37,
            color: yiplidarkblue,
          ),
          Text(
            navbarText,
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            height: 1,
            width: 70,
            color: yiplidarkblue,
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          ),
        ],
      ),
      onTap: () => onPressed,
    );
  }
}
