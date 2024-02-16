import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/Auth/signin.dart';
import 'package:racfmn/ui/page/home_page.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/widgets/newWidget/custom_loader.dart';

class ForgetPasswordPage extends StatefulWidget {
  final VoidCallback? loginCallback;

  const ForgetPasswordPage({Key? key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  FocusNode? _focusNode;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formkey = new GlobalKey<FormState>();
 StateSetter? _setState;
CustomLoader? loader;
bool _obscuretext = false;
  @override
  void initState() {
    _focusNode = FocusNode();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _obscuretext = false;
    _emailController?.text = '';
    loader = CustomLoader();
    _focusNode?.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _emailController?.dispose();
    _passwordController?.dispose();
    _confirmController?.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return Container(
        height: context.height,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _label(),
            SizedBox(
              height: 1,
            ),
            _entryFeild('Enter email',
                controller: _emailController as TextEditingController),
            ///SizedBox(height: 5,),
            _submitButton(context, _submit, "Submit", MediaQuery.of(context).size.width),
          ],
        ));
  }

 
  

  Widget _submitButton(BuildContext context, Function? onPressed, String label, double width) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: width,
      child: CustomFlatButton(
        label: label,
        onPressed: onPressed,
        borderRadius: 30,
      ),
    );
  }

  Widget _label() {
    return Container(
        child: Column(
      children: <Widget>[
        customText('Forget Password',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: customText(
              '''Enter your email address below to receive password reset instruction''',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
              textAlign: TextAlign.center),
        )
      ],
    ));
  }

  void _changePassword() async {
  // CommentProvider commentProvider = Provider.of<CommentProvider>(context, listen: false);
    await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: customText("Change Password", textAlign: TextAlign.center),
              
            ),
            body: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Container(
       height: context.height - 88,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formkey,
          child:  
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                     // SizedBox(height: 0),
                      customText("Please enter a strong memorable password"),
                        SizedBox(height: 10),
                         _entryFeild(
                           'Enter password',
              controller: _passwordController as TextEditingController,
              //isPassword: true,
             // validator: validatePassword,
              isPassword: !_obscuretext,
              iconBefore: _sufixIcon(),
              prefixBefore: const Icon(
                Icons.lock_open,
                size: 20.0,
              ),
            ),
            _entryFeild(
              'Confirm password',
              controller: _confirmController as TextEditingController,
              // onSaved: (value) => _confirmpassword = value,
             // validator: (value) => value != _passwordController!.text ? "Both passwords do not match" : null,
              isPassword: true,
              prefixBefore: const Icon(
                Icons.lock_open,
                size: 20.0,
              ),
            ),
                        _submitButton(context, _updatePassword, "Submit", 260)
                    ]),
          )
          
            );}
            ));},
        fullscreenDialog: true
    ));
    
  }
  
  
  Widget _sufixIcon() {
    
    return IconButton(
        icon: Icon(
          _obscuretext ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).primaryColorDark,
        ),
        onPressed: () {
          _setState!(() {
_obscuretext = !_obscuretext;
print(_obscuretext);
  });
        });
  }
  Widget _entryFeild(
    String hint, {
    TextEditingController? controller,
    bool isPassword = false,
    Widget? iconBefore,
    Widget? prefixBefore, 
    
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller : controller,
         style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefixBefore,
          suffixIcon: iconBefore,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            borderSide: BorderSide(color: Colors.blue),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      )
    );
  }

void _emailClickedopenDialog() async {
  // CommentProvider commentProvider = Provider.of<CommentProvider>(context, listen: false);
    await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: customText("Forget password....", textAlign: TextAlign.center),
              
            ),
            body: Container(
      height: context.height,
        padding: EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               
                      SizedBox(height: 70),
                      customText("Visit your mail box, click the link sent to you then come back and click continue button",
                      style: TextStyle(fontSize: 20, color: Colors.black)),
                        SizedBox(height: 20),
                        _submitButton(context, _checkIfEmailClicked, "Continue", 240)
                    ]),
          )
              
    
            
          );
        },
        fullscreenDialog: true
    ));
    
  }
  void _updatePassword() {
    if (_emailController?.text == null || _emailController!.text.isEmpty) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid token')));
      return;
    }
    if (_passwordController?.text == null || _passwordController!.text.toString().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password should not be empty nor less than eight characters')));
     print(_passwordController?.text);
      return;
    }
    if(_passwordController?.text != _confirmController?.text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Both passwords do not match')));
      return;
    }
    loader!.showLoader(context);
    try {
      var state = Provider.of<AuthState>(context, listen: false);
      state.login(_emailController!.text.toString(), _passwordController!.text.toString(), true, scaffoldKey: _scaffoldKey).then((passwordValue) {
    var errorData = passwordValue["errorData"];
    var dataStatus = passwordValue["status"];
    if(dataStatus && state.authStatus == AuthStatus.LOGGED_IN) {
      loader!.hideLoader();
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
     // Navigator(context,MaterialPageRoute(builder: (context) => HomePage()));
    } else if(dataStatus == false && 
      (errorData.toString().contains("password") || errorData.toString().contains("username"))) {
      loader!.hideLoader();
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email does not exist'))); 
    } else {

      loader!.hideLoader();
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network connection error'))); 
    }
    });
      
  } catch(ex) {
  loader!.hideLoader();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Network connection error'))); 
  }
  }
  void _checkIfEmailClicked() {
    if (_emailController?.text == null || _emailController!.text.isEmpty) {
      Utility.customSnackBar(_scaffoldKey, 'Invalid token');
      return;
    }
    loader!.showLoader(context);
    try {
  var state = Provider.of<AuthState>(context, listen: false);
state.emailClicked(_emailController!.text.toString(), scaffoldkey: _scaffoldKey).then((responseValue) {
final data = responseValue["status"];
final message = responseValue["message"];
if(data == true && message.toString().contains("clicked")) {
  loader!.hideLoader();
  Navigator.pop(context);
  _changePassword();
} else if(data == false && message.toString().contains("yet")) {
  loader!.hideLoader();
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Not validated yet. Try again or go back')));
//  Utility.customSnackBar(_scaffoldKey, "Please click the link sent to your mail before continuing");
} else {
loader!.hideLoader();
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No network connection")));
}
});
    } catch(ex) {
      loader!.hideLoader();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No network connection")));
      print(ex);
    }   
  }
  void _submit() {
    if (_emailController?.text == null || _emailController!.text.isEmpty) {
      Utility.customSnackBar(_scaffoldKey, 'Email field cannot be empty');
      return;
    }
    var isValidEmail = Utility.validateEmal(
      _emailController!.text,
    );
    if (!isValidEmail) {
      Utility.customSnackBar(_scaffoldKey, 'Please enter valid email address');
      return;
    }
     
    _focusNode!.unfocus();
    loader!.showLoader(context);
    try {
    var state = Provider.of<AuthState>(context, listen: false);
  state.emailVerified(_emailController!.text, scaffoldkey: _scaffoldKey).then((valueREturned) {
final status = valueREturned["status"];
final message = valueREturned["message"];
if(status && message.toString().contains("Email")) {
loader!.hideLoader();
//Navigator.pop(context);
_emailClickedopenDialog();
} else if(status == false && message.toString().contains("Nothing")) {
  loader!.hideLoader();
  Utility.customSnackBar(_scaffoldKey, "Account not found");
} else {
  loader!.hideLoader();
  Utility.customSnackBar(_scaffoldKey, "Network connection error");
}
  });
    } catch(ex) {
      loader!.hideLoader();
     // Utility.customSnackBar(_scaffoldKey, "No network connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText('Forget Password',
            context: context, style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }
}


