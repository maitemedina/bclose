

import 'dart:io';

import 'package:bclose/constants/api_path.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/home/controler/documents_controller.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/ui_button.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PreviewDocuments_Page extends StatefulWidget {

  final String img;
  final String nomeFile;
  final String idFile;
  final String category;

  const PreviewDocuments_Page({Key? key, required this.img, required this.nomeFile, required this.idFile, required this.category}) : super(key: key);


  @override
  _PreviewDocuments_Page  createState() => _PreviewDocuments_Page();
}

class _PreviewDocuments_Page extends State<PreviewDocuments_Page> {
  DocumentsController documentsController =  Get.find();

  final TextEditingController fileName = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  _onDelete(String command){

    Get.defaultDialog(
      textConfirm: 'Sim',
      title: 'Apagar documento',
      onConfirm: () {

        documentsController.Delete(widget.category,widget.idFile, context);
        Navigator.pop(context, 'Found');

      },

      confirmTextColor: AppColors.White,
      onCancel: () {
        Get.close;
      },
      textCancel: 'Não',
      middleText: 'Tem certeza que quer apagar o documento?',
    );
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
        body: Container(
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
                UILabels(text: widget.nomeFile, textLines: 4,color: AppColors.Black,),
                SizedBox(height: 16,),
                Expanded(
                  flex: 1,
                  child: Image.network(ApiPath.IMG_BASE_URL+widget.img,
                    fit: BoxFit.cover,
                    width: Get.width,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: Get.width,
                        height: 176,
                        alignment: Alignment.center,
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.Blue,),
                        ),
                      );

                    },
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        debugPrint('Error loading image: $exception \n Stack trace: $stackTrace');
                        return Container(
                          width: Get.width,
                          );
                      }

                  ),
                ),
                SizedBox(height: 32,),
                Container(
                    height: 40,
                    margin: EdgeInsets.fromLTRB(16, 0, 16, 10),

                    child: UIBottons(
                      labels: UILabels.Bold(
                        text: "Apagar documento",
                        fontSize: 16,
                        textLines: 1,
                        color: AppColors.White,
                      ),
                      cb: _onDelete,
                      color: AppColors.Blue, colorList: [AppColors.Blue],
                    )),
                SizedBox(height: 16,),


              ],
            ),
          ),
        )
    );
  }
}


