import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:racfmn/helper/reminderService.dart';
import 'package:racfmn/helper/timeZone.dart';
import 'package:racfmn/model/item.dart';
import 'package:racfmn/ui/page/home_page.dart';
import 'package:rxdart/subjects.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:racfmn/helper/constant.dart';


class REminderSetter extends StatefulWidget {
  REminderSetter({Key? key}) : super(key: key);

  @override
  _REminderSetterState createState() => _REminderSetterState();
}

class _REminderSetterState extends State<REminderSetter> {
List alarmed = [];
  List alarms = [];
  int counter = 0;
  DateTime? dt;
  FlutterLocalNotificationsPlugin fltrNotification =
      new FlutterLocalNotificationsPlugin();

  Map<int, String> monthsInYear = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };

  NotificationService notificationService = NotificationService();
  //late SharedPreferenceHelper sharedPreference;
  String reminder = "A reminder of space booking on ${Constants.appName}. Hurry now!!!";

  List<Item> reminders = [];
final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

  TimeOfDay? time;

  final _formKey = GlobalKey<FormState>();
  List<Item> _lastUsedValue = [];
  List<Item> _valueInserted = [];

  @override
  void initState() {
    super.initState();
   // _configureSelectNotificationSubject();
    dt = DateTime.now();
    time = TimeOfDay.now();
    getPrefernces();
   
       
  }

  void getPrefernces() async{
    // await getIt<SharedPreferenceHelper>().saveItemList(reminders);
    final returnedValue = await getIt<SharedPreferenceHelper>().itemLists();
  final decodedValue = (returnedValue.length > 0) ? Item.decodes(returnedValue) : <Item>[];
 
  decodedValue.forEach((item) { 
    print("only item expanded value is: ${item.expandedValue}");
    print("time of day is ${int.tryParse((item.timeofDay!.split(":")[0]))}");
     alarms.insert(decodedValue.indexOf(item),
      [(DateTime.tryParse(item.expandedValue!.split(",")[0]) as DateTime),
      TimeOfDay(hour: (int.tryParse(item.timeofDay!.split(":")[0]) as int), 
      minute: (int.tryParse((item.timeofDay!.split(":")[1])) as int)),
      dt!.add(Duration(hours: DateTime.now().hour,
      minutes: DateTime.now().minute,
      seconds: 5)),
      item.id, reminder]);
  });
  
  
  //print("alarms value at first is this => $valued");
   setState(() {
       
     _lastUsedValue = generateItems(alarms);
    
   });
    //stringLists =  await getIt<SharedPreferenceHelper>().itemLists(Constants.items);
    //   sharedPreference = await getIt<SharedPreferenceHelper>();
  }

  Future cancelAllNotifications() async {
    await fltrNotification.cancelAll();
    setState(() {
      alarms = [];
      _lastUsedValue = generateItems(alarms);
    });
    await getIt<SharedPreferenceHelper>().removeReminder();
  }

  Future cancelNotification(int id, int index) async {
    await fltrNotification.cancel(id);
    setState(() {
      alarms.removeAt(index);
      _lastUsedValue.removeAt(index);
      print('value of alarms after removed -> $alarms');
      print('Value of reminders after removed -> $reminders');

    });
  }

  void notificationSelected(String? payload) async {
   this.build(context);
   Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
   if(payload != null) {
     debugPrint('notification payload' + payload);
   }
  }

  Future picktime(BuildContext context, int? index) async {
    TimeOfDay tod = TimeOfDay.now();
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: (index != null)
          ? alarms[index][1]
          : TimeOfDay(
              hour: tod.hour,
              minute: (tod.minute == 59) ? tod.minute : tod.minute + 1),
    ) as TimeOfDay;
    if (t != null) {
      int l = alarms.length;
      time = t;
      index = l;
      DateTime st =
          dt!.add(Duration(hours: t.hour, minutes: t.minute, seconds: 5));
      bool didApplicationLaunchFromDetails = await _wasApplicationLaunchedFromNotification();
      
     // reminders = (reminders.length == 1) ? reminders : <Item>[]; 
      setState(() {
       // await setReminder();
        if (didApplicationLaunchFromDetails && DateTime.now().isAtSameMomentAs(st) || DateTime.now().difference(st).inMinutes < 1 && reminder.length > 1 ) {
          print("I was called 1");
          _sNotification(st.add(const Duration(days: 1)), index as int);
          
            alarms.insert(l, [dt, time, st, counter, reminder]);
           // reminder = "";
            reminders = generateItems(alarms);
           print("reminders have the length of ${reminders.length}");
           // print(alarms);
           // print(reminders);
        } else if(!didApplicationLaunchFromDetails && (DateTime.now().isAtSameMomentAs(st) || DateTime.now().difference(st).inMinutes < 1) && reminder.length > 1 ) {
print("I was called 2");
_showNotification(index as int);
            alarms.insert(index, [dt, time, st, counter, reminder]);
           // reminder = "";
            reminders = generateItems(alarms);
         //   print('Reminders value => $reminders');
         print("reminders have the length of ${reminders.length}");
         
        } else { 
        print("I was called 3");
         _sNotification(st, index as int);
         alarms.insert(index, [dt, time, st, counter, reminder]);
           // reminder = "";
            reminders = generateItems(alarms);
        }
      });
    }
     print("alarms content are => $alarms");
   // final valueRetrieved = _lastUsedValue.isNotEmpty ? _lastUsedValue : <Item>[];
    print("_last used value has the length of ${_lastUsedValue.length}");
   // reminders = (reminders.length == 1 && valueRetrieved.length > 0) ? reminders + valueRetrieved : reminders;
  
    await getIt<SharedPreferenceHelper>().saveItemList(reminders);
   setState(() {
     _lastUsedValue = reminders;
   });
    
  
  }

  Future pickDate(BuildContext context, int? index) async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: (index != null) ? alarms[index][0] : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    ) as DateTime;
    if (date != null) {
      setState(() {
        dt = date;
      });
      picktime(context, index);
    }
  }

  getminute(t) {
    if (t.minute < 10)
      return "0" + t.minute.toString();
    else
      return t.minute;
  }

  getm(t) {
    if (t.period.toString() == "DayPeriod.am")
      return "am";
    else
      return "pm";
  }

  editDate(BuildContext context, int index) async {
    print("item is at this index => $index");
    print("alarms value is this => $alarms");
    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: alarms[index][0],
     // initialDate: dts,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    ) as DateTime;
    if (newDate != null) {
      List newdateTime = [newDate, alarms[index][1], false];
     // List newdateTime = [newDate, tms, false];
      if (newdateTime[0] != alarms[index][0] ||
          newdateTime[1] != alarms[index][1]) {
        DateTime nst = dt!.add(Duration(
            hours: newDate.hour, minutes: newDate.minute));
        await fltrNotification.cancel(index);
        await _sNotification(nst, index);
        setState(() {
          alarms[index][0] = newdateTime[0];
          alarms[index][1] = newdateTime[1];
          reminders = generateItems(alarms);
          _lastUsedValue = reminders;
        });
      }
    }
  }

  editTime(BuildContext context, int index,List<Item> valued) async {
    TimeOfDay newtime = await showTimePicker(
      context: context,
      initialTime: alarms[index][1],
    ) as TimeOfDay;
    if (newtime != null) {
      List newdateTime = [alarms[index][0], newtime, false];

      if (newdateTime[0] != alarms[index][0] ||
          newdateTime[1] != alarms[index][1]) {
        DateTime nst = newdateTime[0]
            .add(Duration(hours: newtime.hour, minutes: newtime.minute));
        await fltrNotification.cancel(alarms[index][3]);
        await _sNotification(nst, index);
        setState(() {
          alarms[index][0] = newdateTime[0];
          alarms[index][1] = newdateTime[1];
          reminders = generateItems(alarms);
            _lastUsedValue = reminders;
        });
      }
    }
  }

  editAlarm(BuildContext context, int index, List<Item> valued) async {
    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: alarms[index][0],
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    ) as DateTime;
    if (newDate != null) {
      TimeOfDay newtime = await showTimePicker(
        context: context,
        initialTime: alarms[index][1],
      ) as TimeOfDay;
      if (newtime != null) {
        List newdateTime = [newDate, newtime, false];

        if (newdateTime[0] != alarms[index][0] ||
            newdateTime[1] != alarms[index][1]) {
          DateTime nst =
              dt!.add(Duration(hours: newtime.hour, minutes: newtime.minute));
          await fltrNotification.cancel(alarms[index][3]);
          await _sNotification(nst, index);
          setState(() {
            alarms[index][0] = newdateTime[0];
            alarms[index][1] = newdateTime[1];
            valued = generateItems(alarms);
          });
        }
      }
    }
  }

  editReminder(int index) async {
   // await setReminder();
    if (reminder.length > 4) {
      setState(() {
        alarms[index][4] = reminder;
        DateTime st = alarms[index][0].add(Duration(
            hours: alarms[index][1].hour, minutes: alarms[index][1].minute));
        fltrNotification.cancel(alarms[index][3]);
        _sNotification(st, index);
        _lastUsedValue = generateItems(alarms);
      });
    }
  }

  List<Item> _itemlistValue() {
    var itemList;
    getIt<SharedPreferenceHelper>().itemLists().then((value) => itemList = (value as String));
    if(itemList.isNotEmpty) {
    final decodedValue = Item.decodes(itemList);
    return decodedValue;
    }
   return <Item>[];
  }

   void _configureSelectNotificationSubject() {
   notificationService.selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  Future _sNotification(DateTime scheduledTime, int id) async {
    var androidDetails = notificationService.androidNotificationDetails;
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    final timeZone = TimeZone();

    // The device's timezone.
    String timeZoneName = await timeZone.getTimeZoneName();

    // Find the 'current location'
    final location = await timeZone.getLocation(timeZoneName);

    final st = tz.TZDateTime.from(scheduledTime, location);
    fltrNotification.zonedSchedule(
        counter, "${Constants.appName} reminder", reminder, st, generalNotificationDetails,
        androidAllowWhileIdle: true,
        payload:
            '${alarms[id][4]} at ${alarms[id][1].hourOfPeriod}:${_REminderSetterState().getminute(alarms[id][1])} ${_REminderSetterState().getm(alarms[id][1])}',
         uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    setState(() {
      alarms[id][2] = st;
      alarms[id][3] = counter;
      counter = counter + 1;
    });
  }

  tz.TZDateTime _nextInstanceOf(int index) {
    final now = alarms[index][2];
  
    tz.TZDateTime scheduledDate =  tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute,10);
    final difference = scheduledDate.difference(now);

    if (scheduledDate.isAtSameMomentAs(now) || difference.inMinutes < 1) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> _scheduleDailyNotification(int index) async {
   var androidDetails = notificationService.androidNotificationDetails;
    var iOSDetails = notificationService.iOSNotificationDetails;
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await fltrNotification.zonedSchedule(
        counter,
        '${Constants.appName} daily reminder',
        reminder,
        _nextInstanceOf(index),
        
          generalNotificationDetails,
      
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);

    setState(() {
      counter = counter + 1;
    });
  }

  Future<void> _scheduleWeeklyNotification(int index) async {
     var androidDetails = notificationService.androidNotificationDetails;
    var iOSDetails = notificationService.iOSNotificationDetails;
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await fltrNotification.zonedSchedule(
        counter,
        '${Constants.appName} weekly reminder',
        reminder,
        _nextInstanceOf(index),
        generalNotificationDetails,
        
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    setState(() {
      counter = counter + 1;
    });
  }

   Future<void> _showNotification(int index) async {
      var androidDetails = notificationService.androidNotificationDetails;
    var iOSDetails = notificationService.iOSNotificationDetails;
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await fltrNotification.show(
        counter,
        '${Constants.appName}',
        'Book your library space. Hurry now!',
        generalNotificationDetails,
        payload: "Time to enter the library");
    setState(() {
      counter = counter + 1;
    });
  }

  _buildEmptyListView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty-box.png',
            height: 30.0,
            width: 30.0,
          ),
          Text(
            "Don't miss out  from ${Constants.appName}, book a space",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

 Widget _listView(List<Item> reminders) {
  print("reminders length is => ${reminders.length}");
  return ListView(
        children: <Widget>[
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                reminders[index].isExpanded = !isExpanded;
              });
            },
            children: reminders.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpanded) {
                        return Row(children: [
                          Expanded(
                              child: ListTile(
                            title: Text(item.headerValue.toString()),
                          )),
                          // IconButton(icon: Icon(Icons.edit), onPressed: null),
                          Switch(
                            value: item.toggle,
                            onChanged: (value) {
                              setState(() {
                                item.toggle = !item.toggle;
                                if (!value) {
                                  fltrNotification.cancel(item.id as int);
                                }
                                if (value) {
                                  _sNotification(
                                      alarms[reminders.indexOf(item)][2],
                                      reminders.indexOf(item));
                                }
                              });
                            },
                          )
                        ]);
                      },
                      body: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                item.expandedValue.toString(),
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              )),
                            ),
                          /*  IconButton(
                                icon: Icon(
                                  Icons.edit,
                                ),
                                color: Colors.purple[900],
                                onPressed: () {
                                  editReminder(reminders.indexOf(item));
                                }), */
                            IconButton(
                                color: Colors.purple[900],
                                icon: Icon(
                                  Icons.event,
                                ),
                                onPressed: () {
                                  print("first time is ${item.expandedValue!.split(",")[0]}");
                                  editDate(context, reminders.indexOf(item));
                                }),
                            IconButton(
                                color: Colors.purple[900],
                                icon: Icon(
                                  Icons.access_time,
                                ),
                                onPressed: () {
                                  editTime(context, reminders.indexOf(item), _lastUsedValue);
                                }),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                cancelNotification(
                                    alarms[reminders.indexOf(item)][3],
                                    reminders.indexOf(item));
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        2.0, 0.0, 0.0, 20.0),
                                    child: Column(children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.alarm,
                                          color: item.dailyColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (item.daily) {
                                              fltrNotification.cancel(item.did);
                                              item.dailyColor = Colors.black;
                                              item.daily = false;
                                            } else {
                                              item.did = counter;
                                              _scheduleDailyNotification(
                                                  reminders.indexOf(item));
                                              item.dailyColor = Colors.red;
                                              item.daily = true;
                                            }
                                          });
                                        },
                                      ),
                                      Text('Daily Reminder')
                                    ]))),
                            Expanded(
                                child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        2.0, 0.0, 0.0, 20.0),
                                    child: Column(children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.alarm,
                                          color: item.weeklyColor,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            if (item.weekly) {
                                              fltrNotification.cancel(item.wid);
                                              item.weeklyColor = Colors.black;
                                              item.weekly = false;
                                            } else {
                                              item.wid = counter;
                                              _scheduleWeeklyNotification(
                                                  reminders.indexOf(item));
                                              item.weeklyColor = Colors.red;
                                              item.weekly = true;
                                            }
                                          });
                                        },
                                      ),
                                      Text('Weekly'),
                                    ]))),
                          ],
                        )
                      ]),
                      isExpanded: item.isExpanded);
                }).toList()
          ),
        ],
      );
 }

