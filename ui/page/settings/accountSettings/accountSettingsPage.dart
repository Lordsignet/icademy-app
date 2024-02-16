import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/model/user.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/settings/widgets/headerWidget.dart';
import 'package:racfmn/ui/page/settings/widgets/settingsAppbar.dart';
import 'package:racfmn/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_app_bar.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/widgets/url_text/custom_url_text.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel;
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: /*SettingsAppBar(
        title: 'Account',
      //  subtitle: user.userName.toString(),
      ),
      */
      CustomAppBar(
      isBackButton: true,
        title: customTitleText(
          'Account',
        ),
      centerTile: true,  
      ),
      body: ListView(
        children: <Widget>[
          HeaderWidget('Login and security'),
           SettingRowWidget(
            "Username",
            subtitle: "${user.userName}",
            // navigateTo: 'AccountSettingsPage',
          ),
          SettingRowWidget(
            "Email",
            subtitle: user.email.toString(),
            // navigateTo: 'AccountSettingsPage',
          ),
          Divider(height: 0),
       /*   SettingRowWidget(
            "Phone",
            subtitle: user.displayName.toString(),
          ),
          SettingRowWidget(
            "Email address",
            subtitle: user?.email,
            navigateTo: 'VerifyEmailPage',
          ), */
          SettingRowWidget("Password", subtitle: "********"),
         // SettingRowWidget("Security"),
        /*  HeaderWidget(
            'Data and Permission',
            secondHeader: true,
          ), */
        //  SettingRowWidget("Country"),
        //  SettingRowWidget("Apps and sessions"),
        Padding(
       padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
       child: UrlText(
         text: "Log out",

      ).ripple(() {
        final state = Provider.of<AuthState>(context, listen: false);
              state.logoutCallback();
        Navigator.of(context).pushNamed('/signIn');
      }),
        /*  SettingRowWidget(
            "Log out",
            textColor: TwitterColor.ceriseRed,
            onPressed: () {
              print("hello");
              final state = Provider.of<AuthState>(context);
              state.logoutCallback();
             // Navigator.popUntil(context, ModalRoute.withName('/'));
              
              
            },
          ), */
        ),
        ]),
    );
  }
}
