import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/settings/widgets/headerWidget.dart';
import 'package:racfmn/ui/page/settings/widgets/settingsAppbar.dart';
import 'package:racfmn/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_app_bar.dart';
import 'package:racfmn/widgets/custom_widgets.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AuthState>(context).userModel;
    return Scaffold(
      //backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
      isBackButton: true,
        title: customTitleText(
          'Notifications',
        ),
      centerTile: true,  
      ),
      body: ListView(
        children: <Widget>[
          HeaderWidget('Filters'),
          SettingRowWidget(
            "Quality filter",
            showCheckBox: true,
            subtitle:
                'Filter lower-quality from your notifications.',
            // navigateTo: 'AccountSettingsPage',
          ),
          Divider(height: 0),
          SettingRowWidget("Advanced filter"),
          SettingRowWidget("Muted word"),
          HeaderWidget(
            'Preferences',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Unread notification count badge",
            showCheckBox: false,
            subtitle:
                'Display a badge with the number of notifications waiting for you inside the Ark library app.',
          ),
          SettingRowWidget("Push notifications"),
          SettingRowWidget("Local notifications"),
        /*  SettingRowWidget(
            "Email notifications",
            subtitle: 'Control when how often Fwitter sends emails to you.',
          ), */
        ],
      ),
    );
  }
}
