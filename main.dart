import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:racfmn/helper/notification_helper.dart';
import 'package:racfmn/model/push_notification_model.dart';
import 'package:racfmn/state/details_provider.dart';
import 'package:racfmn/state/favorites_provider.dart';
import 'package:racfmn/state/comment_provider.dart';
import 'package:racfmn/state/notification_provider.dart';
import 'package:racfmn/state/profile_state.dart'; 
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:racfmn/ui/page/settings/accountSettings/themePrefrences/settings_screen_manager.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'helper/reminderService.dart';
import 'helper/routes.dart';
import 'state/app_state.dart';
import 'package:provider/provider.dart';
import 'state/auth_state.dart';
/* import 'state/chats/chatState.dart'
import 'state/feedState.dart'; */
import 'package:google_fonts/google_fonts.dart';

/* import 'state/notificationState.dart'; */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationService notificationService = NotificationService();
  await notificationService.init();
  setupDependencies();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,]);
  runApp(MyApp());
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 await Firebase.initializeApp();
  Map<String, dynamic> dataValue = message.data;
   PushNotificationModel model = PushNotificationModel.fromJson(dataValue);
     final notificationValue = NotificationMethod();
       // Map<String, dynamic> map = model.toJson();
        await notificationValue.insertBooks(model);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //cprint("Handling a background message: ${message}");
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<AuthState>(create: (_) => AuthState()),
        ChangeNotifierProvider<DetailsProvider>(create: (_) => DetailsProvider()),
        
        ChangeNotifierProvider<CommentProvider>(create: (_) => CommentProvider()),
        ChangeNotifierProvider<ProfileState>(create: (_) => ProfileState()),
         ChangeNotifierProvider<SettingsScreenManager>(create: (_) => SettingsScreenManager()),
       ChangeNotifierProvider<FavoritesProvider>(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider<NotificationProvider>(
            create: (_) => NotificationProvider()), 
      ],
        builder: (context, provider) {
          return Consumer<SettingsScreenManager>(
            builder: (context, notifier, child) {
      return MaterialApp(
        title: 'Icademy',
       /* theme: AppTheme.apptheme.copyWith(
          textTheme: GoogleFonts.adventProTextTheme(
            Theme.of(context).textTheme,
          ),
        ), */
         theme: themeData(notifier.themeMode),
                      darkTheme: themeData(AppTheme.darktheme),
                      //themeMode: notifier.themeMode,
        debugShowCheckedModeBanner: false,
        routes: Routes.route(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        onUnknownRoute: (settings) => Routes.onUnknownRoute(settings),
        initialRoute: 'SplashPage',
      );
      }
      );
      }
      );
      }
      ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
       textTheme: GoogleFonts.adventProTextTheme(
            theme.textTheme,
      ),
    );
  }
      }