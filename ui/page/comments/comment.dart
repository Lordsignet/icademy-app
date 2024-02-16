import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/components/book.dart';
import 'package:racfmn/components/book_list_item.dart';
import 'package:racfmn/components/comment_list_item.dart';
import 'package:racfmn/helper/api.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/custom_route.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/state/home_provider.dart';
import 'package:racfmn/ui/page/details/details.dart';
import 'package:racfmn/ui/page/hometabs/book_grid_item.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:racfmn/widgets/newWidget/emptyList.dart';
import 'package:racfmn/widgets/newWidget/loading_widget.dart';

class CommentExtra extends StatefulWidget {
  //BookTab({Key? key, this.refreshIndicatorKey}) : super(key: key);
// final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;
final int? bookId;
CommentExtra({Key? key, this.bookId}): super(key: key);
  static Route<Null> getRoute(int? bookId) {
    return SlideLeftRoute<Null>(
      builder: (BuildContext context) => CommentExtra(
        bookId: bookId,
      ),
    );
  }

  @override
  _CommentExtraState createState() => _CommentExtraState();

  
}
class _CommentExtraState extends State<CommentExtra> {
  static const _pageSize = 12;
 //Api api = Api();
   final PagingController<int, Comment> _pagingController =
      PagingController(firstPageKey: 1);
      //final invisibleItemsThreshold = 2;
 

@override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.noItemsFound) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("No more contents"),
          action: SnackBarAction(label: 'Retry',
          onPressed: () => _pagingController.retryLastFailedRequest(),
          ),
          ),
        );
      }
    });
    super.initState();
  }
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await Api.getAllComment(pageKey, _pageSize, widget.bookId as int);
      // print(newItems);
     // final isLastPage = newItems.length < _pageSize;
     final previouslyFetchedItemsCount =
          _pagingController.itemList?.length ?? 0;
       final totalFetched = newPage.length + previouslyFetchedItemsCount ;
      final isLastPage = totalFetched < _pageSize;
      final newItems = newPage;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      print(error);
      _pagingController.error = error;
    }
  }
   @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
             centerTitle: true,
            title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text("Viewing Comments..."),
            ),),
  body:   RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: PagedListView<int, Comment> (
        
          pagingController: _pagingController,
          //shrinkWrap: true,
          
          builderDelegate: PagedChildBuilderDelegate<Comment>(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 1000),
            itemBuilder: (context, commentfeed, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
         child:     CommentLIstItem(
              img: commentfeed.users_picture?.replaceFirst("../../", Constants.baseHttp) ?? Constants.dummyProfilePic,
              userHandle: commentfeed.users_username ?? "",
              text: commentfeed.coment_content ?? "",
              datePosted: getTimeDifferenceFRomNow(DateTime.parse(commentfeed.coment_date as String)),
            )),
            noItemsFoundIndicatorBuilder: (context) => NotifyText(
              subTitle: "Empty Box",
              title: "Nothing to show!",
            ),
            /*
            firstPageErrorIndicatorBuilder: (context) => NoConnectionIndicator(
              error: _pagingController.error,
              onTryAgain: () => _pagingController.refresh(),
            ),
            
           firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _pagingController.error,
              onTryAgain: () => _pagingController.refresh(),
            ),
            
            newPageErrorIndicatorBuilder: (context) => ErrorIndicator(
              error: _pagingController.error,
             onTryAgain: () => _pagingController.retryLastFailedRequest(),
            ),
            */
           /* newPageProgressIndicatorBuilder: (context) => LoadingWidget(),
            firstPageErrorIndicatorBuilder: (context) => Text('${_pagingController.error}'), */
             
            //noMoreItemsIndicatorBuilder: (context) => SnackBar(content: const Text('for now, no more items; try again in a moment'))
          ),
      /*    padding: const EdgeInsets.all(16), */
          
        ),
      ));


}
String getTimeDifferenceFRomNow(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if(difference.inSeconds < 5) {
      return "Just now";
    } else if(difference.inMinutes < 1) {
      return "${difference.inSeconds}s ago";
    } else if(difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if(difference.inDays < 1) {
      return "${difference.inHours}h ago";
    } else if(difference.inDays < 7) {
    return "${difference.inDays}d ago";
  } else if(difference.inDays < 28 || difference.inDays < 29 || difference.inDays < 30 || difference.inDays < 31) {
    return "${(difference.inDays / 7).round()}w ago";
  } else if(difference.inDays < 365 || difference.inDays < 366) {
     return "${(difference.inDays / 30.44).round()}m ago";
  } else if(difference.inDays < 367) {
    return "${(difference.inDays / 365.25).floor()}y ago";
  }
 return "${dateTime.year.toString()} - ${dateTime.month.toString().padLeft(2, '0')} - ${dateTime.day.toString().padLeft(2, '0')}";
  }

}