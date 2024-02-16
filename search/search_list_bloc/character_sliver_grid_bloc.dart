import 'dart:async';
import 'package:racfmn/helper/api.dart';
import 'package:rxdart/rxdart.dart';

import 'character_sliver_grid_states.dart';

class CharacterSliverGridBloc {
  CharacterSliverGridBloc() {
    _onPageRequest.stream
        .flatMap(_fetchCharacterSummaryList)
        .listen(_onNewListingStateController.add)
        .addTo(_subscriptions);

    _onSearchInputChangedSubject.stream
        .flatMap((_) => _resetSearch())
        .listen(_onNewListingStateController.add)
        .addTo(_subscriptions);
  }

  static const _pageSize = 20;

  final _subscriptions = CompositeSubscription();

  final _onNewListingStateController =
      BehaviorSubject<SearchListingState>.seeded(
    SearchListingState(),
  );

  Stream<SearchListingState> get onNewListingState =>
      _onNewListingStateController.stream;

  final _onPageRequest = StreamController<int>();

  Sink<int> get onPageRequestSink => _onPageRequest.sink;

  final _onSearchInputChangedSubject = BehaviorSubject<String?>.seeded(null);

  Sink<String?> get onSearchInputChangedSink =>
      _onSearchInputChangedSubject.sink;

  String? get _searchInputValue => _onSearchInputChangedSubject.value;

  Stream<SearchListingState> _resetSearch() async* {
    yield SearchListingState();
    yield* _fetchCharacterSummaryList(0);
  }

  Stream<SearchListingState> _fetchCharacterSummaryList(int pageKey) async* {
    final lastListingState = _onNewListingStateController.value;
    if(pageKey == 1) return;
    try {
      final newItems = await Api.getSerachResult(
        pageKey,
        _pageSize,
        _searchInputValue,
      );
       final previouslyFetchedItemsCount =
        lastListingState.itemList?.length ?? 0;
       final totalFetched = newItems.length + previouslyFetchedItemsCount ;
      final isLastPage = totalFetched < _pageSize;
      //final newItems = newPage;
      //final isLastPage = newItems.length < _pageSize;
      //final nextPageKey = isLastPage ? null : pageKey + newItems.length;
      final nextPageKey = isLastPage ? null : pageKey + 1;
      yield SearchListingState(
        error: null,
        nextPageKey: nextPageKey as int,
        itemList: [...lastListingState.itemList ?? [], ...newItems],
      );
    } catch (e) {
      yield SearchListingState(
        error: e,
        nextPageKey: lastListingState.nextPageKey,
        itemList: lastListingState.itemList,
      );
    }
  }

  void dispose() {
    _onSearchInputChangedSubject.close();
    _onNewListingStateController.close();
    _subscriptions.dispose();
    _onPageRequest.close();
  }
}
