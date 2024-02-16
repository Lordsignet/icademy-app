import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:racfmn/components/loading_widget.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:uuid/uuid.dart';

class NotificationListItem extends StatelessWidget {
  final String? img;
  final String? title;
  final String? author;
  final String? desc;
  final int? postsId;
  final String? content;
  //final String? description;
  final int? postsCourseId;
 late String userId = "";
 final int? index;
  late int ratingNumber = 0;
  final String? isRead;
  //final Entry? entry;

  NotificationListItem({
    Key? key,
    this.img,
    this.title,
    this.author,
    this.desc,
    this.postsId,
    this.content,
    //this.description,
    this.postsCourseId,
    this.index,
    this.isRead,
    
  }) : super(key: key);

  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();

  @override
  Widget build(BuildContext context) {
     getCurrentUser().then((value) => userId = value!["userId"].toString());
    return Container(
        height: 150.0,
        color: isRead == "true" ? Colors.white : Colors.greenAccent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              elevation: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                child: Hero(
                  tag: 'notificationlistitemimg' + index.toString(),
                  child: CachedNetworkImage(
                   imageUrl: '$img',
                    placeholder: (context, url) => Container(
                      height: 150.0,
                      width: 100.0,
                      child: LoadingWidget(
                        isImage: true,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                     
                      'assets/images/confused-face.png',
                      fit: BoxFit.cover,
                      height: 150.0,
                      width: 100.0,
                     //  color: isRead == "true" ? Colors.orangeAccent : Colors.black,
                    ),
                    fit: BoxFit.cover,
                    height: 150.0,
                    width: 100.0,
                   //  color: isRead == "true" ? Colors.orangeAccent : Colors.black, 
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                Hero(
                 tag: 'notificationlistitemtext1' + index.toString(),
                child:    Material(
                      type: MaterialType.transparency,
                      child: Text(
                        '${title}',
                        style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          color: isRead == "true" ? Colors.orangeAccent : Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                Hero(
                   tag: 'notificationlistitemtext2' + index.toString(),
                 child:   Material(
                      type: MaterialType.transparency,
                      child: Text(
                        '${author ?? ""}',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w800,
                          color:  isRead == "true" ? Colors.orangeAccent : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    //'${desc!.length < 100 ? desc : desc?.substring(0, 100)}...',
                    '${desc ?? ""}',
                    style: TextStyle(
                      fontSize: 13.0,
                      color:   isRead == "true" ? Colors.orangeAccent : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
 Future<Map<String, Object>?> getCurrentUser() async {
     var userPreference = await getIt<SharedPreferenceHelper>().getUser();
     var userId = userPreference.userId.toString();
     var userName = userPreference.userName.toString();

     return {"userName": userName, "userId": userId};

  }
}