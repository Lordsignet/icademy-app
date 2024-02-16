import 'package:flutter/foundation.dart';
import 'package:racfmn/helper/databaseFile.dart';
import 'package:racfmn/helper/favorite_helper.dart';
import 'package:racfmn/model/category.dart';

class FavoritesProvider extends ChangeNotifier {
  List<TestFeed> _books = [];
  List<TestFeed> get books => _books;
  bool loading = false;
final favourite = FavouriteMethod();

  getFavorites() async {
    setLoading(true);
    books.clear();
    List all = await favourite.getAllBooks();
    //books.addAll(all);
    setbooks(all);
    setLoading(false);
  }
  removeFav(int id) async {
   final v = favourite.delete(id).then((value) {
      print(value);
  
  });}

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  void setbooks(value) {
    _books = value;
    notifyListeners();
  }

  List getbooks() {
    return books;
  }
}
