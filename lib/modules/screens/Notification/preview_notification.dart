

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/home/categore_documents.dart';
import 'package:bclose/modules/screens/home/controler/documents_controller.dart';
import 'package:bclose/modules/screens/home/preview_documents.dart';
import 'package:bclose/modules/screens/home/save_documents.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/confirm_media.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';


class PreviewNotification_Page extends StatefulWidget {

  @override
  _PreviewNotification_Page  createState() => _PreviewNotification_Page();
}

class _PreviewNotification_Page extends State<PreviewNotification_Page> {
  DocumentsController documentsController =  Get.put(DocumentsController());
  var selectitem = 0;
  final ImagePicker _picker = ImagePicker();

  List<String> categoresDoc = ["Família","Pessoal","Análise medicas","Exames","Outros"];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.Gray6,
      appBar: AppBar(
        backgroundColor: AppColors.GREEN.withAlpha(95),
        automaticallyImplyLeading: false,
        centerTitle: false,
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
      body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30,),

              Container(
                height: 30,
                width: Get.width,
                color: AppColors.Blue,
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: UILabels.Regular(text: "Documentos", textLines: 1,fontSize: 16,textAlign: TextAlign.left,),
                ),
              ),

              Expanded(
                flex: 1,
                child: Container(
                  width: Get.width,
                  color: AppColors.Gray3,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(16.0),
                  child: Expanded(
                    flex: 1,
                    // ignore: unnecessary_null_comparison
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: categoresDoc.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              selectitem = index;
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 8,),
                              Container(
                                height: 40,
                                width: Get.width,
                                color: selectitem == index ? AppColors.Blue : AppColors.White,
                                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex:1,
                                        child: UILabels.Regular(text: categoresDoc[index] , textLines: 1,color: selectitem == index ? AppColors.White : AppColors.Black,fontSize: 14,textAlign: TextAlign.left,)),

                            ],

                                )
                              ),
                            ],
                          ),
                        );

                      },
                    )

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: (){
                         Get.to(CategoreDocuments_Page(nomeFile: categoresDoc[selectitem]));
                      },
                      child: Image.asset(
                        'packages/bclose/assets/icons/ic_ver_documentos.png',
                        width: 80,
                        // height: Get.width/2 -32,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              )

            ],

          ),
        ),

    );
  }
}


