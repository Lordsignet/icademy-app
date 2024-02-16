import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/user.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/settings/widgets/headerWidget.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_app_bar.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/widgets/newWidget/title_text.dart';
import 'package:racfmn/widgets/url_text/custom_url_text.dart';

import 'accountSettings/themePrefrences/settings_screen_manager.dart';
import 'accountSettings/themePrefrences/themePrefernce.dart';
import 'widgets/settingsRowWidget.dart';

class SettingsAndPrivacyPage extends StatelessWidget {
  const SettingsAndPrivacyPage({Key? key}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel;
    final String appName = Constants.appName;
    return Scaffold(
     // backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
      isBackButton: true,
        title: customTitleText(
          'Settings',
        ),
      centerTile: true,  
      ),
      body: ListView(
      
        children: <Widget>[
          HeaderWidget("General"),
           Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
           child: UrlText(text: "Theme",),).ripple(() { print("I was clicked");
           _openUserSortSettings(context); print("i WASN'T CALLED");}),
        
          Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
           child: UrlText(text: "Reminder",),).ripple(() {  Navigator.pushNamed(context, '/Reminder');}),
          Divider(height: 0),
         
          HeaderWidget(
            'Others',
            secondHeader: true,
          ),
          
         /* SettingRowWidget(
            "About",
            navigateTo: "AboutPage",
            styles: TextStyle()
          ),
           */
          Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: UrlText(text: "About",),).ripple(() {  Navigator.pushNamed(context, '/AboutPage');}), 
            
         Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: UrlText(text: "Tos",),).ripple(() {  Navigator.pushNamed(context, '/TosPage');}),    
            SizedBox(height: 50),     

        ],
      ),
      bottomNavigationBar: BottomAppBar(child: Text("$appName v1.0", textAlign: TextAlign.center,),
      color: Colors.transparent,),
    );
  }
  void _openBottomSheet(
      BuildContext context, double height, Widget child) async {
   await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: TwitterColor.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: child,
        );
      },
   );
  }

  _openUserSortSettings(BuildContext context) {
   _openBottomSheet(
        context,
      340,
      Column(
        children: <Widget>[
          SizedBox(height: 5),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: TwitterColor.paleSky50,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: TitleText('Theme Settings'),
          ),
          Divider(height: 0),
          _row(context, "Switch Theme"),
          
        ],
      ),
  );
  }

  Widget _row(BuildContext context, String text) {
    //final state = Provider.of<SearchState>(context, listen: false);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child:  Consumer<SettingsScreenManager>(
                            builder: (context, notifier, child) {
                              return  SwitchListTile(
                                  title: notifier.themeMode == AppTheme.apptheme  ? const Text('Light Mode', style: TextStyle(color: Colors.grey)) : const Text('Dark Mode', style: TextStyle(color: Colors.black)),
                                  value: notifier.themeMode == AppTheme.apptheme ? false : true,
                                  secondary:
                                  new Icon(
                                      Icons.dark_mode,
                                      color: notifier.themeMode == AppTheme.apptheme ? AppTheme.apptheme.secondaryHeaderColor : AppTheme.darktheme.primaryColorDark
                                  ),
                                  onChanged:notifier.handleThemeModeSettingChange
                              );
                            }
                        ),
    );
  }
}
