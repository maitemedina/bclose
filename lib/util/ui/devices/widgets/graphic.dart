
import 'package:bclose/bluetooth/services/bluetooth_serveces.dart';
import 'package:bclose/constants/app_colors.dart';
import 'package:bclose/modules/objects/oximeter.dart';
import 'package:bclose/modules/screens/reusables/devices/controller/device_controller.dart';
import 'package:bclose/util/helpers/helpers.dart';
import 'package:bclose/widgets/ui_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class UIGraphc extends StatelessWidget {
  BluetoothServices deviceController =  Get.find();

  loadUserInfo(){


    deviceController.onLoadData();
  }
  @override

  Widget build(BuildContext context) {
    loadUserInfo();
    return Obx(()=> Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(

          width: Get.width,
          color: AppColors.Gray3,
          alignment: Alignment.center,


          child: deviceController.OXIMETRO_SAVE.length > 0? Column(
            children: [

              Container(
                height: 40,
                width: Get.width,
                color: AppColors.Blue,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          flex:1 ,
                          child: UILabels.Regular(text: "OXIMETRO", textLines: 1,fontSize: 16,textAlign: TextAlign.left,)
                      ),
                      // UILabels.Regular(text: Util.parseDataH(deviceController.OXIMETRO_READING[0].timestamp.toString(),), textLines: 1,fontSize: 16,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32,),
              if(deviceController.OXIMETRO_SAVE.length > 0)
              Container(
                width: Get.width,
                height: 350,
                child: Column(
                    children: [
                      //Initialize the chart widget

                      SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          // Chart title
                          title: ChartTitle(text: ''),
                          // Enable legend
                          legend: Legend(isVisible: true),
                          // Enable tooltip
                          tooltipBehavior: TooltipBehavior(enable: true),



                          series: <ChartSeries<OximeterMeasurement, String>>[
                            LineSeries<OximeterMeasurement, String>(
                                dataSource: deviceController.OXIMETRO_SAVE,
                                xValueMapper: (OximeterMeasurement sales, _) => sales.timestampRegister.second.toString(),
                                yValueMapper: (OximeterMeasurement sales, _) => double.parse(sales.saturation.toString()) ,
                                name: 'Sp02',
                                color: AppColors.Blue,
                                width: 3,
                                markerSettings: MarkerSettings(borderColor: AppColors.White,isVisible: true,color: AppColors.Blue),
                                // Enable data label
                                dataLabelSettings: DataLabelSettings(isVisible: true)),
                            LineSeries<OximeterMeasurement, String>(
                                dataSource: deviceController.OXIMETRO_SAVE,
                                xValueMapper: (OximeterMeasurement sales, _) => sales.timestampRegister.second.toString(),
                                yValueMapper: (OximeterMeasurement sales, _) => double.parse(sales.pulseRate.toString()) ,
                                name: 'Bpm',
                                color: AppColors.GREEN,
                                width: 3,

                                markerSettings: MarkerSettings(borderColor: AppColors.White,isVisible: true,color: AppColors.GREEN),

                                // Enable data label
                                dataLabelSettings: DataLabelSettings(isVisible: true)
                            )
                          ]),
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     //Initialize the spark charts widget
                      //     child: SfSparkLineChart.custom(
                      //       //Enable the trackball
                      //       trackball: SparkChartTrackball(
                      //           activationMode: SparkChartActivationMode.tap),
                      //       //Enable marker
                      //       marker: SparkChartMarker(
                      //           displayMode: SparkChartMarkerDisplayMode.all),
                      //       //Enable data label
                      //       labelDisplayMode: SparkChartLabelDisplayMode.all,
                      //       xValueMapper: (int index) => data[index].year,
                      //       yValueMapper: (int index) => data[index].sales,
                      //       dataCount: 5,
                      //     ),
                      //   ),
                      // )
                    ]),
              )

            ],
          ) :
          Center(child: CircularProgressIndicator(color: AppColors.Blue,),),
        ),
        SizedBox(height: 8,),
        if(deviceController.OXIMETRO_SAVE.length>0)
          Column(
            children: [
              UILabels.Regular(text: "Ultima Leitura em: ${Util.parseData(deviceController.OXIMETRO_SAVE.last.timestampRegister.toString())}", textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.Black,),
              SizedBox(height: 16,),
              Container(
                color: AppColors.White,
                padding: const EdgeInsets.all(8.0),
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppColors.Black,
                        padding: const EdgeInsets.all(8.0),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
                        child: Row(
                          children: [
                            UILabels.Bold(text: deviceController.OXIMETRO_SAVE.last.saturation.toString(), textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
                            UILabels.Regular(text: "Spo2", textLines: 1,fontSize: 12,textAlign: TextAlign.left,color: AppColors.White,),
                          ],
                        ),

                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppColors.Black,
                        padding: const EdgeInsets.all(8.0),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
                        child: Row(
                          children: [
                            UILabels.Bold(text: deviceController.OXIMETRO_SAVE.last.perfusion.toString(), textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
                            UILabels.Regular(text: "%PI", textLines: 1,fontSize: 12,textAlign: TextAlign.left,color: AppColors.White,),
                          ],
                        ),

                      ),
                    ),
                    SizedBox(width: 8,),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: AppColors.Black,
                        padding: const EdgeInsets.all(8.0),
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, minHeight: MediaQuery.of(context).size.height),
                        child: Row(
                          children: [
                            UILabels.Bold(text: deviceController.OXIMETRO_SAVE.last.pulseRate.toString(), textLines: 1,fontSize: 16,textAlign: TextAlign.left,color: AppColors.White,),
                            UILabels.Regular(text: "Pulso", textLines: 1,fontSize: 12,textAlign: TextAlign.left,color: AppColors.White,),
                          ],
                        ),

                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

      ],
    ),
    );
  }

}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}