_wasApplicationLaunchedFromNotification() async {
    NotificationAppLaunchDetails? notificationAppLaunchDetails = await fltrNotification.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    return notificationAppLaunchDetails?.didNotificationLaunchApp;
    }
   return false;
  }

  @override
  Widget build(BuildContext context) {
    var datas = [];
  
    Widget child = Center(child: CircularProgressIndicator());
   // final valueReturned = _itemlistValue();
    //final isEmptyOr = valueReturned.isNotEmpty ? 
   // child = valueReturned.isNotEmpty ? _listView(valueReturned) : _buildEmptyListView();    
      
     child = _lastUsedValue.isNotEmpty ? _listView(_lastUsedValue) : _buildEmptyListView(); 

    return Scaffold(
      appBar: AppBar(title: Text('${Constants.appName} reminder'), actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              cancelAllNotifications();
            })
      ]),
      body: child,
   
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickDate(context, null);
        },
        child: Icon(Icons.event, color: Theme.of(context).primaryColor),
        tooltip: 'Add an event',
      ),
    );
  }
}



List<Item> generateItems(List<dynamic> reminders) {
  return List.generate(reminders.length, (int index) {
    return Item(
      id: reminders[index][3],
      headerValue: '${reminders[index][4]}',
      timeofDay: '${reminders[index][1].hourOfPeriod}:${_REminderSetterState().getminute(reminders[index][1])}',
      expandedValue:
          '${reminders[index][0].year}-${reminders[index][0].month}-${reminders[index][0].day}, ${reminders[index][1].hourOfPeriod}:${_REminderSetterState().getminute(reminders[index][1])} ${_REminderSetterState().getm(reminders[index][1])}',
    );
  });
}






