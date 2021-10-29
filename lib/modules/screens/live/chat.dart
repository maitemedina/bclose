import 'dart:async';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'live_controller/chat_controller.dart';
import 'live_controller/live_controller.dart';

class Chat_Page extends StatefulWidget {
  final int position;

  const Chat_Page({Key? key, required this.position}) : super(key: key);
  @override
  _Chat_Page createState() => _Chat_Page();
}

class _Chat_Page extends State<Chat_Page> {
  LiveController liveController = Get.find();
  ChatController chatController = Get.put(ChatController());
  final TextEditingController _chatValue = new TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatController.loadingConversation(context,liveController.userSos[widget.position].userId.toString(),liveController.userSos[widget.position].name.toString());
    _timer = new Timer.periodic(Duration(seconds: 8),
            (Timer timer) => chatController.loadingConversation(context,liveController.userSos[widget.position].userId.toString(),liveController.userSos[widget.position].name.toString())
    );

  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      appBar: AppBar(
        backgroundColor: AppColors.GREEN.withAlpha(95),
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [

              GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: CircleAvatar(
                  child: Image.asset('packages/bclose/assets/device/ic_back.png',
                    height: 65,width: 65,),
                  backgroundColor: AppColors.White,
                  radius: 25,

                ),
              ),
              SizedBox(width: 8,),
              CircleAvatar(
                child: Image.asset('packages/bclose/assets/icons/ic_gree_interrogacao.png',
                  height: 65,width: 65,),
                backgroundColor: AppColors.White,
                radius: 25,

              ),
              SizedBox(width: 8,),
              CircleAvatar(child: Image.asset('packages/bclose/assets/icons/ic_gree_partilhar.png',
                height: 65,width: 65,),
                backgroundColor: AppColors.White,
                radius: 25,
              ),
            ],
          ),
        ),
        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Obx(()=> Container(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(liveController.userSos[widget.position].image,
                       ),
                      backgroundColor: AppColors.White,
                      radius: 20,

                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      flex: 1,
                      child: Container(
                          width: Get.width,
                          child: UILabels.Bold(
                            text: "${liveController.userSos[widget.position].name}",
                            textLines: 2,
                            fontSize: 14,
                            textAlign: TextAlign.left,
                            color: AppColors.Black,
                          )),
                    ),
                  ],
                ),
                Container(
                    width: Get.width,
                    child: UILabels.Regular(
                      text: liveController.userSos[widget.position].number,
                      textLines: 2,
                      fontSize: 14,
                      textAlign: TextAlign.left,
                      color: AppColors.Black,
                    )),
                SizedBox(height: 8,),
                Container(
                  height: 30,
                  width: Get.width,
                  color: AppColors.Blue,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                        flex: 1,
                        child: UILabels.Regular(
                          text: "CHAT",
                          textLines: 1,
                          fontSize: 14,
                          textAlign: TextAlign.left,
                        )),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppColors.Gray3,
                    child: new ListView.builder(
                      shrinkWrap: true,
                      itemCount: chatController.conversation.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                //send
                                if(chatController.conversation[index].patientId != chatController.conversation[index].sender)
                                Column(
                                  children: [
                                    Container(
                                      width: Get.width - 40,
                                      alignment: Alignment.centerLeft,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          color: AppColors.Blue,
                                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                          child: UILabels.Regular(text: chatController.conversation[index].message, textLines: 100,textAlign: TextAlign.left,),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16,),
                                  ],
                                ),
                                if(chatController.conversation[index].patientId == chatController.conversation[index].sender) // receive
                                Column(
                                  children: [
                                    Container(
                                      width: Get.width - 40,
                                      alignment: Alignment.centerRight,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          color: AppColors.White,

                                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                          child: UILabels.Regular(text: chatController.conversation[index].message, textLines: 100,textAlign: TextAlign.left,color: AppColors.Black,),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  color: AppColors.Gray3,
                  padding:  EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    children: [
                      // SizedBox(width: 8,),
                      // Image.asset(
                      //   'packages/bclose/assets/icons/ic_anexar.png',
                      //   width: 30,
                      //   // height: Get.width/2 -32,
                      //   color: AppColors.Black,
                      //   fit: BoxFit.cover,
                      // ),
                      // SizedBox(width: 8,),
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: AppColors.White,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      controller: _chatValue,
                                      maxLines: 4,
                                      minLines: 1,
                                      onChanged: (text) {
                                        setState(() {

                                        });
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Escrever aqui...",
                                          hintStyle: TextStyle(color: Colors.black54),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                                GestureDetector(child: Icon(Icons.send),onTap: (){
                                  if(_chatValue.text != ""){
                                  chatController.SendSMS(context,liveController.userSos[widget.position].userId.toString(),_chatValue.text,liveController.userSos[widget.position].name.toString(),liveController.userSos[widget.position].id.toString());
                                  setState(() {
                                    _chatValue.text = "";
                                  });
                                  }
                                }
                                ,),

                                SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
