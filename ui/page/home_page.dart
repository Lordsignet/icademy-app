import 'dart:async';
import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:racfmn/helper/notification_helper.dart';
import 'package:racfmn/helper/push_notification_service.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/model/push_notification_model.dart';
import 'package:racfmn/state/app_state.dart';
import 'package:racfmn/ui/page/details/details.dart';
import 'package:racfmn/ui/page/hometabs/booktab.dart';
import 'package:racfmn/ui/page/hometabs/papertab.dart';
import 'package:racfmn/ui/page/hometabs/projecttab.dart';
import 'package:racfmn/ui/page/hometabs/spiritual.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:provider/provider.dart';

import 'common/locator.dart';
import 'common/sidebar.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  TabController? _tabController;
  bool showFab = true;
  final notificationDb = NotificationMethod();
   List<PushNotificationModel> returnNotification = [];
    int? returnedValue;


   StreamSubscription<PushNotificationModel>? pushNotificationSubscription; 
  @override
  void initState() {
     getNotifications().then((value) {
           setState(() {
              returnNotification =  value;
           });
          
           
           });
    _tabController = TabController(vsync: this, initialIndex: 0, length: 4);
    _tabController?.addListener(() {
      if (_tabController!.index == 0) {
        showFab = true;
      } else {
        showFab = false;
      }
      // print("called in state");
      
     WidgetsBinding.instance!.addPostFrameCallback((_) {
        var state = Provider.of<AppState>(context, listen: false);
        print("called in state");
        
        // listFuture();
       initNotificaiton();
       
      });
      

      super.initState();
      
    });
  }

  @override
  void dispose() {
    // getIt<PushNotificationService>().pushBehaviorSubject.close();
    super.dispose();
  }

   void initNotificaiton() {
    PushNotificationService pushNotifcationService = PushNotificationService();
    pushNotifcationService.configure();
     pushNotifcationService.pushNotificationResponseStream.listen(listenPushNotification);
     
     
   }
   void listFuture() async {
   // returnNotification = await getNotifications();
    print("${returnNotification.length}");
   }
   Future<List<PushNotificationModel>>  getNotifications() async{
    final value = await notificationDb.getAllBooksNotRead();
    return value;   
     }
  void listenPushNotification(PushNotificationModel model) {
   Navigator.push(context, Details.getRoute(int.parse(model.bookId.toString()), model.bookName, model.imageName, model.description, model.authorName, int.parse(model.book_course_id.toString()), model.fullContent, model.userId.toString(), int.parse(model.ratingNUmber.toString())));
   }
  //StreamSubscription<PushNotificationModel>? pushNotificationSubscription;
 
  

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
   super.debugFillProperties(properties);
    properties.add(
        DiagnosticsProperty<StreamSubscription<PushNotificationModel>>(
            'pushNotificationSubscription', pushNotificationSubscription));
  }
  
  FloatingActionButton _newMessageButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/SearchPage');
      },
      child: customIcon(
        context,
        icon: AppIcon.searchFill,
        istwitterIcon: false,
        iconColor: Theme.of(context).colorScheme.onBackground,
        size: 25,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        
        appBar: _appBar(),
        drawer: SidebarMenu(),
        floatingActionButton:  _newMessageButton(),
            
        body: _body());
        
  }

  _appBar() {
   
   print("called in appBar");
   
    return AppBar(
      // title: Text('BerriesLib'),
      elevation: 0.7,
      //automaticallyImplyLeading: false,
      //backgroundColor: Colors.brown.shade400,
      bottom: TabBar(
        indicatorWeight: 5.0,
        //labelPadding: EdgeInsets.symmetric(horizontal: 2),
        /*indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white, */
        indicatorColor: Theme.of(context).backgroundColor,
       // unselectedLabelColor: Colors.white38,
        controller: _tabController,
        tabs: <Widget>[
          // Tab(icon: Icon(Icons.camera_alt)),
          Tab(text: 'BOOKS'),
          Tab(
            text: 'PAPERS',
          ),
          Tab(
            text: 'JOURNALS',
          ),
           Tab(
            text: 'SPIRITUAL',
          ),
        ],
      ),
      actions: <Widget>[
       
        Badge(
          showBadge: returnNotification.isEmpty? false : true,
           padding: EdgeInsets.all(6),
       /* gradient: LinearGradient(colors: [
          Colors.black,
          Colors.red,
        ]), */
        badgeColor: Colors.orange,
        badgeContent: returnNotification.isEmpty? null : Text(
          '${returnNotification.length}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ), 
        elevation: 5,
        stackFit: StackFit.passthrough,
        alignment: Alignment.topRight,
        position: BadgePosition.topStart(start: 8, top: 0),
      child:  IconButton(icon: Icon(Icons.notifications), onPressed: () {
        Navigator.pushNamed(context, '/PushNotification');
      },),
        ),
      /*  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
        ),
       Icon(Icons.more_vert) */
      ],
      flexibleSpace: SafeArea(
        child: Icon(
          Icons.library_books,
          size: 55.0,
          color: Colors.white60,
        ),
      ),
    );
  }

  _body() {
    return SafeArea(
        child: TabBarView(
      controller: _tabController,
      children: <Widget>[
        //CameraScreen(widget.cameras),
        BookTab(),
        PaperTab(),
        JournalTab(),
        SpiritualTab()
      ],
    ));
  }
}
