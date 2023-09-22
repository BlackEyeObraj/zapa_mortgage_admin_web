import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/borrower_dicussion_message_dialog.dart';
import '../../controllers/borrower_discussion_view_controller.dart';
import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/dialogs/remarks_and_notes_dialog.dart';
import '../../utils/utils_mehtods.dart';

class BorrowerDiscussionView extends GetView<BorrowerDiscussionViewController>{
  final String borrowerId;
  final String adminId;
  final String borrowerName;
  final String borrowerPhoneNumber;

  BorrowerDiscussionView({required this.borrowerId,required this.adminId,required this.borrowerName,required this.borrowerPhoneNumber});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BorrowerDiscussionViewController(),
        builder: (controller){
        return Scaffold(
          body: Column(
            children: [
              Container(
                  width: Get.width * 1,
                  height: Get.height * .1,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'Borrower Discussions',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: AppColors.textColorWhite
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (){
                            // FundDialog().addFundDialog(borrowerId);
                            BorrowerDiscussionMessageDialog().addMessageDialog(borrowerId,borrowerName,borrowerPhoneNumber);

                          },
                          child: Container(
                            height: Get.height * 1,
                            width: 180,
                            decoration: BoxDecoration(
                                color: AppColors.secondaryColor,
                                borderRadius: BorderRadius.circular(10000)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.add,color: AppColors.whiteColor,),
                                Text('Add New Message',style: TextStyle(color: AppColors.textColorWhite),)
                              ],
                            ),
                          ).paddingOnly(top: 16,bottom: 16,right: 16),
                        ),
                      )
                    ],
                  ),

              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirestoreService().getMessages(borrowerId).snapshots(),
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
                        bool isSharedWithNotEmpty = data['sharedWith'] != null && data['sharedWith'].isNotEmpty;
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
                                    SizedBox(width: 16,),
                                    isSharedWithNotEmpty
                                        ? Row(
                                      children: [
                                        Text(
                                          'Shared with: ',
                                          softWrap: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.textColorBlack,
                                          ),
                                        ),
                                        Text(
                                          // Assuming 'sharedWith' is a List<String>
                                          data['sharedWith'].join(', '), // Join array elements into a single string
                                          softWrap: true,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ) : SizedBox(),
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

                                    adminId == data['adminId']? Row(
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            BorrowerDiscussionMessageDialog().editMessageDialog(borrowerId,data['id'], data['message']);
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
                                            BorrowerDiscussionMessageDialog().deleteMessageDialog(
                                                borrowerId,data['id']
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
                                    ):const SizedBox(),

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
                ),
              ),
            ],
          ),
        );
        }
    );
  }

}