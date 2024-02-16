import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:racfmn/helper/notification_helper.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/model/push_notification_model.dart';
import 'package:rxdart/rxdart.dart';




class PushNotificationService {
 
 /* PushNotificationService(this._firebaseMessaging) {
    initializeMessages();
  }
*/
static final PushNotificationService _pushNotificationService = 
PushNotificationService._internal();
factory PushNotificationService() {
  return _pushNotificationService;
}
PushNotificationService._internal();
  PublishSubject<PushNotificationModel>? _pushNotificationSubject;

  Stream<PushNotificationModel> get pushNotificationResponseStream =>
      _pushNotificationSubject!.stream;
 final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance ;
  final notificationValue = NotificationMethod();
  StreamSubscription<RemoteMessage>? _backgroundMessageSubscription;

  

  /// Configured from Home page
  void configure() async {
//    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    _pushNotificationSubject = PublishSubject<PushNotificationModel>();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');

      try {
        // var data = json.decode(message.data.toString()) as Map<String, dynamic>;
        myBackgroundMessageHandler(message.data, onMessage: true);
      } catch (e) {
        print("$e in on => On Message");
      }
    });

    

    /// Get message when the app is in the Terminated form
    _firebaseMessaging.getInitialMessage().then((event) {
      if (event != null && event.data != null) {
        try {
          myBackgroundMessageHandler(event.data, onLaunch: true);
        } catch (e) {
          print("$e => in getinitialMessage");
        }
      }
    });

    /// Returns a [Stream] that is called when a user presses a notification message displayed via FCM.
    _backgroundMessageSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      
        if (message != null && message.data != null) {
           try {
            myBackgroundMessageHandler(message.data, onLaunch: true);
          } catch (e) {
            print("$e in => On onMessageOpenedApp");
          }
        }
      
    });
  }

  /// Return FCM token
  Future<String> getDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    return token as String;
  }

  /// Callback triger everytime a push notification is received
  void myBackgroundMessageHandler(Map<String, dynamic> message,
      {bool onBackGround = false,
      bool onLaunch = false,
      bool onMessage = false,
      bool onResume = false}) async {
   
    try {
      

        PushNotificationModel model = PushNotificationModel.fromJson(message);
       // Map<String, dynamic> map = model.toJson();
        await notificationValue.insertBooks(model);
        _pushNotificationSubject!.add(model);
    
    } catch (error) {
      print("$error in =>: myBackgroundMessageHandler");
    }
  }
}
