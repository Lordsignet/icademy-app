import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:html/parser.dart';
import 'package:racfmn/components/book_list_item.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/search_model.dart';
import 'package:racfmn/ui/page/details/details.dart';

/// List item representing a single Character with its photo and name.
class SearchListItem extends StatelessWidget {
  const SearchListItem({
    required this.searchData,
    Key? key,
  }) : super(key: key);

  final Search searchData;

  @override
  Widget build(BuildContext context) {
   searchData.getCurrentUser().then((value) => searchData.userId = value!["userId"].toString());
void navigationDetail() {
  print("I was called");
  print("this is post is value => ${searchData.posts_course_id}");
    print("this is userid value => ${searchData.userId}");
  Navigator.push(context, Details.getRoute(searchData.posts_id, searchData.posts_title,
                                  searchData.posts_links_url,searchData.posts_content_url,
                                  searchData.posts_author,searchData.posts_course_id,searchData.posts_content,searchData.userId,searchData.ratingNumber));
}
   return  BookListItem(
     onTap:  navigationDetail, 
    img: searchData.posts_links_url?.replaceAll("../../", Constants.baseHttp),
    title: "${searchData.posts_title.toString().length < 100 ? searchData.posts_title : "${searchData.posts_title?.substring(0,100)}..."}", 
     author: "${searchData.posts_author.toString().length < 100 ? searchData.posts_author : "${searchData.posts_author?.substring(0,100)}..."}",
     desc: "${_parseHtml(searchData.posts_content_url.toString()).length < 30 ? "${_parseHtml(searchData.posts_content_url.toString())}" : "${_parseHtml(searchData.posts_content_url.toString()).substring(0,30)}..."}",
    postsId: searchData.posts_id,
    content: searchData.posts_content,
    postsCourseId: searchData.posts_course_id,
    
  );
  
  }
  String _parseHtml(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;
  return parsedString;
}


}