import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:racfmn/components/loading_widget.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:racfmn/ui/page/details/details.dart';
import 'package:uuid/uuid.dart';

class BookCard extends StatelessWidget {
  final String? img;
  final int? postsId;
  final int? tag;
  final String? title;
  final String? author;
  final String? desc;
  final String? content;
  //final String? description;
  final int? postsCourseId;
 late String userId = "";
 final int? index;
  late int ratingNumber = 0;
//  final List<TestFeed>? entry;

  BookCard({
    Key? key,
    this.img,
    this.title,
    this.author,
    this.desc,
    this.postsId,
    this.tag,
    this.content,
    this.postsCourseId,
    this.index,
    
  }) : super(key: key);
  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();

  @override
  Widget build(BuildContext context) {
    getCurrentUser().then((value) => userId = value!["userId"].toString());
    return InkWell(
      onTap: () {
       // Navigator.pop(context);
        Navigator.push(context, 
                                  Details.getRoute(this.postsId, this.title,
                                  this.img,this.desc,
                                  this.author,this.postsCourseId,this.content,userId,ratingNumber),
                                  );
      },
                                  
    child: Container(
      width: 120.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        elevation: 4.0,
        child: InkWell(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
         
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Hero(
              tag: 'bookcard' + index.toString() ,
              child: CachedNetworkImage(
                imageUrl: '$img',
                placeholder: (context, url) => LoadingWidget(
                  isImage: true,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/place.png',
                  fit: BoxFit.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    ));
  }
Future<Map<String, Object>?> getCurrentUser() async {
     var userPreference = await getIt<SharedPreferenceHelper>().getUser();
     var userId = userPreference.userId.toString();
     var userName = userPreference.userName.toString();

     return {"userName": userName, "userId": userId};

  }
}
