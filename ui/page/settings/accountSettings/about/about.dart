import 'package:flutter/material.dart';
import 'package:racfmn/helper/constant.dart';
import 'package:racfmn/helper/utility.dart';
import 'package:racfmn/ui/page/settings/widgets/headerWidget.dart';
import 'package:racfmn/ui/page/settings/widgets/settingsRowWidget.dart';
import 'package:racfmn/ui/theme/theme.dart';
import 'package:racfmn/widgets/custom_app_bar.dart';
import 'package:racfmn/widgets/custom_widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar: AppBar(
        
        title: customTitleText(
          'About ${Constants.appName}',
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: <Widget>[
          HeaderWidget(
            'Intro...',
          ),
           SizedBox(height: 20),
          customText("Icademy is an electronic library app that offers online learning for those in academia.", 
          style: TextStyle(fontSize: 16)),
             SizedBox(height: 3),
            
           customText("So if you are in search of an electronic library that is not just a reservoir of knowledge, cutting across discipline but also has magical features and tools? You guess what? You just hit the jackpot with Icademy.", 
           overflow: TextOverflow.clip, style: TextStyle(height: 2, fontSize: 16)),
          

            SizedBox(height: 30),
          HeaderWidget('Vision'),
          
            SizedBox(height:20),

    customText("Access at will for all, knowledge beyond bounds to grasp", style: TextStyle(height: 2, fontSize: 16)),    
                 SizedBox(height: 16),
               HeaderWidget('Mission'),
               SizedBox(height: 20),
                customText('''=>) To provide premium and featured materials''', style: TextStyle(height: 2, fontSize: 15)),
                SizedBox(height: 2),
                customText('''=>) To promote research''', style: TextStyle(height: 2, fontSize: 15)),
                SizedBox(height: 2),
                customText('''=>) To facilitate knowledge accessability''', style: TextStyle(height: 2, fontSize: 15)),
                 SizedBox(height: 20),

        
          HeaderWidget('Slogan'),
         customText("feed your mind, be priceless"),
          SizedBox(height: 20),
          HeaderWidget('Developer'),
          customText('''Name:  Rockling Anayo Einstein''',style: TextStyle(height: 2, fontSize: 15) ),
          customText('''Contact: rocklinganayo@lordsignet.org''', style: TextStyle(height: 2, fontSize: 15))
          
        ],
      ),
    );
  }
}
