import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:racfmn/components/book_card.dart';
import 'package:racfmn/components/book_list_item.dart';
import 'package:racfmn/components/comment_list_item.dart';
import 'package:racfmn/components/description_text.dart';
import 'package:racfmn/components/loading_widget.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/custom_route.dart';
import 'package:racfmn/state/comment_provider.dart';
import 'package:racfmn/ui/page/comments/comment.dart';
import 'package:racfmn/ui/page/readbooks/readPdfFile.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/state/details_provider.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;


class Details extends StatefulWidget {
  final int? bookId;
  final String? imageName;
  final String? description;
  final String? authorName;
  final String? fullContent;
  //final String? imgTag;
  final String? bookName;
  final int? book_course_id;
  final String? userId;
  final int? ratingNumber;
  //final String? authorTag;

  Details({
    Key? key, this.bookId, this.bookName, this.imageName, this.description,this.authorName,this.book_course_id,this.fullContent,this.userId,this.ratingNumber
  }) : super(key: key);

  static Route<Null> getRoute(int? bookId, String? bookName, String? imageName, String? description, String? authorName, int? book_course_id,String? fullContent,String userId, int ratingNumber) {
    return SlideLeftRoute<Null>(
            builder: (BuildContext context) => Details(
        bookId: bookId,
        bookName: bookName,
        imageName: imageName,
        description: description,
        authorName: authorName,
        book_course_id: book_course_id,
        fullContent: fullContent,
        userId: userId,
        ratingNumber: ratingNumber,
      ),
    );
  }

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  static final uuid = Uuid();
  final String imgTag = uuid.v4();
  final String titleTag = uuid.v4();
  final String authorTag = uuid.v4();
  late double _rating;
  double _initialRating = 0.0;
 late double _userRating;
 late dynamic _ratingId;
 List<Comment> list = [];
 List<String> imagePaths = [];
 final formKey = new GlobalKey<FormState>();
 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController commentController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
     //_rating = _initialRating;
    SchedulerBinding.instance!.addPostFrameCallback(
      (_) {
        imagePaths.add('${widget.imageName?.replaceAll("../../", Constants.baseHttp)}');
        Timer(Duration(seconds: 3), () {
        //print("I hate you");
       
       /* Provider.of<DetailsProvider>(context, listen: false)
            .setEntry(widget.bookId);  */

             Provider.of<DetailsProvider>(context, listen: false)
            .getCategory(widget.bookId.toString(),widget.book_course_id.toString(),widget.authorName);
            Provider.of<DetailsProvider>(context, listen: false)
            .getAuthorsOthersBook(widget.bookId.toString(),widget.book_course_id.toString(),widget.authorName);
           Provider.of<DetailsProvider>(context, listen: false).getsubmitRating(widget.bookId.toString(),widget.userId,widget.ratingNumber);
        Provider.of<CommentProvider>(context, listen: false).getComments(widget.bookId);
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
   /* return Consumer<DetailsProvider>(
      builder: (BuildContext context, DetailsProvider detailsProvider,
          child) { */
          DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context, listen: false);
        return Scaffold(
          appBar: AppBar(
             centerTitle: true,
            title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(widget.bookName as String),
            ),
            actions: <Widget>[
             Selector<DetailsProvider, bool>(
                 selector: (_, model ) => model.faved,
                builder: (context, value, child) =>
              IconButton(
                onPressed: () async {
                  if (detailsProvider.faved) {
                    detailsProvider.removeFav(widget.bookId as int);
                  } else {
                    detailsProvider.addFav(widget.bookId as int, widget.bookName as String, widget.imageName as String, widget.authorName as String, widget.book_course_id as int, widget.description as String, widget.fullContent as String);
                  }
                },
                icon: Icon(
                  value == true ? Icons.favorite : AppIcon.heartEmpty,
                  color: value == true
                      ? Colors.red
                      : Theme.of(context).iconTheme.color,
                ),
              ),
             
              ),
              IconButton(
                onPressed: () => _share(),
                icon: Icon(
                Icons.share_sharp,
                ),
              ),
            ],
          ),
          resizeToAvoidBottomInset: true,
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            controller: _controller,
            children: <Widget>[
              SizedBox(height: 10.0),
              //Text("Hello"),
              _buildImageTitleSection(detailsProvider),
              SizedBox(height: 30.0),
              _buildSectionTitle('Book Description'),
            //  _buildDivider(),
              SizedBox(height: 10.0),
              DescriptionTextWidget(
               // text: '${widget.description?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), "")}',
               text: '${widget.description ?? ""}'
              ),
              SizedBox(height: 30.0),
              _buildSectionTitle('Related Books'),
             // _buildDivider(),
              SizedBox(height: 10.0),
              _buildCategory(detailsProvider),
              SizedBox(height: 30.0),
               _buildSectionTitle('More books from the Author'),
              //_buildDivider(),
              SizedBox(height: 10.0),
              _buildMoreBook(detailsProvider),
              SizedBox(height: 40.0),
              _buildCommentSectionTitle('Comments'),
                 SizedBox(height: 20.0),
              _buildComment(Provider.of<CommentProvider>(context, listen: false)),
            //   _buildComment(detailsProvider),
            
            //  SizedBox(height: 10.0),
           //   _showLoadMoreComment(list)
             //  _buildCommentChild(detailsProvider)

          
            ],
          ),
          floatingActionButton: _buildFloatingACtionButtons(Theme.of(context).accentColor),
        );
      //},
    //);
  }

