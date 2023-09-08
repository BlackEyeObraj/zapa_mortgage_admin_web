import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:zapa_mortgage_admin_web/controllers/add_income_dialog_controller.dart';
import 'package:zapa_mortgage_admin_web/utils/constants.dart';
import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../snack_bar.dart';
import '../widgets/text_widget.dart';

class ManualIncomeDialog{
  String baseYear = '';
  String w2Year = '';
  String priorW2Year = '';
  addManualIncome(AddIncomeDialogController controller, String borrowerId){
    final box = GetStorage();
    controller.companyNameTextController.text = '';
    controller.grossAnnualIncomeTextController.text = '';
    controller.startDateIncomeTextController.text = '';
    controller.endDateIncomeTextController.text = '';
    controller.setCurrentWorkingStatus(true);
    controller.calculateMonthlyIncome('0.00');
    Get.put(AddIncomeDialogController()).selectedAddedBy.value = 'processor';
    String verifyStatus = 'Verified';

    Get.defaultDialog(
      title: 'Add ${controller.employerIncomeType}',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * .6,
          width: Get.width * .4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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

                    Text('Employer Name',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 12),).paddingOnly(top: 8),
                    TextFormField(
                      controller: controller.companyNameTextController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Type Name',
                          hintStyle: TextStyle(fontSize: 12),
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Get.height * .01, horizontal: Get.width * .02)
                      ),
                    ),
                    Text('Gross Annual Income ( Estimated )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
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
                              controller: controller.grossAnnualIncomeTextController,
                              keyboardType: TextInputType.number,
                              onChanged: (String annualIncome){
                                if(controller.grossAnnualIncomeTextController.text == ''){
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
                            String startWorkDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                            controller.startDateIncomeTextController.text = startWorkDate;
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
                          controller: controller.startDateIncomeTextController,
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
                            value: controller.currentlyWorking,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value){
                              if(controller.currentlyWorking == false){
                                controller.setCurrentWorkingStatus(true);
                                controller.endDateIncomeTextController.text = '';
                              }else{
                                controller.setCurrentWorkingStatus(false);
                                controller.endDateIncomeTextController.text = '';
                              }
                            }
                        ),),
                        const TextWidget(
                            text: 'Currently Working ?',
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            fontColor: AppColors.textColorBlack,
                            textAlign: TextAlign.center)
                      ],
                    ),
                    Obx(() => !controller.currentlyWorking? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select End Date',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
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
                                  String endWorkDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                                  controller.endDateIncomeTextController.text = endWorkDate;
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
                                controller: controller.endDateIncomeTextController,
                                enabled: false,
                                style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: 'Select Date',
                                  hintStyle: TextStyle(fontSize: 12,color: AppColors.blackColor.withOpacity(.6)),
                                  prefixIcon: Icon(Icons.calendar_month,color: AppColors.blackColor.withOpacity(.4),),
                                  border: InputBorder.none, // Remove the default border
                                ),
                              ),
                            )
                        ),
                      ],
                    ):const SizedBox(),),

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
                      height: 48,
                      width: Get.width * .4,
                      child: ElevatedButton(
                          onPressed: () async{
                            if(controller.companyNameTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please enter company name');
                            }else if(controller.grossAnnualIncomeTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please enter gross annual income');
                            }else if(controller.startDateIncomeTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please select start date');
                            }else{
                              await getCurrentAndPreviousYears();
                              FirestoreService().addIncomeManual(controller.selectedAddedBy.value,verifyStatus,borrowerId,controller.companyNameTextController.text,
                                  controller.grossAnnualIncomeTextController.text,controller.monthlyIncome,
                                  controller.startDateIncomeTextController.text,controller.endDateIncomeTextController.text,
                                  controller.employerIncomeType,baseYear,w2Year,priorW2Year,box.read(Constants.USER_NAME));
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
  editManualIncome(AddIncomeDialogController controller,
      String companyName,String grossAnnualIncome,String startDate, String endDate,
      String employerIncomeType, int index){
    controller.companyNameTextController.text = companyName;
    controller.grossAnnualIncomeTextController.text = grossAnnualIncome;
    controller.startDateIncomeTextController.text = startDate;
    controller.endDateIncomeTextController.text = endDate;
    controller.setCurrentWorkingStatus(endDate.isNotEmpty?false:true);
    controller.calculateMonthlyIncome(grossAnnualIncome);
    Get.defaultDialog(
      title: 'Edit Your $employerIncomeType',
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
                    Text('Employer Name',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 12),).paddingOnly(top: 8),
                    TextFormField(
                      controller: controller.companyNameTextController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Type Name',
                          hintStyle: TextStyle(fontSize: 12),
                          border: const OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Get.height * .01, horizontal: Get.width * .02)
                      ),
                    ),

                    Text('Gross Annual Income ( Estimated )',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
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
                              controller: controller.grossAnnualIncomeTextController,
                              keyboardType: TextInputType.number,
                              onChanged: (String annualIncome){
                                if(controller.grossAnnualIncomeTextController.text == ''){
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
                            String startWorkDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                            controller.startDateIncomeTextController.text = startWorkDate;
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
                          controller: controller.startDateIncomeTextController,
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
                            value: controller.currentlyWorking,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value){
                              if(controller.currentlyWorking == false){
                                controller.setCurrentWorkingStatus(true);
                                controller.endDateIncomeTextController.text = '';
                              }else{
                                controller.setCurrentWorkingStatus(false);
                                controller.endDateIncomeTextController.text = '';
                              }
                            }
                        ),),
                        const TextWidget(
                            text: 'Currently Working ?',
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            fontColor: AppColors.textColorBlack,
                            textAlign: TextAlign.center)
                      ],
                    ),
                    Obx(() => !controller.currentlyWorking? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Select End Date',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
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
                                  String endWorkDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                                  controller.endDateIncomeTextController.text = endWorkDate;
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
                                controller: controller.endDateIncomeTextController,
                                enabled: false,
                                style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: 'Select Date',
                                  hintStyle: TextStyle(fontSize: 12,color: AppColors.blackColor.withOpacity(.6)),
                                  prefixIcon: Icon(Icons.calendar_month,color: AppColors.blackColor.withOpacity(.4),),
                                  border: InputBorder.none, // Remove the default border
                                ),
                              ),
                            )
                        ),

                      ],
                    ):const SizedBox(),),
                    SizedBox(
                      width: Get.width * 1,
                      child: ElevatedButton(
                          onPressed: () async{
                            if(controller.companyNameTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please enter company name');
                            }else if(controller.grossAnnualIncomeTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please enter gross annual income');
                            }else if(controller.startDateIncomeTextController.text.isEmpty){
                              SnackBarApp().errorSnack('Info Incomplete', 'Please select start date');
                            }else{
                              // FirestoreService().editIncomeManual(controller.companyNameTextController.text,
                              //     controller.grossAnnualIncomeTextController.text,controller.monthlyIncome,
                              //     controller.startDateIncomeTextController.text,controller.endDateIncomeTextController.text,index);
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
                          child: const Text('Save Changes',style: TextStyle(color: AppColors.textColorWhite),)
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

  removeIncomeDialog(int index){
    Get.defaultDialog(
      title: 'Remove Income',
      middleText: 'Are you sure want to remove income',
      titleStyle: TextStyle(color: AppColors.primaryColor,fontSize: 16,fontWeight: FontWeight.bold),
      confirm: TextButton(onPressed: ()async{
        // await FirestoreService().removeIncome(index);

      }, child: Text('Yes')),
      cancel: TextButton(onPressed: (){
        Get.back();
      }, child: Text('No')),
    );
  }
}