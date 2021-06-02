import 'a_widgets_index.dart';

// ignore: must_be_immutable
class YipliTextInput extends StatefulWidget {
  //static final Color inputColor = yipliWhite;
  final String hintText;
  final String labelText;
  final IconData prefixIcon;
  bool obscureText;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;
  final String initialText;
  TextInputFormatter inputFormatter;
  bool isPasswordField;

  TextInputType inputType;
  Color textColor;
  List<FilteringTextInputFormatter> _whitelistingTextFormatters =
      new List<FilteringTextInputFormatter>();

  void addWhitelistingTextFormatter(
      FilteringTextInputFormatter inputFormatter) {
    _whitelistingTextFormatters.add(inputFormatter);
  }

  final bool initEnabled;

  void disable() {
    _textInputState.disable();
  }

  void enable() {
    _textInputState.enable();
  }

  void setText(String textValue) {
    _textInputState.setText(textValue);
  }

  _YipliTextInputState _textInputState;

  YipliTextInput(
      this.hintText, this.labelText, this.prefixIcon, this.obscureText,
      [this.validator,
      this.onSaved,
      this.initialText,
      this.initEnabled = true,
      this.inputType,
      this.textColor,
      this.inputFormatter,
      this.isPasswordField = false]);

  String getText() {
    return _textInputState.initialText;
  }

  @override
  _YipliTextInputState createState() {
    _textInputState = _YipliTextInputState();

    return _textInputState;
  }
}

class _YipliTextInputState extends State<YipliTextInput> {
  TextEditingController _textFilter = new TextEditingController();

  String initialText;
  bool isTextFieldEnabled;

  _YipliTextInputState();

  void _textListen() {
    if (_textFilter.text.isEmpty) {
      initialText = "";
    } else {
      initialText = _textFilter.text;
    }
  }

  void disable() {
    setState(() {
      isTextFieldEnabled = false;
    });
  }

  void enable() {
    setState(() {
      isTextFieldEnabled = true;
    });
  }

  @override
  void initState() {
    super.initState();
    print('Setting the initEnabled for text--${widget.initEnabled}');
    isTextFieldEnabled = widget.initEnabled;
    _textFilter.addListener(_textListen);
    _textFilter.text = initialText;
  }

  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    _textFilter.text = widget.initialText;
    _textFilter.selection = TextSelection.fromPosition(
        TextPosition(offset: _textFilter.text.length));

    widget.textColor = widget?.textColor ?? Theme.of(context).primaryColorLight;
    List<TextInputFormatter> listOfTextInputFormatters = List();
    listOfTextInputFormatters.addAll(widget._whitelistingTextFormatters);
    if (widget.inputFormatter != null) {
      listOfTextInputFormatters.add(widget.inputFormatter);
    }
    return Container(
        child: TextFormField(
      inputFormatters: listOfTextInputFormatters,
      keyboardType:
          widget.inputType != null ? widget.inputType : TextInputType.text,
      enabled: isTextFieldEnabled,
      onSaved: widget.onSaved,
      validator: widget.validator,
      controller: _textFilter,
      cursorColor: widget.textColor,
      style: Theme.of(context).textTheme.bodyText2.copyWith(
            color: widget.textColor,
          ),
      obscureText: widget.obscureText,
      onChanged: widget.onSaved,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            focusColor: androidTVFocusColor,
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
                widget.obscureText = !widget.obscureText;
              });
            },
            icon: widget.isPasswordField == false
                ? Icon(null)
                : showPassword == false
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
            color: widget.textColor.withOpacity(0.6),
            iconSize: 16,
          ),
          prefixIcon: Icon(
            widget.prefixIcon,
            color: widget.textColor.withOpacity(0.6),
            size: 16,
          ),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.caption.copyWith(
                color: widget.textColor.withOpacity(0.3),
              ),
          labelText: widget.labelText,
          labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                color: widget.textColor.withOpacity(0.6),
              ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 2.0, color: widget.textColor.withOpacity(0.8))),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 2.0, color: widget.textColor.withOpacity(0.5))),
          border: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 2.0, color: widget.textColor.withOpacity(0.8))),
          disabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  width: 2.0, color: widget.textColor.withOpacity(0.3)))),
    ));
  }

  void setText(String textValue) {
    _textFilter.text = textValue;
  }
}
