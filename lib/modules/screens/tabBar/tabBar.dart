

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/core/shared_preference/interface_shared_preference.dart';
import 'package:bclose/core/shared_preference/shared_preference_service.dart';
import 'package:bclose/modules/screens/Notification/notification.dart';
import 'package:bclose/modules/screens/Notification/preview_notification.dart';
import 'package:bclose/modules/screens/calender/calender.dart';
import 'package:bclose/modules/screens/home/home.dart';
import 'package:bclose/modules/screens/live/live.dart';
import 'package:bclose/modules/screens/reusables/profile/profile.dart';
import 'package:bclose/modules/screens/sos/sos.dart';
import 'package:bclose/util/mixins/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class TabBarHomePage extends StatefulWidget {

  @override
  _TabBarHomePageState createState() => _TabBarHomePageState();
}

class _TabBarHomePageState extends State<TabBarHomePage> {
  int currentTabIndex = 0;
  static const double _kTabBarHeight = 172.0;
  ScreenshotController screenshotController = ScreenshotController();
  static ILocalStorage localStorage = new PrefsLocalStorageService();
  TabController? tabController;
  var base64image = "";
  final GlobalKey _key = GlobalKey();

  // onTapped(int index) {
  //   setState(() {
  //     print(index);
  //     if(index == 4){
  //       launch("https://www.abola.pt");
  //     }else{
  //       currentTabIndex = index;
  //     }
  //
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingUser();


  }

  loadingUser(){
    setState(()  {

       localStorage.get("image").then((value) => value.toString()).then((value) =>
           setState(() {
             print("image");
             print(value);
             print("image");
             base64image = value;
           })

       );
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(_kTabBarHeight);

  List<Widget> tabs = [
    Home_Page(),
    Calender_Page(),
    Sos_Page(),
    Live_Page(),
    Live_Page(),
  ];

  Widget customBottomNavigationBar(BuildContext context){
    double myHeight = 70.0;//Your height HERE
    return SafeArea(
      child: SizedBox(
        height: myHeight,
        width: MediaQuery.of(context).size.width,
        child:Container(
          color: AppColors.GREEN,
          child: TabBar(
            tabs: [
              Tab(
                icon:
                Image.asset(
                  'packages/bclose/assets/tabBar/ic_home_b.png',
                   width: 55,
                   height: 55,
                   ),

              ),
              Tab(
                icon:
                Image.asset(
                  'packages/bclose/assets/tabBar/ic_calender.png',
                  width: 40,
                  height: 40,
                ),
              ),
              Tab(
                icon:
                Image.asset(
                  'packages/bclose/assets/tabBar/ic_sos.png',
                  width: 40,
                  height: 40,
                ),
              ),
              Tab(
                icon:
                GestureDetector(
                  onTap: () async {
                    await launch("https://www.bclose.pt/pt/mylife/");
                    // print("https://www.abola.pt");

                  },
                  child: Image.asset(
                    'packages/bclose/assets/tabBar/ic_my_bclose.png',
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              Tab(
                icon:
                Image.asset(
                  'packages/bclose/assets/tabBar/ic_pessoa.png',
                  width: 40,
                  height: 40,
                ),
              ),
            ],
            labelStyle: TextStyle(fontSize: 12.0),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white30,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _key,
      child: Scaffold(
        backgroundColor: AppColors.Gray6,
        appBar: AppBar(
          backgroundColor: AppColors.GREEN.withAlpha(95),
          iconTheme: IconThemeData(
            color: AppColors.Blue, //change your color here
          ),
          centerTitle: false,
          title: Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [

                GestureDetector(
                  onTap: () async {
                    Get.to(Notification_Page());
                  },
                  child: CircleAvatar(
                    //child: Image.asset(name),
                    backgroundColor: AppColors.White,
                    radius: 25,
                    child: Image.asset(
                      'packages/bclose/assets/icons/ic_campainha.png',
                      width: 65,
                      height: 65,
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                GestureDetector(
                  onTap: (){
                    Get.to(PreviewNotification_Page());
                  },
                  child: CircleAvatar(
                    //child: Image.asset(name),
                    radius: 25,
                    backgroundColor: AppColors.White,

                    child: Image.asset(
                      'packages/bclose/assets/icons/ic_gree_fotografia.png',
                      width: 65,
                      height: 65,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                GestureDetector(
                  onTap: (){
                    _takeScreenshot();
                  },
                  child: CircleAvatar(
                    //child: Image.asset(name),
                    backgroundColor: AppColors.White,
                    radius: 25,
                    child: Image.asset(
                      'packages/bclose/assets/icons/ic_gree_partilhar.png',
                      width: 65,
                      height: 65,
                    ),

                  ),
                ),

              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                setState(() {
                  // Get.to();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      fullscreenDialog: false,
                      builder: (context) => Profile_Page(),
                    ),
                  );
                });
              },
              child: Row(
                children: [
                  Container(

                    width: 60,
                    height: 60,
                    child: base64image != "" ? CircleAvatar(
                      radius: 60,
                      backgroundImage: imageFromBase64String(base64image).image,
                      // child: imageFromBase64String(base64image),
                    )  : CircleAvatar(
                      //child: Image.asset(name),
                        radius: 60,
                        backgroundImage:NetworkImage('https://via.placeholder.com/140x100')
                    ),
                  ),
                  Icon(Icons.more_vert,color: AppColors.Black,),
                  SizedBox(width: 16,)
                ],
              ),
            ),
          ],
          elevation: 0,
          toolbarHeight: 80,
        ),
        body: DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            body: TabBarView(
              controller: tabController,
              children: tabs,
            ),
            bottomNavigationBar: customBottomNavigationBar(context),
            backgroundColor: AppColors.GREEN,
          ),
        ),


      ),
    );
  }



   _takeScreenshot() async {






    RenderRepaintBoundary boundary =
    _key.currentContext!.findRenderObject() as RenderRepaintBoundary;

    print("_takeScreenshot");

    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      // final directory = await getApplicationDocumentsDirectory();
      // final imagePath = await File('${directory.path}/image.png').create();
      // await imagePath.writeAsBytes(pngBytes);
      // await Share.file('Bhealth', 'esys.png', pngBytes, 'image/png', text: '');

      // setState(() {
      //     Services().share("imagePath.path", "Share Image");
      //   // _message = 'New screenshot successfully saved!';
      // });
    }

  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String),fit: BoxFit.scaleDown,);
  }

  Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  String base64String(Uint8List data) {
    return base64Encode(data);
  }



}

