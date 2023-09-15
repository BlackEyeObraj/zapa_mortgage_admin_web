import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/dash_board_page_controller.dart';
import 'package:zapa_mortgage_admin_web/pages/views/history_view.dart';
import 'package:zapa_mortgage_admin_web/pages/views/remarks_view.dart';
import 'package:zapa_mortgage_admin_web/pages/views/today_engagement.dart';
import 'package:zapa_mortgage_admin_web/pages/views/users_view.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/res/app_images.dart';

class DashBoardPage extends GetView<DashBoardPageController> {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: DashBoardPageController(),
        builder: (controller) {
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
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height: 140,
                                          width: 140,
                                          child: Image.asset(AppImages.appLogo)),
                                      const Text('Admin Panel',style: TextStyle(color: AppColors.textColorWhite,
                                          fontWeight: FontWeight.bold,fontSize: 24),)
                                    ],
                                  )),
                              Expanded(
                                flex: 7,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          controller.setTabOption('Borrowers');
                                        },
                                        child: MouseRegion(
                                          onEnter: (_) => controller.setHoverOption('Borrowers', true),
                                          onExit: (_) => controller.setHoverOption('Borrowers', false),
                                          child:Obx(() => Container(
                                            width: Get.width * 1,
                                            height: 48,
                                            decoration: BoxDecoration(
                                                color: controller.userOptionHover || controller.selectedTab == 'Borrowers'?AppColors.whiteColor:AppColors.transparentColor,
                                                border: Border.all(color: AppColors.whiteColor),
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.person,color: controller.userOptionHover || controller.selectedTab == 'Borrowers'?AppColors.primaryColor:AppColors.whiteColor,),
                                                const SizedBox(width: 16,),
                                                Text('Borrowers',style: TextStyle(color: controller.userOptionHover || controller.selectedTab == 'Borrowers'?AppColors.primaryColor:AppColors.whiteColor,
                                                    fontWeight: FontWeight.bold,fontSize: 16),)
                                              ],
                                            ),
                                          ),),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          controller.setTabOption('Remarks & Notes');
                                        },
                                        child: MouseRegion(
                                          onEnter: (_) => controller.setHoverOption('Remarks & Notes', true),
                                          onExit: (_) => controller.setHoverOption('Remarks & Notes', false),
                                          child:Obx(() => Container(
                                            width: Get.width * 1,
                                            height: 48,
                                            decoration: BoxDecoration(
                                                color: controller.remarksOptionHover || controller.selectedTab == 'Remarks & Notes'?AppColors.whiteColor:AppColors.transparentColor,
                                                border: Border.all(color: AppColors.whiteColor),
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.message,color: controller.remarksOptionHover || controller.selectedTab == 'Remarks & Notes'?AppColors.primaryColor:AppColors.whiteColor,),
                                                const SizedBox(width: 16,),
                                                Text('Remarks & Notes',style: TextStyle(color: controller.remarksOptionHover || controller.selectedTab == 'Remarks & Notes'?AppColors.primaryColor:AppColors.whiteColor,
                                                    fontWeight: FontWeight.bold,fontSize: 16),)
                                              ],
                                            ),
                                          ),),
                                        ),
                                      ).marginOnly(top: 16),
                                      InkWell(
                                        onTap: (){
                                          controller.setTabOption('History');
                                        },
                                        child: MouseRegion(
                                          onEnter: (_) => controller.setHoverOption('History', true),
                                          onExit: (_) => controller.setHoverOption('History', false),
                                          child:Obx(() => Container(
                                            width: Get.width * 1,
                                            height: 48,
                                            decoration: BoxDecoration(
                                                color: controller.historyOptionHover || controller.selectedTab == 'History'?AppColors.whiteColor:AppColors.transparentColor,
                                                border: Border.all(color: AppColors.whiteColor),
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.history,color: controller.historyOptionHover || controller.selectedTab == 'History'?AppColors.primaryColor:AppColors.whiteColor,),
                                                const SizedBox(width: 16,),
                                                Text('History',style: TextStyle(color: controller.historyOptionHover || controller.selectedTab == 'History'?AppColors.primaryColor:AppColors.whiteColor,
                                                    fontWeight: FontWeight.bold,fontSize: 16),)
                                              ],
                                            ),
                                          ),),
                                        ),
                                      ).marginOnly(top: 16),
                                      InkWell(
                                        onTap: (){
                                          controller.setTabOption("Today's Engagement");
                                        },
                                        child: MouseRegion(
                                          onEnter: (_) => controller.setHoverOption("Today's Engagement", true),
                                          onExit: (_) => controller.setHoverOption("Today's Engagement", false),
                                          child:Obx(() => Container(
                                            width: Get.width * 1,
                                            height: 48,
                                            decoration: BoxDecoration(
                                                color: controller.engagementOptionHover || controller.selectedTab == "Today's Engagement"?AppColors.whiteColor:AppColors.transparentColor,
                                                border: Border.all(color: AppColors.whiteColor),
                                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),bottomRight: Radius.circular(10))
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.calendar_month,color: controller.engagementOptionHover || controller.selectedTab == "Today's Engagement"?AppColors.primaryColor:AppColors.whiteColor,),
                                                const SizedBox(width: 16,),
                                                Text("Today's Engagement",style: TextStyle(color: controller.engagementOptionHover || controller.selectedTab == "Today's Engagement"?AppColors.primaryColor:AppColors.whiteColor,
                                                    fontWeight: FontWeight.bold,fontSize: 16),)
                                              ],
                                            ),
                                          ),),
                                        ),
                                      ).marginOnly(top: 16),

                                    ],
                                  ).marginOnly(left: 18,right: 18),
                                ),
                              ),
                            ],
                          ),

                        ],
                      )
                    )),
                Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(controller.selectedTab,style: const TextStyle(
                                  color: AppColors.primaryColor,fontSize: 28,fontWeight: FontWeight.bold
                                ),)),
                                Container(
                                  width: Get.width * .12,
                                  height: Get.height * .064,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.primaryColor),
                                    borderRadius: BorderRadius.circular(1000)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const CircleAvatar(backgroundColor: AppColors.primaryColor,foregroundImage: AssetImage(AppImages.noUserImage),),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Signed In as:',style: TextStyle(
                                              color: AppColors.primaryColor,fontSize: 10,fontWeight: FontWeight.bold
                                          ),),
                                          Obx(() => Text(controller.userName,style: const TextStyle(
                                              color: AppColors.primaryColor,fontSize: 12,fontWeight: FontWeight.bold
                                          ),),)

                                        ],
                                      ),
                                  PopupMenuButton(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onSelected: (value) {
                                      if(value == 'logout'){
                                        controller.logout();
                                      }
                                    },
                                    itemBuilder: (BuildContext bc) {
                                      return const [
                                        PopupMenuItem(
                                          value: 'logout',
                                          child: Text("Logout"),
                                        ),

                                      ];
                                    },
                                  )
                                    ],
                                  ).marginSymmetric(horizontal: 4),
                                )
                              ],
                            ).marginSymmetric(horizontal: 16)
                        ),
                        Container(width: Get.width * 1,height: .6,color: AppColors.greyColor,),
                         Expanded(
                            flex: 9,
                            child: Obx(() => controller.selectedTab == 'Borrowers'? UsersView()
                                :controller.selectedTab == 'Remarks & Notes'? RemarksView()
                                :controller.selectedTab == 'History'? HistoryView()
                                :controller.selectedTab == "Today's Engagement"? TodayEngagement()
                                :SizedBox())

                        ),
                      ],
                    )
                ),
              ],
            ),
          );
        });
  }
}
