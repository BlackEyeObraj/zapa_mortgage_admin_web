import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zapa_mortgage_admin_web/controllers/users_view_controller.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/borrower_dialog.dart';
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              value: controller.selectedLOA.value.isEmpty?'All':controller.selectedLOA.value,
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
                                controller.selectedLOA.value = value.toString() == 'All'?'':value.toString();
                                print(controller.selectedLOA.value);
                                // print(controller.selectedLeadStage.value);
                              },
                              onSaved: (value) {
                                // selectedLiabilityType = value.toString();
                                controller.selectedLOA.value = value.toString() == 'All'?'':value.toString();
                                print(controller.selectedLOA.value);
                                // print(controller.selectedLeadStage.value);
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Filter by Borrower RE Agent',style: TextStyle(fontWeight: FontWeight.bold),),
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
                              value: controller.selectedBREA.value.isEmpty?'All':controller.selectedBREA.value,
                              hint: const Text(
                                'Select Agent',
                                style: TextStyle(fontSize: 12),
                              ),
                              items: controller.agentFilter
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
                                  return 'Select Agent';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                //Do something when selected item is changed.
                                // selectedLiabilityType = value.toString();
                                controller.selectedBREA.value = value.toString() == 'All'?'':value.toString();
                                print(controller.selectedBREA.value);
                                // print(controller.selectedLeadStage.value);
                              },
                              onSaved: (value) {
                                // selectedLiabilityType = value.toString();
                                controller.selectedBREA.value = value.toString() == 'All'?'':value.toString();
                                print(controller.selectedBREA.value);
                                // print(controller.selectedLeadStage.value);
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Search by name / Phone Number',style: TextStyle(fontWeight: FontWeight.bold),),
                          Container(
                            height: Get.height * .064,
                            width: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1.0),
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
                                      hintText: 'Type Here',
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
                          ).marginOnly(right: 8),
                        ],
                      ),
                    ],
                  ).marginOnly(left: 16),
                ),
                InkWell(
                  onTap: (){
                    BorrowerDialog().addBorrowerDialog();
                  },
                  child: Container(
                    height: Get.height * .06,
                    width: 120,
                    decoration: BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.circular(10000)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.add,color: AppColors.whiteColor,),
                        Text('Add Borrower',style: TextStyle(color: AppColors.textColorWhite),)
                      ],
                    ),
                  ).marginOnly(right: 8),
                )
              ],
            ).marginOnly(top: 16),
            Align(alignment: Alignment.centerLeft,child: Text('Filter by Lead Stage',style: TextStyle(fontWeight: FontWeight.bold),).paddingAll(16)),
            SizedBox(
              width: Get.width * 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                  children: [
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = '';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                          color: controller.selectedLeadStage.value.isEmpty?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('All',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value.isEmpty?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Open';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Open'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Open',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Open'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Warm';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Warm'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Warm',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Warm'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Hot';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Hot'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Hot',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Hot'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'On Followup';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'On Followup'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('On Followup',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'On Followup'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Negotiation';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Negotiation'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Negotiation',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Negotiation'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Booked';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Booked'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Booked',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Booked'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Cold';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Cold'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Cold',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Cold'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Inactive';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Inactive'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Inactive',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Inactive'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Pre-Approved';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Pre-Approved'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Pre-Approved',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Pre-Approved'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Pending';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Pending'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Pending',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Pending'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Not Qualified';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Not Qualified'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Not Qualified',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Not Qualified'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                    InkWell(
                      onTap: () {
                        controller.selectedLeadStage.value = 'Up Coming';
                        // print(controller.selectedLeadStage.value);
                        // print(controller.selectedLOA.value);

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primaryColor, width: 1),
                          borderRadius: BorderRadius.circular(1000),
                            color: controller.selectedLeadStage.value == 'Up Coming'?AppColors.primaryColor:AppColors.transparentColor
                        ),
                        child: Text('Up Coming',
                          style: TextStyle(fontWeight: FontWeight.bold,
                              color: controller.selectedLeadStage.value == 'Up Coming'?AppColors.whiteColor:AppColors.primaryColor
                          ),).paddingSymmetric(
                            vertical: 2, horizontal: 12),
                      ).marginSymmetric(horizontal: 4),
                    ),
                      // leadStageContainer(controller,''),
                    // leadStageContainer(controller,'Open'),
                    // leadStageContainer(controller,'Warm'),
                    // leadStageContainer(controller,'Hot'),
                    // leadStageContainer(controller,'On Followup'),
                    // leadStageContainer(controller,'Negotiation'),
                    // leadStageContainer(controller,'Booked'),
                    // leadStageContainer(controller,'Cold'),
                    // leadStageContainer(controller,'Inactive'),
                    // leadStageContainer(controller,'Pre-Approved'),
                    // leadStageContainer(controller,'Pending'),
                    // leadStageContainer(controller,'Not Qualified'),
                    // leadStageContainer(controller,'Up Coming'),
                    // leadStageContainer(controller,'Not Qualified'),
                  ],
                )),
              )
            ).marginOnly(top: 0,left: 16,right: 16),
            Expanded(
              child:Obx(() => StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getUsers(controller.selectedLOA.value,controller.selectedLeadStage.value,controller.selectedBREA.value,controller.phoneNumbers.value).snapshots(),

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
                                            text: 'Verified Name: ',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(text: data['verifiedName'] != ''?data['verifiedName']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16,),
                                        InkWell(
                                          onTap: (){
                                            NickNameDialog().addVerifiedName(data['userId'],data['nickName']??'',data['userName'],data['phoneNumber']);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.secondaryColor,
                                                borderRadius: BorderRadius.circular(1000)
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,size: 12,color: AppColors.whiteColor,),
                                                Text('Add / Edit Verified Name',style: TextStyle(fontSize: 10,color: AppColors.textColorWhite),)
                                              ],
                                            ).paddingAll(4),
                                          ),
                                        )
                                      ],
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
                                            NickNameDialog().addNickName(data['userId'],data['nickName']??'',data['userName'],data['phoneNumber']);
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
                                Get.toNamed(RouteName.userDetailScreen,arguments: {'borrowerId': data['userId'],'borrowerPhoneNumber': data['phoneNumber'],'borrowerUserName':data['userName'],'token':data['deviceToken']});
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
              )),

            ),
          ],
        );
        }
    );
  }

}
Widget leadStageContainer(UsersViewController controller, String value) {
  return InkWell(
    onTap: () {
      controller.selectedLeadStage.value = value;
      // print(controller.selectedLeadStage.value);
      // print(controller.selectedLOA.value);

    },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Text(value.isNotEmpty ? value : 'All',
        style: TextStyle(fontWeight: FontWeight.bold),).paddingSymmetric(
          vertical: 2, horizontal: 12),
    ).marginSymmetric(horizontal: 4),
  );
}