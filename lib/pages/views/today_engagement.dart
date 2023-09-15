import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:zapa_mortgage_admin_web/controllers/today_engagement_controller.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/engagement_status_dialog.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/routes/route_name.dart';

class TodayEngagement extends GetView<TodayEngagementController>{
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TodayEngagementController(),
        builder: (controller){
        controller.getDate();
        return Obx(() => StreamBuilder<QuerySnapshot>(
          stream: FirestoreService().getUsersTodayEngagement(controller.date).snapshots(),
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
                  Text('No Engagement Found For Today.'),
                ],
              );
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                return Container(
                  width: Get.width * 1,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2.0
                      )
                    ],
                    border: Border.all(color: AppColors.primaryColor,width: 1),
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10000),
                            child: data['userImage'] != ''?
                            ImageNetwork(image: data['userImage'], height: 60, width: 60):
                            Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.primaryColor)
                                ),
                                child: Icon(Icons.person,color: AppColors.whiteColor,size: 28,).paddingAll(6)
                            ),
                          ).paddingSymmetric(vertical: 4),
                          // CircleAvatar(
                          //     radius: Get.height * .04,
                          //     backgroundColor: AppColors.primaryColor,
                          //     backgroundImage: data['userImage'] != ''
                          //         ?
                          //         // ? Image(image: NetworkImage(data['userImage']))
                          //         : const AssetImage(AppImages.noUserImage) as ImageProvider
                          // ),

                          SizedBox(width: Get.width * .01,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Borrower Name: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(text: data['userName'] != ''?data['userName']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              RichText(
                                text: TextSpan(
                                  text: 'Phone Number: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(text: data['phoneNumber'], style: TextStyle(fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              RichText(
                                text: TextSpan(
                                  text: 'Nick Name: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(text: data['nickName'] != ''?data['nickName']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                            ],
                          ).paddingSymmetric(vertical: 8)
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Engagement Date & Time: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(text: data['nextEngagement'] != ''?data['nextEngagement']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              RichText(
                                text: TextSpan(
                                  text: 'Engagement Status: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    TextSpan(text: data['engagementStatus'] != ''?data['engagementStatus']:'Not Engaged Yet.', style: TextStyle(fontWeight: FontWeight.bold,color: data['engagementStatus'] != ''?AppColors.greenColor:AppColors.errorTextColor)),

                                  ],
                                ),
                              ),
                              SizedBox(height: 8,),
                              data['engagementStatus'] != 'Engaged'? InkWell(
                                onTap: ()async{
                                  EngagementStatusDialog().showDialog(data['userId'],data['userName'],data['phoneNumber']);
                                },
                                child: Container(
                                  height: Get.height * .04,
                                  decoration: BoxDecoration(
                                    color: AppColors.greenColor,
                                    border: Border.all(color: AppColors.greenColor,width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(child: Text('Change Status to Engaged',style: TextStyle(color: AppColors.textColorWhite,
                                      fontWeight: FontWeight.bold),).paddingSymmetric(horizontal: 4)),
                                ),):SizedBox(),
                            ],
                          ).paddingSymmetric(vertical: 8)
                        ],
                      ),

                      Column(
                        children: [

                          InkWell(
                            onTap: ()async{
                              Get.toNamed(RouteName.userDetailScreen,arguments: {'borrowerId': data['userId'],'borrowerPhoneNumber': data['phoneNumber'],'borrowerUserName':data['userName']});
                            },
                            child: MouseRegion(
                              onEnter: (_) => controller.setHoverOption(data['phoneNumber']),
                              onExit: (_) => controller.setHoverOption(''),
                              child: Obx(() => Container(
                                width: Get.width * .1,
                                height: Get.height * .04,
                                decoration: BoxDecoration(
                                  color: controller.onHover == data['phoneNumber']?AppColors.primaryColor:AppColors.transparentColor,
                                  border: Border.all(color: AppColors.primaryColor,width: 1),
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Center(child: Text('View Details',style: TextStyle(color: controller.onHover == data['phoneNumber']?AppColors.whiteColor:AppColors.primaryColor,
                                    fontWeight: FontWeight.bold),)),
                              ),),
                            ),
                          ),


                        ],
                      )
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ).paddingOnly(top: 16);
              },
            ).paddingSymmetric(horizontal: 16,vertical: 16);
          },
        ));
        }
    );
  }

}