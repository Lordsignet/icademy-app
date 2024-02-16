import 'package:flutter/foundation.dart';
import 'package:racfmn/helper/notification_helper.dart';
import 'package:racfmn/model/push_notification_model.dart';

class NotificationProvider extends ChangeNotifier {
 List<PushNotificationModel> _books = [];
 List<PushNotificationModel> get books => _books;
 bool loading = false;
final notification = NotificationMethod();
String isRead = "false";
changeRead(value) {
isRead = value;
notifyListeners();
}
updateBook(String bookId, Map<String, Object> map) async {

  try {
    await notification.updateRead(bookId, map);
/* if(data.isEmpty) {
return;
  }
  */
  //changeRead("true");
  } catch(e) {
    print("catch was called");
   print(e);
  }
  
}

  getFavorites() async {
    setLoading(true);
    books.clear();
    List all = await notification.getAllBooks();
    //books.addAll(all);
    setbooks(all);
    setLoading(false);
  }
  removeFav(String id) async {
   final v = notification.delete(id).then((value) {
      print("$value was successfully removed");
  
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
