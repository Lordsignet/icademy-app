import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:racfmn/ui/page/details/details.dart';
import 'package:racfmn/ui/page/readbooks/readPdfFile.dart';
import 'package:racfmn/widgets/custom_widgets.dart';

/// List item representing a single Character with its photo and name.
class BookGridtItem extends StatelessWidget {
  BookGridtItem({
    required this.testfeed,
    required this.mainNavigation,
    this.ordersUrl,
    Key? key,
  }) : super(key: key);

  final TestFeed testfeed;
  late String userId = "";
  late int ratingNumber = 0;
  String mainNavigation = "notOrder";
  String? ordersUrl;
  @override
  Widget build(BuildContext context) {
    print(testfeed);
  
    getCurrentUser().then((value) => userId = value!["userId"].toString());
     return Stack(
                      //padding: EdgeInsets.all(5),
                      children: <Widget>[
                        Positioned(
                          top: 128,
                          left: 0,
                          right: 0,
                          child: Container(
                              // color: Colors.white,
                              child: Column(
                            children: <Widget>[
                              Image.network(
                                Constants.coverImage,
                                width: 100.0,
                                fit: BoxFit.cover,
                                // height: 120.0,
                              ),
                            ],
                          )),
                        ),
                        Positioned(
                            top: 10,
                            left: 0,
                            right: 0,
                            child: Container(
                              child: Column(
                                children: <Widget>[
                             /*     Image.network(
                                    snapshot.data![index],
                                    width: 180.0,
                                    height: 120.0,
                                  ),
                                  */
                                   Hero(tag: 'bookgriditem' + testfeed.posts_id.toString(), 
                      
                        child:  InkWell(
                            splashColor: Colors.grey,
                            onTap: () {
                              if( mainNavigation == "notOrder") {
                              Navigator.push(context, 
                                  Details.getRoute(testfeed.posts_id, testfeed.posts_title,
                                  testfeed.posts_links_url,testfeed.posts_content,
                                  testfeed.posts_author,testfeed.posts_course_id,testfeed.posts_fullcontent,userId,ratingNumber),
                                  );
                                  } else {
                                print("called in onTap ${testfeed.posts_fullcontent}");
                               Navigator.push(context, MaterialPageRoute(builder: (contex) => ReadFileSCreen(filename: testfeed.posts_fullcontent)));
                             }
                            },
                            child: CachedNetworkImage(
                              imageUrl: testfeed.posts_links_url!.replaceFirst("../../", Constants.baseHttp),
                              //fit: BoxFit.cover,
                              width: 180,
                              height: 120.0,
                               placeholder: (context, url) => loader(),
              errorWidget: (context, url, error) => Icon(Icons.error),

                            )
                          )
                        
                        
                                   )],
                              ),
                            )),
                      ],
                    ); 
  }
  Future<Map<String, Object>?> getCurrentUser() async {
     var userPreference = await getIt<SharedPreferenceHelper>().getUser();
     var userId = userPreference.userId.toString();
     var userName = userPreference.userName.toString();

     return {"userName": userName, "userId": userId};

  }
}
   