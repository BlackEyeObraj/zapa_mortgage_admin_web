import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zapa_mortgage_admin_web/controllers/liability_view_controller.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../constants.dart';
import '../snack_bar.dart';
import '../utils_mehtods.dart';

class LiabilityDialog{

  addLiabilityDialog(String borrowerId, LiabilityViewController controller, String borrowerName, String borrowerPhoneNumber){
    final box = GetStorage();
    final liabilityNameController = TextEditingController();
    final liabilityMonthlyAmountController = TextEditingController();
    final liabilityUnpaidBalanceAmountController = TextEditingController();
    final liabilityRemainingMonthController = TextEditingController();
    controller.selectedLiabilityType.value = '';
    String selectedExcludedReason = '';
    String verifyStatus = 'Verified';
    Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
    Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', false);

    Get.defaultDialog(
      title: 'Add New Liability',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content: Flexible(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text("Add as Processor"),
                      value: "processor",
                      groupValue: Get.put(LiabilityViewController()).selectedAddedBy.value,
                      onChanged: (value){
                        selectedExcludedReason = '';
                        Get.put(LiabilityViewController()).selectedAddedBy.value = 'processor';
                        Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
                        Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExeCheck', false);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text("Add as Borrower"),
                      value: "customer",
                      groupValue: Get.put(LiabilityViewController()).selectedAddedBy.value,
                      onChanged: (value){
                        selectedExcludedReason = '';
                        Get.put(LiabilityViewController()).selectedAddedBy.value = 'customer';
                        Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
                        Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExeCheck', false);
                      },
                    ),
                  )
                ],
              ),),

              Text('Liability Name *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),),
              TextFormField(
                controller: liabilityNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Type Name',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),
              Text('Liability Type *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),
              DropdownButtonFormField2<String>(
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
                hint: const Text(
                  'Select Liability Type',
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
                    return 'Select Liability Type';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when selected item is changed.
                  liabilityMonthlyAmountController.text =  '';
                  liabilityUnpaidBalanceAmountController.text = '';
                  controller.onePercentAmount.value  = 0.00;
                  controller.selectedLiabilityType.value = value.toString();
                },
                onSaved: (value) {
                  liabilityMonthlyAmountController.text =  '';
                  liabilityUnpaidBalanceAmountController.text = '';
                  controller.onePercentAmount.value  = 0.00;
                  controller.selectedLiabilityType.value = value.toString();
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

              Text('Unpaid Balance *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2.0,
                      width: Get.width * .01,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: liabilityUnpaidBalanceAmountController,
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter liability amount';
                        //   }
                        //   return null;
                        //
                        // },
                        onChanged: (String amount){
                          if(controller.selectedLiabilityType.value == 'Installment (Student)'){
                            if(amount.isNotEmpty){
                              controller.calculateOnePercent(double.parse(amount));
                            }else{
                              controller.onePercentAmount.value = 0.00;
                            }
                          }else{
                            controller.onePercentAmount.value = 0.00;
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Type Amount',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              top: 0,bottom: 4),

                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => controller.selectedLiabilityType.value == 'Installment (Student)'?Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('I know my Monthly Payment',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                      Obx(() => Checkbox(
                          value: controller.idoKnow.value,
                          onChanged: (value){
                            controller.idoKnow.value = value!;
                            controller.idoNotKnow.value = false;
                          }),)
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text('I do not know my Monthly Payment 1% of Unpaid Balance will be used.',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                      Obx(() => Checkbox(
                          value: controller.idoNotKnow.value,
                          onChanged: (value){
                            controller.idoNotKnow.value = value!;
                            controller.idoKnow.value = false;
                          }),)
                    ],
                  ),
                ],
              ):const SizedBox(),)  ,
              Obx(() =>controller.selectedLiabilityType.value != 'Installment (Student)'? Text('Monthly Payment *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01):Text('Monthly Payment',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),),
              Obx(() => controller.selectedLiabilityType.value  != 'Installment (Student)'? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2.0,
                      width: Get.width * .01,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: liabilityMonthlyAmountController,
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter liability amount';
                        //   }
                        //   return null;
                        //
                        // },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Type Amount',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              top: 10),
                          suffixIcon: Text('per month',style: TextStyle(fontSize: 10,
                              color: AppColors.primaryColor),).paddingOnly(top: 16,right: 8,left: 8,),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ):
              controller.idoNotKnow.value? Container(
                height: Get.height * .05,
                decoration: BoxDecoration(
                  color:AppColors.viewColor.withOpacity(.8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_money_outlined,color: AppColors.primaryColor,),
                    Expanded(
                        child:Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(controller.onePercentAmount.value)}'))
                    )
                  ],
                ),
              ):TextFormField(
                controller: liabilityMonthlyAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Type Month Remaining',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),),


              Text('Month Remaining ( optional )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),
              TextFormField(
                controller: liabilityRemainingMonthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Type Month Remaining',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),


              Obx(() => Get.put(LiabilityViewController()).selectedAddedBy.value == 'processor' ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Obx(() =>  Checkbox(
                          value: Get.put(LiabilityViewController()).verifiedCheck,
                          onChanged: (value){
                            if(Get.put(LiabilityViewController()).verifiedCheck == true){
                              verifyStatus = 'Verified But Excluded';
                              Get.put(LiabilityViewController()).setVerifyCheck('verified', false);
                              Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', true);
                            }else{
                              verifyStatus = 'Verified';
                              selectedExcludedReason = '';
                              Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
                              Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', false);
                            }
                          }
                      ),
                      ),
                      Text('Verified',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: Get.put(LiabilityViewController()).verifiedButExeCheck,
                          onChanged: (value){
                            if(Get.put(LiabilityViewController()).verifiedButExeCheck == true){
                              selectedExcludedReason = '';
                              verifyStatus = 'Verified';
                              Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
                              Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', false);
                            }else{
                              verifyStatus = 'Verified But Excluded';
                              Get.put(LiabilityViewController()).setVerifyCheck('verified', false);
                              Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', true);
                            }
                          }
                      ),),
                      Text('Verified But Excluded',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                ],
              ).marginOnly(top: 8):SizedBox(),),

              Obx(() => Get.put(LiabilityViewController()).verifiedButExeCheck == true? DropdownButtonFormField2<String>(
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
                hint: const Text(
                  'Select Execution Reason',
                  style: TextStyle(fontSize: 12),
                ),
                items: Constants().verifiedButExcludedReasons
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
                    return 'Select Execution Reason';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when selected item is changed.
                  selectedExcludedReason = value.toString();
                },
                onSaved: (value) {
                  selectedExcludedReason = value.toString();
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
              ).marginOnly(top: 8):SizedBox(),
              ),

              SizedBox(
                width: Get.width * .4,
                height: Get.height * .1,
                child: ElevatedButton(
                    onPressed: () async{

                      if (liabilityNameController.text.isEmpty){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please enter liability Name');
                      }else if(controller.selectedLiabilityType.value == ''){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please select liability Type');
                      }
                      else if(controller.selectedLiabilityType.value != 'Installment (Student)'){
                        if(liabilityUnpaidBalanceAmountController.text.isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
                        }else if(liabilityMonthlyAmountController.text.isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');

                        }else if(Get.put(LiabilityViewController()).selectedAddedBy.value == 'processor' && Get.put(LiabilityViewController()).verifiedButExeCheck == true && selectedExcludedReason .isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please select excluded reason');
                        }
                        else{
                            await FirestoreService().addLiability(
                                Get.put(LiabilityViewController()).selectedAddedBy.value,
                                borrowerId,
                                liabilityNameController.text,
                                liabilityMonthlyAmountController.text,
                                controller.selectedLiabilityType.value,
                                liabilityUnpaidBalanceAmountController.text,
                                liabilityRemainingMonthController.text,
                                verifyStatus,selectedExcludedReason,box.read(Constants.USER_NAME),
                            controller.idoKnow.value,
                            controller.idoNotKnow.value,borrowerName,borrowerPhoneNumber);
                        }
                      }else if(controller.selectedLiabilityType.value == 'Installment (Student)'){
                        if(liabilityUnpaidBalanceAmountController.text.isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
                        }else if(controller.idoKnow.value == true && liabilityMonthlyAmountController.text.isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');
                        }else if(Get.put(LiabilityViewController()).selectedAddedBy.value == 'processor' && Get.put(LiabilityViewController()).verifiedButExeCheck == true && selectedExcludedReason .isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please select excluded reason');
                        }
                        else{
                          await FirestoreService().addLiability(
                              Get.put(LiabilityViewController()).selectedAddedBy.value,
                              borrowerId,
                              liabilityNameController.text,
                              controller.idoKnow.value == true?liabilityMonthlyAmountController.text: controller.onePercentAmount.toString(),
                              controller.selectedLiabilityType.value,
                              liabilityUnpaidBalanceAmountController.text,
                              liabilityRemainingMonthController.text,verifyStatus,selectedExcludedReason,box.read(Constants.USER_NAME),
                              controller.idoKnow.value,
                              controller.idoNotKnow.value,borrowerName,borrowerPhoneNumber);
                        }
                      }

                      // if (liabilityNameController.text.isEmpty){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter liability Name');
                      // }else if(controller.selectedLiabilityType.value == ''){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please select liability Type');
                      // }
                      // else if(liabilityMonthlyAmountController.text.isEmpty){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');
                      // }else if(liabilityUnpaidBalanceAmountController.text.isEmpty){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
                      // }else if(Get.put(LiabilityViewController()).selectedAddedBy.value == 'processor' && Get.put(LiabilityViewController()).verifiedButExeCheck == true && selectedExcludedReason .isEmpty){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please select excluded reason');
                      // }
                      // else{
                      //   await FirestoreService().addLiability(Get.put(LiabilityViewController()).selectedAddedBy.value,borrowerId,liabilityNameController.text,liabilityMonthlyAmountController.text,
                      //       controller.selectedLiabilityType.value,liabilityUnpaidBalanceAmountController.text,
                      //   liabilityRemainingMonthController.text,verifyStatus,selectedExcludedReason,box.read(Constants.USER_NAME));
                      // }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.primaryColor),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            )
                        )
                    ),
                    child: const Text('Save',style: TextStyle(color: AppColors.textColorWhite),)
                ).paddingOnly(top: Get.height * .04),
              )
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );

  }

  editLiabilityDialog(String addedBy,String borrowerId,int index, String name, String amountMonthly, String type, String amountBalance, String monthRemaining,
      String status, LiabilityViewController liabilityController, bool iKnow, bool iDoNotKnow, String executionReason, String verifyStatusOld, String borrowerName, String borrowerPhoneNumber
      )async{
    final liabilityNameController = TextEditingController(text: name);
    final liabilityMonthlyAmountController = TextEditingController(text: amountMonthly);
    final liabilityUnpaidBalanceAmountController = TextEditingController(text: amountBalance);
    final liabilityRemainingMonthController = TextEditingController(text: monthRemaining);
    Get.put(LiabilityViewController()).selectedAddedBy.value = addedBy;
    liabilityController.selectedLiabilityType.value = type;
    liabilityController.idoKnow.value = iKnow;
    liabilityController.idoNotKnow.value = iDoNotKnow;
    Get.put(LiabilityViewController()).setVerifyCheck('verified', verifyStatusOld == 'Verified'?true:false);
    Get.put(LiabilityViewController()).setVerifyCheck('notVerified', verifyStatusOld == 'Verified But Excluded'?true:false);
    liabilityController.calculateOnePercent(double.parse(amountBalance));
    await liabilityController.setStatusLiability(status);
    String selectedExcludedReason = executionReason;
    String verifyStatus = verifyStatusOld;

    Get.defaultDialog(
      title: 'Edit Liability',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content: Flexible(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text("Add as Processor"),
                      value: "processor",
                      groupValue: Get.put(LiabilityViewController()).selectedAddedBy.value,
                      onChanged: (value){
                        selectedExcludedReason = '';
                        Get.put(LiabilityViewController()).selectedAddedBy.value = 'processor';
                        Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
                        Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExeCheck', false);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text("Add as Borrower"),
                      value: "customer",
                      groupValue: Get.put(LiabilityViewController()).selectedAddedBy.value,
                      onChanged: (value){
                        selectedExcludedReason = '';
                        Get.put(LiabilityViewController()).selectedAddedBy.value = 'customer';
                        Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
                        Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExeCheck', false);
                      },
                    ),
                  )
                ],
              ),),

              Text('Liability Name *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),),
              TextFormField(
                controller: liabilityNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Type Name',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),
              Text('Liability Type *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),
              DropdownButtonFormField2<String>(
                value: liabilityController.selectedLiabilityType.value,
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
                hint: const Text(
                  'Select Liability Type',
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
                    return 'Select Liability Type';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when selected item is changed.
                  liabilityMonthlyAmountController.text =  '';
                  liabilityUnpaidBalanceAmountController.text = '';
                  liabilityController.onePercentAmount.value  = 0.00;
                  liabilityController.selectedLiabilityType.value = value.toString();
                },
                onSaved: (value) {
                  liabilityMonthlyAmountController.text =  '';
                  liabilityUnpaidBalanceAmountController.text = '';
                  liabilityController.onePercentAmount.value  = 0.00;
                  liabilityController.selectedLiabilityType.value = value.toString();
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

              Text('Unpaid Balance *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2.0,
                      width: Get.width * .01,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: liabilityUnpaidBalanceAmountController,
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter liability amount';
                        //   }
                        //   return null;
                        //
                        // },
                        onChanged: (String amount){
                          if(liabilityController.selectedLiabilityType.value == 'Installment (Student)'){
                            if(amount.isNotEmpty){
                              liabilityController.calculateOnePercent(double.parse(amount));
                            }else{
                              liabilityController.onePercentAmount.value = 0.00;
                            }
                          }else{
                            liabilityController.onePercentAmount.value = 0.00;
                          }
                        },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Type Amount',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              top: 0,bottom: 4),

                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() => liabilityController.selectedLiabilityType.value == 'Installment (Student)'?Column(
                children: [
                  Row(
                    children: [
                      const Expanded(child: Text('I know my Monthly Payment',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                      Obx(() => Checkbox(
                          value: liabilityController.idoKnow.value,
                          onChanged: (value){
                            liabilityController.idoKnow.value = value!;
                            liabilityController.idoNotKnow.value = false;
                          }),)
                    ],
                  ),
                  Row(
                    children: [
                      const Expanded(child: Text('I do not know my Monthly Payment 1% of Unpaid Balance will be used.',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                      Obx(() => Checkbox(
                          value: liabilityController.idoNotKnow.value,
                          onChanged: (value){
                            liabilityController.idoNotKnow.value = value!;
                            liabilityController.idoKnow.value = false;
                          }),)
                    ],
                  ),
                ],
              ):const SizedBox(),)  ,
              Obx(() =>liabilityController.selectedLiabilityType.value != 'Installment (Student)'? Text('Monthly Payment *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01):Text('Monthly Payment',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),),
              Obx(() => liabilityController.selectedLiabilityType.value  != 'Installment (Student)'? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                    ),
                    VerticalDivider(
                      color: Colors.black,
                      thickness: 2.0,
                      width: Get.width * .01,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: liabilityMonthlyAmountController,
                        keyboardType: TextInputType.number,
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Please enter liability amount';
                        //   }
                        //   return null;
                        //
                        // },
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Type Amount',
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                              top: 10),
                          suffixIcon: Text('per month',style: TextStyle(fontSize: 10,
                              color: AppColors.primaryColor),).paddingOnly(top: 16,right: 8,left: 8,),
                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ):
              liabilityController.idoNotKnow.value? Container(
                height: Get.height * .05,
                decoration: BoxDecoration(
                  color:AppColors.viewColor.withOpacity(.8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.attach_money_outlined,color: AppColors.primaryColor,),
                    Expanded(
                        child:Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(liabilityController.onePercentAmount.value)}'))
                    )
                  ],
                ),
              ):TextFormField(
                controller: liabilityMonthlyAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Type Month Remaining',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),),


              Text('Month Remaining ( optional )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),
              TextFormField(
                controller: liabilityRemainingMonthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Type Month Remaining',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),


              Obx(() => Get.put(LiabilityViewController()).selectedAddedBy.value == 'processor' ?Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Obx(() =>  Checkbox(
                          value: Get.put(LiabilityViewController()).verifiedCheck,
                          onChanged: (value){
                            if(Get.put(LiabilityViewController()).verifiedCheck == true){
                              verifyStatus = 'Verified But Excluded';
                              selectedExcludedReason = '';
                              Get.put(LiabilityViewController()).setVerifyCheck('verified', false);
                              Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', true);
                            }else{
                              verifyStatus = 'Verified';
                              selectedExcludedReason = '';
                              Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
                              Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', false);
                            }
                          }
                      ),
                      ),
                      Text('Verified',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  Row(
                    children: [
                      Obx(() => Checkbox(
                          value: Get.put(LiabilityViewController()).verifiedButExeCheck,
                          onChanged: (value){
                            if(Get.put(LiabilityViewController()).verifiedButExeCheck == true){
                              selectedExcludedReason = '';
                              verifyStatus = 'Verified';
                              Get.put(LiabilityViewController()).setVerifyCheck('verified', true);
                              Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', false);
                            }else{
                              verifyStatus = 'Verified But Excluded';
                              selectedExcludedReason = '';
                              Get.put(LiabilityViewController()).setVerifyCheck('verified', false);
                              Get.put(LiabilityViewController()).setVerifyCheck('verifiedButExcluded', true);
                            }
                          }
                      ),),
                      Text('Verified But Excluded',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                ],
              ).marginOnly(top: 8):SizedBox(),),

              Obx(() => Get.put(LiabilityViewController()).verifiedButExeCheck == true? DropdownButtonFormField2<String>(
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
                value: selectedExcludedReason.isEmpty? null:executionReason,
                hint: const Text(
                  'Select Execution Reason',
                  style: TextStyle(fontSize: 12),
                ),
                items: Constants().verifiedButExcludedReasons
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
                    return 'Select Execution Reason';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when selected item is changed.
                  selectedExcludedReason = value.toString();
                },
                onSaved: (value) {
                  selectedExcludedReason = value.toString();
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
              ).marginOnly(top: 8):SizedBox(),
              ),

              SizedBox(
                width: Get.width * .4,
                height: Get.height * .1,
                child: ElevatedButton(
                    onPressed: () async{

                      if (liabilityNameController.text.isEmpty){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please enter liability Name');
                      }else if(liabilityController.selectedLiabilityType.value == ''){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please select liability Type');
                      }
                      else if(liabilityController.selectedLiabilityType.value != 'Installment (Student)'){
                        if(liabilityUnpaidBalanceAmountController.text.isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
                        }else if(liabilityMonthlyAmountController.text.isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');

                        }else if(Get.put(LiabilityViewController()).selectedAddedBy.value == 'processor' && Get.put(LiabilityViewController()).verifiedButExeCheck == true && selectedExcludedReason .isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please select excluded reason');
                        }
                        else{
                          await FirestoreService().updateLiabilityValues(
                              index,
                              Get.put(LiabilityViewController()).selectedAddedBy.value,
                              borrowerId,
                              liabilityNameController.text,
                              liabilityMonthlyAmountController.text,
                              liabilityController.selectedLiabilityType.value,
                              liabilityUnpaidBalanceAmountController.text,
                              liabilityRemainingMonthController.text,
                              verifyStatus,
                              selectedExcludedReason,
                              liabilityController.idoKnow.value,
                              liabilityController.idoNotKnow.value,borrowerName,borrowerPhoneNumber);
                        }
                      }else if(liabilityController.selectedLiabilityType.value == 'Installment (Student)'){
                        if(liabilityUnpaidBalanceAmountController.text.isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
                        }else if(liabilityController.idoKnow.value == true && liabilityMonthlyAmountController.text.isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');
                        }else if(Get.put(LiabilityViewController()).selectedAddedBy.value == 'processor' && Get.put(LiabilityViewController()).verifiedButExeCheck == true && selectedExcludedReason .isEmpty){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please select excluded reason');
                        }
                        else{
                          await FirestoreService().updateLiabilityValues(
                              index,
                              Get.put(LiabilityViewController()).selectedAddedBy.value,
                              borrowerId,
                              liabilityNameController.text,
                              liabilityController.idoKnow.value == true?liabilityMonthlyAmountController.text: liabilityController.onePercentAmount.toString(),
                              liabilityController.selectedLiabilityType.value,
                              liabilityUnpaidBalanceAmountController.text,
                              liabilityRemainingMonthController.text,
                              verifyStatus,
                              selectedExcludedReason,
                              liabilityController.idoKnow.value,
                              liabilityController.idoNotKnow.value,borrowerName,borrowerPhoneNumber);
                        }
                      }

                      // if (liabilityNameController.text.isEmpty){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter liability Name');
                      // }else if(controller.selectedLiabilityType.value == ''){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please select liability Type');
                      // }
                      // else if(liabilityMonthlyAmountController.text.isEmpty){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');
                      // }else if(liabilityUnpaidBalanceAmountController.text.isEmpty){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
                      // }else if(Get.put(LiabilityViewController()).selectedAddedBy.value == 'processor' && Get.put(LiabilityViewController()).verifiedButExeCheck == true && selectedExcludedReason .isEmpty){
                      //   SnackBarApp().errorSnack('Info Incomplete', 'Please select excluded reason');
                      // }
                      // else{
                      //   await FirestoreService().addLiability(Get.put(LiabilityViewController()).selectedAddedBy.value,borrowerId,liabilityNameController.text,liabilityMonthlyAmountController.text,
                      //       controller.selectedLiabilityType.value,liabilityUnpaidBalanceAmountController.text,
                      //   liabilityRemainingMonthController.text,verifyStatus,selectedExcludedReason,box.read(Constants.USER_NAME));
                      // }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.primaryColor),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            )
                        )
                    ),
                    child: const Text('Save',style: TextStyle(color: AppColors.textColorWhite),)
                ).paddingOnly(top: Get.height * .04),
              )
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );

    // Get.defaultDialog(
    //   title: 'Edit Liability',
    //   titleStyle: const TextStyle(fontSize: 16,
    //       fontWeight: FontWeight.bold,
    //       color: AppColors.textColorBlack),
    //   barrierDismissible: true,
    //   content: Flexible(
    //     child: SingleChildScrollView(
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //
    //           Text('Liability Name *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
    //               fontSize: 12),),
    //           TextFormField(
    //             controller: liabilityNameController,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 hintText: 'Type Name',
    //                 hintStyle: TextStyle(fontSize: 12),
    //                 border: const OutlineInputBorder(),
    //                 contentPadding: EdgeInsets.symmetric(
    //                     vertical: Get.height * .01, horizontal: Get.width * .02)
    //             ),
    //           ),
    //           Text('Liability Type *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
    //               fontSize: 12),).paddingOnly(top: Get.height * .01),
    //           DropdownButtonFormField2<String>(
    //             value: liabilityController.selectedLiabilityType.value,
    //             isExpanded: false,
    //             decoration: InputDecoration(
    //               // Add Horizontal padding using menuItemStyleData.padding so it matches
    //               // the menu padding when button's width is not specified.
    //               contentPadding: const EdgeInsets.symmetric(vertical: 10),
    //               border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(4),
    //               ),
    //               // Add more decoration..
    //             ),
    //             hint: const Text(
    //               'Select Liability Type',
    //               style: TextStyle(fontSize: 12),
    //             ),
    //             items: Constants().liabilityTypes
    //                 .map((item) => DropdownMenuItem<String>(
    //               value: item,
    //               child: Text(
    //                 item,
    //                 style: const TextStyle(
    //                     fontSize: 14,
    //                     color: AppColors.primaryColor
    //                 ),
    //               ),
    //             )).toList(),
    //             validator: (value) {
    //               if (value == null) {
    //                 return 'Select Liability Type';
    //               }
    //               return null;
    //             },
    //             onChanged: (value) {
    //               //Do something when selected item is changed.
    //               liabilityMonthlyAmountController.text =  '';
    //               liabilityUnpaidBalanceAmountController.text = '';
    //               liabilityController.onePercentAmount.value  = 0.00;
    //               liabilityController.selectedLiabilityType.value = value.toString();
    //             },
    //             onSaved: (value) {
    //               liabilityMonthlyAmountController.text =  '';
    //               liabilityUnpaidBalanceAmountController.text = '';
    //               liabilityController.onePercentAmount.value  = 0.00;
    //               liabilityController.selectedLiabilityType.value = value.toString();
    //             },
    //             buttonStyleData: const ButtonStyleData(
    //               padding: EdgeInsets.only(right: 8),
    //             ),
    //             iconStyleData: const IconStyleData(
    //               icon: Icon(
    //                 Icons.arrow_drop_down,
    //                 color: Colors.black45,
    //               ),
    //               iconSize: 24,
    //             ),
    //             dropdownStyleData: DropdownStyleData(
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //             ),
    //             menuItemStyleData: const MenuItemStyleData(
    //               padding: EdgeInsets.symmetric(horizontal: 16),
    //             ),
    //           ),
    //
    //           Text('Unpaid Balance *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
    //               fontSize: 12),).paddingOnly(top: Get.height * .01),
    //           Container(
    //             decoration: BoxDecoration(
    //               border: Border.all(color: Colors.black, width: 1.0),
    //               borderRadius: BorderRadius.circular(4.0),
    //             ),
    //             child: Row(
    //               children: [
    //                 Container(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
    //                 ),
    //                 VerticalDivider(
    //                   color: Colors.black,
    //                   thickness: 2.0,
    //                   width: Get.width * .01,
    //                 ),
    //                 Expanded(
    //                   child: TextFormField(
    //                     controller: liabilityUnpaidBalanceAmountController,
    //                     keyboardType: TextInputType.number,
    //                     // validator: (value) {
    //                     //   if (value!.isEmpty) {
    //                     //     return 'Please enter liability amount';
    //                     //   }
    //                     //   return null;
    //                     //
    //                     // },
    //                     onChanged: (String amount){
    //                       if(liabilityController.selectedLiabilityType.value == 'Installment (Student)'){
    //                         if(amount.isNotEmpty){
    //                           liabilityController.calculateOnePercent(double.parse(amount));
    //                         }else{
    //                           liabilityController.onePercentAmount.value = 0.00;
    //                         }
    //                       }else{
    //                         liabilityController.onePercentAmount.value = 0.00;
    //                       }
    //                     },
    //                     decoration: InputDecoration(
    //                       isDense: true,
    //                       hintText: 'Type Amount',
    //                       hintStyle: TextStyle(fontSize: 12),
    //                       border: InputBorder.none,
    //                       contentPadding: const EdgeInsets.only(
    //                           top: 0,bottom: 4),
    //
    //                       prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Obx(() => liabilityController.selectedLiabilityType.value == 'Installment (Student)'?Column(
    //             children: [
    //               Row(
    //                 children: [
    //                   const Expanded(child: Text('I know my Monthly Payment',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
    //                   Obx(() => Checkbox(
    //                       value: liabilityController.idoKnow.value,
    //                       onChanged: (value){
    //                         liabilityController.idoKnow.value = value!;
    //                         liabilityController.idoNotKnow.value = false;
    //                         liabilityMonthlyAmountController.text = '';
    //                         // liabilityController.onePercentAmount.value  = 0.00;
    //                       }),)
    //                 ],
    //               ),
    //               Row(
    //                 children: [
    //                   const Expanded(child: Text('I do not know my Monthly Payment 1% of Unpaid Balance will be used.',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
    //                   Obx(() => Checkbox(
    //                       value: liabilityController.idoNotKnow.value,
    //                       onChanged: (value){
    //                         liabilityController.idoNotKnow.value = value!;
    //                         liabilityController.idoKnow.value = false;
    //                         liabilityMonthlyAmountController.text = '';
    //                         // liabilityController.onePercentAmount.value  = 0.00;
    //                       }),)
    //                 ],
    //               ),
    //             ],
    //           ):const SizedBox(),)  ,
    //           Obx(() =>liabilityController.selectedLiabilityType.value != 'Installment (Student)'? Text('Monthly Payment *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
    //               fontSize: 12),).paddingOnly(top: Get.height * .01):Text('Monthly Payment',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
    //               fontSize: 12),).paddingOnly(top: Get.height * .01),),
    //           Obx(() => liabilityController.selectedLiabilityType.value  != 'Installment (Student)'? Container(
    //             decoration: BoxDecoration(
    //               border: Border.all(color: Colors.black, width: 1.0),
    //               borderRadius: BorderRadius.circular(4.0),
    //             ),
    //             child: Row(
    //               children: [
    //                 Container(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
    //                 ),
    //                 VerticalDivider(
    //                   color: Colors.black,
    //                   thickness: 2.0,
    //                   width: Get.width * .01,
    //                 ),
    //                 Expanded(
    //                   child: TextFormField(
    //                     controller: liabilityMonthlyAmountController,
    //                     keyboardType: TextInputType.number,
    //                     // validator: (value) {
    //                     //   if (value!.isEmpty) {
    //                     //     return 'Please enter liability amount';
    //                     //   }
    //                     //   return null;
    //                     //
    //                     // },
    //                     decoration: InputDecoration(
    //                       isDense: true,
    //                       hintText: 'Type Amount',
    //                       hintStyle: TextStyle(fontSize: 12),
    //                       border: InputBorder.none,
    //                       contentPadding: const EdgeInsets.only(
    //                           top: 10),
    //                       suffixIcon: Text('per month',style: TextStyle(fontSize: 10,
    //                           color: AppColors.primaryColor),).paddingOnly(top: 16,right: 8,left: 8,),
    //                       prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ):
    //           liabilityController.idoNotKnow.value? Container(
    //             height: Get.height * .05,
    //             decoration: BoxDecoration(
    //               color:AppColors.viewColor.withOpacity(.8),
    //             ),
    //             child: Row(
    //               children: [
    //                 Icon(Icons.attach_money_outlined,color: AppColors.primaryColor,),
    //                 Expanded(
    //                     child:Obx(() => Text('\$${UtilMethods().formatNumberWithCommas(liabilityController.onePercentAmount.value)}'))
    //                 )
    //               ],
    //             ),
    //           ):TextFormField(
    //             controller: liabilityMonthlyAmountController,
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(
    //                 hintText: 'Type Month Remaining',
    //                 hintStyle: TextStyle(fontSize: 12),
    //                 border: const OutlineInputBorder(),
    //                 contentPadding: EdgeInsets.symmetric(
    //                     vertical: Get.height * .01, horizontal: Get.width * .02)
    //             ),
    //           ),),
    //
    //
    //           Text('Month Remaining ( optional )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
    //               fontSize: 12),).paddingOnly(top: Get.height * .01),
    //           TextFormField(
    //             controller: liabilityRemainingMonthController,
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(
    //                 hintText: 'Type Month Remaining',
    //                 hintStyle: TextStyle(fontSize: 12),
    //                 border: const OutlineInputBorder(),
    //                 contentPadding: EdgeInsets.symmetric(
    //                     vertical: Get.height * .01, horizontal: Get.width * .02)
    //             ),
    //           ),
    //
    //           SizedBox(
    //             width: Get.width * .4,
    //             height: Get.height * .1,
    //             child: ElevatedButton(
    //                 onPressed: () async{
    //                   if (liabilityNameController.text.isEmpty){
    //                     SnackBarApp().errorSnack('Info Incomplete', 'Please enter liability Name');
    //                   }else if(liabilityController.selectedLiabilityType.value == ''){
    //                     SnackBarApp().errorSnack('Info Incomplete', 'Please select liability Type');
    //                   } else if(liabilityController.selectedLiabilityType.value != 'Installment (Student)'){
    //                     if(liabilityUnpaidBalanceAmountController.text.isEmpty){
    //                       SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
    //                     }else if(liabilityMonthlyAmountController.text.isEmpty){
    //                       SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');
    //                     }else{
    //                       await FirestoreService().updateLiabilityValues(
    //                           index,
    //                           liabilityNameController.text,
    //                           liabilityController.selectedLiabilityType.value,
    //                           liabilityMonthlyAmountController.text,
    //                           liabilityUnpaidBalanceAmountController.text,
    //                           liabilityRemainingMonthController.text,
    //                           liabilityController.statusLiability,liabilityController.idoKnow.value,liabilityController.idoNotKnow.value,
    //                           borrowerId);
    //                     }
    //                   }else if(liabilityController.selectedLiabilityType.value == 'Installment (Student)'){
    //                     if(liabilityUnpaidBalanceAmountController.text.isEmpty){
    //                       SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
    //                     }else if(liabilityController.idoKnow.value == true && liabilityMonthlyAmountController.text.isEmpty){
    //                       SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');
    //                     }
    //                     else{
    //                       await FirestoreService().updateLiabilityValues(
    //                           index,liabilityNameController.text,
    //                           liabilityController.selectedLiabilityType.value,
    //                           liabilityController.idoKnow.value == true?liabilityMonthlyAmountController.text: liabilityController.onePercentAmount.toString(),
    //                           liabilityUnpaidBalanceAmountController.text,
    //                           liabilityRemainingMonthController.text,
    //                           liabilityController.statusLiability,liabilityController.idoKnow.value,liabilityController.idoNotKnow.value,
    //                           borrowerId);
    //                     }
    //                   }
    //
    //
    //
    //                   // final isConnected = await ConnectivityStateChecker().checkState();
    //                   // if (liabilityNameController.text.isEmpty){
    //                   //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter liability Name');
    //                   // }else if(liabilityController.selectedLiabilityType.value == ''){
    //                   //   SnackBarApp().errorSnack('Info Incomplete', 'Please select liability Type');
    //                   // }
    //                   // else if(liabilityController.selectedLiabilityType.value != 'Installment (Student)'){
    //                   //   if(liabilityUnpaidBalanceAmountController.text.isEmpty){
    //                   //     SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
    //                   //   }else if(liabilityMonthlyAmountController.text.isEmpty){
    //                   //     SnackBarApp().errorSnack('Info Incomplete', 'Please enter monthly amount');
    //                   //   }else if(!isConnected){
    //                   //     SnackBarApp().errorSnack('Connection error', 'Please check your Internet connection and try again.');
    //                   //   }else{
    //                   //       await FirestoreService().updateLiabilityValues(
    //                   //           index,
    //                   //           liabilityNameController.text,
    //                   //           liabilityController.selectedLiabilityType.value,
    //                   //           liabilityMonthlyAmountController.text,
    //                   //           liabilityUnpaidBalanceAmountController.text,
    //                   //           liabilityRemainingMonthController.text,
    //                   //       controller.statusLiability);
    //                   //   }
    //                   // }else if(liabilityController.selectedLiabilityType.value == 'Installment (Student)'){
    //                   //   if(liabilityUnpaidBalanceAmountController.text.isEmpty){
    //                   //     SnackBarApp().errorSnack('Info Incomplete', 'Please enter balance amount');
    //                   //   }else if(!isConnected){
    //                   //     SnackBarApp().errorSnack('Connection error', 'Please check your Internet connection and try again.');
    //                   //   }else{
    //                   //     await FirestoreService().updateLiabilityValues(
    //                   //         index,liabilityNameController.text,
    //                   //         liabilityController.selectedLiabilityType.value,
    //                   //         liabilityController.onePercentAmount.toString(),
    //                   //         liabilityUnpaidBalanceAmountController.text,
    //                   //         liabilityRemainingMonthController.text,
    //                   //         controller.statusLiability);
    //                   //   }
    //                   // }
    //                 },
    //                 style: ButtonStyle(
    //                     backgroundColor: MaterialStateProperty.all<Color>(
    //                         AppColors.primaryColor),
    //                     shape: MaterialStateProperty.all<
    //                         RoundedRectangleBorder>(
    //                         RoundedRectangleBorder(
    //                           borderRadius: BorderRadius.circular(0.0),
    //                         )
    //                     )
    //                 ),
    //                 child: const Text('Save Changes',style: TextStyle(color: AppColors.textColorWhite),)
    //             ).paddingOnly(top: Get.height * .04),
    //           )
    //         ],
    //       ).marginSymmetric(horizontal: 8),
    //     ),
    //   ),
    // );

  }

  removeLiabilityDialog(int index, String borrowerId, String liabilityName, String borrowerName, String borrowerPhoneNumber){
    Get.defaultDialog(
      title: 'Remove Liability',
      middleText: 'Are you sure want to remove liability',
      titleStyle: const TextStyle(color: AppColors.primaryColor,fontSize: 16,fontWeight: FontWeight.bold),
      confirm: TextButton(onPressed: ()async{
        await FirestoreService().removeLiability(index,borrowerId,liabilityName,borrowerName,borrowerPhoneNumber);

      }, child: const Text('Yes')),
      cancel: TextButton(onPressed: (){
        Get.back();
      }, child: const Text('No')),
    );
  }
}