import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/helper/api.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/ui/page/hometabs/book_grid_item.dart';

class JournalTab extends StatefulWidget {
 // PaperTab({Key? key}) : super(key: key);
 @override
 _JournalTabState createState() => _JournalTabState();

}
class _JournalTabState extends State<JournalTab> {
static const _pageSize = 9;
static const postsType = "Journals";
 //Api api = Api();
   final PagingController<int, TestFeed> _pagingController =
      PagingController(firstPageKey: 1);
      //final invisibleItemsThreshold = 2;


@override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
   /* _pagingController.addStatusListener((status) {
      if (status == PagingStatus.noItemsFound) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("No more contents"),
          action: SnackBarAction(label: 'Retry',
          onPressed: () => _pagingController.retryLastFailedRequest(),
          ),
          ),
        );
      }
    }); */
    super.initState();
  }
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newPage = await Api.getalldata(pageKey, _pageSize,postsType);
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
  Widget build(BuildContext context) => RefreshIndicator(
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
               mainNavigation: "notOrder",
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
            'No items found',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
            /* newPageErrorIndicatorBuilder: (_) => Text("No data found....", style: TextStyle(color: Colors.transparent)),
             
            
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

  