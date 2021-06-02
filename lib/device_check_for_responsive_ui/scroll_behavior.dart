//Below code is from Github 'https://github.com/Codelessly/ResponsiveFramework/tree/7724666e31b598dcad850a20f6231497703a3ac0/lib'

import 'package:flutter/widgets.dart';

class BouncingScrollBehavior extends ScrollBehavior {
  // Disable overscroll glow.
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  // Set physics to bouncing.
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return BouncingScrollPhysics();
  }
}

class BouncingScrollWrapper extends StatelessWidget {
  final Widget child;

  const BouncingScrollWrapper({Key key, this.child}) : super(key: key);

  static Widget builder(BuildContext context, Widget child) {
    return BouncingScrollWrapper(child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: BouncingScrollBehavior(),
      child: child,
    );
  }
}

class ClampingScrollBehavior extends ScrollBehavior {
  // Disable overscroll glow.
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }

  // Set physics to clamping.
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return ClampingScrollPhysics();
  }
}

class ClampingScrollWrapper extends StatelessWidget {
  final Widget child;

  const ClampingScrollWrapper({Key key, this.child}) : super(key: key);

  static Widget builder(BuildContext context, Widget child) {
    return ClampingScrollWrapper(child: child);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ClampingScrollBehavior(),
      child: child,
    );
  }
}
