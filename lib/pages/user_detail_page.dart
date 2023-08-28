import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zapa_mortgage_admin_web/controllers/user_detail_page_controller.dart';
import 'package:zapa_mortgage_admin_web/pages/views/borrower_discussion_view.dart';
import 'package:zapa_mortgage_admin_web/pages/views/fico_view.dart';
import 'package:zapa_mortgage_admin_web/pages/views/funds_view.dart';
import 'package:zapa_mortgage_admin_web/pages/views/income_view.dart';
import 'package:zapa_mortgage_admin_web/pages/views/liability_view.dart';
import 'package:zapa_mortgage_admin_web/pages/views/summary_view.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/utils/constants.dart';

import '../res/app_images.dart';

class UserDetailPage extends GetView<UserDetailPageController>{
  const UserDetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UserDetailPageController(),
        builder: (controller){
          return Scaffold(
            body: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: SizedBox(
                        child:Stack(
                          children: [
                            SizedBox(
                              width: Get.width * 1,
                              height: Get.height * 1,
                              child: Image.asset(AppImages.bgOne,height: Get.height * 1,fit: BoxFit.cover,),
                            ),
                            Container(
                              width: Get.width * 1,
                              height: Get.height * 1,
                              color: AppColors.blackColor.withOpacity(.6),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back,
                                    color: AppColors.whiteColor,)),
                                    Text('Borrower Details',
                                      style: TextStyle(color: AppColors.textColorWhite,
                                          fontSize: 24,fontWeight: FontWeight.bold),),
                                  ],
                                ).paddingAll(16),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            controller.setTabOption('Summary');
                                          },
                                          child: MouseRegion(
                                            onEnter: (_) => controller.setHoverOption('Summary', true),
                                            onExit: (_) => controller.setHoverOption('Summary', false),
                                            child:Obx(() => Container(
                                              width: Get.width * 1,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: controller.summaryOptionHover || controller.selectedTab == 'Summary'?AppColors.whiteColor:AppColors.transparentColor,
                                                  border: Border.all(color: AppColors.whiteColor),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.person,color: controller.ficoOptionHover || controller.selectedTab == 'FICO'?AppColors.primaryColor:AppColors.whiteColor,),
                                                  // const SizedBox(width: 16,),
                                                  Text('Summary',style: TextStyle(color: controller.summaryOptionHover || controller.selectedTab == 'Summary'?AppColors.primaryColor:AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,fontSize: 16),)
                                                ],
                                              ),
                                            ),),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            controller.setTabOption('FICO');
                                          },
                                          child: MouseRegion(
                                            onEnter: (_) => controller.setHoverOption('FICO', true),
                                            onExit: (_) => controller.setHoverOption('FICO', false),
                                            child:Obx(() => Container(
                                              width: Get.width * 1,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: controller.ficoOptionHover || controller.selectedTab == 'FICO'?AppColors.whiteColor:AppColors.transparentColor,
                                                  border: Border.all(color: AppColors.whiteColor),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.person,color: controller.ficoOptionHover || controller.selectedTab == 'FICO'?AppColors.primaryColor:AppColors.whiteColor,),
                                                  // const SizedBox(width: 16,),
                                                  Text('FICO',style: TextStyle(color: controller.ficoOptionHover || controller.selectedTab == 'FICO'?AppColors.primaryColor:AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,fontSize: 16),)
                                                ],
                                              ),
                                            ),),
                                          ),
                                        ).marginOnly(top: 16),
                                        InkWell(
                                          onTap: (){
                                            controller.setTabOption('Income');
                                          },
                                          child: MouseRegion(
                                            onEnter: (_) => controller.setHoverOption('Income', true),
                                            onExit: (_) => controller.setHoverOption('Income', false),
                                            child:Obx(() => Container(
                                              width: Get.width * 1,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: controller.incomeOptionHover || controller.selectedTab == 'Income'?AppColors.whiteColor:AppColors.transparentColor,
                                                  border: Border.all(color: AppColors.whiteColor),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.settings,color: controller.incomeOptionHover || controller.selectedTab == 'Income'?AppColors.primaryColor:AppColors.whiteColor,),
                                                  // const SizedBox(width: 16,),
                                                  Text('Income',style: TextStyle(color: controller.incomeOptionHover || controller.selectedTab == 'Income'?AppColors.primaryColor:AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,fontSize: 16),)
                                                ],
                                              ),
                                            ),),
                                          ),
                                        ).marginOnly(top: 16),
                                        InkWell(
                                          onTap: (){
                                            controller.setTabOption('Liability');
                                          },
                                          child: MouseRegion(
                                            onEnter: (_) => controller.setHoverOption('Liability', true),
                                            onExit: (_) => controller.setHoverOption('Liability', false),
                                            child:Obx(() => Container(
                                              width: Get.width * 1,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: controller.liabilityOptionHover || controller.selectedTab == 'Liability'?AppColors.whiteColor:AppColors.transparentColor,
                                                  border: Border.all(color: AppColors.whiteColor),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.settings,color: controller.liabilityOptionHover || controller.selectedTab == 'Liability'?AppColors.primaryColor:AppColors.whiteColor,),
                                                  // const SizedBox(width: 16,),
                                                  Text('Liability',style: TextStyle(color: controller.liabilityOptionHover || controller.selectedTab == 'Liability'?AppColors.primaryColor:AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,fontSize: 16),)
                                                ],
                                              ),
                                            ),),
                                          ),
                                        ).marginOnly(top: 16),
                                        InkWell(
                                          onTap: (){
                                            controller.setTabOption('Funds');
                                          },
                                          child: MouseRegion(
                                            onEnter: (_) => controller.setHoverOption('Funds', true),
                                            onExit: (_) => controller.setHoverOption('Funds', false),
                                            child:Obx(() => Container(
                                              width: Get.width * 1,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: controller.fundsOptionHover || controller.selectedTab == 'Funds'?AppColors.whiteColor:AppColors.transparentColor,
                                                  border: Border.all(color: AppColors.whiteColor),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.settings,color: controller.fundsOptionHover || controller.selectedTab == 'Funds'?AppColors.primaryColor:AppColors.whiteColor,),
                                                  // const SizedBox(width: 16,),
                                                  Text('Funds',style: TextStyle(color: controller.fundsOptionHover || controller.selectedTab == 'Funds'?AppColors.primaryColor:AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,fontSize: 16),)
                                                ],
                                              ),
                                            ),),
                                          ),
                                        ).marginOnly(top: 16),
                                        InkWell(
                                          onTap: (){
                                            controller.setTabOption('Scenario');
                                          },
                                          child: MouseRegion(
                                            onEnter: (_) => controller.setHoverOption('Scenario', true),
                                            onExit: (_) => controller.setHoverOption('Scenario', false),
                                            child:Obx(() => Container(
                                              width: Get.width * 1,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: controller.scenarioOptionHover || controller.selectedTab == 'Scenario'?AppColors.whiteColor:AppColors.transparentColor,
                                                  border: Border.all(color: AppColors.whiteColor),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.settings,color: controller.fundsOptionHover || controller.selectedTab == 'Funds'?AppColors.primaryColor:AppColors.whiteColor,),
                                                  // const SizedBox(width: 16,),
                                                  Text('Scenario',style: TextStyle(color: controller.scenarioOptionHover || controller.selectedTab == 'Scenario'?AppColors.primaryColor:AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,fontSize: 16),)
                                                ],
                                              ),
                                            ),),
                                          ),
                                        ).marginOnly(top: 16),
                                        InkWell(
                                          onTap: (){
                                            controller.setTabOption('BorrowerDiscussions');
                                          },
                                          child: MouseRegion(
                                            onEnter: (_) => controller.setHoverOption('BorrowerDiscussions', true),
                                            onExit: (_) => controller.setHoverOption('BorrowerDiscussions', false),
                                            child:Obx(() => Container(
                                              width: Get.width * 1,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                  color: controller.borrowerDiscussionsOptionHover || controller.selectedTab == 'BorrowerDiscussions'?AppColors.whiteColor:AppColors.transparentColor,
                                                  border: Border.all(color: AppColors.whiteColor),
                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                      topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  // Icon(Icons.settings,color: controller.fundsOptionHover || controller.selectedTab == 'Funds'?AppColors.primaryColor:AppColors.whiteColor,),
                                                  // const SizedBox(width: 16,),
                                                  Text('Borrower Discussions',style: TextStyle(color: controller.borrowerDiscussionsOptionHover || controller.selectedTab == 'BorrowerDiscussions'?AppColors.primaryColor:AppColors.whiteColor,
                                                      fontWeight: FontWeight.bold,fontSize: 16),)
                                                ],
                                              ),
                                            ),),
                                          ),
                                        ).marginOnly(top: 16),
                                      ],
                                    ).marginOnly(left: 18,right: 18).paddingSymmetric(vertical: 16),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        )
                    )),
                Expanded(
                    flex: 8,
                    child:Obx(() => SizedBox(
                      width: Get.width * 1,
                      height: Get.height * 1,
                      child: controller.selectedTab == 'Summary'?SummaryView(borrowerId: controller.borrowerId,):
                      controller.selectedTab == 'FICO'?FicoView(borrowerId: controller.borrowerId,):
                      controller.selectedTab == 'Income'?IncomeView(borrowerId: controller.borrowerId,):
                      controller.selectedTab == 'Liability'?LiabilityView(borrowerId: controller.borrowerId,):
                      controller.selectedTab == 'Funds'?FundsView(borrowerId: controller.borrowerId,):
                      controller.selectedTab == 'BorrowerDiscussions'?BorrowerDiscussionView(borrowerId: controller.borrowerId,adminId: GetStorage().read(Constants.USER_ID),):SizedBox(),
                    ))
                ),
              ],
            ),
          );
        }
    );
  }

}