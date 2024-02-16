import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:racfmn/helper/api.dart';
import 'package:racfmn/model/search_model.dart';
import 'package:racfmn/widgets/custom_widgets.dart';

import 'search_list_bloc/search_list_item.dart';
import 'search_list_bloc/character_search_input_sliver.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _pageSize = 5;
 bool isSearching = false;
//final TextEditingController? _textController = TextEditingController();

  final PagingController<int, Search> _pagingController =
      PagingController(firstPageKey: 0);

  String? _searchTerm;
  final TextEditingController _textController = TextEditingController();
  @override
  void initState() {
    
    _pagingController.addPageRequestListener((pageKey) {
    if(_pagingController.value.status == PagingStatus.loadingFirstPage && pageKey == 0) {
     _fetchFirst(pageKey);    
       
     }
     
  _fetchSearchPage(pageKey);
    });
   /* 
    _pagingController.addStatusListener((status) {
      if (status == PagingStatus.subsequentPageError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Something went wrong while fetching a new page.',
            ),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () => _pagingController.retryLastFailedRequest(),
            ),
          ),
        );
      }
    });
  */  
isSearching = _textController.text.isEmpty;
  _textController.addListener(() {
    if(isSearching != _textController.text.isEmpty) {
      setState(() => {
        isSearching = _textController.text.isEmpty
      });
    }
  });
    super.initState();
  }
Future<void> _fetchFirst(pageKey) async {
  final List<Search>firstItems = [];
  final previouslyFetchedItemsCount =
        _pagingController.itemList?.length ?? 0;
     
      final nextPageKey = pageKey + 1;
     // final isLastPage = newItems.length < _pageSize;
      _pagingController.appendPage(firstItems, nextPageKey);
}
  Future<void> _fetchSearchPage(pageKey) async {
    print("this is te page key before if statement ${pageKey}");
   if(pageKey == 0) {
      final List<Search>firstItems = [];
 final nextPageKey = pageKey + 1;
  //print("${pageKey} ${_pageSize} ${_textController.text}");
  _pagingController.appendPage(firstItems, nextPageKey);
  _pagingController.error = "Initial error";
    } else {
    
    getOtherSearch(pageKey); 
    }
  }
  Future<void> getOtherSearch(pageKey) async {
    print("${pageKey} ${_pageSize} ${_textController.text}");
try {
      final newItems = await Api.getSerachResult(
        pageKey,
        _pageSize,
        _textController.text
      );
      print(newItems);
       final previouslyFetchedItemsCount =
        _pagingController.itemList?.length ?? 0;
       final totalFetched = newItems.length + previouslyFetchedItemsCount ;
      final isLastPage = totalFetched < _pageSize;
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
 void _toggle() {
    setState(() {
  _textController.clear();   
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: CharacterSearchInputSliver(
         //  onChanged: (searchTerm) => _updateSearchTerm(searchTerm),
         onFieldSubmit: (searchTerm) =>  _updateSearchTerm(searchTerm),
          //print("search went");
         
         controllers: _textController,
         suffixIcon: _textController.text.isNotEmpty  ? IconButton(icon: const Icon(Icons.clear), onPressed: () => _toggle()) : null, 
          ),
  body:   CustomScrollView(
  
        
    slivers: <Widget> [
            PagedSliverList<int, Search>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Search>(
              animateTransitions: true,
              itemBuilder: (context, item, index) {
                if(_pagingController.value.status == PagingStatus.ongoing) {
                return  Container(
              height: 50,
              alignment: Alignment.center,
             child: CircularProgressIndicator(color: Colors.blueAccent));
                }
                return SearchListItem(
                searchData: item,
              );},
             noItemsFoundIndicatorBuilder: (_) {
               if(_pagingController.error.toString().contains("Initial")) {
              return Text("Searching....", style: TextStyle(color: Colors.transparent)); 
               
             }
             return Column(
               children: <Widget>[
                 SizedBox(height: 50),

             Text("Search Result", style: TextStyle(color: Colors.black, fontSize: 30,fontWeight: FontWeight.bold, height: 1.0)),
             SizedBox(height: 20),
             Icon(Icons.emoji_emotions, size: 50, color: Colors.orangeAccent),
             SizedBox(height: 20),
             Text("No data found for your search.", style: TextStyle(color: Colors.black, fontSize: 16,fontWeight: FontWeight.normal)),
               ]
             );

               },
            newPageErrorIndicatorBuilder: (_) => Text("No data found....", style: TextStyle(color: Colors.white)),
            newPageProgressIndicatorBuilder: (_) => Container(
              height: 50,
              alignment: Alignment.center,
             child: CircularProgressIndicator(color: Colors.blueAccent)),
           // transitionDuration: const Duration(seconds: 5),
            
            transitionDuration: const Duration(milliseconds: 1000),
            )
            )
            ]
            )
            );
          
        
      
    
  }
  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    print(_pagingController.nextPageKey);
   _pagingController.refresh();
   
   getOtherSearch(_pagingController.nextPageKey);
   
   
   print("final pagekey is ${_pagingController.nextPageKey}");
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
