//import 'package:dartz/dartz.dart';
import 'package:flutter/rendering.dart';
import 'package:petitparser/petitparser.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/custom_route.dart';
import 'package:racfmn/state/profile_state.dart';
import 'package:racfmn/ui/page/profile/edit_profile.dart';

import 'package:racfmn/ui/page/profile/widgets/circular_image.dart';
import 'package:racfmn/ui/page/profile/profile_image_view.dart';
/*import 'package:racfmn/ui/page/profile/qrCode/scanner.dart'; */
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:racfmn/helper/enum.dart';
import 'package:racfmn/helper/utility.dart';
/*import 'package:racfmn/model/feed_model.dart'; */
import '../../../model/user.dart';
import 'widgets/tab_painter.dart';
import 'package:racfmn/ui/page/profile/widgets/tab_painter.dart';
import 'package:racfmn/state/auth_state.dart';
/*import 'package:racfmn/state/chats/chatState.dart';
import 'package:racfmn/state/feedState.dart'; */
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/cache_image.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/widgets/newWidget/custom_loader.dart';
import 'package:racfmn/widgets/url_text/custom_url_text.dart';
import 'package:racfmn/widgets/newWidget/ripple_button.dart';
/*import 'package:racfmn/widgets/tweet/tweet.dart';
import 'package:radlib/widgets/tweet/widgets/tweetBottomSheet.dart'; */
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  static Route<Null> getRoute({int? profileId, String? profilePic, String? email, String? username}) {
    return SlideLeftRoute<Null>(
      builder: (BuildContext context) =>  ProfilePage(
            profileId: profileId,
            profilePic: profilePic,
            email: email,
            username: username,
          ),
      
    );
  }

  ProfilePage({Key? key, this.profileId, this.profilePic, this.email, this.username}) : super(key: key);

  final int? profileId;
  final String? email;
  final String? profilePic;
  final String? username;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool isMyProfile = false;

  int pageIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
    Provider.of<ProfileState>(context, listen: false).getProfileUser(widget.profileId as int);

     // isMyProfile = authstate.isMyProfile;
    });
   /* _tabController = TabController(vsync: this, length: 3); */
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  SliverAppBar getAppbar() {
    return SliverAppBar(
      forceElevated: false,
      expandedHeight: 200,
      elevation: 0,
      stretch: true,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
       
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  SizedBox.expand(
                    child: Container(
                      padding: EdgeInsets.only(top: 50),
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                  // Container(height: 50, color: Colors.black),

                  /// Banner image
                  Container(
                    height: 180,
                    padding: EdgeInsets.only(top: 28),
                    child: CacheImage(
                      path: "${widget.profilePic ?? Constants.dummyProfilePic}",
                      fit: BoxFit.fill,
                    ),
                  ),

                  /// UserModel avatar, message icon, profile edit and follow/following button
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 5),
                              shape: BoxShape.circle),
                          child: RippleButton(
                            child: CircularImage(
                              path: "${widget.profilePic ?? Constants.dummyProfilePic}",
                              height: 80,
                            ),
                            borderRadius: BorderRadius.circular(50),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  ProfileImageView.getRoute("${widget.profilePic}"));
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 90, right: 30),
                          child: Row(
                            children: <Widget>[
                              
                              Container(height: 40),
                                 
                              SizedBox(width: 10),
                              RippleButton(
                                splashColor:
                                    TwitterColor.dodgetBlue_50.withAlpha(100),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                onPressed: () {
                                  Navigator.push(
                                        context, EditProfilePage.getRoute());
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: TwitterColor.white,
                                    border: Border.all(
                                        color: 
                                             Colors.black87.withAlpha(180),
                                          
                                        width: 1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  /// If [isMyProfile] is true then
                                  /// Edit profile button will display
                                  // Otherwise Follow/Following button will be display
                                  child: Text(
                                  
                                        'Edit Profile',
                                        
                                    style: TextStyle(
                                      color: Colors.black87.withAlpha(180),
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/CreateFeedPage');
      },
      child: customIcon(
        context,
        icon: AppIcon.fabTweet,
        istwitterIcon: true,
        iconColor: Theme.of(context).colorScheme.onPrimary,
        size: 25,
      ),
    );
  }

  Widget _emptyBox() {
    return SliverToBoxAdapter(child: SizedBox.shrink());
  }

  bool isFollower() {
    var authstate = Provider.of<ProfileState>(context, listen: false);
  /*  if (authstate.profileUserModel.followersList != null &&
        authstate.profileUserModel.followersList!.isNotEmpty) {
      return (authstate.profileUserModel.followersList!
          .any((x) => x == authstate.userId));
    } else {
      return false;
    }
    */
    return true;
  }

  /// This meathod called when user pressed back button
  /// When profile page is about to close
  /// Maintain minimum user's profile in profile page list
  Future<bool> _onWillPop() async {
    return true;
  }

  void shareProfile(BuildContext context) async {
    var authstate = context.read<AuthState>();
    var user = authstate.profileUserModel;
    Utility.createLinkAndShare(
      context,
      'profilePage/${widget.profileId}/',
      socialMetaTagParameters: SocialMetaTagParameters(
      /*  description: !user.bio!.contains('Edit profile')
            ? user.bio
            : "Checkout ${user.displayName}'s profile on Fwitter app",
            */
        title: '${widget.username} is on Ark library ',
        imageUrl: Uri.parse(user.profilePic as String),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //var state = Provider.of<FeedState>(context);
    ProfileState authstate = Provider.of<ProfileState>(context, listen: false);
   
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ListTileTheme(iconColor: Colors.blue,
      child: Scaffold(
        key: scaffoldKey,
       // floatingActionButton: !isMyProfile ? null : _floatingActionButton(),
        //backgroundColor: TwitterColor.mystic,
        body: NestedScrollView(
          
          headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
            return <Widget>[
              getAppbar(),
           
             
            ];
          },
          body: _headerData(authstate),
        ),
      ),
    ));
  }

  
}
_headerData(ProfileState profilestate) {


  return Selector<ProfileState, List<UserModel>>(
    selector: (_,profileData) => profileData.userModel,
    builder: (context, profileResult,child) {
      if(profilestate.loading) {
      return Container(
    padding: EdgeInsets.only(left: 20),
    height: 20,
    width: 40,
    child: Center(child: CircularProgressIndicator()),
  );

      
    } else if(profilestate.loading == false && profileResult.isEmpty == true) {
      return Container();
    }
return ListView.builder(
  scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: profileResult.length,
        itemBuilder: (BuildContext context, int index) => UserNameRowWidget(
          email: profileResult[index].email ?? '',
          userName: profileResult[index].userName ?? '',
          address: profileResult[index].address ?? '',
          contact: profileResult[index].contact ?? '',
          country: profileResult[index].country ?? '',
          state: profileResult[index].state ?? '',
          displayLast: profileResult[index].displayLast ?? '',
           dob: profileResult[index].dob ?? '',
          displayName: profileResult[index].displayName ?? '',
          philosophy: profileResult[index].philosophy ?? '',

  ));});}


class UserNameRowWidget extends StatelessWidget {
  const UserNameRowWidget({
    Key? key,
    this.userid,
    this.profilePic,
    this.userName,
    this.address,
    this.contact,
    this.dob,
    this.country,
    this.displayLast,
    this.displayName,
    this.email,
    this.state,
    this.philosophy
  }) : super(key: key);

 // final bool isMyProfile;
  final int? userid;
  final String? email;
  final String? profilePic;
  final String? contact;
  final String? country;
  final String? state;
  final String? dob;
  final String? userName;
  final String? address;
  final String? displayLast;
  final String? displayName;
  final String? philosophy;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Row(
            children: <Widget>[
              Text(
                "${displayLast} ${displayName}",
              /*  style: TextStyle(
                  
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                ), */
              ),
              SizedBox(
                width: 3,
              ),
             /* user.isVerified == true
                  ? customIcon(context,
                      icon: AppIcon.blueTick,
                      istwitterIcon: true,
                      iconColor: AppColor.primary,
                      size: 13,
                      paddingIcon: 3) */
                  SizedBox(width: 0),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 9, vertical: 20),
         /* child: customText(
            '${userName}',
            style: TextStyles.subtitleStyle.copyWith(fontSize: 20),
          ),
          */
           child:  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customIcon(context,
                  icon: Icons.account_box,
                  size: 30,
                  istwitterIcon: false,
                  paddingIcon: 5,
                  ),
              SizedBox(width: 10),
              Expanded(
                child: customText(
                  "${userName}",
                  //style: TextStyle(color: AppColor.darkGrey),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child:  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customIcon(context,
                  icon: Icons.mail_sharp,
                  size: 25,
                  istwitterIcon: false,
                  paddingIcon: 5,
                 /*  */),
              SizedBox(width: 10),
              Expanded(
                child: customText(
                  "${email}",
                 //
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              customIcon(context,
                  icon: AppIcon.locationPin,
                  size: 30,
                  istwitterIcon: true,
                  paddingIcon: 5,
                  /*  */),
              SizedBox(width: 10),
              Expanded(
                child: customText(
                  "${address}",
                 
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: <Widget>[
              customIcon(context,
                  icon: Icons.contact_phone,
                  size: 25,
                  istwitterIcon: false,
                  paddingIcon: 5,
                  ),
              SizedBox(width: 10),
              customText(
               "${contact}" ,
               
              ),
              
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: <Widget>[
              customIcon(context,
                  icon: AppIcon.calender,
                  size: 25,
                  istwitterIcon: false,
                  paddingIcon: 5,
                  ),
              SizedBox(width: 10),
              customText(
               "${dob}" ,
               
              ),
              
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: <Widget>[
              customIcon(context,
                  icon: Icons.subway_rounded,
                  size: 30,
                  istwitterIcon: false,
                  paddingIcon: 5,
                  ),
              SizedBox(width: 10),
              customText(
               "${state}" ,
               
              ),
              
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: <Widget>[
              customIcon(context,
                  icon: Icons.map,
                  size: 30,
                  istwitterIcon: false,
                  paddingIcon: 5,
                  ),
              SizedBox(width: 10),
              customText(
               "${country}" ,
               
              ),
              
            ],
          ),
        ),
         Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            children: <Widget>[
              customIcon(context,
                  icon: Icons.format_quote_sharp,
                  size: 30,
                  istwitterIcon: false,
                  paddingIcon: 5,
                  ),
              SizedBox(width: 10),
              customText(
               "${philosophy}", 
               
              ),
              
            ],
          ),
        ),
      ],
    );
  }
}

class Choice {
  const Choice({this.title, this.icon, this.isEnable = false});
  final bool isEnable;
  final IconData? icon;
  final String? title;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Share', icon: Icons.directions_car, isEnable: true),
  const Choice(
      title: 'QR code', icon: Icons.directions_railway, isEnable: true),
  const Choice(title: 'Draft', icon: Icons.directions_bike),
  const Choice(title: 'View Lists', icon: Icons.directions_boat),
  const Choice(title: 'View Moments', icon: Icons.directions_bus),
];