  _buildDivider() {
    return Divider(
      color: Theme.of(context).primaryColor,
    );
  }
_showLoadMoreComment(List<Comment> data) {
  if(data.length == 5) return Text("Hello");
}
  _buildComment(CommentProvider commentProvider) {
return Selector<CommentProvider, List<Comment>>(
  selector: (_,commentModel) => commentModel.commentData,
   shouldRebuild: (List<Comment>prev, List<Comment>next) => true,
  builder: (context, commentValue, child) {
    if(commentProvider.loading) {

      return Container(
        child: loader(),
        height: 20
      );
    } else if(commentProvider.loading == false && commentValue == null || commentProvider.loading == false && commentValue.length == 0) {
return Container(
  margin: EdgeInsets.only(left: 20.0),
  child: Text("Be the first to comment",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
  height: 20
);



    }

    _showLoadMoreComment(List<Comment> data) {

      if(data.length == 5) {

        return Text("Hello");
      }
    }
   list  = commentValue;
    var commentBuild;
    if(list.length == 1) {
      commentBuild = 1;
    } else if(list.length == 2) {
      commentBuild = 2;
    } else if(list.length == 3) {
      commentBuild = 3;
    } else if(list.length == 4) {
      commentBuild = 4;
    } else {
      commentBuild = 5;
    }
     return ListView.builder(
       scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: commentBuild,
        itemBuilder: (BuildContext context, int index) {
            
            return Column(
               children: <Widget>[
                 
                 
     Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: CommentLIstItem(
              img: commentValue[index].users_picture?.replaceFirst("../../", Constants.baseHttp) ?? Constants.dummyProfilePic,
              userHandle: commentValue[index].users_username ?? "",
              text: commentValue[index].coment_content ?? "",
              datePosted: getTimeDifferenceFRomNow(DateTime.parse(commentValue[index].coment_date as String)),
              // loadmore: Text("Hello"),
            )
            ),
          SizedBox(height: 20),
            if(index == 4) InkWell(child: Text("Load more comments....", style: TextStyle(color: Colors.blueAccent,fontSize: 18)), onTap: () { Navigator.push(context, 
                                  CommentExtra.getRoute(widget.bookId),
                                  );}),
                     
            ]);
      
  
});

});
  }
  String getTimeDifferenceFRomNow(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if(difference.inSeconds < 5) {
      return "Just now";
    } else if(difference.inMinutes < 1) {
      return "${difference.inSeconds}s ago";
    } else if(difference.inHours < 1) {
      return "${difference.inMinutes}m ago";
    } else if(difference.inDays < 1) {
      return "${difference.inHours}h ago";
    } else if(difference.inDays < 7) {
    return "${difference.inDays}d ago";
  } else if(difference.inDays < 28 || difference.inDays < 29 || difference.inDays < 30 || difference.inDays < 31) {
    return "${(difference.inDays / 7).round()}w ago";
  } else if(difference.inDays < 365 || difference.inDays < 366) {
     return "${(difference.inDays / 30.44).round()}m ago";
  } else if(difference.inDays < 367) {
    return "${(difference.inDays / 365.25).floor()}y ago";
  }
 return "${dateTime.year.toString()} - ${dateTime.month.toString().padLeft(2, '0')} - ${dateTime.day.toString().padLeft(2, '0')}";
  }

