import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/components/book.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/components/book_list_item.dart';
import 'package:racfmn/helper/api.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/state/home_provider.dart';
import 'package:racfmn/ui/page/details/details.dart';
import 'package:racfmn/ui/page/common/locator.dart';
import 'package:racfmn/ui/page/hometabs/book_grid_item.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';


class OrdersPage extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<OrdersPage> {
 static const _pageSize = 9;
  String? userId;
 //Api api = Api();
   final PagingController<int, TestFeed> _pagingController =
      PagingController(firstPageKey: 1); 

@override
  void initState() {
 var state = Provider.of<AuthState>(context, listen: false).userModel;
  userId = state.userId.toString();
 _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
   
  }
 _lauchUrl(url) async {
   // const url = Constants.baseHttp + "pricing";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
 Future<Map<String, Object>?> getCurrentUser() async {
     var userPreference = await getIt<SharedPreferenceHelper>().getUser();
     var userId = userPreference.userId.toString();
     var userName = userPreference.userName.toString();

     return {"userName": userName, "userId": userId};

  }
Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await Api.getUserOrders(pageKey, _pageSize,userId);
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

  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Books ordered',
            ),
          ),
          body:  _buildOrders(context)
        );
      
    
  }
  _buildOrders(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: Center (
           child: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: NetworkImage(Constants.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),

       child: PagedGridView<int, TestFeed> (
         showNewPageErrorIndicatorAsGridChild: false,
         showNewPageProgressIndicatorAsGridChild: false,
         showNoMoreItemsIndicatorAsGridChild: false,
          pagingController: _pagingController,
                  
          //shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
                    childAspectRatio: 100 / 150,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
            ),
          builderDelegate: PagedChildBuilderDelegate<TestFeed>(
            animateTransitions: true,
            transitionDuration: const Duration(milliseconds: 1000),
            itemBuilder: (context, testfeed, index) => BookGridtItem(
              testfeed: testfeed,
               mainNavigation: "Order",
            ),
             noItemsFoundIndicatorBuilder: (context) => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty-box.png',
            height: 30.0,
            width: 30.0,
          ),
          Text(
            'You have not orderd any items',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          CustomFlatButton(
          label: "Click to order now",
          onPressed: () { Navigator.pop(context);
        String url = Constants.baseHttp;
      _lauchUrl(url);}) 
        ],
      ),
    ),
            /*: (contect) => Center(child: Text("No more item found")),
             newPageErrorIndicatorBuilder: (_) => Text("No data found....", style: TextStyle(color: Colors.transparent)),
             
            
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
      )));



 
  
   
  
}
}
