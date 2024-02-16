import 'package:racfmn/helper/databaseFile.dart';
import 'package:racfmn/model/category.dart';
import 'package:sembast/sembast.dart';

class FavouriteMethod {
   static const String folderName = "Books";
  final _booksFolder = intMapStoreFactory.store(folderName);
  //Insertion
  Future<Database> get  _db  async => await AppDatabase.instance.database;

  Future insertBooks(Map<String, Object> booked) async{

    await  _booksFolder.add(await _db, booked );
    final recordSnapshot = await _booksFolder.find(await _db);
    print("books added to favourite are => $booked");
    final data =  recordSnapshot.map((snapshot){
      final books = TestFeed.fromJson(snapshot.value);
      print(books);
      return books;
    }).toList();
   // print(books);

  }

 Future checkBooks(int value) async{
    final finder = Finder(filter: Filter.equals('posts_id', value));
    final val = await _booksFolder.find(await _db, finder: finder);
    return val;

  }


  Future delete(int bookId) async{
    final finder = Finder(filter: Filter.equals('posts_id', bookId));
    await _booksFolder.delete(await _db, finder: finder);
  }

  Future<List<TestFeed>> getAllBooks()async{
    final recordSnapshot = await _booksFolder.find(await _db);
    return recordSnapshot.map((snapshot){
      final books = TestFeed.fromJson(snapshot.value);
      return books;
    }).toList();
  }
}
