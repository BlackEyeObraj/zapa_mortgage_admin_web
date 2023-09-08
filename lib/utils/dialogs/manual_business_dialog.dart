import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../controllers/add_income_dialog_controller.dart';
import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../constants.dart';
import '../snack_bar.dart';
import '../utils_mehtods.dart';
import '../widgets/text_widget.dart';

class ManualBusinessDialog{
  String baseYear = '';
  String w2Year = '';
  String priorW2Year = '';
  addManualBusinessDialog(AddIncomeDialogController controller, String borrowerId){
    final box = GetStorage();
    String businessStartDateStamp = '';
    String greaterOrLessThen2Years = '';
    controller.setBusinessNameTextController('');
    controller.setNetProfitTextController('');
    controller.calculateMonthlyIncome('0.0');
    controller.setStartDateOfBusinessTextController('');
    controller.setCurrentActiveStatus(true);
    String verifyStatus = 'Verified';
    Get.put(AddIncomeDialogController()).selectedAddedBy.value = 'processor';

    Get.defaultDialog(
      title: 'Add Your ${controller.businessIncomeType}',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content: SingleChildScrollView(
        child: SizedBox(
          width: Get.width * .4,
          height: Get.height * .6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: Text("Add as Processor"),
                            value: "processor",
                            groupValue: Get.put(AddIncomeDialogController()).selectedAddedBy.value,
                            onChanged: (value){
                              Get.put(AddIncomeDialogController()).selectedAddedBy.value = 'processor';
                              Get.put(AddIncomeDialogController()).setVerifyCheck('verified', true);
                              Get.put(AddIncomeDialogController()).setVerifyCheck('verifiedButExeCheck', false);
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: Text("Add as Borrower"),
                            value: "customer",
                            groupValue: Get.put(AddIncomeDialogController()).selectedAddedBy.value,
                            onChanged: (value){
                              Get.put(AddIncomeDialogController()).selectedAddedBy.value = 'customer';
                              Get.put(AddIncomeDialogController()).setVerifyCheck('verified', true);
                              Get.put(AddIncomeDialogController()).setVerifyCheck('verifiedButExeCheck', false);
                            },
                          ),
                        )
                      ],
                    ),),

