import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:racfmn/ui/page/home_page.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/widgets/newWidget/custom_loader.dart';
import 'package:racfmn/widgets/newWidget/emptyList.dart';
import 'package:racfmn/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';

class VerifyEmailPage extends StatefulWidget {
 //final VoidCallback? loginCallback;
  const VerifyEmailPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _VerifyEmailPageState();
}


class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   TextEditingController? _controller;
   dynamic errorReturned;
   dynamic message;
   dynamic email;
   dynamic userId;
   CustomLoader? loader;
   Timer? _timer;
   int _start = 600;
 @override
 void initState() {
_controller = TextEditingController();
 _userPrefs();
 loader = CustomLoader();
 startTimer();
super.initState();
 }

 void _userPrefs() async{
  final userPreference = await getIt<SharedPreferenceHelper>().getUser();
  email = userPreference.email;
  userId = userPreference.userId;
print('${email}' + '${userId}' + '${userPreference}');
 
 }

@override
void dispose() {
 _controller?.dispose();
 _timer?.cancel();
  super.dispose();
}
void startTimer() {
if(_timer != null) {
_timer?.cancel();
_timer = null;
} else {
  _timer = new Timer.periodic(const Duration(seconds: 1), (timer) => setState(() {
   if(_start < 1) {
     timer.cancel();
   } else {
     _start = _start - 1;
   } 
  }));
}
}
_appBar() {
  return AppBar(title: customText(
          'Email Verification',
          context: context,
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,);
}

  Widget _body(BuildContext context) {
    //_appBar();
   // var state = Provider.of<AuthState>(context, listen: false);
    return Container(
      height: context.height,
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
           /*          // Spacer(flex: 3),
                      customText(
          'Verification of Email',
          context: context,
          style: TextStyle(fontSize: 20),
        ),
                      Spacer(),
                      */
                      Spacer(flex:1),
                      customText(
          'Enter the otp sent to your mail to verify your account',
          context: context,
          style: TextStyle(fontSize: 20),
        ),
                  
                       Spacer(flex: 1),
                      customText( '${ _start == 0 ? "Click resend button" : 'Time left : ${formatTime(_start)}'}', textAlign: TextAlign.left,style: TextStyle(color: Colors.black, fontSize: 20)),
                       Spacer(flex: 1),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        
                         
                          
                        
                         PinCodeTextField(
                            controller: _controller,
                            highlightColor: Colors.white,
                            highlightAnimation: true,
                            highlightAnimationBeginColor: Colors.white,
                            highlightAnimationEndColor: Theme.of(context).primaryColor,
                            pinTextAnimatedSwitcherDuration: Duration(milliseconds: 500),
                            wrapAlignment: WrapAlignment.start,
                            hasTextBorderColor: Colors.transparent,
                            highlightPinBoxColor: Colors.white,
                            autofocus: true,
                            pinBoxHeight: 40,
                            pinBoxWidth: 32,
                            pinBoxRadius: 5,
                            maxLength: 6,
                            defaultBorderColor: Colors.transparent,
                            pinBoxColor: Color.fromRGBO(255, 255, 255, 0.8),
                          
                          ),
                        
                      
                      SizedBox(width: 1),
                      Expanded(child: _submitButton(context, _resendOtp(), _resendButton, EdgeInsets.only(left: 0), EdgeInsets.symmetric(horizontal: 0.0)))
                      ]
                      ),
                      Spacer(flex: 1),
//                      otpCode,
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0),
                        child: _submitButton(context, _submitText(), _submit,  EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0), EdgeInsets.symmetric(horizontal: 20.0)),
                      ),
                     // Spacer(flex: 2),
                    //  _submitButton(context, _resendOtp(), _submit),
                      Spacer()
                    ],
                  ),
                )
      
              ]
              )
              );
  }

Widget _submitText() {
  return TitleText(
              'Verify',
              color: Colors.white,
            );
}
String formatTime(int seconds) {
  int minutes = (seconds / 60).truncate();
  String minutesStr = (minutes).toString().padLeft(2, '0');
  String secondsStr = (seconds %  60).toString().padLeft(2, '0');
  return "$minutesStr:$secondsStr"; 
  }
