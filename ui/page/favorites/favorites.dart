import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/components/book_list_item.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/state/favorites_provider.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    getFavorites();
  }

  @override
  void deactivate() {
    super.deactivate();
    getFavorites();
  }

  getFavorites() {
    SchedulerBinding.instance!.addPostFrameCallback(
      (_) {
        if (mounted) {
          Provider.of<FavoritesProvider>(context, listen: false).getFavorites();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<FavoritesProvider>(
      builder: (BuildContext context, FavoritesProvider favoritesProvider,
          child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Favorites',
            ),
          ),
          body: _checkIfFavorite(favoritesProvider)
        );
      },
    );
  }
  _checkIfFavorite(FavoritesProvider favoritesProvider) {
    if(favoritesProvider.loading == true) {
      return Center(child: CircularProgressIndicator());
    } else if(favoritesProvider.loading == false && favoritesProvider.books.isEmpty) {
  return _buildEmptyListView();

    }
    return _buildListView(favoritesProvider );
  }
 
}

  _buildEmptyListView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty-box.png',
            height: 30.0,
            width: 30.0,
          ),
          Text(
            'Your favourite books will appear here',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildListView(FavoritesProvider favoritesProvider) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      shrinkWrap: true,
      itemCount: favoritesProvider.books.length,
     /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 200 / 340,
      ), */
      itemBuilder: (BuildContext context, int index) {
      //  Entry entry = Entry.fromJson(favoritesProvider.posts[index]['item']);
      List<TestFeed> authorsRelated = favoritesProvider.books;
      final item = authorsRelated[index];
      final title = item.posts_title ?? "";
      final postsId = item.posts_id;
      print("this is item ${item.posts_content}");
       return Dismissible(
         key: Key(item.toString()),
         onDismissed: (direction) {
           /*favoritesProvider.removeFav(postsId as int);
           authorsRelated.removeAt(index);
           */
           
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title dismissed')));
         },
         confirmDismiss: (DismissDirection direction) async {
          return await showDialog(context: context, 
          builder: (BuildContext context) {
              return AlertDialog(title: Text("Confirm delete?"),
               content: Text("Are you sure you want to delete this item?"),
               actions: <Widget>[
                IconButton(onPressed: () {

                 favoritesProvider.removeFav(postsId as int);
           authorsRelated.removeAt(index);
              Navigator.of(context).pop(true);
                },color: Colors.red, 
                icon: Icon(Icons.delete_forever_rounded)
              ),
              IconButton(onPressed: () {
              Navigator.of(context).pop(false);
                }, icon: Icon(Icons.cancel_presentation_rounded
              ))
              ]
              );
          });
         },
         background: Container(color: Colors.red),
         child: Padding(           
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: BookListItem(
              img: item.posts_links_url?.replaceFirst("../../", Constants.baseHttp),
              title: title,
              author: item.posts_author ?? "",
              desc: item.posts_content.toString().replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), "").length > 30 ? "${item.posts_content?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), "").substring(0,30)}..." : item.posts_content?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ""),
              postsId: postsId,
              content: item.posts_fullcontent,
              postsCourseId: item.posts_course_id,
              
            ),
          ));
      },
    );
  }