  _buildCommentChild(DetailsProvider commentProvider) {
  return  CommentBox(
          userImage:
              Constants.dummyProfilePic,
        //  child:  _buildComment(commentProvider),
        //     child: Text("Hello"),
          labelText: 'Write a comment...',
          focusNode: _focusNode,
          withBorder: false,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        );

  }
_buildFloatingACtionButtons(Color color) {

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    
  children: [
    FloatingActionButton(
      backgroundColor: color,
      child: Icon(Icons.comment, size: 25,),

      onPressed: () {
        _commentopenDialog();
      
      },
      heroTag: Text("Btn1"),),
    SizedBox(
    height: 30,
    ),

    FloatingActionButton(
      backgroundColor: color,
      child: Icon(AppIcon.searchFill, size: 25,),
      onPressed: () {
         Navigator.pushNamed(context, '/SearchPage');
      },
      heroTag: Text("Btn2"),
      ),  
      SizedBox(
        height: 80
      )

  ]
  );
}

  _buildImageTitleSection(DetailsProvider detailsProvider) {
    //DetailsProvider detailsProvider = Provider.of<DetailsProvider>(context, listen: false);
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: '${widget.bookId.toString()}',
            child: CachedNetworkImage(
              imageUrl: '${widget.imageName!.replaceFirst("../../", Constants.baseHttp)}',
              placeholder: (context, url) => Container(
                height: 200.0,
                width: 130.0,
                child: LoadingWidget(),
              ),
              errorWidget: (context, url, error) => Icon(AppIcon.bulbOn),
              fit: BoxFit.cover,
              height: 200.0,
              width: 130.0,
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0),
           //     Hero(
             //     tag: '${widget.bookId.toString()}',
                  Material(
                    type: MaterialType.transparency,
                    child: 
                    FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                      '${widget.bookName}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                    ),
                    ),
            ),
                
                 // ),
               // ),
                SizedBox(height: 5.0),
               // Hero(
               //   tag: '${widget.bookId.toString()}',
                  Material(
                    type: MaterialType.transparency,
                    
                    child: FittedBox(
              fit: BoxFit.fitWidth,
              child:Text(
                      '${widget.authorName ?? ""}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ),
                
                SizedBox(height: 10.0),
              //  _buildCategory(detailsProvider),
                 Center (
                   child: Container(
                   height: 50.0,
                   width: MediaQuery.of(context).size.width,
                   child: Row(
                     children: <Widget>[
                      _ratingIndicator(detailsProvider),
                    
                     ]
                   ),
                   ),),
                   SizedBox(height: 10.0),
                Center(
                  child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width,
                   // width: 110.0,
                   
                   child: Row(
                     children: <Widget>[
                       Expanded(
                      child: _buildDownloadReadButton(Theme.of(context).primaryColor, widget.fullContent as String),
                       ),
                       SizedBox(
                         width: 10
                       ),
                       Expanded(
                         child: _buildRating(context,detailsProvider, Theme.of(context).primaryColor),
                       )
                     ]
                   )
                    
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildSectionTitle(String title) {
    return Text(
      '$title',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  _buildCommentSectionTitle(String title) {
    return Text(
      '$title',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  _ratingIndicator(DetailsProvider ratingprovider) {
    
    return Selector<DetailsProvider, List<Rating>>(
      selector: (_, ratingMOdel) => ratingMOdel.ratingData,
      shouldRebuild: (List<Rating>previous, List<Rating>next) => true,
      builder: (context, ratingValue, child) {
//List<Rating> ratingData = ratingprovider.ratingData;
if(ratingprovider.loading) {
  return Container(
    padding: EdgeInsets.only(left: 20),
    height: 20,
    width: 40,
    child: Center(child: CircularProgressIndicator()),
  );

} else if(ratingprovider.loading == false && ratingValue == null || ratingprovider.loading == false && ratingValue.length == 0) {
 _userRating = 0.0;
  _rating =  _userRating;



return Column(
  children: <Widget>[
RatingBarIndicator(
                    rating: _userRating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      size: 3.0,
                      color: Colors.amber.withOpacity(0),
                    ),
                    itemCount: 5,
                    itemSize: 30,
                    unratedColor: Colors.amber.withAlpha(50),
                    direction: Axis.horizontal,
                  ),
            /*       Expanded(
                   child:  customText('${"No rating yet" }', ),) */
  ]);


}
int totalStars = 5;
 int rating_counts = ratingValue.length > 0 ? ratingValue[0].rating_count as int: 0;
dynamic rating_average = ratingValue.length > 0 ? ratingValue[0].rating_average : 0;
dynamic ratingIdValue = ratingValue.length > 0 ? ratingValue[0].rating_id : "";
  _userRating = (double.tryParse(rating_average.toString()) as double);
  _rating =  _userRating;
  _ratingId = ratingIdValue;
  final tofixedString = _userRating.toStringAsFixed(1);
String ratIng = "Rating";
   return Column(
    children: <Widget>[  
   RatingBarIndicator(
                    rating: _userRating,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      size: 3.0,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 30,
                    unratedColor: Colors.amber.withOpacity(0.1),
                    direction: Axis.horizontal,
                  ),
                  SizedBox(
                    height: 5
                  ),
                 Expanded(
                   child: FittedBox(  
                child:   Text('${rating_counts > 0 ?  'Rating: $tofixedString''/ ${totalStars} out of '  '${rating_counts} user(s)' : "No rating yet" }', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,height: 1)
                   ),fit: BoxFit.fitWidth)
                ),
    SizedBox(
      height: 5,
    ),
    ]
    );
    });
    }
    Widget _ratingBar() {
    
          return RatingBar.builder(
          initialRating: _initialRating,
          direction: Axis.horizontal,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
          //  setState(() {
              _rating = rating;
              print('I was throughly called in onRatingUpdate ${_rating}');
          //  });
          
          },
          
          updateOnDrag: true,
        );
    }
  _buildMoreBook(DetailsProvider provider) {
   //  print('value ---> of' + json.encode(provider.authorsrelated));
   return Selector<DetailsProvider, List<TestFeed>>(
selector: (_, model2) => model2.authorsrelated,
builder: (context, authorsRelated, child) {
  // List<TestFeed> authorsRelated = provider.authorsrelated;
    if (provider.loading) {
      return Container(
        height: 100.0,
        child: LoadingWidget(),
      );
    } else if(provider.loading == false && authorsRelated == null) {
       return SizedBox(

       );

    } else if(provider.loading == false && authorsRelated == null || provider.loading == false && authorsRelated.length == 0) {
       return  Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/images/empty-box.png',
            height: 30.0,
            width: 30.0,
          ),
          Text(
            "No more books from this author for now, check back later",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      
  
       );
    }
     else {
      // List<TestFeed> authorsRelated = provider.authorsrelated;
      // var datas = provider.authorsrelated;
      return ListView.builder(
       scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: authorsRelated.length,
        itemBuilder: (BuildContext context, int index) {
        // List<TestFeed> testfeed = provider.authorsrelated;
        print('${authorsRelated.toString()}');
        if(authorsRelated.toString().contains("No data")) {
          
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
        child:  Text ('Empty box'),
          );
          
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: BookListItem(
              img: authorsRelated[index].posts_links_url?.replaceFirst("../../", Constants.baseHttp),
              title: authorsRelated[index].posts_title ?? "" ,
              author: authorsRelated[index].posts_author ?? "",
              desc: authorsRelated[index].posts_content.toString().length < 30  ? authorsRelated[index].posts_content?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), "") : "${authorsRelated[index].posts_content?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').substring(0, 30)}..." ,
              postsId: authorsRelated[index].posts_id,
              content: authorsRelated[index].posts_fullcontent,
              postsCourseId: authorsRelated[index].posts_course_id,
              index: index,
              
            
            ),
          );
        }
        },
      );
    }
});
  }