Widget _resendOtp() {
  return TitleText(
              'Resend',
              color: Colors.white,
            );
}
  Widget _submitButton(BuildContext context, Widget child, void Function()? onpressed, EdgeInsets margin, EdgeInsets padding) {
    return Container(
      margin: margin,
      width: MediaQuery.of(context).size.width / 2,
      alignment: Alignment.centerRight,
      child: Wrap(
        children: <Widget>[
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Theme.of(context).primaryColor,
            onPressed: onpressed,
            padding: padding,
            child: child,
            /*TitleText(
              'Send OTP',
              color: Colors.white,
            ), */
          ),
        ],
      ),
    );
  }

void _resendCode() {

 loader!.showLoader(context);
 
 var state = Provider.of<AuthState>(context, listen: false);
 try {
 state.resendCode(email, scaffoldkey: _scaffoldKey).then((responseValue) {
 var status = responseValue["success"];
 message = responseValue["message"];
 if(status && message.toString().contains("Successful")) {
   loader!.hideLoader();
   Utility.customSnackBar(_scaffoldKey, "Verification code has been sent to your email");
 } else if(status == false && message.toString().contains("failed")) {
   loader!.hideLoader();
   Utility.customSnackBar(_scaffoldKey, "Something went wrong some where, try again");
 } else {
   loader!.hideLoader();
   Utility.customSnackBar(_scaffoldKey, "No network connection");
 }
 
 
 });
 } catch (ex) {
   print(ex);
   loader!.hideLoader();
 }
}

void _resendButton() {
  print("resend button was clicked");
if(email.toString().isEmpty || userId.toString().isEmpty) {
      Utility.customSnackBar(_scaffoldKey, "Failed Registration token");
      return;
    }
    print("I failed the first if");
if(_start > 0) {
return;
}
print("I passed the final if");
loader!.showLoader(context);
var state = Provider.of<AuthState>(context, listen: false);
try {
state.resendCode(email, scaffoldkey : _scaffoldKey).then((valueReturned)  {

var status = valueReturned["status"];
if(status) {
loader!.hideLoader();
Utility.customSnackBar(_scaffoldKey, "Otp was successfully sent to your mail box");
  
} else {
loader!.hideLoader();
Utility.customSnackBar(_scaffoldKey, "Something went wrong, pls try again");
}
});
} catch(ex) {
  loader!.hideLoader();
  print(ex);
}
}

void _submit() {
    
    if(_controller!.text.isEmpty || _controller!.text.length < 6 ) {
    Utility.customSnackBar(_scaffoldKey, "Please fill in the field properly");
    return;
    }
    if(email.toString().isEmpty || userId.toString().isEmpty) {
      Utility.customSnackBar(_scaffoldKey, "Failed Registration token");
      return;
    }
    loader!.showLoader(context);
    var state = Provider.of<AuthState>(context, listen: false);
    try {
    state.sendEmailVerification(userId.toString(), email,'${_controller!.text.toString()}',scaffoldKey: _scaffoldKey ).then((returnData) {
  var status = returnData["status"];
  errorReturned = returnData["errorData"];

  if(status && errorReturned.toString().isEmpty && state.authStatus == AuthStatus.LOGGED_IN) {
  loader!.hideLoader();
   Navigator.pop(context);
  // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  // widget.loginCallback;
  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage()));
  
  } else if(status == false && errorReturned.toString().contains("expired") && state.authStatus == AuthStatus.NOT_LOGGED_IN ) {
loader!.hideLoader();
Utility.customSnackBar(_scaffoldKey, "Verificaton failed, Token has expired");
  }
  else if(status == false && errorReturned.toString().contains("wrong") && state.authStatus == AuthStatus.NOT_LOGGED_IN ) {
loader!.hideLoader();
Utility.customSnackBar(_scaffoldKey, "Verificaton failed, wrong token");
  }
  else {
    loader!.hideLoader();
Utility.customSnackBar(_scaffoldKey, "Network connection error");
  }
    } );
    } catch (error) {
      loader!.hideLoader();
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    
    return Scaffold(
      key: _scaffoldKey,
     // backgroundColor: TwitterColor.mystic,
      appBar: _appBar(),
      body: _body(context),
    );
  }
}
