import 'package:racfmn/model/search_model.dart';

class SearchListingState {
  SearchListingState({
    this.itemList,
    this.error,
    this.nextPageKey = 1,
  });

  final List<Search>? itemList;
  final dynamic error;
  final int? nextPageKey;
}
