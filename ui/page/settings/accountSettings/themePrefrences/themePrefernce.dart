import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/newWidget/title_text.dart';

import 'settings_screen_manager.dart';

class ThemePrefernce extends StatelessWidget {
  ThemePrefernce({Key? key}) : super(key: key);

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
                                  title: const Text('Switch Mode'),
                                  value: notifier.themeMode == ThemeMode.light ? false : true,
                                  secondary:
                                  new Icon(
                                      Icons.dark_mode,
                                      color: notifier.themeMode == ThemeMode.light ? Color(0xFF642ef3) : Color.fromARGB(200, 243, 231, 106)
                                  ),
                                  onChanged:notifier.handleThemeModeSettingChange
                              );
                            }
                        ),
    );
  }

  @override
  Widget build(BuildContext context) {
           // print("I was clicked");
             return ( Padding(padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child:    _openUserSortSettings(context) ));
            
  }
}
