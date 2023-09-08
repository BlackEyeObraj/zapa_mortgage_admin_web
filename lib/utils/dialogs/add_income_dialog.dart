import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/add_income_dialog_controller.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/1040_1065_K1_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/1040_1120S_K1_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/1040_1120_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/fixed_income_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/sch_c_income_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/variable_income_dialog.dart';

import '../../res/app_colors.dart';
import '../constants.dart';
import '../widgets/text_widget.dart';
import 'manual_business_dialog.dart';
import 'manual_income_dialog.dart';

class AddIncomeDialog{
  addIncomeDialog(String borrowerId){

    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero, // Remove default padding
        child: Container(
          height : Get.height * .9,
          width : Get.width * .4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Add New Income',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                  IconButton(onPressed: (){
                    Get.back();
                  }, icon: Icon(Icons.close,color: AppColors.errorTextColor,))
                ],
              ),
              Container(width: Get.width * .4,height: Get.height * .001,color: AppColors.primaryColor,),
              Text('Work Type',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,color: AppColors.primaryColor),).marginOnly(top: 16),
              DropdownButtonFormField2<String>(
                isExpanded: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: Get.height * .020),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                hint: const Text(
                  'Select Work Type',
                  style: TextStyle(fontSize: 12),
                ),
                items: Constants().workTypes
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
                    return 'Select Work Type';
                  }
                  return null;
                },
                onChanged: (value) {
                  Get.put(AddIncomeDialogController()).setWorkType(value!);
                },
                onSaved: (value) {
                  Get.put(AddIncomeDialogController()).setWorkType(value!);
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ).marginOnly(top: 4),
              Expanded(child: Obx(() => Get.put(AddIncomeDialogController()).workType == 'Employment'?employmentView(
                  Get.context!,
                  Get.put(AddIncomeDialogController())
              ).marginOnly(top: 4):
              Get.put(AddIncomeDialogController()).workType == 'Business / Self Employed'?businessView(
                  Get.context!,
                  Get.put(AddIncomeDialogController())
              ).marginOnly(top: 4):Get.put(AddIncomeDialogController()).workType == 'Other Income'?otherView(
                  Get.context!,
                  Get.put(AddIncomeDialogController())
              ).marginOnly(top: 4):const SizedBox()),),
              SizedBox(
                  width: Get.width * 1,
                  height: Get.height * .1,
                  child: ElevatedButton(
                      onPressed: (){
                        if(Get.put(AddIncomeDialogController()).workType == 'Employment'){
                          if(Get.put(AddIncomeDialogController()).employerIncomeType == 'Fixed Income' || Get.put(AddIncomeDialogController()).employerIncomeType == 'Variable Income'){
                            if(Get.put(AddIncomeDialogController()).addIncomeMethodType == 'manual'){
                              ManualIncomeDialog().addManualIncome(Get.put(AddIncomeDialogController()),borrowerId);
                            }else{
                              if(Get.put(AddIncomeDialogController()).employerIncomeType == 'Fixed Income'){
                                FixedIncomeDialog().addFixedIncome(borrowerId);
                              }else{
                                VariableIncomeDialog().addVariableIncome(borrowerId);
                              }
                            }
                          }
                        }else if(Get.put(AddIncomeDialogController()).workType == 'Business / Self Employed'){
                          if(Get.put(AddIncomeDialogController()).businessIncomeType == 'Form 1040 & Sch C' ||
                              Get.put(AddIncomeDialogController()).businessIncomeType == 'Form 1065 & K1' ||
                              Get.put(AddIncomeDialogController()).businessIncomeType == 'Form 1120S & K1' ||
                              Get.put(AddIncomeDialogController()).businessIncomeType == 'Form 1120'){
                            if(Get.put(AddIncomeDialogController()).addBusinessMethodType == 'manual'){
                              ManualBusinessDialog().addManualBusinessDialog(Get.put(AddIncomeDialogController()),borrowerId);
                            }else{
                              if(Get.put(AddIncomeDialogController()).businessIncomeType == 'Form 1040 & Sch C'){
                                SchCIncomeDialog().addIncome(borrowerId);
                              }else if(Get.put(AddIncomeDialogController()).businessIncomeType == 'Form 1065 & K1'){
                                Form10401065K1IncomeDialog().addIncome(borrowerId);
                              }else if(Get.put(AddIncomeDialogController()).businessIncomeType == 'Form 1120S & K1'){
                                Form10401120SK1IncomeDialog().addIncome(borrowerId);
                              }else{
                                Form10401120IncomeDialog().addIncome(borrowerId);
                              }
                            }
                          }
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              )
                          )
                      ),
                      child: const TextWidget(
                          text: 'Continue',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.textColorWhite,
                          textAlign: TextAlign.center
                      )
                  ).paddingSymmetric(vertical: Get.height * .024)
              ),
            ],
          )
        ).paddingAll(16),
      ),
      barrierDismissible: true, // To prevent closing by tapping outside
    );


  }
  Widget employmentView(BuildContext context, AddIncomeDialogController controller) => SizedBox(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                    text: 'Employer Income Type',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontColor: AppColors.primaryColor,
                    textAlign: TextAlign.center).paddingOnly(top: 0),
              ],
            ).paddingOnly(top: 4),
            // Obx(() => Row(
            //   children: [
            //     Expanded(
            //       child: GestureDetector(
            //         onTap: (){
            //           controller.setEmployerIncomeType('Fixed Income');
            //         },
            //         child: SizedBox(
            //           child: Row(
            //             children: [
            //               Radio(
            //                   value: 'Fixed Income',
            //                   groupValue: controller.employerIncomeType,
            //                   onChanged: (value){
            //                     controller.setEmployerIncomeType(value!);
            //                   }
            //               ),
            //               TextWidget(
            //                   text: 'Fixed Income',
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w600,
            //                   fontColor: AppColors.blackColor.withOpacity(.6),
            //                   textAlign: TextAlign.center),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: GestureDetector(
            //         onTap: (){
            //           controller.setEmployerIncomeType('Variable Income');
            //         },
            //         child: SizedBox(
            //           child: Row(
            //
            //             children: [
            //               Radio(
            //                   value: 'Variable Income',
            //                   groupValue: controller.employerIncomeType,
            //                   onChanged: (value){
            //                     controller.setEmployerIncomeType(value!);
            //                   }
            //               ),
            //               TextWidget(
            //                   text: 'Variable Income',
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w600,
            //                   fontColor: AppColors.blackColor.withOpacity(.6),
            //                   textAlign: TextAlign.center),
            //             ],
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // )
            Obx(() => Column(
              children: [
                GestureDetector(
                  onTap: (){
                    controller.setEmployerIncomeType('Fixed Income');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.employerIncomeType == 'Fixed Income'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                            value: 'Fixed Income',
                            groupValue: controller.employerIncomeType,
                            onChanged: (value){
                              controller.setEmployerIncomeType(value!);
                            }
                        ),
                        const TextWidget(
                            text: 'Fixed Income',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors.blackColor,
                            textAlign: TextAlign.center),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .02),
                GestureDetector(
                  onTap: (){
                    controller.setEmployerIncomeType('Variable Income');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.employerIncomeType == 'Variable Income'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                            value: 'Variable Income',
                            groupValue: controller.employerIncomeType,
                            onChanged: (value){
                              controller.setEmployerIncomeType(value!);
                            }
                        ),
                        const TextWidget(
                            text: 'Variable Income',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontColor: AppColors.blackColor,
                            textAlign: TextAlign.center),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .02),

              ],
            )
            ),
            Obx(() => controller.employerIncomeType == 'Fixed Income'?
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const TextWidget(
                  //     text: 'How do you wish to add your fixed income?\nPlease select one of the options below:',
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.w900,
                  //     fontColor: AppColors.primaryColor,
                  //     textAlign: TextAlign.start).paddingOnly(top: Get.height * .02),
                  Text('How do you wish to add your fixed income?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddIncomeMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addIncomeMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addIncomeMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addIncomeMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Gross Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addIncomeMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addIncomeMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddIncomeMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addIncomeMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addIncomeMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addIncomeMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addIncomeMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addIncomeMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .06)
                  ),
                ],
              ),
            ):
            controller.employerIncomeType == 'Variable Income'?
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your variable income?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddIncomeMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addIncomeMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addIncomeMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addIncomeMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Gross Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addIncomeMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addIncomeMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddIncomeMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addIncomeMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addIncomeMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addIncomeMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addIncomeMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addIncomeMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .06))
                ],
              ),
            ):const SizedBox())
          ],
        ),
      )
  );
  Widget businessView(BuildContext context, AddIncomeDialogController controller) => SizedBox(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                    text: 'Business / Self Employed Income Type',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontColor: AppColors.primaryColor,
                    textAlign: TextAlign.center).paddingOnly(top: 0),
              ],
            ).paddingOnly(top: 4),
            Obx(() => Column(
              children: [
                GestureDetector(
                  onTap: (){
                    controller.setBusinessIncomeType('Form 1040 & Sch C');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.businessIncomeType == 'Form 1040 & Sch C'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                            value: 'Form 1040 & Sch C',
                            groupValue: controller.businessIncomeType,
                            onChanged: (value){
                              controller.setBusinessIncomeType(value!);
                            }
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                  text: 'Independent Contractor Income',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor,
                                  textAlign: TextAlign.center),
                              TextWidget(
                                  text: 'Schedule C',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor.withOpacity(.6),
                                  textAlign: TextAlign.center),
                              // Text('Such as Form 1099, Uber/Lyft, Self-Employed, etc',
                              // style: TextStyle(fontSize: 12),),
                              TextWidget(
                                  text: 'Such as Form 1099, Uber/Lyft, Self-Employed, etc',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor.withOpacity(.6),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .02),
                GestureDetector(
                  onTap: (){
                    controller.setBusinessIncomeType('Form 1065 & K1');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.businessIncomeType == 'Form 1065 & K1'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(

                      children: [
                        Radio(
                            value: 'Form 1065 & K1',
                            groupValue: controller.businessIncomeType,
                            onChanged: (value){
                              controller.setBusinessIncomeType(value!);
                            }
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                  text: 'Partnership Income',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor,
                                  textAlign: TextAlign.center),
                              TextWidget(
                                  text: 'Form 1040,1065 & K1',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor.withOpacity(.6),
                                  textAlign: TextAlign.center),
                              TextWidget(
                                  text: 'W2 from Partnership (if any)',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor.withOpacity(.6),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .01),
                GestureDetector(
                  onTap: (){
                    controller.setBusinessIncomeType('Form 1120S & K1');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.businessIncomeType == 'Form 1120S & K1'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(
                      children: [
                        Radio(
                            value: 'Form 1120S & K1',
                            groupValue: controller.businessIncomeType,
                            onChanged: (value){
                              controller.setBusinessIncomeType(value!);
                            }
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                  text: 'S Corp Income',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor,
                                  textAlign: TextAlign.center),
                              TextWidget(
                                  text: 'Form 1040,1120S & K1',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor.withOpacity(.6),
                                  textAlign: TextAlign.center),
                              TextWidget(
                                  text: 'W2 from S Corp (if any)',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor.withOpacity(.6),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .01),
                GestureDetector(
                  onTap: (){
                    controller.setBusinessIncomeType('Form 1120');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.businessIncomeType == 'Form 1120'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(

                      children: [
                        Radio(
                            value: 'Form 1120',
                            groupValue: controller.businessIncomeType,
                            onChanged: (value){
                              controller.setBusinessIncomeType(value!);
                            }
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                  text: 'C Corp Income',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor,
                                  textAlign: TextAlign.center),
                              TextWidget(
                                  text: 'Form 1040 & 1120',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor.withOpacity(.6),
                                  textAlign: TextAlign.center),
                              TextWidget(
                                  text: 'W2 from C Corp (if any)',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  fontColor: AppColors.blackColor.withOpacity(.6),
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .01),
              ],
            )),

            Obx(() => controller.businessIncomeType == 'Form 1040 & Sch C'?SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Sch C?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddBusinessMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Net Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addBusinessMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddBusinessMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addBusinessMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            controller.businessIncomeType == 'Form 1065 & K1'? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Form 1040, 1065 & K1?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddBusinessMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Net Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addBusinessMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddBusinessMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addBusinessMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            controller.businessIncomeType == 'Form 1120S & K1'? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Form 1040, 1120S & K1?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddBusinessMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Net Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addBusinessMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddBusinessMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addBusinessMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            controller.businessIncomeType == 'Form 1120'? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Form 1040 & 1120?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddBusinessMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Net Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addBusinessMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddBusinessMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .1,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addBusinessMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addBusinessMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            const SizedBox())
          ],
        ),
      )
  );
  Widget otherView(BuildContext context, AddIncomeDialogController controller) => SizedBox(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                    text: 'Other Income Type',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontColor: AppColors.primaryColor,
                    textAlign: TextAlign.center).paddingOnly(top: 0),
              ],
            ).paddingOnly(top: 4),
            Obx(() => Column(
              children: [
                GestureDetector(
                  onTap: (){
                    controller.setOtherIncomeType('Rental Property Income');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.otherIncomeType == 'Rental Property Income'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Radio(
                            value: 'Rental Property Income',
                            groupValue: controller.otherIncomeType,
                            onChanged: (value){
                              controller.setOtherIncomeType(value!);
                            }
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(
                                text: 'Rental Property Income',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor,
                                textAlign: TextAlign.center),
                            TextWidget(
                                text: 'Sch E from 1040',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor.withOpacity(.6),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .02),
                GestureDetector(
                  onTap: (){
                    controller.setOtherIncomeType('Social Security Income');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.otherIncomeType == 'Social Security Income'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(

                      children: [
                        Radio(
                            value: 'Social Security Income',
                            groupValue: controller.otherIncomeType,
                            onChanged: (value){
                              controller.setOtherIncomeType(value!);
                            }
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(
                                text: 'Social Security Income',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor,
                                textAlign: TextAlign.center),
                            TextWidget(
                                text: 'Retirement / Disability',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor.withOpacity(.6),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .01),
                GestureDetector(
                  onTap: (){
                    controller.setOtherIncomeType('Child Support');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.otherIncomeType == 'Child Support'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(
                      children: [
                        Radio(
                            value: 'Child Support',
                            groupValue: controller.otherIncomeType,
                            onChanged: (value){
                              controller.setOtherIncomeType(value!);
                            }
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(
                                text: 'Child Support',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor,
                                textAlign: TextAlign.center),
                            TextWidget(
                                text: 'At least One Child under 15 years old',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor.withOpacity(.6),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .01),
                GestureDetector(
                  onTap: (){
                    controller.setOtherIncomeType('Alimony / Separate Maintenance');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.otherIncomeType == 'Alimony / Separate Maintenance'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(

                      children: [
                        Radio(
                            value: 'Alimony / Separate Maintenance',
                            groupValue: controller.otherIncomeType,
                            onChanged: (value){
                              controller.setOtherIncomeType(value!);
                            }
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(
                                text: 'Alimony / Separate Maintenance',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor,
                                textAlign: TextAlign.center),
                            TextWidget(
                                text: 'As per Written Agreement / Court Decree',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor.withOpacity(.6),
                                textAlign: TextAlign.center),

                          ],
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .01),
                GestureDetector(
                  onTap: (){
                    controller.setOtherIncomeType('Other Income');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2,color:
                        controller.otherIncomeType == 'Other Income'? AppColors.primaryColor:
                        AppColors.greyColor),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    width: Get.width * 1,
                    child: Row(

                      children: [
                        Radio(
                            value: 'Other Income',
                            groupValue: controller.otherIncomeType,
                            onChanged: (value){
                              controller.setOtherIncomeType(value!);
                            }
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextWidget(
                                text: 'Other Income',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor,
                                textAlign: TextAlign.center),
                            TextWidget(
                                text: 'Any other Income that you can Prove',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                fontColor: AppColors.blackColor.withOpacity(.6),
                                textAlign: TextAlign.center),

                          ],
                        ),
                      ],
                    ).paddingSymmetric(vertical: Get.height * .01),
                  ),
                ).paddingOnly(top: Get.height * .01),
              ],
            )),

            Obx(() => controller.otherIncomeType == 'Rental Property Income'?SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Rental Property Income?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Gross Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            controller.otherIncomeType == 'Social Security Income'? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Social Security Income?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Gross Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            controller.otherIncomeType == 'Child Support'? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Child Support?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Gross Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            controller.otherIncomeType == 'Alimony / Separate Maintenance'? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Alimony / Separate Maintenance?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Gross Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            controller.otherIncomeType == 'Other Income'? SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How do you wish to add your Other Income?\nPlease select one of the options below:',
                    style: TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold,fontSize: 13),)
                      .paddingOnly(top: Get.height * .02),
                  Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('manual');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Enter Manual',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.edit,color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Gross Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'manual'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'manual'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      ),
                      TextWidget(
                          text: 'OR',
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          fontColor: AppColors.blackColor.withOpacity(.6),
                          textAlign: TextAlign.center),
                      Stack(
                        children: [
                          InkWell(
                            onTap: (){
                              controller.setAddOtherMethodType('calculator');
                            },
                            child: Container(
                              width: Get.width * .35,
                              height: Get.height * .16,
                              decoration: BoxDecoration(
                                  color: AppColors.greyColor.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.4),width: 2)
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Calculate Income',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ).paddingOnly(top: Get.height * .01),
                                  Icon(Icons.calculate,color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8)),
                                  Text(
                                    'Using Calculator',textAlign: TextAlign.center,style: TextStyle(color: controller.addOtherMethodType == 'calculator'?AppColors.primaryColor:
                                  AppColors.greyColor.withOpacity(.8),fontWeight: FontWeight.bold,fontSize: 13),
                                  ),
                                ],
                              ).paddingOnly(bottom: Get.height * .02),
                            ),
                          ),
                          SizedBox(
                            child: Icon(Icons.check_circle,color: controller.addOtherMethodType == 'calculator'?AppColors.secondaryColor:
                            AppColors.greyColor.withOpacity(.4)).paddingOnly(left: Get.width * .02,top: Get.height * .01),
                          )
                        ],
                      )
                    ],
                  ).paddingOnly(top: Get.height * .02)
                  ),
                ],
              ),
            ):
            const SizedBox())
          ],
        ),
      )
  );
}