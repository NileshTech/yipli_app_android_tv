import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/helpers/color_scheme.dart';

// ignore: must_be_immutable
class YipliButton extends StatelessWidget {
  final String buttonText;
  final double buttonWidth;
  final double buttonHeight;
  Color buttonColor;
  Color buttonTextColor;
  Function onPressed;

  YipliButton(this.buttonText,
      [this.buttonColor,
      this.buttonTextColor,
      this.buttonWidth = 232.0,
      this.buttonHeight = 40.0]);

  void setClickHandler(Function onPressed) {
    this.onPressed = onPressed;
  }

  String getButtonText() {
    return this.buttonText;
  }

  @override
  Widget build(BuildContext context) {
    buttonTextColor = buttonTextColor ?? Theme.of(context).primaryColorLight;
    buttonColor = buttonColor ?? Theme.of(context).buttonColor;

    return MediaQuery(
      child: SizedBox(
        width: buttonWidth,
        height: buttonHeight,
        child: RaisedButton(
          focusColor: androidTVFocusColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                  color: buttonTextColor,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
          onPressed: () => onPressed(),
          color: buttonColor,
        ),
      ),
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    );
  }
}