/*
  openBook(DetailsProvider provider) async {
    List dlList = await provider.getDownload();
    if (dlList.isNotEmpty) {
      // dlList is a list of the downloads relating to this Book's id.
      // The list will only contain one item since we can only
      // download a book once. Then we use `dlList[0]` to choose the
      // first value from the string as out local book path
      Map dl = dlList[0];
      String path = dl['path'];

      List locators =
          await LocatorDB().getLocator(widget.bookId as String);

      EpubViewer.setConfig(
        identifier: 'androidBook',
        themeColor: Theme.of(context).accentColor,
        scrollDirection: EpubScrollDirection.VERTICAL,
        enableTts: false,
        allowSharing: true,
      );
      EpubViewer.open(path,
          lastLocation:
              locators.isNotEmpty ? EpubLocator.fromJson(locators[0]) : null);
      EpubViewer.locatorStream.listen((event) async {
        // Get locator here
        Map json = jsonDecode(event);
        json['bookId'] = widget.bookId.toString();
        // Save locator to your database
        await LocatorDB().update(json);
      });
    }
  }
*/
_sendButtonMethod() async {
  CommentProvider commentProvider = Provider.of<CommentProvider>(context, listen: false);

            if (commentController.text.length > 0 && widget.userId != null) {
              print(commentController.text);
             commentProvider.postComments(commentController.text, widget.bookId.toString(),widget.userId );
              commentController.clear();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Posting comment....')));
               Timer(Duration(seconds: 5), () {
              Navigator.pop(context);
               });
             
            } else if(widget.userId == null) {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please submit your rating first before commenting')));
              print("Not validated");
              return;
            } else {
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a comment before you proceed')));
             print(commentController.text);
              return;
            }
}
 Widget _sendWidget() {
return Icon(Icons.send_sharp, size: 30, color: Colors.white);
}

 void _commentopenDialog() async {
  // CommentProvider commentProvider = Provider.of<CommentProvider>(context, listen: false);
    await Navigator.of(context).push(new MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
             // title: const Text('F'),
              actions: [
              
           
          ElevatedButton(onPressed: _sendButtonMethod, child: Icon(Icons.send_sharp, size: 30, color: Colors.white))            ],
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child:  CommentBox(
          userImage:Constants.dummyProfilePic,
        //  child:  _buildComment(commentProvider),
        //     child: Text("Hello"),
          labelText: 'Write a comment...',
          focusNode: _focusNode,
          withBorder: false,
          fontedSize: 18,
          errorText: 'Comment cannot be blank',
         
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.white,
          textColor: Colors.black,
         // sendWidget: _sendWidget(),
        ),
           
              
            ),
          );
        },
        fullscreenDialog: true
    ));
    
  }

  _buildDownloadReadButton(Color color, String value) {
   // DetailsProvider provider = Provider.of<DetailsProvider>(context, listen: false);
    //if (provider.downloaded) {
     
      return CustomFlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (contex) => ReadFileSCreen(filename: value)));
        //print("I was pressed");
        },
       // isWraped: true,
       overlayColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent),
       label:    'Read',
       width: 10.0,
       color:    color,
       padding: EdgeInsets.fromLTRB(15, 1.0, 15, 1.0),
       labelStyle: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary
      
      )
      );
   // } 
   /*
    else {
      return FlatButton(
        onPressed: () => provider.downloadFile(
          context,
          widget.entry.link[3].href,
          widget.entry.title.t.replaceAll(' ', '_').replaceAll(r"\'", "'"),
        ),
        child: Text(
          'Download',
        ),
      );
    }
    */
  }


 _buildRating(BuildContext context, DetailsProvider ratingProvider, Color color) {
    //if (provider.downloaded) {
     
     
      return CustomFlatButton(
       // onPressed: () => openBook(provider),
       overlayColor: MaterialStateColor.resolveWith((states) => Colors.blueAccent),
       onPressed: () {
         
               showAndroidIosdialogue(context,ratingProvider).then((val) {
                  if(val == null) return;

                //  setState(() {
                  
                    _userRating = val;
                     _rating =  _userRating;
                    
                      print('I was called in build Rating ${_userRating}');
                //  });
                }); 
              
       },
        //isWraped: true,
        
        width: 10.0,
       label:    'Rate',
       color:    color,
       padding: EdgeInsets.fromLTRB(15, 1.0, 15, 1.0),
       labelStyle: GoogleFonts.mulish(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onPrimary
      
      )
      );
   // } 
   /*
    else {
      return FlatButton(
        onPressed: () => provider.downloadFile(
          context,
          widget.entry.link[3].href,
          widget.entry.title.t.replaceAll(' ', '_').replaceAll(r"\'", "'"),
        ),
        child: Text(
          'Download',
        ),
      );
    }
    */
  }

 Future<dynamic> showAndroidIosdialogue(BuildContext context, DetailsProvider ratingProvider) async{
    if(defaultTargetPlatform == TargetPlatform.iOS) {
      return showCupertinoDialog(context: context, 
      builder: (context) => CupertinoAlertDialog(
        title: FittedBox(child: Text('Rating the book: Click icons to rate')),
        content: _ratingBar(),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Cancel", style: TextStyle(
              color: Colors.blueAccent,

            ),),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(child: Text("Submit", style: TextStyle(color: Colors.greenAccent)),
          isDefaultAction: true,
          onPressed: () {},
          )
        ]
      ));
      
    }
    return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)
              ),
                    title: FittedBox(child: Text("Rating the book: Click icons...")),
                    content: _ratingBar(),
                    actions: <Widget>[
                      Row(
                  children: <Widget>[
                     Expanded(
                  child:    CustomFlatButton(
                        label:  "Cancel",
                        color: Colors.blueAccent,
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white60),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                     ),
                      SizedBox(
                        width: 10
                      ),
                      Expanded(

                 child:      CustomFlatButton(
                        label:  "Submit",
                        color: Colors.greenAccent,
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.white60),
                        onPressed: () {
//DetailsProvider ratingState = Provider.of<DetailsProvider>(context, listen: false);

int values = _rating.toInt();
//int valued = int.tryParse(values) as int;
/*
print('Rated value is: ${values}');

*/
        ratingProvider.getsubmitRating(widget.bookId.toString(),widget.userId,values);
  /*       
         List<Rating> ratingEntry = ratingState.ratingData;
             if(ratingState.loading == true) {
               return Center(child: CircularProgressIndicator());

             } else if(ratingState.loading == false && ratingEntry == null) {

               _userRating = 0.0;
               _rating = 0.0;

             }
             print(ratingEntry);
              int rating_counts = ratingEntry[0].rating_count as int;
int rating_average = ratingEntry[0].rating_average as int;
  _userRating = double.parse(rating_counts.toString());
  _rating =  _userRating;
*/
                          print('Has _rating being updated ${_rating}');
                          Navigator.pop(context, _rating);
                        },
                      ),
                      )
                    ],
                      ),
                    ]
                    );
                },
              );
  
  }
  _buildCategory(DetailsProvider categoryprovider) {
    //DetailsProvider categoryprovider = Provider.of<DetailsProvider>(context, listen: false);
    return Selector<DetailsProvider, List<TestFeed>>(
      selector: (_, anotherModel) => anotherModel.testfeed,
      builder: (context, entry, child) {
   //  List<TestFeed> entry = categoryprovider.testfeed;
     // print('value ---> of' + json.encode(provider.testfeed));
    if (categoryprovider.loading) {
      return Container(
        height: 100.0,
        child: LoadingWidget(),
      );
    } else if(categoryprovider.loading == false && entry == null || categoryprovider.loading == false && entry.length == 0) {
     
      return SizedBox();
    } else {
       return Container(
      height: 200.0,
      child: Center(
        child: ListView.builder(

          //primary: false,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: entry.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
         //   List<TestFeed> entry = provider.testfeed;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: BookCard(
                img: entry[index].posts_links_url?.replaceFirst("../../", Constants.baseHttp),
              title: entry[index].posts_title ?? "" ,
              author: entry[index].posts_author ?? "",
              desc: entry[index].posts_content.toString().length < 30  ? entry[index].posts_content?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), "") : "${entry[index].posts_content?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').substring(0, 30)}..." ,
              postsId: entry[index].posts_id,
              content: entry[index].posts_fullcontent,
              postsCourseId: entry[index].posts_course_id,
              index: index,
    
              ),
            );
          },
        ),
      ),
    );
   
    }
      });
  }

  void _share() async{
    final fileName = '${widget.imageName?.replaceAll("../../", Constants.baseHttp)}'; 
    var appName = Constants.appName;
    http.Response response = await http.get(Uri.parse(fileName));
   
    final mimeType = lookupMimeType(fileName);
    final fileExtension = p.extension(fileName);
    final fullFilename = "sharefile" + "." + fileExtension;
   
    await WcFlutterShare.share(
      sharePopupTitle: 'Premium books for free on $appName',
      subject: 'Read ${widget.bookName}',
       mimeType: mimeType.toString(),
       fileName: fullFilename,
       text: 'Read premium book: ${widget.bookName} from $appName',
       bytesOfFile: response.bodyBytes
       );
    
  }
  
}