import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:racfmn/search/SearchPage.dart';
import 'package:racfmn/ui/page/Auth/select_auth_method.dart';
import 'package:racfmn/ui/page/Auth/verify_email.dart';
import 'package:racfmn/ui/page/common/splash.dart';
import 'package:racfmn/ui/page/favorites/favorites.dart';
import 'package:racfmn/ui/page/notification/pushnotificationPage.dart';
import 'package:racfmn/ui/page/profile/profile_page.dart';
import 'package:racfmn/ui/page/orders/orders.dart';
import 'package:racfmn/ui/page/settings/accountSettings/about/about.dart';
import 'package:racfmn/ui/page/settings/accountSettings/accountSettingsPage.dart';
import 'package:racfmn/ui/page/settings/accountSettings/reminder/notificationSetting.dart';
import 'package:racfmn/ui/page/settings/accountSettings/reminder/reminder.dart';
import 'package:racfmn/ui/page/settings/accountSettings/tos/tos.dart';
import 'package:racfmn/ui/page/settings/settingsAndPrivacyPage.dart';
import 'custom_route.dart';
import '../ui/page/Auth/forget_password_page.dart';
import '../ui/page/Auth/signin.dart';
import '../ui/page/Auth/signup.dart';
import '../widgets/custom_widgets.dart';

class Routes {
  static dynamic route() {
    return {
      'SplashPage': (BuildContext context) => SplashPage(),
    };
  }

  static void sendNavigationEventToFirebase(String path) {
    if (path != null && path.isNotEmpty) {
      // analytics.setCurrentScreen(screenName: path);
    }
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name!.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null as Route<dynamic>;
    }

    switch (pathElements[1]) {
      case 'ProfilePage':
        int? profileId;
        if (pathElements.length > 2) {
          profileId = pathElements[2] as int;
        }
        return CupertinoPageRoute<bool>(
            builder: (BuildContext context) => ProfilePage(
                  profileId: profileId,
                ));

      case 'WelcomePage':
        return CustomRoute<bool>(
            builder: (BuildContext context) => WelcomePage());
      case 'SignIn':
       return CustomRoute<bool>(
            builder: (BuildContext context) => SignIn());
      case 'SignUp':
       return CustomRoute<bool>(
            builder: (BuildContext context) => Signup());
      case 'ForgetPasswordPage':
       return CustomRoute<bool>(
            builder: (BuildContext context) =>ForgetPasswordPage());
            case 'FavoritesPage':
        return CustomRoute<bool>(
            builder: (BuildContext context) => Favorites());
        case 'SearchPage':
        return CupertinoPageRoute<bool>(
            builder: (BuildContext context) => SearchPage());
            case 'SettingsAndPrivacyPage':
        return CupertinoPageRoute<bool>(
          builder: (BuildContext context) => SettingsAndPrivacyPage(),
        );
         case 'OrderPage':
        return CupertinoPageRoute<bool>(
            builder: (BuildContext context) => OrdersPage());
           
        case 'AccountSettingsPage':
        return CupertinoPageRoute<bool>(
          builder: (BuildContext context) => AccountSettingsPage(),
        );
         case 'Reminder':
        return CustomRoute<bool>(
          builder: (BuildContext context) => REminderSetter(),
        );
         case 'NotificationPage':
        return CustomRoute<bool>(
          builder: (BuildContext context) => NotificationPage(),
        );
        case 'PushNotification':
         return CustomRoute<bool>(
          builder: (BuildContext context) => pushNotificationPage(),
        );
        case 'AboutPage':
         return CustomRoute<bool>(
          builder: (BuildContext context) => AboutPage(),
        );
        case 'TosPage':
         return CustomRoute<bool>(
          builder: (BuildContext context) => TosPage(),
        );
      case 'VerifyEmailPage':
        return CustomRoute<bool>(
          builder: (BuildContext context) => VerifyEmailPage(),
        );
      default:
        return onUnknownRoute(RouteSettings(name: '/Feature'));
    }
  }

  static Route onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: customTitleText(settings.name!.split('/')[1]),
          centerTitle: true,
        ),
        body: Center(
          child: Text('${settings.name?.split('/')[1]} Comming soon..'),
        ),
      ),
    );
  }
}
