import 'dart:async';
import 'package:flutter/material.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/model/user.dart';
import 'package:racfmn/state/auth_state.dart';
import 'package:racfmn/ui/page/profile/profile_page.dart';
import 'package:racfmn/ui/page/profile/widgets/circular_image.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';


class SidebarMenu extends StatefulWidget {
  final VoidCallback? loginCallback;
  const SidebarMenu({Key? key, this.loginCallback, this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState>? scaffoldKey;

  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  List<DrawerList>? drawerList;
Future<void>? _launched;
var state;
@override
  void initState() {
setDrawerListArray();
Provider.of<AuthState>(context, listen: false).getUserPrefs();
//state = Provider.of<AuthState>(context, listen: false);
//callMeAfter();
super.initState();
  }
  _lauchUrl(url) async {
   // const url = Constants.baseHttp + "pricing";
    if (await canLaunch(url)) {
      await launch(
        url);
    } else {
      throw 'Could not launch $url';
    }
  }



  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.Home,
        labelName: 'Home',
        icon: Icon(AppIcon.home),
      ),
      DrawerList(
        index: DrawerIndex.Orders,
        labelName: 'Orders',
        icon: Icon(Icons.library_books),
      ),
      DrawerList(
        index: DrawerIndex.Products,
        labelName: 'Products',
        icon: Icon(Icons.shopping_cart),
      ),
      DrawerList(
        index: DrawerIndex.Favourite,
        labelName: 'Favourite',
        icon: Icon(Icons.favorite_outline_sharp),
      ),
      DrawerList(
        index: DrawerIndex.Notification,
        labelName: 'Notification',
        icon: Icon(AppIcon.notification)
      ),
    
      DrawerList(
        index: DrawerIndex.Profile,
        labelName: 'Profile',
        icon: Icon(AppIcon.profile),
      ),
      DrawerList(
        index: DrawerIndex.Publish,
        labelName: 'Publish',
        icon: Icon(Icons.publish_outlined),
      ),
    /*
       DrawerList(
        index: DrawerIndex.Support,
        labelName: 'Support',
        icon: Icon(AppIcon.about),
      ),
      */
       DrawerList(
        index: DrawerIndex.Search,
        labelName: 'Search',
        icon: Icon(AppIcon.search),
      ),
      DrawerList(
        index: DrawerIndex.Settings,
        labelName: 'Settings',
        icon: Icon(AppIcon.settings),
      ),
      DrawerList(
        index: DrawerIndex.LOgout,
        labelName: 'Log out',
        icon: Icon(AppIcon.bulbOff),
      ),
    ];
  }
  Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }
  Widget _menuHeader(AuthState authstate) {
   return Selector<AuthState, UserModel>( 
  selector: (_,_userModel) => _userModel.userModel,
   shouldRebuild: (UserModel prev, UserModel next) => true,
  builder: (context, userValue, child) {
  if(authstate.isbusy) {

return Container(child: CircularProgressIndicator());
  }else if (authstate.isbusy == false && authstate.userModel == null) {
      _logOut();
      return ConstrainedBox(
        constraints: BoxConstraints(minWidth: 200, minHeight: 100),
        child: Center(
          child: Text(
            'Login to continue',
            style: TextStyles.textStyle14,
          ),
        ),
      ).ripple(() {
        _logOut();
        //  Navigator.of(context).pushNamed('/signIn');
      });
    } else {
      
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: Colors.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                              ],
                            image: DecorationImage(
                  image: NetworkImage(
                 Constants.dummyProfilePic
                  ),
                  fit: BoxFit.cover,
                ),
                            ),
                           /*
                             // userValue.profilePic?.replaceAll("https://hephziland.org/", Constants.baseHttp) ?? Constants.dummyProfilePic.replaceAll("https://hephziland.org/", Constants.baseHttp),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                              child: ,
                            ),
                            */
                            
                          ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    ProfilePage.getRoute(profileId: userValue.userId, profilePic: userValue.profilePic ?? Constants.dummyProfilePic,email: state.userModel.email, username: state.userModel.userName));
              },
            //  selectedTileColor: Colors.brown,
             // focusColor: Colors.white70,
              title: Row(
                children: <Widget>[
                  Text(
                    userValue.userName ?? '',
                    style: TextStyles.onPrimaryTitleText
                        .copyWith(color: Theme.of(context).primaryColor, fontSize: 20),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  userValue.isVerified == 1
                      ? customIcon(context,
                          icon: AppIcon.blueTick,
                          istwitterIcon: true,
                          iconColor: AppColor.primary,
                          size: 18,
                          paddingIcon: 3)
                      : SizedBox(
                          width: 0,
                        ),
                ],
              ),
              subtitle: customText(
                userValue.email as String,
                style: TextStyles.onPrimarySubTitleText
                    .copyWith(color: Theme.of(context).primaryColor, fontSize: 18),
              ),
              /*
              trailing: customIcon(context,
                  icon: AppIcon.arrowDown,
                  iconColor: AppColor.primary,
                  paddingIcon: 20),
                  */
            ),
            
            /*  Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 17,
                  ),
                  _tappbleText(context, '${state.userModel.getFollower}',
                      ' Followers', 'FollowerListPage'),
                  SizedBox(width: 10),
                  _tappbleText(context, '${state.userModel.getFollowing}',
                      ' Following', 'FollowingListPage'),
                ],
              ),
            ), */
          ],
        ),
      );
    }
  
  });
  }

Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    
    //widget.callBackIndex!(indexScreen);
    //onDrawerClick();
     try {
            changeIndex(indexScreen);
                          
                      } catch (e) {}
  }
  void changeIndex(DrawerIndex drawerIndexdata) {
  
      //screenInddrawerIndexdata;
      if (drawerIndexdata  == DrawerIndex.Home) {
       /* setState(() {
          screenView = const MyHomePage();
        });
        */
         Navigator.pop(context);
      } else if (drawerIndexdata == DrawerIndex.Favourite) {
       // Navigator.pop(context);
  Navigator.pushNamed(context, '/FavoritesPage');
   } else if (drawerIndexdata == DrawerIndex.Notification) {
       // Navigator.pop(context);
  Navigator.pushNamed(context, '/PushNotification');
      } else if (drawerIndexdata == DrawerIndex.Search) {
         //Navigator.pop(context);
         Navigator.pushNamed(context, '/SearchPage');
      } else if(drawerIndexdata == DrawerIndex.Publish) {
        Navigator.pop(context);
        String url = Constants.baseHttp + "pricing";
      _lauchUrl(url); 
      }else if(drawerIndexdata == DrawerIndex.Products) {
        Navigator.pop(context);
        String url = Constants.baseHttp;
      _lauchUrl(url); 
      } else if (drawerIndexdata == DrawerIndex.Orders) {
         //Navigator.pop(context);
         Navigator.pushNamed(context, '/OrderPage');
      }else if (drawerIndexdata == DrawerIndex.Settings) {
        // Navigator.pop(context);
         Navigator.pushNamed(context, '/SettingsAndPrivacyPage');
      } else if(drawerIndexdata == DrawerIndex.Profile) {
      Navigator.push(context,
                    ProfilePage.getRoute(profileId: Provider.of<AuthState>(context, listen: false).userModel.userId));
      }else if(drawerIndexdata == DrawerIndex.LOgout) {
      _logOut();
      }
       else {
        //do in your way......
      }
    
  }

