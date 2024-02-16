import 'package:flutter/material.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/ui/page/common/splash.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_flat_button.dart';
import 'package:racfmn/widgets/newWidget/title_text.dart';

class UpdateApp extends StatefulWidget {
  const UpdateApp({Key? key}) : super(key: key);

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SplashPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/icon-480.png'),
            TitleText(
              'New Update is available',
              fontSize: 25,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TitleText(
              '''The current version of app is no longer supported. 
              We aploigize for any inconveiience we may have caused you''',
              fontSize: 14,
              color: AppColor.darkGrey,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Container(
              width: context.width,
              margin: EdgeInsets.symmetric(vertical: 35),
              child: CustomFlatButton(
                label: 'Update now',
                onPressed: () {
                  Utility.launchURL(
                      'https://play.google.com/store/apps/details?id=com.thealphamerc.racfmn');
                },
                borderRadius: 30,
              ),
            )
          ],
        ),
      ),
    );
  }
}
