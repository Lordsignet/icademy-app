import 'package:flutter/material.dart';
part 'app_icons.dart';
part 'color/light_color.dart';
part 'text_styles.dart';
part 'extention.dart';

class AppTheme {
  static final ThemeData apptheme = ThemeData(
      primarySwatch: Colors.blue,
      //colorScheme: ColorScheme.fromSwatch(),
      // fontFamily: 'HelveticaNeue',
      backgroundColor: TwitterColor.white,
      accentColor: TwitterColor.dodgetBlue,
      brightness: Brightness.light,
      primaryColor: AppColor.primary,
      focusColor: Colors.brown.shade700,
      cardColor: Colors.white,
      unselectedWidgetColor: Colors.grey,
      bottomAppBarColor: Colors.white,
      iconTheme: IconThemeData(color: TwitterColor.dodgetBlue),
       primaryIconTheme: IconThemeData(color: Colors.blueAccent),

      bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColor.white),
      appBarTheme: AppBarTheme(
          brightness: Brightness.light,
         // color: AppColor.primary,
         backgroundColor: Colors.brown.shade400,
          iconTheme: IconThemeData(
            color: TwitterColor.white,
          ),
          actionsIconTheme: IconThemeData(size: 30, color: Colors.white),
          elevation: 0,
          textTheme: TextTheme(
            headline5: TextStyle(
                color: Colors.black, fontSize: 26, fontStyle: FontStyle.normal),
          )),
        
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white38,
        labelStyle:
            TextStyles.titleStyle.copyWith(color: Colors.white),
       // unselectedLabelColor: AppColor.darkGrey,
        unselectedLabelStyle:
            TextStyles.titleStyle.copyWith(color: AppColor.darkGrey),
        //labelColor: TwitterColor.dodgetBlue,
        labelPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: TwitterColor.white,
      ),
      colorScheme: ColorScheme(
          background: Colors.white,
          onPrimary: Colors.white,
          onBackground: Colors.black,
          onError: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          primary: Colors.blue,
          primaryVariant: Colors.blue,
          secondary: AppColor.secondary,
          secondaryVariant: AppColor.darkGrey,
          surface: Colors.white,
          brightness: Brightness.light));


           static final ThemeData darktheme = ThemeData(
      primarySwatch: Colors.lightBlue,
      // fontFamily: 'HelveticaNeue',
      backgroundColor: TwitterColor.black,
      accentColor: TwitterColor.spindle,
      brightness: Brightness.dark,
      primaryColor: AppColor.lightGrey,
      focusColor: Colors.amberAccent,
      cardColor: Colors.grey,
      unselectedWidgetColor: Colors.white,
      bottomAppBarColor: Colors.black,
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: AppColor.darkGrey),
      appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          color: AppColor.lightGrey,
          iconTheme: IconThemeData(
            color: TwitterColor.black,
          ),
          elevation: 0,
          textTheme: TextTheme(
            headline5: TextStyle(
                color: Colors.white, fontSize: 26, fontStyle: FontStyle.normal),
          )),
      tabBarTheme: TabBarTheme(
         indicatorSize: TabBarIndicatorSize.label,
        labelStyle:
            TextStyles.titleStyle.copyWith(color: TwitterColor.paleSky),
        unselectedLabelColor: AppColor.lightGrey,
        unselectedLabelStyle:
            TextStyles.titleStyle.copyWith(color: AppColor.lightGrey),
        labelColor: TwitterColor.woodsmoke,
        labelPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: TwitterColor.black,
      ),
      colorScheme: ColorScheme(
          background: Colors.black,
          onPrimary: Colors.black,
          onBackground: Colors.white,
          onError: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          error: Colors.deepOrange,
          primary: Colors.purple,
          primaryVariant: Colors.purple,
          secondary: AppColor.lightGrey,
          secondaryVariant: AppColor.white,
          surface: Colors.black,
          brightness: Brightness.dark));

  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(
        blurRadius: 10,
        offset: Offset(5, 5),
        color: AppTheme.apptheme.accentColor,
        spreadRadius: 1)
  ];
  static BoxDecoration softDecoration = BoxDecoration(boxShadow: <BoxShadow>[
    BoxShadow(
        blurRadius: 8,
        offset: Offset(5, 5),
        color: Color(0xffe2e5ed),
        spreadRadius: 5),
    BoxShadow(
        blurRadius: 8,
        offset: Offset(-5, -5),
        color: Color(0xffffffff),
        spreadRadius: 5)
  ], color: Color(0xfff1f3f6));
}

String get description {
  return '';
}
