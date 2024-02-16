import 'package:racfmn/helper/databaseFile.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/model/push_notification_model.dart';
import 'package:sembast/sembast.dart';

class NotificationMethod {
   static const String folderName = "Notification";
  final _booksFolder = intMapStoreFactory.store(folderName);
  //Insertion
  Future<Database> get  _db  async => await AppDatabase.instance.database;

  Future insertBooks(PushNotificationModel booked) async{

    await  _booksFolder.add(await _db, booked.toJson() );
    final recordSnapshot = await _booksFolder.find(await _db);
    final data =  recordSnapshot.map((snapshot){
      final books = PushNotificationModel.fromJson(snapshot.value);
      print(books);
      return books;
    }).toList();
   // print(books);

  }

 Future checkMapBooks(Map<String, Object?> map) async{
   final filter = Filter.and(map.entries.map((e) => Filter.equals(e.key, e.value)).toList());
    final finder = Finder(filter: filter);
    final val = await _booksFolder.find(await _db, finder: finder);
    return val;

  }
  Future checkBooks(String value) async{
    final filter = Filter.equals("bookId", value);
    final val = await _booksFolder.find(await _db, finder: Finder(filter: filter));
    return val;
  }

Future updateRead(String bookId, Map<String, Object> map) async{
  List checkResult = await checkBooks(bookId);
  String? isRead;
  checkResult.forEach((element) {
isRead = element["isRead"];
   });
   print("isRead value is => $isRead");
  if(isRead == "true") {
   // isRead = "true";
    return;
  }
   final filter = Filter.equals("bookId", bookId);
   final finder = Finder(filter:filter);
final updateValue = await _booksFolder.update(await _db, map, finder: finder);
//return updateValue;
 final returnedResult = await checkBooks(bookId);
 return  returnedResult;
}
  Future delete(String bookId) async{
    final finder = Finder(filter: Filter.equals('bookId', bookId));
    await _booksFolder.delete(await _db, finder: finder);
  }
Future<List<PushNotificationModel>> getAllBooksNotRead() async{
     final filter = Filter.equals("isRead", "false");
     final finder = Finder(filter: filter);
    final recordSnapshot = await _booksFolder.find(await _db, finder: finder);
    return recordSnapshot.map((snapshot){
      final books = PushNotificationModel.fromJson(snapshot.value);
      return books;
    }).toList();
  }
  Future<int> stimulatValue() async {
    final value = 3;
    return value;
  }
  Future<List<PushNotificationModel>> getAllBooks() async{
    final recordSnapshot = await _booksFolder.find(await _db);
    return recordSnapshot.map((snapshot){
      final books = PushNotificationModel.fromJson(snapshot.value);
      return books;
    }).toList();
  }
}
