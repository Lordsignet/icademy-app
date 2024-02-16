import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/push_notification_model.dart';
import 'package:racfmn/state/notification_provider.dart';
import 'package:racfmn/ui/page/details/details.dart';
import 'package:racfmn/ui/page/notification/widget/notification_list_item.dart';

class pushNotificationPage extends StatefulWidget {
  @override
  _pushNotificationPageState createState() => _pushNotificationPageState();
}
class _pushNotificationPageState extends State<pushNotificationPage> {
  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  void deactivate() {
    super.deactivate();
    getFavorites();
  }

  getFavorites() {
    SchedulerBinding.instance!.addPostFrameCallback(
      (_) {
        if (mounted) {
          Provider.of<NotificationProvider>(context, listen: false).getFavorites();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<NotificationProvider>(
      builder: (BuildContext context, NotificationProvider notifiesProvider,
          child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Notifications center',
            ),
          ),
          body: _checkIfFavorite(notifiesProvider)
        );
      },
    );
  }
  _checkIfFavorite(NotificationProvider notifiesprovider) {
    if(notifiesprovider.loading == true) {
      return Center(child: CircularProgressIndicator());
    } else if(notifiesprovider.loading == false && notifiesprovider.books.isEmpty) {
  return _buildEmptyListView();

    }
    return _buildListView(notifiesprovider );
  }
 
}

  _buildEmptyListView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty-box.png',
            height: 50.0,
            width: 50.0,
          ),
          Text(
            'Your notifications will appear here',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildListView(NotificationProvider notifiesprovider) {
    print(" This is the length of the container ${notifiesprovider.books.length}");
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      shrinkWrap: true,
      itemCount: notifiesprovider.books.length,
     /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 200 / 340,
      ), */
      itemBuilder: (BuildContext context, int index) {
      //  Entry entry = Entry.fromJson(notifiesprovider.posts[index]['item']);
      List<PushNotificationModel> pushRelated = notifiesprovider.books;
      final item = pushRelated[index];
      final title = item.bookName ?? "";
      final postsId = item.bookId;
      print("${item.isRead} is the status of the $postsId");
       return Dismissible(
         key: Key(item.toString()),
         onDismissed: (direction) {
          
            
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title deleted')));
         },
         confirmDismiss: (DismissDirection direction) async {
          return await showDialog(context: context, 
          builder: (BuildContext context) {
              return AlertDialog(title: Text("Confirm delete?"),
               content: Text("Are you sure you want to delete this item?"),
               actions: <Widget>[
                IconButton(onPressed: () {

                  notifiesprovider.removeFav(postsId as String);
                  pushRelated.removeAt(index);
              Navigator.of(context).pop(true);
                },color: Colors.red, 
                icon: Icon(Icons.delete_forever_rounded)
              ),
              IconButton(onPressed: () {
              Navigator.of(context).pop(false);
                }, icon: Icon(Icons.cancel_presentation_rounded
              ))
              ]
              );
          });
         },
         background: Container(color: Colors.red),
         child: InkWell(
           onTap: () async {
           notifiesprovider.updateBook(postsId as String, {"isRead": "true"});
          //  print("${notifiesprovider.isRead}");
            Navigator.push(context, 
                                  Details.getRoute(int.parse(item.bookId.toString()), item.bookName,
                                  item.imageName,item.description,
                                  item.authorName,int.parse(item.book_course_id.toString()),item.fullContent,item.userId.toString(),item.ratingNUmber as int),
                                  );
           },
     child:    Padding(           
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: NotificationListItem(
              index: index,
              isRead: item.isRead,
              img: item.imageName,
              title: title,
              author: item.authorName ?? "",
              desc: item.description?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ""),
              postsId: int.parse(postsId.toString()),
              postsCourseId: int.parse(item.book_course_id.toString()),
            
            ),
          )));
      },
    );
  }
