import 'dart:async';

import 'package:flutter/material.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/state/auth_state.dart';
/*import 'package:racfmn/ui/page/Auth/widget/google_login_button.dart'; */
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/widgets/newWidget/custom_loader.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  final VoidCallback? loginCallback;

  const SignIn({Key? key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  CustomLoader? loader;
  dynamic userError;
  bool _obscuretext = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    loader = CustomLoader();
    super.initState();
  }

  @override
  void dispose() {
    _emailController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 150),
            _entryFeild('Enter email',
                controller: _emailController as TextEditingController,
                prefixBefore: const Icon(
                Icons.account_circle_sharp,
                size: 20.0,
              ),),
            _entryFeild(
              'Enter password',
              controller: _passwordController as TextEditingController,
              isPassword: !_obscuretext,
              iconBefore: _sufixIcon(),
              prefixBefore: const Icon(
                Icons.lock_open,
                size: 20.0,
              ),
            ),
            _emailLoginButton(context),
            SizedBox(height: 1),
            _labelButton('Forget password?', onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/ForgetPasswordPage');
            }),
            Divider(
              height: 30,
            ),
            SizedBox(
              height: 30,
            ),
            /* GoogleLoginButton(
              loginCallback: widget.loginCallback as void Function(),
              loader: loader as CustomLoader,
            ), */
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController? controller,
      Widget? iconBefore,
      Widget? prefixBefore,
      bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: iconBefore,
          prefixIcon: prefixBefore,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              borderSide: BorderSide(color: Colors.blue)),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  Widget _labelButton(String title, {Function? onPressed}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: AppColor.primary, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ]);
  }

  Widget _emailLoginButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35),
      child: CustomFlatButton(
        label: 'Submit',
        onPressed: _emailLogin,
        borderRadius: 30,
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
  void _returnedValue() {
  widget.loginCallback!();
   Navigator.popAndPushNamed(context, "/SignIn");
  }

  void _emailLogin() {
    var state = Provider.of<AuthState>(context, listen: false);
   /* if (state.isbusy) {
      return;
    }
    */
    loader!.showLoader(context);
    
    var isValid = Utility.validateCredentials(
        _scaffoldKey, _emailController!.text, _passwordController!.text);
    if (isValid) {
      try {
        state
          .login(_emailController!.text, _passwordController!.text,false,
              scaffoldKey: _scaffoldKey)
          .then((responseData) {
          userError = responseData['errorData'];
          print(responseData);
          print("${state.authStatus} is the authstatus");

     // print(userError);
      if(responseData['status'] && state.authStatus == AuthStatus.LOGGED_IN ) {
        //user = responseData['data'];
        loader!.hideLoader();
        Navigator.pop(context);
          widget.loginCallback!();
       // var whatUserName = user!.userName;
       // print(whatUserName);
        
      } else if(responseData['status'] == false && 
      (userError.toString().contains("password") || userError.toString().contains("username"))) {
       
       loader!.hideLoader();
            Utility.customSnackBar(
          _scaffoldKey, "Wrong username or password");
           //Timer(Duration(seconds: 2), _returnedValue);
          
          //return false;
       } else if(responseData['status'] == false && (userError.toString().contains("verified"))) {
       
       loader!.hideLoader();
         /*   Utility.customSnackBar(
          _scaffoldKey, "Wrong username or password");
           */
           //Timer(Duration(seconds: 2), _returnedValue);
         Navigator.pushNamed(context, "/VerifyEmailPage");
          //return false;
      } 
      else {
         loader!.hideLoader();
         Utility.customSnackBar(
          _scaffoldKey, "No network connection on your gadget");
          //Timer(Duration(seconds: 2), _returnedValue);
         
          
             
          //return false; 
      }
      //return false;
      });
     } catch (e) {
        loader!.hideLoader();
        
        print(e);
      }
    } else {
      loader!.hideLoader();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: customText('Sign in',
            context: context, style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: _body(context),
    );
  }
}
