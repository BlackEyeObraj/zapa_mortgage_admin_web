import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zapa_mortgage_admin_web/controllers/funds_view_controller.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../constants.dart';
import '../snack_bar.dart';

class FundDialog{

  addFundDialog(String borrowerID){
    final box = GetStorage();
    Get.put(FundsViewController()).selectedAssetTypeFund.value = '';
    Get.put(FundsViewController()).setSelectedAssetTypeEnableOrDisable(true);
    final bankNameController = TextEditingController();
    final accountNumberController = TextEditingController();
    final amountController = TextEditingController();
    String verifyStatus = 'Verified';

    Get.defaultDialog(
      title: 'Add New Fund',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content:
      Flexible(
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
                      groupValue: Get.put(FundsViewController()).selectedAddedBy.value,
                      onChanged: (value){
                        Get.put(FundsViewController()).selectedAddedBy.value = 'processor';
                        Get.put(FundsViewController()).setVerifyCheck('verified', true);
                        Get.put(FundsViewController()).setVerifyCheck('verifiedButExeCheck', false);
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text("Add as Borrower"),
                      value: "customer",
                      groupValue: Get.put(FundsViewController()).selectedAddedBy.value,
                      onChanged: (value){
                        Get.put(FundsViewController()).selectedAddedBy.value = 'customer';
                        Get.put(FundsViewController()).setVerifyCheck('verified', true);
                        Get.put(FundsViewController()).setVerifyCheck('verifiedButExeCheck', false);
                      },
                    ),
                  )
                ],
              ),),

              Text('Asset Type',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),),
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
                  'Select Asset Type',
                  style: TextStyle(fontSize: 14),
                ),
                items: Constants().assetsItems
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
                    return 'Select Asset Type';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when selected item is changed.
                  Get.put(FundsViewController()).selectedAssetTypeFund.value = value.toString();
                  Get.put(FundsViewController()).setSelectedAssetTypeEnableOrDisable(true);
                  print(Get.put(FundsViewController()).selectedAssetTypeFund.value);
                },
                onSaved: (value) {
                  Get.put(FundsViewController()).selectedAssetTypeFund.value = value.toString();
                  Get.put(FundsViewController()).setSelectedAssetTypeEnableOrDisable(true);
                  print(Get.put(FundsViewController()).selectedAssetTypeFund.value);
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
              Text('Name of Bank/Source',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: 8),
              TextFormField(
                controller: bankNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Type Name',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),
              Text('Account Number (optional)',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: 8),
              TextFormField(
                controller: accountNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Type Account Number',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),
              Obx(() => Get.put(FundsViewController()).selectedAssetTypeFund.value == 'Gift Funds - from Donor'?
              Text('Current Balance ( Funds Available )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01):Text('Current Balance',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).paddingOnly(top: Get.height * .01),),
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
                        controller: amountController,
                        keyboardType: TextInputType.number,

                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Type Amount',
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
              ),
              Obx(() => Get.put(FundsViewController()).selectedAssetTypeFund.value == 'Gift Funds - from Donor'?
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                      value: Get.put(FundsViewController()).selectedAssetTypeEnable,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value){
                        if(Get.put(FundsViewController()).selectedAssetTypeEnable == true){
                          Get.put(FundsViewController()).setSelectedAssetTypeEnableOrDisable(false);
                        }else{
                          Get.put(FundsViewController()).setSelectedAssetTypeEnableOrDisable(true);
                        }
                      }
                  ),
                  const Flexible(
                    child: Text('I here by verify that I shall receive gift funds from a relative.\n'
                        '(Related by blood, marriage, adoption )'),
                  )
                ],
              ).paddingOnly(top: 8):const SizedBox(),),
              Obx(() =>Get.put(FundsViewController()).selectedAssetTypeEnable == false?
              const Text("* If You don't verify. This fund can not be modified until it is verified by ZAPA Mortgage Team.",
              style: TextStyle(color: AppColors.errorTextColor),).paddingSymmetric(horizontal: 8):const SizedBox()),
              Obx(() => Get.put(FundsViewController()).selectedAddedBy.value == 'processor' ?
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Obx(() =>  Checkbox(
                          value: Get.put(FundsViewController()).verifiedCheck,
                          onChanged: (value){
                            if(Get.put(FundsViewController()).verifiedCheck == true){
                              verifyStatus = 'Verified But Excluded';
                              Get.put(FundsViewController()).setVerifyCheck('verified', false);
                              Get.put(FundsViewController()).setVerifyCheck('verifiedButExcluded', true);
                            }else{
                              verifyStatus = 'Verified';
                              Get.put(FundsViewController()).setVerifyCheck('verified', true);
                              Get.put(FundsViewController()).setVerifyCheck('verifiedButExcluded', false);
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
                          value: Get.put(FundsViewController()).verifiedButExeCheck,
                          onChanged: (value){
                            if(Get.put(FundsViewController()).verifiedButExeCheck == true){
                              verifyStatus = 'Verified';
                              Get.put(FundsViewController()).setVerifyCheck('verified', true);
                              Get.put(FundsViewController()).setVerifyCheck('verifiedButExcluded', false);
                            }else{
                              verifyStatus = 'Verified But Excluded';
                              Get.put(FundsViewController()).setVerifyCheck('verified', false);
                              Get.put(FundsViewController()).setVerifyCheck('verifiedButExcluded', true);
                            }
                          }
                      ),),
                      Text('Verified But Excluded',style: TextStyle(fontSize: 12),)
                    ],
                  ),
                ],
              ).marginOnly(top: 8):SizedBox(),
              ),

              SizedBox(
                width: Get.width * .4,
                height: Get.height * .08,
                child: ElevatedButton(
                    onPressed: () async{
                      if(Get.put(FundsViewController()).selectedAssetTypeFund.value == ''){
                          SnackBarApp().errorSnack('Info Incomplete', 'Please select asset type');
                      }else if(bankNameController.text.isEmpty){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please enter bank name');
                      }else if(amountController.text.isEmpty){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please enter current balance');
                      }else{
                        await FirestoreService().addFunds(Get.put(FundsViewController()).selectedAddedBy.value,borrowerID,
                            Get.put(FundsViewController()).selectedAssetTypeFund.value,
                            bankNameController.text,
                            accountNumberController.text,
                            amountController.text,
                            Get.put(FundsViewController()).selectedAssetTypeEnable,verifyStatus,box.read(Constants.USER_NAME));
                      }
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
                ).paddingOnly(top: Get.height * .02),
              )
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );
  }
  // editFundDialog(int index, String assetType,String accountNumber, String currentBalance, String bankName, bool userVerifiedFund, StatusDetailScreenController controller,String status, ){
  //   final bankNameController = TextEditingController(text: bankName);
  //   final accountNumberController = TextEditingController(text: accountNumber);
  //   final amountController = TextEditingController(text:currentBalance);
  //   controller.selectedAssetTypeFund.value = assetType;
  //   controller.setSelectedAssetTypeEnableOrDisable(userVerifiedFund);
  //   String statusCurrent = status;
  //
  //
  //   Get.defaultDialog(
  //     title: 'Edit Fund',
  //     titleStyle: const TextStyle(fontSize: 16,
  //         fontWeight: FontWeight.bold,
  //         color: AppColors.textColorBlack),
  //     barrierDismissible: true,
  //     content:
  //     Flexible(
  //       child: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text('Asset Type',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
  //                 fontSize: 12.sp),),
  //             DropdownButtonFormField2<String>(
  //               value: controller.selectedAssetTypeFund.value,
  //               isExpanded: false,
  //               decoration: InputDecoration(
  //                 // Add Horizontal padding using menuItemStyleData.padding so it matches
  //                 // the menu padding when button's width is not specified.
  //                 contentPadding: const EdgeInsets.symmetric(vertical: 10),
  //                 border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(4),
  //                 ),
  //                 // Add more decoration..
  //               ),
  //               hint: const Text(
  //                 'Select Asset Type',
  //                 style: TextStyle(fontSize: 14),
  //               ),
  //               items: Constants().assetsItems
  //                   .map((item) => DropdownMenuItem<String>(
  //                 value: item,
  //                 child: Text(
  //                   item,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     color: AppColors.primaryColor
  //                   ),
  //                 ),
  //               )).toList(),
  //               validator: (value) {
  //                 if (value == null) {
  //                   return 'Select Asset Type';
  //                 }
  //                 return null;
  //               },
  //               onChanged: (value) {
  //                 //Do something when selected item is changed.
  //                 controller.selectedAssetTypeFund.value = value.toString();
  //                 print(controller.selectedAssetTypeFund.value);
  //               },
  //               onSaved: (value) {
  //                 controller.selectedAssetTypeFund.value = value.toString();
  //                 print(controller.selectedAssetTypeFund.value);
  //               },
  //               buttonStyleData: const ButtonStyleData(
  //                 padding: EdgeInsets.only(right: 8),
  //               ),
  //               iconStyleData: const IconStyleData(
  //                 icon: Icon(
  //                   Icons.arrow_drop_down,
  //                   color: Colors.black45,
  //                 ),
  //                 iconSize: 24,
  //               ),
  //               dropdownStyleData: DropdownStyleData(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(15),
  //                 ),
  //               ),
  //               menuItemStyleData: const MenuItemStyleData(
  //                 padding: EdgeInsets.symmetric(horizontal: 16),
  //               ),
  //             ),
  //             Text('Name of Bank/Source',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
  //                 fontSize: 12.sp),).paddingOnly(top: 8),
  //             TextFormField(
  //               controller: bankNameController,
  //               keyboardType: TextInputType.text,
  //               decoration: InputDecoration(
  //                   hintText: 'Type Name',
  //                   hintStyle: TextStyle(fontSize: 12.sp),
  //                   border: const OutlineInputBorder(),
  //                   contentPadding: EdgeInsets.symmetric(
  //                       vertical: Get.height * .01, horizontal: Get.width * .02)
  //               ),
  //             ),
  //             Text('Account Number',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
  //                 fontSize: 12.sp),).paddingOnly(top: 8),
  //             TextFormField(
  //               controller: accountNumberController,
  //               keyboardType: TextInputType.number,
  //               decoration: InputDecoration(
  //                   hintText: 'Type Account Number',
  //                   hintStyle: TextStyle(fontSize: 12.sp),
  //                   border: const OutlineInputBorder(),
  //                   contentPadding: EdgeInsets.symmetric(
  //                       vertical: Get.height * .01, horizontal: Get.width * .02)
  //               ),
  //             ),
  //             Obx(() => controller.selectedAssetTypeFund.value == 'Gift Funds - from Donor'?
  //             Text('Current Balance ( Funds Available )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
  //                 fontSize: 12.sp),).paddingOnly(top: Get.height * .01):Text('Current Balance',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
  //                 fontSize: 12.sp),).paddingOnly(top: Get.height * .01),),
  //
  //             Container(
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.black, width: 1.0),
  //                 borderRadius: BorderRadius.circular(4.0),
  //               ),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(8.0),
  //                     child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
  //                   ),
  //                   VerticalDivider(
  //                     color: Colors.black,
  //                     thickness: 2.0,
  //                     width: Get.width * .01,
  //                   ),
  //                   Expanded(
  //                     child: TextFormField(
  //                       controller: amountController,
  //                       keyboardType: TextInputType.number,
  //
  //                       decoration: InputDecoration(
  //                         isDense: true,
  //                         hintText: 'Type Amount',
  //                         hintStyle: TextStyle(fontSize: 12.sp),
  //                         border: InputBorder.none,
  //                         contentPadding: const EdgeInsets.only(
  //                             bottom: 4),
  //
  //                         prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
  //                       ),
  //
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Obx(() => controller.selectedAssetTypeFund.value == 'Gift Funds - from Donor'?
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Checkbox(
  //                     value: controller.selectedAssetTypeEnable,
  //                     activeColor: AppColors.primaryColor,
  //                     onChanged: (value){
  //                       if(controller.selectedAssetTypeEnable == true){
  //                         controller.setSelectedAssetTypeEnableOrDisable(false);
  //                         statusCurrent = 'Exclude';
  //                       }else{
  //                         controller.setSelectedAssetTypeEnableOrDisable(true);
  //                         statusCurrent = 'Include';
  //                       }
  //                     }
  //                 ),
  //                 const Flexible(
  //                   child: Text('I here by verify that I shall receive gift funds from a relative. ('
  //                       ' Related by blood, marriage, adoption )'),
  //                 )
  //               ],
  //             ).paddingOnly(top: 8):const SizedBox(),),
  //             Obx(() =>controller.selectedAssetTypeEnable == false?
  //             const Text("* If You don't verify. This fund can not be modified until it is verified by ZAPA Mortgage Team.",
  //               style: TextStyle(color: AppColors.errorTextColor),).paddingSymmetric(horizontal: 8):const SizedBox()),
  //             SizedBox(
  //               width: Get.width * 1,
  //               child: ElevatedButton(
  //                   onPressed: () async{
  //                     if(controller.selectedAssetTypeFund.value == ''){
  //                         SnackBarApp().errorSnack('Info Incomplete', 'Please select asset type');
  //                     }else if(bankNameController.text.isEmpty){
  //                       SnackBarApp().errorSnack('Info Incomplete', 'Please enter bank name');
  //                     }else if(amountController.text.isEmpty){
  //                       SnackBarApp().errorSnack('Info Incomplete', 'Please enter current balance');
  //                     }else{
  //                       FirestoreService().updateFundValues(index, bankNameController.text,
  //                           accountNumberController.text, amountController.text, controller.selectedAssetTypeFund.value,controller.selectedAssetTypeEnable,statusCurrent);
  //                       Get.back();
  //                     }
  //                   },
  //                   style: ButtonStyle(
  //                       backgroundColor: MaterialStateProperty.all<Color>(
  //                           AppColors.primaryColor),
  //                       shape: MaterialStateProperty.all<
  //                           RoundedRectangleBorder>(
  //                           RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(0.0),
  //                           )
  //                       )
  //                   ),
  //                   child: const Text('Save Changes',style: TextStyle(color: AppColors.textColorWhite),)
  //               ).paddingOnly(top: Get.height * .02),
  //             )
  //           ],
  //         ).marginSymmetric(horizontal: 8),
  //       ),
  //     ),
  //   );
  // }
  //
  // removeFundDialog(int index){
  //   Get.defaultDialog(
  //     title: 'Remove Fund',
  //     middleText: 'Are you sure want to remove fund',
  //     titleStyle: TextStyle(color: AppColors.primaryColor,fontSize: 16,fontWeight: FontWeight.bold),
  //     confirm: TextButton(onPressed: ()async{
  //       await FirestoreService().removeFunds(index);
  //
  //     }, child: Text('Yes')),
  //     cancel: TextButton(onPressed: (){
  //       Get.back();
  //     }, child: Text('No')),
  //   );
  // }
}