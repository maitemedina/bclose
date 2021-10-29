

import 'dart:io';

import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/screens/home/controler/documents_controller.dart';
import 'package:bclose/modules/screens/home/preview_documents.dart';
import 'package:bclose/modules/screens/home/save_documents.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/util/mixins/services.dart';
import 'package:bclose/widgets/alert/request_alert.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class CategoreDocuments_Page extends StatefulWidget {

  final String nomeFile;

  const CategoreDocuments_Page({Key? key,required this.nomeFile}) : super(key: key);


  @override
  _CategoreDocuments_Page  createState() => _CategoreDocuments_Page();
}

class _CategoreDocuments_Page extends State<CategoreDocuments_Page> {
  DocumentsController documentsController =  Get.put(DocumentsController());
  var selectitem = 0;
  final ImagePicker _picker = ImagePicker();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    documentsController.loadingDoc(widget.nomeFile,context);


  }

  void getMediaPost() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true);
    setState(() {
      if(result != null) {

        List<File> file = [];

        for(var item in result.files){
          file.add(File(item.path.toString()));

        }
        Get.to(SaveDocuments_Page(img: file, sub_title: "Gostaria de anexar foto", nomeFile: widget.nomeFile,));
     
      }
    });
  }

  void getImagePost() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    print("camera");
    setState(() {
      Get.to(SaveDocuments_Page(img: [File(photo!.path)], sub_title: "Gostaria de anexar foto", nomeFile: widget.nomeFile,));
      // if(result != null) {
      //   tabBarController.imageFiles.value = [];
      //   var filevalue = result.paths.map((path) => File(path)).toList();
      //
      //   for(var pathUrl in filevalue)
      //     tabBarController.imageFiles.add(pathUrl);
      //   // runFlutterVideoCompressMethods(File(pathUrl.path));
      //
      // }
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

        elevation: 0,
        toolbarHeight: 80,
      ),
      body: Obx(() =>

          Stack(
            children: [
              Container(
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
                        child: UILabels.Regular(text: "Documentos ${widget.nomeFile}", textLines: 1,fontSize: 16,textAlign: TextAlign.left,),
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
                          child: documentsController.documents.length > 0 ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: documentsController.documents.length,
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
                                        height: 30,
                                        width: Get.width,
                                        color: selectitem == index ? AppColors.Blue : AppColors.White,
                                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex:1,
                                                child: UILabels.Regular(text: documentsController.documents[index].name , textLines: 1,color: selectitem == index ? AppColors.White : AppColors.Black,fontSize: 14,textAlign: TextAlign.left,)),
                                            UILabels.Regular(text: Util.parseData(documentsController.documents[index].data.toString()), textLines: 1,color: selectitem == index ? AppColors.White : AppColors.Black,fontSize: 14,),

                                          ],

                                        )
                                    ),
                                  ],
                                ),
                              );

                            },
                          )
                              : Image.asset(
                            'packages/bclose/assets/icons/ic_sem_doc.png',
                            width: 250,
                            // height: Get.width/2 -32,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 32, 0, 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          GestureDetector(
                            onTap: (){
                              getImagePost();
                              // print("camera");
                            },
                            child: Image.asset(
                              'packages/bclose/assets/icons/ic_criar_perfil_foto.png',
                              width: 80,
                              // height: Get.width/2 -32,
                              fit: BoxFit.cover,
                            ),

                          ),
                          GestureDetector(
                            onTap: (){
                              getMediaPost();
                            },
                            child: Image.asset(
                              'packages/bclose/assets/icons/ic_anexar_ficheiro.png',
                              width: 80,
                              // height: Get.width/2 -32,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Get.to(PreviewDocuments_Page(
                                nomeFile: documentsController.documents[selectitem].name,
                                img: documentsController.documents[selectitem].image,
                                idFile: documentsController.documents[selectitem].id.toString(),
                                category: documentsController.documents[selectitem].type,)
                              );
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
              if(documentsController.loading.value)
                UIRequestAlert(cb: (value){documentsController.loading.value=false;}, title: 'Bhealth', sub_title: 'A carregar as suas informações ',)
            ],
          ),
      ),
    );
  }
}


