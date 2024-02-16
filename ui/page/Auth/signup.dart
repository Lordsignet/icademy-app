import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:matcher/matcher.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/model/user.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/helper/validator.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
/* import 'package:racfmn/ui/page/Auth/widget/google_login_button.dart'; */
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/widgets/newWidget/custom_loader.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class Signup extends StatefulWidget {
 // final VoidCallback? loginCallback;

  const Signup({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController? _usernameController;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  TextEditingController? _confirmController;
  
  CustomLoader? loader;
  dynamic userError;
  UserModel? user;
  bool _obscuretext = false;
  final _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    loader = CustomLoader();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    super.initState();
  }
  dynamic _username, _email, _password;

  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    _usernameController?.dispose();
    _confirmController?.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return Container(
      height: context.height - 88,
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
        
            
            _entryFeild('Enter email',
           // validator: validateEmail,
           onSaved: (value) => _email = value,
                prefixBefore: const Icon(
                  Icons.account_circle_sharp,
                  size: 20.0,
                ),
                controller: _emailController as TextEditingController,
                isEmail: true),
            // _entryFeild('Mobile no',controller: _mobileController),
            _entryFeild(
              'Enter password',
              controller: _passwordController as TextEditingController,
              //isPassword: true,
             // validator: validatePassword,
                onSaved: (value) => _password = value,
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
            _submitButton(context),

            Divider(height: 30),
            SizedBox(height: 30),
            // _googleLoginButton(context),
            /* GoogleLoginButton(
              loginCallback: widget.loginCallback as void Function(),
              loader: loader as CustomLoader,
            ), */
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sufixIcon() {
    return IconButton(
        icon: Icon(
          _obscuretext ? Icons.visibility : Icons.visibility_off,
          color: Theme.of(context).primaryColorDark,
        ),
        onPressed: () {
          setState(() {
            _obscuretext = !_obscuretext;
          });
        });
  }

  Widget _entryFeild(
    String hint, {
    TextEditingController? controller,
    bool isPassword = false,
    bool isEmail = false,
    Widget? iconBefore,
    Widget? prefixBefore, 
    void Function(String?)? onSaved,
    
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
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
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35),
      child: CustomFlatButton(
        label: 'Sign up',
        onPressed: _submitForm,
        borderRadius: 30,
      )  
    );
  }
 
 

  void _submitForm() {
    final form = _formKey.currentState;
  
   
    if(!(new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(_emailController!.text))) {
 Utility.customSnackBar(
          _scaffoldKey, 'Please provide a valid email address');
      return;
      }
    if(_passwordController!.text.length < 8) {
      Utility.customSnackBar(
          _scaffoldKey, 'Password characters should be at least 8 characters');
      return;
    }
    if (_emailController!.text == null ||
        _emailController!.text.isEmpty ||
        _passwordController!.text == null ||
        _passwordController!.text.isEmpty ||
        _confirmController!.text == null) {
      Utility.customSnackBar(_scaffoldKey, 'Please fill form carefully');
      return;
    } else if (_passwordController!.text != _confirmController!.text) {
      Utility.customSnackBar(
          _scaffoldKey, 'Password and confirm password did not match');
      return;
    }

    loader!.showLoader(context);
  try { var state = Provider.of<AuthState>(context, listen: false);
    Random random = new Random();
    int randomNumber = random.nextInt(8);
    
    form!.save();
    state.register(
    _email,
    _password,
      scaffoldKey: _scaffoldKey,
    ).then((responseData) {
      print(responseData);
      userError = responseData['errorData'];
     // print(userError);
      if(responseData['status'] && userError.toString().isEmpty) {
      
        loader!.hideLoader();
       
          Navigator.pushNamed(context, "/VerifyEmailPage");
       
        
      } else if(responseData['status'] == false && userError.toString().contains("Email")) {
       
       loader!.hideLoader();
            Utility.customSnackBar(
          _scaffoldKey, "Email already exist");
      } else {
         loader!.hideLoader();
            Utility.customSnackBar(
          _scaffoldKey, "No network connection"); 
      }
    }); 
  } catch (error) {
    print(error);
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText(
          'Sign Up',
          context: context,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }

  void _userNameFunc(String? value) {
      var data = value?.split("@");
      _username = data?[0];
  }
}
