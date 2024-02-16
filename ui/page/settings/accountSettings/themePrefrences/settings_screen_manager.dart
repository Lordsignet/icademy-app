import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:racfmn/ui/theme/theme.dart';


class SettingsScreenManager extends ChangeNotifier {

  
  SharedPreferenceHelper _storageService = getIt<SharedPreferenceHelper>();

  ThemeData _themeMode = AppTheme.apptheme;
  get themeMode => _themeMode;
 
  SettingsScreenManager() {
    _gatherDataFromStorage();
  }

  void _gatherDataFromStorage() async {
    bool isDarkModeEnabled = await _storageService.getThemeModeSetting();
    _themeMode = isDarkModeEnabled ? AppTheme.darktheme : AppTheme.apptheme;
    notifyListeners();
  }

  void handleThemeModeSettingChange(bool isDarkModeEnabled) {
    _themeMode = _themeMode == AppTheme.darktheme ? AppTheme.apptheme : AppTheme.darktheme;
    _storageService.saveThemeModeSetting(isDarkModeEnabled);
    notifyListeners();
  }

}