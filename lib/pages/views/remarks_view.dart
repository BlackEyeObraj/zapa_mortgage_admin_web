import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/remarks_view_controller.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/remarks_and_notes_dialog.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/utils_mehtods.dart';

class RemarksView extends GetView<RemarksViewController>{
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: RemarksViewController(),
        builder: (controller){
        return Column(
          children: [
            Expanded(
              flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: Get.height * .06,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor
                          ),
                            onPressed: (){
                          RemarksAndNotesDialog().addRemarksAndNotesDialog();
                        }, child: Text('Add New Remark/Note',style: TextStyle(fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  ],
                ).marginSymmetric(horizontal: 16)
            ),
            Expanded(
              flex: 9,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirestoreService().getRemarksAndNotes().snapshots(),
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
                          Text('No Remarks or Notes Found.'),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Added By: ',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.textColorBlack
                                      ),
                                    ),
                                    Text(
                                      data['addedBy'],
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.primaryColor
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                    'Added On: ',
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: AppColors.textColorBlack
                                      ),
                                    ),
                                    Text(
                                    UtilMethods().parseFirestoreTimestamp(data['addedDateTime']),
                                      softWrap: true,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: AppColors.primaryColor
                                      ),
                                    ),
                                    SizedBox(width: 8,),

                                    Obx(() => controller.userId.value == data['userId']? Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            RemarksAndNotesDialog().editRemarksAndNotesDialog(data['id'], data['remarkAndNote']);
                                          },
                                          child: Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green
                                            ),
                                            child: Center(
                                              child: Icon(Icons.edit,color: AppColors.whiteColor,size: 18,),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8,),
                                        InkWell(
                                          onTap: (){
                                            RemarksAndNotesDialog().deleteRemarksAndNotesDialog(
                                              data['id']
                                            );
                                          },
                                          child: Container(
                                            width: 34,
                                            height: 34,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.red
                                            ),
                                            child: Center(
                                              child: Icon(Icons.delete,color: AppColors.whiteColor,size: 18,),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ):const SizedBox()),

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
                                      data['remarkAndNote'],
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
                ),
            ),
          ],
        );
        }
    );
  }

}