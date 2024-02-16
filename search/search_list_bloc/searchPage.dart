import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:racfmn/model/search_model.dart';

import 'character_list_item.dart';
import 'character_search_input_sliver.dart';
import 'character_sliver_grid_bloc.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final CharacterSliverGridBloc _bloc = CharacterSliverGridBloc();
  final PagingController<int, Search> _pagingController =
      PagingController(firstPageKey: 1);
  late StreamSubscription _blocListingStateSubscription;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _bloc.onPageRequestSink.add(pageKey);
    });

    // We could've used StreamBuilder, but that would unnecessarily recreate
    // the entire [PagedSliverGrid] every time the state changes.
    // Instead, handling the subscription ourselves and updating only the
    // _pagingController is more efficient.
    _blocListingStateSubscription =
        _bloc.onNewListingState.listen((listingState) {
      _pagingController.value = PagingState(
        nextPageKey: listingState.nextPageKey,
        error: listingState.error,
        itemList: listingState.itemList,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: CharacterSearchInputSliver(
            onChanged: (searchTerm) => _bloc.onSearchInputChangedSink.add(
              searchTerm,
            ),
          ),
  body:   CustomScrollView(
        slivers: <Widget>[
          
          PagedSliverList<int, Search>(
            pagingController: _pagingController,
           
             
            
            builderDelegate: PagedChildBuilderDelegate<Search>(
              itemBuilder: (context, item, index) => SearchListItem(
                searchData: item,
              ),
            ),
          ),
        ],
      ),
    );

 
}
 @override
  void dispose() {
    _pagingController.dispose();
    _blocListingStateSubscription.cancel();
    _bloc.dispose();
    super.dispose();
  }
}