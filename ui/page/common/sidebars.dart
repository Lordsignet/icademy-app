import 'package:flutter/material.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'dart:async';
//import 'package:flutter/material.dart';
import 'package:racfmn/helper/constant.dart';
//import 'package:racfmn/model/user.dart';
import 'package:racfmn/state/auth_state.dart';
//import 'package:racfmn/ui/page/common/locator.dart';
/*import 'package:racfmn/ui/page/bookmark/bookmark_page.dart';
import 'package:racfmn/ui/page/profile/follow/followerListPage.dart'; */
import 'package:racfmn/ui/page/profile/profile_page.dart';
/*import 'package:racfmn/ui/page/profile/qrCode/scanner.dart'; */
//import 'package:racfmn/helper/shared_prefrence_helper.dart';
import 'package:racfmn/ui/page/profile/widgets/circular_image.dart';
//import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_widgets.dart';
import 'package:racfmn/widgets/url_text/custom_url_text.dart';
import 'package:provider/provider.dart';
//import 'dart:convert';
class SidebarMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final VoidCallback? loginCallback;
  const SidebarMenu({Key? key, this.loginCallback, this.scaffoldKey}) : super(key: key);

  //final AnimationController? iconAnimationController;
  //final DrawerIndex? screenIndex;
  //final Function(DrawerIndex)? callBackIndex;

  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu>with TickerProviderStateMixin {
  List<DrawerList>? drawerList;
  DrawerIndex? screenIndex;
  AnimationController? iconAnimationController;
  ScrollController? scrollController;
  //AnimationController? iconAnimationController;
  AnimatedIconData? animatedIconData = AnimatedIcons.arrow_menu;
Function(bool)? drawerIsOpen;
  double scrolloffset = 0.0;
 double drawerWidth = 250;
 String screenView = 'SettingsAndPrivacyPage';
  AnimationController? animationController;


  @override
  void initState() {
    setDrawerListArray();
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    iconAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 0));
    iconAnimationController?..animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
    scrollController = ScrollController(initialScrollOffset: drawerWidth * 0.75);
    scrollController!
      ..addListener(() {
        if (scrollController!.offset <= 0) {
          if (scrolloffset != 1.0) {
            setState(() {
              scrolloffset = 1.0;
              try {
                drawerIsOpen!(true);
              } catch (_) {}
            });
          }
          iconAnimationController?.animateTo(0.0, duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
        } else if (scrollController!.offset > 0 && scrollController!.offset < drawerWidth * 0.75.floor()) {
          iconAnimationController?.animateTo((scrollController!.offset * 100 / (drawerWidth * 0.75)) / 100,
              duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
        } else {
          if (scrolloffset != 0.0) {
            setState(() {
              scrolloffset = 0.0;
              try {
                drawerIsOpen!(false);
              } catch (_) {}
            });
          }
          iconAnimationController?.animateTo(1.0, duration: const Duration(milliseconds: 0), curve: Curves.fastOutSlowIn);
        }
      });
    WidgetsBinding.instance?.addPostFrameCallback((_) => getInitState());
    super.initState();
  }
Future<bool> getInitState() async {
    scrollController?.jumpTo(
      drawerWidth * 0.75,
    );
    return true;
  }
  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.Home,
        labelName: 'Home',
        icon: Icon(AppIcon.homeFill),
      ),
      DrawerList(
        index: DrawerIndex.Explore,
        labelName: 'Explore',
        icon: Icon(AppIcon.thumbpinFill),
      ),
      DrawerList(
        index: DrawerIndex.Bookmark,
        labelName: 'Bookmark',
        icon: Icon(AppIcon.bookmark),
      ),
      DrawerList(
        index: DrawerIndex.Favourite,
        labelName: 'Favourite',
        icon: Icon(AppIcon.bulbOff),
      ),
      DrawerList(
        index: DrawerIndex.Donate,
        labelName: 'Donate',
        icon: Icon(AppIcon.heartEmpty),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'About Us',
        icon: Icon(AppIcon.about),
      ),
      DrawerList(
        index: DrawerIndex.Settings,
        labelName: 'Settings',
        icon: Icon(AppIcon.settings),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold(
     // backgroundColor: Colors.white60.withOpacity(0.5),
      return SingleChildScrollView(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        physics: const PageScrollPhysics(parent: ClampingScrollPhysics()),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: drawerWidth + drawerWidth * 0.75,
          //we use with as screen width and add drawerWidth (from navigation_home_screen)
          child: Row(
            children: <Widget>[
              SizedBox(
                width: drawerWidth * 0.75,
                //we divided first drawer Width with HomeDrawer and second full-screen Width with all home screen, we called screen View
                height: MediaQuery.of(context).size.height,
                child: AnimatedBuilder(
                  animation: iconAnimationController!,
                  builder: (BuildContext context, Widget? child) {
                    return Transform(
                      //transform we use for the stable drawer  we, not need to move with scroll view
                      transform: Matrix4.translationValues(scrollController!.offset, 0.0, 0.0),
      child: newMethod(context),
       );
                  },
                ),
              ),
              SizedBox(
                width: drawerWidth,
                height: MediaQuery.of(context).size.height,
                //full-screen Width with widget.screenView
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    boxShadow: <BoxShadow>[
                      BoxShadow(color: AppColor.lightGrey.withOpacity(0.6), blurRadius: 24),
                    ],
                  ),
                  child: Stack(
                    children: <Widget>[
                      //this IgnorePointer we use as touch(user Interface) widget.screen View, for example scrolloffset == 1 means drawer is close we just allow touching all widget.screen View
                      IgnorePointer(
                        ignoring: scrolloffset == 1 || false,
                        child: Text(screenView),
                      ),
                      //alternative touch(user Interface) for widget.screen, for example, drawer is close we need to tap on a few home screen area and close the drawer
                      if (scrolloffset == 1.0)
                        InkWell(
                          onTap: () {
                            onDrawerClick();
                          },
                        ),
                      // this just menu and arrow icon animation
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 8),
                        child: SizedBox(
                          width: AppBar().preferredSize.height - 8,
                          height: AppBar().preferredSize.height - 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(AppBar().preferredSize.height),
                              child: Center(
                                // if you use your own menu view UI you add form initialization
                                child: AnimatedIcon(
                                        icon: AnimatedIcons.arrow_menu,
                                        progress: iconAnimationController!),
                              ),
                              onTap: () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                onDrawerClick();
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Column newMethod(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 40.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                AnimatedBuilder(
                  animation: iconAnimationController!,
                  builder: (BuildContext context, Widget? child) {
                    return ScaleTransition(
                      scale: AlwaysStoppedAnimation<double>(1.0 - (iconAnimationController!.value) * 0.2),
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation<double>(Tween<double>(begin: 0.0, end: 24.0)
                                .animate(CurvedAnimation(parent: iconAnimationController!, curve: Curves.fastOutSlowIn))
                                .value /
                            360),
                       /* child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: Colors.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                            child: Image.asset('assets/images/userImage.png'),
                          ),
                        ), */
                      child: _menuHeader(),
                      ),
                    );
                  },
                ),
               /* Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4),
                  child: Text(
                    'Chris Hemsworth',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.grey,
                      fontSize: 18,
                    ),
                  ),
                ), */
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Divider(
          height: 1,
          color: Colors.grey.withOpacity(0.6),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(0.0),
            itemCount: drawerList?.length,
            itemBuilder: (BuildContext context, int index) {
              return inkwell(drawerList![index]);
            },
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey.withOpacity(0.6),
        ),
        Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Sign Out',
                style: TextStyle(
                  
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.left,
              ),
              trailing: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              onTap: () {
                _logOut();
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ],
    );
  }
  
  void onTapped() {
    print('Doing Something...'); // Print to console.
  }
void _logOut() {
    final state = Provider.of<AuthState>(context, listen: false);
    Navigator.pop(context);
    state.logoutCallback();
  }
  
 Future<void>callMeAfter() async {
  final state = Provider.of<AuthState>(context, listen: false);
  var data =  await state.getUserPrefs();
    
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
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
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName, color: screenIndex == listData.index ? Colors.blue : AppColor.darkGrey),
                        )
                      : Icon(listData.icon?.icon, color: screenIndex == listData.index ? Colors.blue : AppColor.darkGrey),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: screenIndex == listData.index ? Colors.blue : AppColor.darkGrey,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (drawerWidth * 0.75 - 64) * (1.0 - iconAnimationController!.value - 1.0), 0.0, 0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width: drawerWidth * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    
    //widget.callBackIndex!(indexScreen);
    onDrawerClick();
     try {
            changeIndex(indexScreen);
                          } catch (e) {}
  }
   Widget _menuHeader() {
   //final state = context.watch<AuthState>();
   final state = Provider.of<AuthState>(context);
   
   //print(state.userModel);
   //final dasProfile = getUserPrefs();
   
  callMeAfter();
   
   //print(state);
   
   //print(state.getCurrentUser());
   //print(state.userModel.userId);
   //print('value is-->' + json.encode(state.userModel));
    
    if (state.userModel == null) {
      
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
          /*  Container(
              height: 56,
              width: 56,
              margin: EdgeInsets.only(left: 17, top: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(28),
                image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    state.userModel.profilePic ?? Constants.dummyProfilePic,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            */
            Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: Colors.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                              ],
                            image: DecorationImage(
                  image: customAdvanceNetworkImage(
                    state.userModel.profilePic ?? Constants.dummyProfilePic,
                  ),
                  fit: BoxFit.cover,
                ),
                            ),
                           /* child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(60.0)),
                              child: ,
                            ),
                            */
                            
                          ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    ProfilePage.getRoute(profileId: state.userModel.userId));
              },
              selectedTileColor: Colors.brown,
              focusColor: Colors.white70,
              title: Row(
                children: <Widget>[
                  UrlText(
                    text: state.userModel.userName ?? '',
                    style: TextStyles.onPrimaryTitleText
                        .copyWith(color: Colors.brown, fontSize: 20),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  state.userModel.isVerified == true
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
                state.userModel.email as String,
                style: TextStyles.onPrimarySubTitleText
                    .copyWith(color: Colors.black87, fontSize: 18),
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
  
  }

 void _navigateTo(String path) {
   screenView = path;
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/$screenView');
  }
void changeIndex(DrawerIndex drawerIndexdata) {
    if (screenIndex != drawerIndexdata) {
      screenIndex = drawerIndexdata;
      if (screenIndex == DrawerIndex.Home) {
       /* setState(() {
          screenView = const MyHomePage();
        });
        */
         Navigator.pop(context);
      } else if (screenIndex == DrawerIndex.Explore) {
        Navigator.pop(context);

      } else if (screenIndex == DrawerIndex.Bookmark) {
         Navigator.pop(context);
      } else if (screenIndex == DrawerIndex.Favourite) {
         Navigator.pop(context);
      } else {
        //do in your way......
      }
    }
  }

void onDrawerClick() {
    //if scrollcontroller.offset != 0.0 then we set to closed the drawer(with animation to offset zero position) if is not 1 then open the drawer
    if (scrollController!.offset != 0.0) {
      scrollController?.animateTo(
        0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      scrollController?.animateTo(
        drawerWidth * 0.75,
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
      );
    }
  }
}

enum DrawerIndex {
  Home,
  Explore,
  Favourite,
  Bookmark,
  Donate,
  About,
  Settings,
  Publish,
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
