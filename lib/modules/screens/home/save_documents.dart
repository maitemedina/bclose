

import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/home/controler/documents_controller.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/confirm_media.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_textFields.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SaveDocuments_Page extends StatefulWidget {

  final List<File> img;
  final String sub_title;
  final String nomeFile;

  const SaveDocuments_Page({Key? key, required this.img, required this.sub_title, required this.nomeFile}) : super(key: key);


  @override
  _SaveDocuments_Page  createState() => _SaveDocuments_Page();
}

class _SaveDocuments_Page extends State<SaveDocuments_Page> {
  DocumentsController documentsController =  Get.find();

  final TextEditingController fileName = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }



  _onSave(String command){
    if(fileName.text!=""){

      documentsController.saveDoc(widget.img,fileName.text,widget.nomeFile, context);

    }else{
      Services().pushAlert('Nome e de prenchimento obrigatório.',context);
    }
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

        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Obx(() => Stack(
        children: [
          Container(
            // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
            color: AppColors.Black.withOpacity(0.5),
            alignment: Alignment.center,
            child: Container(
              width: Get.width,
              padding: EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: AppColors.White,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child:Column(
                children: [
                  UILabels.Bold(text: "Nome do ficheiro", textLines: 4,color: AppColors.Blue, textAlign: TextAlign.left,),
                  SizedBox(height: 8,),
                  Container(
                    padding: const EdgeInsets.all(0.0),

                    decoration: BoxDecoration(
                      color: AppColors.Gray3,
                      borderRadius: BorderRadius.circular(8.0),


                    ),
                    child: UITextFields(text:"Nome",inputText: fileName, prefix_Icon: Icon(Icons.supervised_user_circle),),

                  ),
                  SizedBox(height: 16,),
                  Image.file(widget.img[0],
                    fit: BoxFit.cover,
                    width: Get.width,
                    height: 220,),
                  SizedBox(height: 16,),
                  UILabels(text: widget.sub_title, textLines: 4,color: AppColors.Black,),
                  SizedBox(height: 16,),
                  Container(
                      height: 40,
                      margin: EdgeInsets.fromLTRB(16, 0, 16, 10),

                      child: UIBottons(
                        labels: UILabels.Bold(
                          text: "Gravar",
                          fontSize: 16,
                          textLines: 1,
                          color: AppColors.White,
                        ),
                        cb: _onSave,
                        color: AppColors.Blue, colorList: [AppColors.Blue],
                      )),

                ],
              ),
            ),
          ),
          if(documentsController.loading.value)
            UIRequestAlert(cb: (value){documentsController.loading.value=false;}, title: 'Bhealth', sub_title: 'Gravar',)
        ],
      )
    )
    );
  }
}