Widget inkwell(DrawerList listData, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.brown,
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  /*
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName, color: screenIndex == listData.index ? Colors.blue : AppColor.darkGrey),
                        )
                      :
                      */ 
                      // ignore: deprecated_member_use
                      Icon(listData.icon?.icon, color: color),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: color,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
           
        const SizedBox()
          ],
        ),
      ),
    );
  }
  
  ListTile _menuListRowButton(String title,
      {Function? onPressed, IconData? icon, bool isEnable = false}) {
    return ListTile(
     
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      leading: icon == null
          ? null
          : Padding(
              padding: EdgeInsets.only(top: 5),
              child: customIcon(
                context,
                icon: icon,
                size: 25,
                iconColor: isEnable ? AppColor.darkGrey : AppColor.lightGrey,
              ),
            ),

      title: customText(
        title,
        style: TextStyle(
          fontSize: 20,
          color: isEnable ? AppColor.secondary : AppColor.lightGrey,
        ),
      ),
    );
  }
 /* Widget tapableText(String text, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text)
    );

  }
  */

  Positioned _footer() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Column(
        children: <Widget>[
          Divider(height: 0),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
                height: 45,
              ),
              customIcon(context,
                  icon: AppIcon.bulbOn,
                  istwitterIcon: true, 
                  size: 25,
                  iconColor: TwitterColor.dodgetBlue),
              Spacer(),
              TextButton(
                onPressed: () {
                  /* Navigator.push(
                      context,
                      ScanScreen.getRoute(
                          context.read<AuthState>().profileuserModel)); */
                },
                child: Image.network(
                  Constants.footer,
                  height: 25,
                ),
              ),
              SizedBox(
                width: 0,
                height: 45,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _logOut() {
    final state = Provider.of<AuthState>(context, listen: false);
    Navigator.pop(context);
    state.logoutCallback();
  }
  
 callMeAfter() async {
  final state = Provider.of<AuthState>(context, listen: false);
var data = state.getUserPrefs();
    
  }
  

  void _navigateTo(String path) {
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/$path');
  }

  @override
  Widget build(BuildContext context) {
    String toLaunch = Constants.baseHttp + "pricing";
    final authstats = Provider.of<AuthState>(context, listen: false);
    return Drawer (
        child: SafeArea(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start, 
         children: <Widget>[
          _menuHeader(authstats),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0.0),
            itemCount: drawerList?.length,
            itemBuilder: (BuildContext context, int index) {
              return inkwell(drawerList![index], Theme.of(context).accentColor);
            },
          ),
        ),
         ]

      ),
    ));
  }
}
enum DrawerIndex {
  Home,
  Notification,
  Support,
  Orders,
  Products,
  Search,
  Favourite,
  Profile,
  About,
  Settings,
  Publish,
  LOgout,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}