//File for all input validators

class YipliValidators {
  static String validateMacAddress(String value) {
    print("Validating mac!");
    Pattern pattern = r'^([A-F0-9]*)$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value.replaceAll(":", "")))
      return 'Enter valid mac address!';
    else
      return null;
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value.length == 0)
      return 'Enter valid email';
    else
      return null;
  }

  static String validateName(String value) {
    if (value.length < 3)
      return 'Please enter more than 2 charaters';
    else
      return null;
  }

  static String validateOTP(String value) {
    if (value.length < 6)
      return 'OTP should be 6 digits!';
    else
      return null;
  }

  static String validateWeight(String value) {
    if ((value == "") || (value == null)) {
      return null;
    }
    var iWeight = double.parse(value);
    if (iWeight < 20 || iWeight > 150)
      return 'Please enter valid weight in kgs';
    else
      return null;
  }

  static String validateHeight(String value) {
    if ((value == "") || (value == null)) {
      //if empty return empty
      return null;
    }
    var iHeight = double.parse(value);
    if (iHeight < 60 || iHeight > 210)
      return 'Please enter valid height in cms';
    else
      return null;
  }

  static String validatePassword(String value) {
    if (value.length < 6 || value.length > 20)
      return 'Password must be between 6 to 20 characters';
    else
      return null;
  }

  static String validatePhoneNumberLength(String value) {
    if (value.length < 10 || value.length > 10)
      return 'Enter valid Phone number';
    else
      return null;
  }
}
