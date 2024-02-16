
  bool _isNumeric(String s) {
    for (int i = 0; i < s.length; i++) {
      if (double.tryParse(s[i]) != null) {
        return true;
      }
    }
    return false;
  }

  String validateEmail(String value) {
    String? _msg;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);
    if(value.isEmpty)  {
      _msg = "Your username is required";
    } else if (!regex.hasMatch(value)) {
      _msg = "Please provide a valid email address";
    } 
    return _msg as String;
  }

  String validateName(String value) {
    String? _msg;
    if (_isNumeric(value)) {
      _msg = 'Invalid Name!';
    } else if (value.isEmpty) {
    _msg = 'Please enter your name';
    } else if(value.trim().length < 5) {
      _msg = 'The characters should not be less than 5';
    }
    return _msg as String;
  }

  String validatePassword(String value) {
    String? _msg;
    if (value.isEmpty) {
      _msg = 'Please enter a password';
    } else if(value.length < 8) {
      _msg = 'The Characters must be minium of eight';
    }
    return _msg as String;
  }
String validatePasswords(String value, String password) {
    String? _msg;
    if (password.isEmpty) {
      _msg = 'Please confirm your password';
    } else if(password != value) {
      _msg = 'The two password must match';
    }
    return _msg as String;
  }