                    Text('Business Name / Type',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 12),).paddingOnly(top: 8),
                    TextFormField(
                      controller: controller.businessNameTextController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Type Name',
                          hintStyle: TextStyle(fontSize: 12),
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Get.height * .01, horizontal: Get.width * .02)
                      ),
                    ),
                    Text('Net Profit / Loss ( Annual )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
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
                          Expanded(
                            child: TextFormField(
                              controller: controller.netProfitTextController,
                              keyboardType: TextInputType.number,
                              onChanged: (String annualIncome){
                                if(controller.netProfitTextController.text == ''){
                                  controller.setMonthlyIncomeToZero();
                                }
                                controller.calculateMonthlyIncome(annualIncome);
                              },
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
                    Text('Monthly Income ( Estimated )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 12),).paddingOnly(top: 8),
                    Container(
                      width: Get.width * 1,
                      height: Get.height * .06,
                      decoration:  BoxDecoration(
                          color:AppColors.viewColor.withOpacity(.8),
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.attach_money,color: AppColors.primaryColor,),
                                Obx(() => Text(controller.calculatedMonthlyIncome,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),)),
                              ],
                            ),
                            Text('/ per month',style: TextStyle(fontSize: 10),)

                          ],).paddingSymmetric(horizontal: Get.width * .02),
                      ),
                    ).paddingOnly(top: Get.height * .004),
                    Text('Select Start Date',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 12),).paddingOnly(top: 8),
                    GestureDetector(
                      onTap: (){
                        showDatePicker(
                          context: Get.context!,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            businessStartDateStamp = selectedDate.toString();
                            greaterOrLessThen2Years = UtilMethods().isDifferenceGreaterThanTwoYears(businessStartDateStamp).toString();
                            String startWorkDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                            controller.startDateOfBusinessTextController.text = startWorkDate;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blackColor.withOpacity(.5), // Set the color of the outline border
                            width: 1.0, // Set the width of the outline border
                          ),
                          borderRadius: BorderRadius.circular(4.0), // Set the border radius
                        ),
                        child: TextFormField(
                          controller: controller.startDateOfBusinessTextController,
                          enabled: false,
                          style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Select Date',
                            hintStyle: TextStyle(fontSize: 12,color: AppColors.blackColor.withOpacity(.6)),
                            prefixIcon: Icon(Icons.calendar_month,color: AppColors.blackColor.withOpacity(.4),),
                            border: InputBorder.none, // Remove the default border
                          ),
                        ),
                      ).paddingOnly(top: Get.height * .002),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Checkbox(
                            value: controller.currentlyActive,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value){
                              if(controller.currentlyActive == false){
                                controller.setCurrentActiveStatus(true);
                              }else{
                                controller.setCurrentActiveStatus(false);
                              }
                            }
                        ),),
                        const TextWidget(
                            text: 'Currently Active ?',
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            fontColor: AppColors.textColorBlack,
                            textAlign: TextAlign.center)
                      ],
                    ),
                    // Obx(() => !controller.currentlyActive ?Text('If your business in currently inactive or not running. Then this income will not be considered in total income.'):SizedBox()),
                    Obx(() => !controller.currentlyActive ?RichText(
                      text: const TextSpan(
                        text: 'Note: ',
                        style: TextStyle(color: AppColors.errorTextColor),
                        children: <TextSpan>[
                          TextSpan(text: 'If your business in currently inactive or not running. Then this income will not be considered in total income.',
                          style: TextStyle(color: AppColors.textColorBlack)),
                        ],
                      ),
                    ):SizedBox()),
                    Obx(() => Get.put(AddIncomeDialogController()).selectedAddedBy.value == 'processor' ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Obx(() =>  Checkbox(
                                value: Get.put(AddIncomeDialogController()).verifiedCheck,
                                onChanged: (value){
                                  if(Get.put(AddIncomeDialogController()).verifiedCheck == true){
                                    verifyStatus = 'Verified But Excluded';
                                    Get.put(AddIncomeDialogController()).setVerifyCheck('verified', false);
                                    Get.put(AddIncomeDialogController()).setVerifyCheck('verifiedButExcluded', true);
                                  }else{
                                    verifyStatus = 'Verified';
                                    Get.put(AddIncomeDialogController()).setVerifyCheck('verified', true);
                                    Get.put(AddIncomeDialogController()).setVerifyCheck('verifiedButExcluded', false);
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
                                value: Get.put(AddIncomeDialogController()).verifiedButExeCheck,
                                onChanged: (value){
                                  if(Get.put(AddIncomeDialogController()).verifiedButExeCheck == true){
                                    verifyStatus = 'Verified';
                                    Get.put(AddIncomeDialogController()).setVerifyCheck('verified', true);
                                    Get.put(AddIncomeDialogController()).setVerifyCheck('verifiedButExcluded', false);
                                  }else{
                                    verifyStatus = 'Verified But Excluded';
                                    Get.put(AddIncomeDialogController()).setVerifyCheck('verified', false);
                                    Get.put(AddIncomeDialogController()).setVerifyCheck('verifiedButExcluded', true);
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
                      width: Get.width * 1,
                      child: ElevatedButton(
                          onPressed: () async{
                            if(controller.businessNameTextController.text.isEmpty){
                                SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Your Business Name');
                            }else if(controller.netProfitTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Net Profit / Loss');
                            }else if(controller.startDateOfBusinessTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please Select Start Date Of Your Business');
                            }else{
                              await getCurrentAndPreviousYears();
                              FirestoreService().addBusinessManual(
                                borrowerId,
                                  controller.businessNameTextController.text,
                                  controller.netProfitTextController.text,
                                  controller.monthlyIncome,
                                  controller.startDateOfBusinessTextController.text,
                                  controller.businessIncomeType,
                                  controller.currentlyActive.toString(),
                                  baseYear,
                                  w2Year,
                                  priorW2Year,
                                businessStartDateStamp,
                                  greaterOrLessThen2Years,
                                  Get.put(AddIncomeDialogController()).selectedAddedBy.value,
                                verifyStatus,
                                  box.read(Constants.USER_NAME)
                              );
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
                ),
              )),
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );


  }
  editManualBusinessDialog(AddIncomeDialogController controller, int index,String companyName,String currentlyActive, String employerIncomeType, String grossAnnualIncome, String startDate,String businessStartDateStampValue, String greaterOrLessThen2YearsValue){
    String businessStartDateStamp = businessStartDateStampValue;
    String greaterOrLessThen2Years = greaterOrLessThen2YearsValue;
    print(businessStartDateStamp);
    controller.setBusinessNameTextController(companyName);
    controller.setNetProfitTextController(grossAnnualIncome);
    controller.calculateMonthlyIncome(grossAnnualIncome);
    controller.setStartDateOfBusinessTextController(startDate);
    controller.setCurrentActiveStatus(bool.parse(currentlyActive));
    Get.defaultDialog(
      title: 'Edit $employerIncomeType',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content: SingleChildScrollView(
        child: SizedBox(
          width: Get.width * 1,
          height: Get.height * .4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Business Name / Type',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 12),).paddingOnly(top: 8),
                    TextFormField(
                      controller: controller.businessNameTextController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Type Name',
                          hintStyle: TextStyle(fontSize: 12),
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Get.height * .01, horizontal: Get.width * .02)
                      ),
                    ),
                    Text('Net Profit / Loss ( Annual )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
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
                          Expanded(
                            child: TextFormField(
                              controller: controller.netProfitTextController,
                              keyboardType: TextInputType.number,
                              onChanged: (String annualIncome){
                                if(controller.netProfitTextController.text == ''){
                                  controller.setMonthlyIncomeToZero();
                                }
                                controller.calculateMonthlyIncome(annualIncome);
                              },
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
                    Text('Monthly Income ( Estimated )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 12),).paddingOnly(top: 8),
                    Container(
                      width: Get.width * 1,
                      height: Get.height * .06,
                      decoration:  BoxDecoration(
                          color:AppColors.viewColor.withOpacity(.8),
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.attach_money,color: AppColors.primaryColor,),
                                Obx(() => Text(controller.calculatedMonthlyIncome,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),)),
                              ],
                            ),
                            Text('/ per month',style: TextStyle(fontSize: 10),)

                          ],).paddingSymmetric(horizontal: Get.width * .02),
                      ),
                    ).paddingOnly(top: Get.height * .004),
                    Text('Select Start Date',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 12),).paddingOnly(top: 8),
                    GestureDetector(
                      onTap: (){
                        showDatePicker(
                          context: Get.context!,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            businessStartDateStamp = selectedDate.toString();
                            greaterOrLessThen2Years = UtilMethods().isDifferenceGreaterThanTwoYears(businessStartDateStamp).toString();
                            String startWorkDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                            controller.startDateOfBusinessTextController.text = startWorkDate;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.blackColor.withOpacity(.5), // Set the color of the outline border
                            width: 1.0, // Set the width of the outline border
                          ),
                          borderRadius: BorderRadius.circular(4.0), // Set the border radius
                        ),
                        child: TextFormField(
                          controller: controller.startDateOfBusinessTextController,
                          enabled: false,
                          style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Select Date',
                            hintStyle: TextStyle(fontSize: 12,color: AppColors.blackColor.withOpacity(.6)),
                            prefixIcon: Icon(Icons.calendar_month,color: AppColors.blackColor.withOpacity(.4),),
                            border: InputBorder.none, // Remove the default border
                          ),
                        ),
                      ).paddingOnly(top: Get.height * .002),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Checkbox(
                            value: controller.currentlyActive,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value){
                              if(controller.currentlyActive == false){
                                controller.setCurrentActiveStatus(true);
                                print(controller.currentlyActive.toString());
                              }else{
                                controller.setCurrentActiveStatus(false);
                                print(controller.currentlyActive.toString());
                              }
                            }
                        ),),
                        const TextWidget(
                            text: 'Currently Active ?',
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            fontColor: AppColors.textColorBlack,
                            textAlign: TextAlign.center)
                      ],
                    ),
                    // Obx(() => !controller.currentlyActive ?Text('If your business in currently inactive or not running. Then this income will not be considered in total income.'):SizedBox()),
                    Obx(() => !controller.currentlyActive ?RichText(
                      text: const TextSpan(
                        text: 'Note: ',
                        style: TextStyle(color: AppColors.errorTextColor),
                        children: <TextSpan>[
                          TextSpan(text: 'If your business in currently inactive or not running. Then this income will not be considered in total income.',
                          style: TextStyle(color: AppColors.textColorBlack)),
                        ],
                      ),
                    ):SizedBox()),
                    SizedBox(
                      width: Get.width * 1,
                      child: ElevatedButton(
                          onPressed: () async{
                            if(controller.businessNameTextController.text.isEmpty){
                                SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Your Business Name');
                            }else if(controller.netProfitTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Net Profit / Loss');
                            }else if(controller.startDateOfBusinessTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please Select Start Date Of Your Business');
                            }else{
                              // FirestoreService().editBusinessManual(
                              //     controller.businessNameTextController.text,
                              //     controller.netProfitTextController.text,
                              //     controller.monthlyIncome,
                              //     startDate, controller.currentlyActive.toString(),
                              //     index,
                              //     businessStartDateStamp,
                              //   controller.startDateOfBusinessTextController.text,
                              //   greaterOrLessThen2Years
                              // );
                            }
                            // if(selectedAssetType == ''){
                            //   SnackBarApp().errorSnack('Info Incomplete', 'Please select asset type');
                            // }else if(bankNameController.text.isEmpty){
                            //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter bank name');
                            // }else if(amountController.text.isEmpty){
                            //   SnackBarApp().errorSnack('Info Incomplete', 'Please enter current balance');
                            // }else{
                            //   await FirestoreService().addFunds(
                            //       selectedAssetType,
                            //       bankNameController.text,
                            //       accountNumberController.text,
                            //       amountController.text);
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
                      ).paddingOnly(top: Get.height * .02),
                    )

                  ],
                ),
              )),
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );


  }

  getCurrentAndPreviousYears(){
    var currentDate = DateTime.now();
    var w2Date = DateTime(currentDate.year-1);
    var priorW2Date = DateTime(w2Date.year-1);
    baseYear = currentDate.year.toString();
    w2Year = w2Date.year.toString();
    priorW2Year = priorW2Date.year.toString();
  }
}