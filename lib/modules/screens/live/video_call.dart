import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/Notification/preview_notification.dart';
import 'package:bclose/modules/screens/live/chat.dart';
import 'package:bclose/modules/screens/sos/edit_user.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class VideoCall_Page extends StatefulWidget {

  @override
  _VideoCall_Page  createState() => _VideoCall_Page();
}

class _VideoCall_Page extends State<VideoCall_Page> {


  late List<String> sosUser;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sosUser = [

      "packages/bclose/assets/device/ic_device_oximetro.png",
      "packages/bclose/assets/device/ic_pressao.png",
      "packages/bclose/assets/device/ic_device_balança.png",
      "packages/bclose/assets/device/ic_device_fit_band.png",

      "packages/bclose/assets/icons/ic_mais_dispositivpo.png",
    ];

  }

  _onAtiveBlue(String command){
    setState(() {


    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      appBar: AppBar(
        backgroundColor: AppColors.GREEN.withAlpha(95),
        iconTheme: IconThemeData(
          color: AppColors.Blue, //change your color here
        ),
        centerTitle: false,
        title:Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              CircleAvatar(
                //child: Image.asset(name),
                backgroundColor: AppColors.White,
                radius: 20,
                backgroundImage: AssetImage(
                  'packages/bclose/assets/icons/ic_gree_interrogacao.png',

                ),
              ),
              SizedBox(width: 8,),
              CircleAvatar(
                //child: Image.asset(name),
                backgroundColor: AppColors.White,
                radius: 20,
                backgroundImage: AssetImage(
                  'packages/bclose/assets/icons/ic_gree_partilhar.png',

                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              // Get.to(Profile_page());
            },
            child: Row(
              children: [
                Container(

                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    //child: Image.asset(name),
                      radius: 50,
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
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: AppColors.White,
          child: Column(
            children: [
              Container(
                height: 30,
                width: Get.width,
                color: AppColors.Blue,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    flex: 1,
                      child: UILabels.Regular(text: "VIDEOCUNSULTAS DE HOJE", textLines: 1,fontSize: 14,textAlign: TextAlign.left,)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: UILabels.Regular(text: "SELECIONE A CUNSULTA QUE PRETENDE REALIZAR", textLines: 2,fontSize: 14,textAlign: TextAlign.left,color: AppColors.Black,),
              ),

              Expanded(
                flex: 1,
                child: new ListView.builder(
                  shrinkWrap: true,
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          // Get.to();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: false,
                              builder: (context) => Chat_Page( position: 1,),
                            ),
                          );
                        });
                      },
                      child: Column(
                        children: [

                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Container(
                              height: 60,
                              width: Get.width,
                              color: AppColors.Gray3,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Expanded(
                                flex:1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex:1,
                                            child: UILabels(text: "09:00", textLines: 1,color: AppColors.Black,textAlign: TextAlign.left,)),

                                        UILabels(text: "09:00", textLines: 1,color: AppColors.Black,)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    UILabels.Bold(text: "Tomar Ben-u-ron" , textLines: 1,color: AppColors.Black,)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                  },
                ),
              ),

              SizedBox(height: 16,),
              Image.asset(
                'packages/bclose/assets/icons/ic_filmar.png',
                width: 80,
                // height: Get.width/2 -32,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16,),
            ],

          ),
        ),
      ),
    );
  }
}


