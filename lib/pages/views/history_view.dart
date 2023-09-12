import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/history_view_controller.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/utils_mehtods.dart';

class HistoryView extends GetView<HistoryViewController>{
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HistoryViewController(),
        builder: (controller){
          return Column(
            children: [
              SizedBox(
                height: 60,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1,color: AppColors.primaryColor),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          Text('Filter By Date: ',style: TextStyle(fontWeight: FontWeight.bold),),
                          Obx(() => Text('${controller.pickedDate.value.isEmpty?'none':controller.pickedDate.value}',style: TextStyle(fontWeight: FontWeight.normal),),),
                          IconButton(onPressed: ()async{
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2000), // Minimum allowable date
                              lastDate: DateTime.now(), initialDate: DateTime.now(), // Maximum allowable date
                            );
                            if (picked != null) {
                              controller.pickedDate.value = '${picked.day}/${picked.month}/${picked.year}';
                            }
                          }, icon: Icon(Icons.calendar_month,color: AppColors.secondaryColor,))
                        ],
                      ).paddingSymmetric(horizontal: 8),
                    ),
                    Obx(() =>controller.pickedDate.value.isNotEmpty? IconButton(onPressed: (){
                      controller.pickedDate.value = '';
                    }, icon: Icon(Icons.cancel,color: AppColors.errorTextColor,)):SizedBox())

                  ],
                ),
              ).paddingSymmetric(horizontal: 16),
              Expanded(
                child:Obx(() => StreamBuilder<QuerySnapshot>(
                  stream:FirestoreService().getHistory(controller.pickedDate.value).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    if (documents.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel,size: 100,color: AppColors.greyColor,),
                          SizedBox(height: 16,),
                          Text('No history Yet.'),
                        ],
                      );
                    }
                    return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Action On: ',
                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: AppColors.textColorBlack
                                      ),
                                    ),
                                    Text(
                                      UtilMethods().parseFirestoreTimestamp(data['timestamp']),
                                      softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: AppColors.primaryColor
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: Get.width * 1,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                border: Border.all(color: AppColors.primaryColor, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0), // Add padding for better appearance
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['message'],
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ).paddingOnly(top: 4),
                          ],
                        ).paddingOnly(top: 16);
                      },
                    ).paddingSymmetric(horizontal: 16,vertical: 16);
                  },
                ),),
              ),
            ],
          );
        }
    );
  }

}