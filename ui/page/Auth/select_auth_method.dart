import 'package:flutter/material.dart';
import 'package:matcher/matcher.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/Auth/signup.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/widgets/newWidget/title_text.dart';
import 'package:provider/provider.dart';
import '../home_page.dart';
import 'signin.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      child: CustomFlatButton(
        label: 'Create Account',
        onPressed: () {
          var state = Provider.of<AuthState>(context, listen: false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Signup(),
            ),
          );
        },
        borderRadius: 30,
      ),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 80,
              height: 40,
              child: Image.asset(
                  'assets/images/icon_480.png'),
            ),
            Spacer(),
            TitleText(
              'Explore a reservoir of knowledge, be at the peak of your profession',
              fontSize: 25,
            ),
            SizedBox(
              height: 20,
            ),
            _submitButton(),
            SizedBox(
              height: 50,
            ),
            Wrap(
              alignment: WrapAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 40.0),
                  child: TitleText(
                    'Have an account already?',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                ),
                InkWell(
                  onTap: () {
                    var state = Provider.of<AuthState>(context, listen: false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SignIn(loginCallback: state.getCurrentUser),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                    child: TitleText(
                      ' Log in',
                      fontSize: 15,
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            Spacer(),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: state.authStatus == AuthStatus.NOT_LOGGED_IN || state.authStatus == AuthStatus.NOT_DETERMINED
         ? _body() : HomePage(),
    );
  }
}
