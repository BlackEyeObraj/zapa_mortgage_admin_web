import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_network/image_network.dart';
import 'package:zapa_mortgage_admin_web/controllers/users_view_controller.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/loa_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/nick_name_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/routes/route_name.dart';

import '../../utils/constants.dart';

class UsersView extends GetView<UsersViewController>{
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: UsersViewController(),
        builder: (controller){
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text('Filter by LOA',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(
                            width: 230,
                            child: Obx(() => DropdownButtonFormField2<String>(
                              isExpanded: false,
                              decoration: InputDecoration(
                                // Add Horizontal padding using menuItemStyleData.padding so it matches
                                // the menu padding when button's width is not specified.
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                // Add more decoration..
                              ),
                              value: 'All',
                              hint: const Text(
                                'Select LOA',
                                style: TextStyle(fontSize: 12),
                              ),
                              items: controller.adminFilter
                                  .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryColor
                                  ),
                                ),
                              )).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Select LOA';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                //Do something when selected item is changed.
                                // selectedLiabilityType = value.toString();
                                controller.selectedLOA.value = value.toString();
                              },
                              onSaved: (value) {
                                // selectedLiabilityType = value.toString();
                                controller.selectedLOA.value = value.toString();
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                            ),
                          ),

                        ],
                      ),
                      SizedBox(width: 8,),
                      Column(
                        children: [
                          Text('Filter by Borrower RE Agent',style: TextStyle(fontWeight: FontWeight.bold),),
                          SizedBox(
                            width: 230,
                            child: DropdownButtonFormField2<String>(
                              isExpanded: false,
                              decoration: InputDecoration(
                                // Add Horizontal padding using menuItemStyleData.padding so it matches
                                // the menu padding when button's width is not specified.
                                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                // Add more decoration..
                              ),
                              // value: 'All',
                              hint: const Text(
                                'Select Borrower ER Agent',
                                style: TextStyle(fontSize: 12),
                              ),
                              items: Constants().liabilityTypes
                                  .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.primaryColor
                                  ),
                                ),
                              )).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return 'Select Borrower ER Agent';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                //Do something when selected item is changed.
                                // selectedLiabilityType = value.toString();
                              },
                              onSaved: (value) {
                                // selectedLiabilityType = value.toString();
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.only(right: 8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 24,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ).marginOnly(left: 16),
                ),
                Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(Icons.search,color: AppColors.primaryColor,), // Replace with your desired icon
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: controller.searchPhoneNumberTextController,
                          onChanged: (String phoneNumber){
                            controller.setPhoneNumber(phoneNumber.isNotEmpty?phoneNumber:'');
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Search User e.g Nick Name or Phone Number',
                            hintStyle: TextStyle(fontSize: 12),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(
                                bottom: 4),
                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                          ),

                        ),
                      ),
                    ],
                  ),
                ).marginOnly(right: 8)
              ],
            ).marginOnly(top: 16),

            Expanded(
              child:Obx(() => StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getUsers(controller.selectedLOA.value).snapshots(),
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
                        Text('No User Found.'),
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
                                ),
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
                                    Row(
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: 'Nick Name: ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(text: data['nickName'] != ''?data['nickName']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16,),
                                        InkWell(
                                          onTap: (){
                                            NickNameDialog().addNickName(data['userId'],data['nickName']??'');
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.secondaryColor,
                                              borderRadius: BorderRadius.circular(1000)
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,size: 12,color: AppColors.whiteColor,),
                                                Text('Add / Edit Nick Name',style: TextStyle(fontSize: 10,color: AppColors.textColorWhite),)
                                              ],
                                            ).paddingAll(4),
                                          ),
                                        )
                                      ],
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
                                        text: 'Borrower RE Agent: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(text: data['customerAgent'] != ''?data['customerAgent']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 8,),
                                    RichText(
                                      text: TextSpan(
                                        text: 'LOA: ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(text: data['assignedTo'] != ''?data['assignedTo']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),

                                        ],
                                      ),
                                    ),
                                  ],
                                ).paddingSymmetric(vertical: 8)
                              ],
                            ),

                            InkWell(
                              onTap: ()async{
                                Get.toNamed(RouteName.userDetailScreen,arguments: {'borrowerId': data['userId']});
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
                            )
                          ],
                        ).paddingSymmetric(horizontal: 16),
                      ).paddingOnly(top: 16);
                    },
                  ).paddingSymmetric(horizontal: 16,vertical: 16);
                },
              ),)
            ),
          ],
        );
        }
    );
  }

}