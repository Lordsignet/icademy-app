import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
//import 'package:epub_viewer/epub_viewer.dart';
//import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:racfmn/components/book_list_item.dart';
import 'package:racfmn/components/description_text.dart';
import 'package:racfmn/components/loading_widget.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/custom_route.dart';
import 'package:racfmn/helper/locator_helper.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/model/category.dart';
import 'package:racfmn/state/details_provider.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:racfmn/widgets/custom_widgets.dart';

class Details extends StatefulWidget {
  final int? bookId;
  final String? imageName;
  final String? description;
  final String? authorName;
  //final String? imgTag;
  final String? bookName;
  final int? book_course_id;
  //final String? authorTag;

  Details({
    Key? key, this.bookId, this.bookName, this.imageName, this.description,this.authorName,this.book_course_id
  }) : super(key: key);

  static Route<Null> getRoute(int? bookId, String? bookName, String? imageName, String? description, String? authorName, int? book_course_id) {
    return SlideLeftRoute<Null>(
      builder: (BuildContext context) => Details(
        bookId: bookId,
        bookName: bookName,
        imageName: imageName,
        description: description,
        authorName: authorName,
        book_course_id: book_course_id,
      ),
    );
  }

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback(
      (_) {
       /* Provider.of<DetailsProvider>(context, listen: false)
            .setEntry(widget.bookId); */
        Provider.of<DetailsProvider>(context, listen: false)
            .getFeed(widget.bookId.toString(),widget.book_course_id.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsProvider>(
      builder: (BuildContext context, DetailsProvider detailsProvider,
          child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(widget.bookName as String),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () async {
                  if (detailsProvider.faved) {
                    detailsProvider.removeFav();
                  } else {
                    detailsProvider.addFav();
                  }
                },
                icon: Icon(
                  detailsProvider.faved ? Icons.favorite : AppIcon.heartEmpty,
                  color: detailsProvider.faved
                      ? Colors.red
                      : Theme.of(context).iconTheme.color,
                ),
              ),
              customIcon(context,
                  icon: AppIcon.bulbOn,
                  istwitterIcon: false,
                  size: 25,
                  iconColor: TwitterColor.white),
            ],
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            children: <Widget>[
              SizedBox(height: 10.0),
              _buildImageTitleSection(detailsProvider),
              SizedBox(height: 30.0),
              _buildSectionTitle('Book Description'),
              _buildDivider(),
              SizedBox(height: 10.0),
              DescriptionTextWidget(
                text: '${widget.description}',
              ),
              SizedBox(height: 30.0),
              _buildSectionTitle('More from Author'),
              _buildDivider(),
              SizedBox(height: 10.0),
              _buildMoreBook(detailsProvider),
            ],
          ),
        );
      },
    );
  }

  _buildDivider() {
    return Divider(
      color: Theme.of(context).textTheme.caption!.color,
    );
  }

  _buildImageTitleSection(DetailsProvider detailsProvider) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: widget.bookName as String,
            child: CachedNetworkImage(
              imageUrl: '${widget.imageName!.replaceFirst("../../", Constants.baseHttp)}',
              placeholder: (context, url) => Container(
                height: 200.0,
                width: 130.0,
                child: LoadingWidget(),
              ),
              errorWidget: (context, url, error) => Icon(AppIcon.report),
              fit: BoxFit.cover,
              height: 200.0,
              width: 100.0,
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
               // Hero(
                //  tag: widget.bookName as String,
                //  child: Material(
                //    type: MaterialType.transparency,
                     Text(
                      '${widget.bookName}',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                    ),
                //  ),
               // ),
                SizedBox(height: 5.0),
               // Hero(
                 // tag: widget.authorName as String,
                //  child: Material(
                  //  type: MaterialType.transparency,
                    Text(
                      '${widget.authorName}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                 // ),
               // ),
                SizedBox(height: 5.0),
                _buildCategory(detailsProvider, context),
                Center(
                  child: Container(
                    height: 20.0,
                    width: MediaQuery.of(context).size.width,
                    child: _buildDownloadReadButton(detailsProvider, context),
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
        color: Theme.of(context).accentColor,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  _buildMoreBook(DetailsProvider provider) {
    if (provider.loading) {
      return Container(
        height: 100.0,
        child: LoadingWidget(),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: provider.testfeed.length,
        itemBuilder: (BuildContext context, int index) {
        List<TestFeed> entry = provider.testfeed;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: BookListItem(
              img: entry[index].posts_links_url!.replaceFirst("../../", Constants.baseHttp),
              title: entry[index].posts_title,
              author: entry[index].posts_author,
              desc: entry[index].posts_content,
              
            ),
          );
        },
      );
    }
  }

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
          await LocatorDB().getLocator(widget.bookId.toString());
/*
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
        json['bookId'] = widget.entry.id.t.toString();
        // Save locator to your database
        await LocatorDB().update(json);
      });
      */
    }
  }

  _buildDownloadReadButton(DetailsProvider provider, BuildContext context) {
    if (provider.downloaded) {
      return TextButton(
        onPressed: () => openBook(provider),
        child: Text(
          'Read Book',
        ),
      );
    } else {
      return TextButton(
        onPressed: () => provider.downloadFile(
          context,
          widget.bookName as String,
          //widget.entry!.title!.t!.replaceAll(' ', '_').replaceAll(r"\'", "'"),
          widget.bookId.toString(),
        ),
        child: Text(
          'Download',
        ),
      );
    }
  }

  _buildCategory(DetailsProvider categoryprovider, BuildContext context) {
    final encodedData = categoryprovider.testfeed;
  
    if (encodedData.length <= 0) {
      return SizedBox();
    } else {
      return Container(
        height: encodedData.length < 3 ? 55.0 : 95.0,
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: encodedData.length > 4 ? 4 : encodedData.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 210 / 80,
          ),
          itemBuilder: (BuildContext context, int index) {
           //Category cat = entry.category![index];
           List<TestFeed> cat = categoryprovider.testfeed;
            return CustomScrollView(
              primary: false,
              //padding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 5.0),
              slivers: <Widget>[
                SliverPadding(
                  padding: EdgeInsets.all(16.0),
                  sliver: SliverGrid.count(
                    childAspectRatio: 2/3,
                    crossAxisCount: 3,
                    mainAxisSpacing: 20.0,
                    crossAxisSpacing: 20.0,
                    children: <Widget>[
                      Hero(
                        tag: cat[index].posts_title as String, 
                        child: Material(
                          shadowColor: Colors.yellow.shade900,
                          child: InkWell(
                            onTap: () {},
                            child: CachedNetworkImage(
                              imageUrl: cat[index].posts_links_url!.replaceFirst("../../", Constants.baseHttp),
                              fit: BoxFit.cover,

                            )
                          )
                        )
                        )
                    ]
                  )
                )

              ]
              
            );
          },
        ),
      );
    }
  }
/*
  _share() {
    Share.text(
      '${widget.entry.title.t} by ${widget.entry.author.name.t}',
      'Read/Download ${widget.entry.title.t} from ${widget.entry.link[3].href}.',
      'text/plain',
    );
  }
  */
}
