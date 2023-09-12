import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/form_1040_&_sch_c_calculator_controller.dart';
import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../snack_bar.dart';
import '../utils_mehtods.dart';
import '../widgets/text_widget.dart';

class SchCIncomeDialog{

  addIncome(String borrowerId){
    final controller = Form1040CalculatorController();
    controller.getCurrentAndPreviousYears();
    String verifyStatus = 'Verified';

    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero, // Remove default padding
        child: Container(
          height : Get.height * .9,
          width : Get.width * .4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text('Calculate Sch. C Income',style: TextStyle(
                      fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                      fontSize: 28
                  ),),
                ),
                Container(
                  width: Get.width * .4,
                  height: Get.height * .001,
                  color: AppColors.primaryColor.withOpacity(.4),
                ),
                Obx(() => Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: Text("Add as Processor"),
                        value: "processor",
                        groupValue: controller.selectedAddedBy.value,
                        onChanged: (value){
                          controller.selectedAddedBy.value = 'processor';
                          controller.setVerifyCheck('verified', true);
                          controller.setVerifyCheck('verifiedButExeCheck', false);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: Text("Add as Borrower"),
                        value: "customer",
                        groupValue: controller.selectedAddedBy.value,
                        onChanged: (value){
                          controller.selectedAddedBy.value = 'customer';
                          controller.setVerifyCheck('verified', true);
                          controller.setVerifyCheck('verifiedButExeCheck', false);
                        },
                      ),
                    )
                  ],
                ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                        text: "Name of proprietor",
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center).marginOnly(top: 16),
                  ],
                ),
                TextFormField(
                  controller: controller.nameOfProprietorTextController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Enter Name of proprietor',
                      hintStyle: TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.height * .01,
                          horizontal: Get.width * .02)),
                ).paddingOnly(top: Get.height * .004),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                        text: "A: Principal business or profession",
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),
                  ],
                ).paddingOnly(top: Get.height * .01),
                TextFormField(
                  controller: controller.principalBusinessOrProfessionTextController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Enter Principal business/profession',
                      hintStyle: TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.height * .01,
                          horizontal: Get.width * .02)),
                ).paddingOnly(top: Get.height * .004),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                        text: "C: Business Name/Type",
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),
                  ],
                ).paddingOnly(top: Get.height * .01),
                TextFormField(
                  controller: controller.businessNameTypeTextController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Enter Business Name/Type',
                      hintStyle: TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.height * .01,
                          horizontal: Get.width * .02)),
                ).paddingOnly(top: Get.height * .004),
                const TextWidget(
                    text: "Business Start Date",
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontColor: AppColors.primaryColor,
                    textAlign: TextAlign.center)
                    .paddingOnly(top: Get.height * .01),
                GestureDetector(
                    onTap: () {
                      showDatePicker(
                        context: Get.context!,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((selectedDate) {
                        if (selectedDate != null) {
                          controller.businessStartDateStamp.value = selectedDate.toString();
                          controller.greaterOrLessThen2Years.value = UtilMethods().isDifferenceGreaterThanTwoYears(controller.businessStartDateStamp.value).toString();
                          String startWorkDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                          controller.businessStartDateTextController.text = startWorkDate;
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.blackColor.withOpacity(.5),
                          // Set the color of the outline border
                          width: 1.0, // Set the width of the outline border
                        ),
                        borderRadius:
                        BorderRadius.circular(4.0), // Set the border radius
                      ),
                      child: TextFormField(
                        controller: controller.businessStartDateTextController,
                        enabled: false,
                        style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'Select Start Date',
                          hintStyle: TextStyle(
                              fontSize: 12,
                              color: AppColors.blackColor.withOpacity(.6)),
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: AppColors.blackColor.withOpacity(.4),
                          ),
                          border: InputBorder.none, // Remove the default border
                        ),
                      ),
                    )),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(
                          () => Checkbox(
                          value: controller.currentlyActive,
                          activeColor: AppColors.primaryColor,
                          onChanged: (value) {
                            if (controller.currentlyActive == false) {
                              controller.setCurrentActiveStatus(true);
                            } else {
                              controller.setCurrentActiveStatus(false);
                            }
                          }),
                    ),
                    const TextWidget(
                        text: 'Currently Active ?',
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        fontColor: AppColors.textColorBlack,
                        textAlign: TextAlign.center)
                  ],
                ),
                Obx(() => !controller.currentlyActive
                    ? RichText(
                  text: const TextSpan(
                    text: 'Note: ',
                    style: TextStyle(color: AppColors.errorTextColor),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                          'If your business in currently inactive or not running. Then this income will not be considered in total income.',
                          style:
                          TextStyle(color: AppColors.textColorBlack)),
                    ],
                  ),
                )
                    : const SizedBox()),

                Container(
                  width: Get.width * 1,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                          color: AppColors.primarySecondaryColor, width: 1)),
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 1,
                        decoration: const BoxDecoration(
                            color: AppColors.primarySecondaryColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: Align(
                          alignment: Alignment.center,
                          child: const TextWidget(
                              text: "Schedule C",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontColor: AppColors.textColorWhite,
                              textAlign: TextAlign.center)
                              .paddingSymmetric(vertical: 6),
                        ),
                      ),

                      Column(
                        children: [
                          //////Most Recent Year///////
                          Align(
                            alignment: Alignment.center,
                            child: TextWidget(
                                text:
                                "Most Recent Year (${controller.w2Year})",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.primaryColor,
                                textAlign: TextAlign.center)
                                .marginOnly(top: 8),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Net Profit / Loss - (Line 31)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .netProfitLossIncomeRecentTextController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (String value) {
                                      controller.netProfitLossRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('recent');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Non Recurring Income - (Line 6)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),

                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .nonRecurringIncomeRecentTextController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (String value) {
                                      controller.nonRecurringRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('recent');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Depletion - (Line 12)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(

                                    controller: controller
                                        .depletionIncomeRecentTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.depletionRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('recent');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Depreciation - (Line 13)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .depreciationIncomeRecentTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.depreciationRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('recent');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Meals and Entertainment Exclusion - (Line 24b)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .mealsAndEntertainmentExclusionRecentIncomeTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.mealsAndEntertainmentExclusionRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('recent');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Business Use of Home - (Lines 30)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .businessUseOfHomeRecentIncomeTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.businessUseOfHomeRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('recent');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child:
                                Text('Amortization/Casualty Loss/One Time Expense - (Page 2 , Part V)',
                                  textAlign: TextAlign.start,style: GoogleFonts.roboto(
                                      fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .amortizationCasualtyLossOneTimeExpenseRecentIncomeTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.amortizationCasualtyLossOneTimeExpenseRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('recent');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextWidget(
                                  text: "Mileage Depreciation",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center),
                            ],
                          ).marginOnly(top: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text('Business Miles - (Page 2, Part IV, Line 44a)',
                                  textAlign: TextAlign.start,style: GoogleFonts.roboto(
                                      fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                              SizedBox(width: Get.width * .04,),
                              Expanded(child: Obx(() =>  TextWidget(
                                  text: "Dep. Rate (${controller.w2Year})",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.start),))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child:Container(
                                height: Get.height * .05,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: controller
                                            .businessMilesRecentIncomeTextController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                        ],
                                        onChanged: (String value) {
                                          controller.businessMilesRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                          controller.calculateSubTotalAmount('recent');
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Enter miles',
                                          hintStyle: TextStyle(fontSize: 12),
                                          border: InputBorder.none,
                                          contentPadding:
                                          const EdgeInsets.only(bottom: 4,left: 16),
                                          prefixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 0, minHeight: 0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).paddingOnly(top: Get.height * .004),),
                              SizedBox(width: Get.width * .04,),
                              Expanded(child: Container(
                                  height: Get.height * .05,
                                  width: Get.width * 1,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.primaryColor,width: 1),
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Obx(() => Center(child: Text(controller.depRatePrior.toString(),
                                    style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),)))
                              ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const TextWidget(
                                text: "Sub Total",
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                fontColor: AppColors.primaryColor,
                                textAlign: TextAlign.center)
                                .marginOnly(top: 8),
                          ),
                          Container(
                            width: Get.width * 1,
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                                color: AppColors.viewColor.withOpacity(.8),
                                borderRadius: BorderRadius.circular(6)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.attach_money,
                                        color: AppColors.primaryColor,
                                      ),
                                      Obx(() =>  Text(
                                        controller.subtotalRecent < 0?controller.subtotalRecent.toString():UtilMethods().formatNumberWithCommas(controller.subtotalRecent),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:controller.subtotalRecent < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                            fontSize: 14),
                                      ),)

                                    ],
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: Get.width * .02),
                            ),
                          ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),

                          Container(
                            width: Get.width * 1,
                            height: Get.height * .001,
                            color: AppColors.primaryColor.withOpacity(.4),
                          ).paddingOnly(top: 16, bottom: 16),

                          //////Prior Year///////
                          Align(
                            alignment: Alignment.center,
                            child: TextWidget(
                                text:
                                "Prior Year (${controller.priorW2Year})",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.primaryColor,
                                textAlign: TextAlign.center)
                                .marginOnly(top: 8),
                          ),
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                  value: controller.moreThan5YearsOld,
                                  onChanged: (value){
                                    controller.setMoreThan5YearsOld(value!);
                                  }
                              ),),
                              Expanded(
                                  child: Text('My business Is more than 5 years old and I wish to use only 1 year , latest year income ${controller.w2Year}',
                                    style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),)),
                            ],
                          ).marginOnly(top: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Net Profit / Loss - (Line 31)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .netProfitLossIncomePriorTextController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (String value) {
                                      controller.netProfitLossPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('prior');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Non Recurring Income - (Line 6)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),

                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .nonRecurringIncomePriorTextController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (String value) {
                                      controller.nonRecurringPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('prior');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Depletion - (Line 12)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .depletionIncomePriorTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.depletionPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('prior');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Depreciation - (Line 13)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .depreciationIncomePriorTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.depreciationPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('prior');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Meals and Entertainment Exclusion - (Line 24b)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .mealsAndEntertainmentExclusionPriorIncomeTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.mealsAndEntertainmentExclusionPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('prior');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('Business Use of Home - (Lines 30)',style: GoogleFonts.roboto(
                                    fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .businessUseOfHomePriorIncomeTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.businessUseOfHomePrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('prior');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child:
                                Text('Amortization/Casualty Loss/One Time Expense - (Page 2 , Part V)',
                                  textAlign: TextAlign.start,style: GoogleFonts.roboto(
                                      fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                            ],
                          ).marginOnly(top: 8),
                          Container(
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                              border:
                              Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ), // Replace with your desired icon
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: controller
                                        .amortizationCasualtyLossOneTimeExpensePriorIncomeTextController,
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                    ],
                                    onChanged: (String value) {
                                      controller.amortizationCasualtyLossOneTimeExpensePrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                      controller.calculateSubTotalAmount('prior');
                                    },
                                    decoration: InputDecoration(
                                      isDense: true,
                                      hintText: 'Type Amount',
                                      hintStyle: TextStyle(fontSize: 12),
                                      border: InputBorder.none,
                                      contentPadding:
                                      const EdgeInsets.only(bottom: 4),
                                      prefixIconConstraints:
                                      const BoxConstraints(
                                          minWidth: 0, minHeight: 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ).paddingOnly(top: Get.height * .004),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextWidget(
                                  text: "Mileage Depreciation",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center),
                            ],
                          ).marginOnly(top: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text('Business Miles - (Page 2, Part IV, Line 44a)',
                                  textAlign: TextAlign.start,style: GoogleFonts.roboto(
                                      fontSize: 12,fontWeight: FontWeight.w900,color: AppColors.primaryColor),),
                              ),
                              SizedBox(width: Get.width * .04,),
                              Expanded(child: Obx(() =>  TextWidget(
                                  text: "Dep. Rate (${controller.w2Year})",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.start),))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child:Container(
                                height: Get.height * .05,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: controller
                                            .businessMilesPriorIncomeTextController,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp('-')), // Disallow the minus sign "-"
                                        ],
                                        onChanged: (String value) {
                                          controller.businessMilesPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                          controller.calculateSubTotalAmount('prior');
                                        },
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Enter miles',
                                          hintStyle: TextStyle(fontSize: 12),
                                          border: InputBorder.none,
                                          contentPadding:
                                          const EdgeInsets.only(bottom: 4,left: 16),
                                          prefixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 0, minHeight: 0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).paddingOnly(top: Get.height * .004),),
                              SizedBox(width: Get.width * .04,),
                              Expanded(child: Container(
                                  height: Get.height * .05,
                                  width: Get.width * 1,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.primaryColor,width: 1),
                                      borderRadius: BorderRadius.circular(4)
                                  ),
                                  child: Obx(() => Center(child: Text(controller.depRatePrior.toString(),
                                    style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),)))
                              ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const TextWidget(
                                text: "Sub Total",
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                fontColor: AppColors.primaryColor,
                                textAlign: TextAlign.center)
                                .marginOnly(top: 8),
                          ),
                          Container(
                            width: Get.width * 1,
                            height: Get.height * .05,
                            decoration: BoxDecoration(
                                color: AppColors.viewColor.withOpacity(.8),
                                borderRadius: BorderRadius.circular(6)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.attach_money,
                                        color: AppColors.primaryColor,
                                      ),
                                      Obx(() =>  Text(
                                        controller.subtotalPrior < 0?controller.subtotalPrior.toString():UtilMethods().formatNumberWithCommas(controller.subtotalPrior),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:controller.subtotalPrior < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                            fontSize: 14),
                                      ),)
                                    ],
                                  ),
                                ],
                              ).paddingSymmetric(horizontal: Get.width * .02),
                            ),
                          ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),

                        ],
                      ).paddingAll(8),

                    ],
                  ),
                ).paddingOnly(top: Get.height * .010).marginOnly(top: 8),


                Align(
                  alignment: Alignment.center,
                  child: const TextWidget(
                      text: 'Summary of income (Calculated)',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      fontColor: AppColors.textColorApp,
                      textAlign: TextAlign.center).marginOnly(top: Get.height * .03),
                ),
                Container(
                  width: Get.width * 1,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryColor,width: 1),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: TextWidget(
                            text: 'Total Summary (${controller.priorW2Year})',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            fontColor: AppColors.textColorApp,
                            textAlign: TextAlign.center).marginOnly(top: Get.height * .01),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Personal Tax Return",
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.primaryColor,
                              textAlign: TextAlign.center)
                              .marginOnly(top: 8),
                        ],
                      ),
                      Container(
                        width: Get.width * 1,
                        height: Get.height * .05,
                        decoration: BoxDecoration(
                            color: AppColors.viewColor.withOpacity(.8),
                            borderRadius: BorderRadius.circular(6)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ),
                                  Obx(() =>  Text(
                                    controller.subtotalRecent < 0?controller.subtotalRecent.toString():UtilMethods().formatNumberWithCommas(controller.subtotalRecent),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:controller.subtotalRecent < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                        fontSize: 14),
                                  ),)
                                ],
                              ),
                            ],
                          ).paddingSymmetric(horizontal: Get.width * .02),
                        ),
                      ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Applicable Income Grand Total",
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.primaryColor,
                              textAlign: TextAlign.center)
                              .marginOnly(top: 8),
                        ],
                      ),
                      Container(
                        width: Get.width * 1,
                        height: Get.height * .05,
                        decoration: BoxDecoration(
                            color: AppColors.viewColor.withOpacity(.8),
                            borderRadius: BorderRadius.circular(6)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ),
                                  Obx(() =>  Text(
                                    controller.subtotalRecent < 0?controller.subtotalRecent.toString():UtilMethods().formatNumberWithCommas(controller.subtotalRecent),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:controller.subtotalRecent < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                        fontSize: 14),
                                  ),)
                                ],
                              ),
                            ],
                          ).paddingSymmetric(horizontal: Get.width * .02),
                        ),
                      ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),
                      Container(
                        width: Get.width * 1,
                        height: Get.height * .001,
                        color: AppColors.primaryColor.withOpacity(.4),
                      ).paddingOnly(top: 16, bottom: 16),
                      Align(
                        alignment: Alignment.center,
                        child: TextWidget(
                            text: 'Total Summary (${controller.w2Year})',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            fontColor: AppColors.textColorApp,
                            textAlign: TextAlign.center).marginOnly(top: Get.height * .01),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Personal Tax Return",
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.primaryColor,
                              textAlign: TextAlign.center)
                              .marginOnly(top: 8),
                        ],
                      ),
                      Container(
                        width: Get.width * 1,
                        height: Get.height * .05,
                        decoration: BoxDecoration(
                            color: AppColors.viewColor.withOpacity(.8),
                            borderRadius: BorderRadius.circular(6)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ),
                                  Obx(() =>  Text(
                                    controller.subtotalPrior < 0?controller.subtotalPrior.toString():UtilMethods().formatNumberWithCommas(controller.subtotalPrior),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:controller.subtotalPrior < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                        fontSize: 14),
                                  ),)
                                ],
                              ),
                            ],
                          ).paddingSymmetric(horizontal: Get.width * .02),
                        ),
                      ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Applicable Income Grand Total",
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.primaryColor,
                              textAlign: TextAlign.center)
                              .marginOnly(top: 8),
                        ],
                      ),
                      Container(
                        width: Get.width * 1,
                        height: Get.height * .05,
                        decoration: BoxDecoration(
                            color: AppColors.viewColor.withOpacity(.8),
                            borderRadius: BorderRadius.circular(6)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ),
                                  Obx(() =>  Text(
                                    controller.subtotalPrior < 0?controller.subtotalPrior.toString():UtilMethods().formatNumberWithCommas(controller.subtotalPrior),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:controller.subtotalPrior < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                        fontSize: 14),
                                  ),)
                                ],
                              ),
                            ],
                          ).paddingSymmetric(horizontal: Get.width * .02),
                        ),
                      ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),
                      Container(
                        width: Get.width * 1,
                        height: Get.height * .001,
                        color: AppColors.primaryColor.withOpacity(.4),
                      ).paddingOnly(top: 16, bottom: 16),

                      Obx(() =>controller.calculationMessage.isNotEmpty? Container(
                          decoration: BoxDecoration(
                              color: AppColors.viewColor.withOpacity(.8),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primaryColor,width: 1)
                          ),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.warning,color: AppColors.primaryColor,),
                                  SizedBox(width: 8,),
                                  Expanded(child: Text('Income Trend & Calculation',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor),))
                                ],
                              ),
                              Text(controller.calculationMessage),
                            ],
                          ).paddingAll(8)).marginOnly(top: 8):SizedBox()),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Monthly Income",
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.primaryColor,
                              textAlign: TextAlign.center)
                              .marginOnly(top: 8),
                        ],
                      ),
                      Container(
                        width: Get.width * 1,
                        height: Get.height * .05,
                        decoration: BoxDecoration(
                            color: AppColors.viewColor.withOpacity(.8),
                            borderRadius: BorderRadius.circular(6)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.attach_money,
                                    color: AppColors.primaryColor,
                                  ),
                                  Obx(() =>  Text(
                                    controller.monthlyIncome < 0?controller.monthlyIncome.toString():UtilMethods().formatNumberWithCommas(controller.monthlyIncome),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:controller.monthlyIncome < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                        fontSize: 14),
                                  ),)
                                ],
                              ),
                            ],
                          ).paddingSymmetric(horizontal: Get.width * .02),
                        ),
                      ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),

                    ],
                  ).paddingAll(8),
                ),
                Obx(() => controller.selectedAddedBy.value == 'processor' ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Obx(() =>  Checkbox(
                            value: controller.verifiedCheck,
                            onChanged: (value){
                              if(controller.verifiedCheck == true){
                                verifyStatus = 'Verified But Excluded';
                                controller.setVerifyCheck('verified', false);
                                controller.setVerifyCheck('verifiedButExcluded', true);
                              }else{
                                verifyStatus = 'Verified';
                                controller.setVerifyCheck('verified', true);
                                controller.setVerifyCheck('verifiedButExcluded', false);
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
                            value: controller.verifiedButExeCheck,
                            onChanged: (value){
                              if(controller.verifiedButExeCheck == true){
                                verifyStatus = 'Verified';
                                controller.setVerifyCheck('verified', true);
                                controller.setVerifyCheck('verifiedButExcluded', false);
                              }else{
                                verifyStatus = 'Verified But Excluded';
                                controller.setVerifyCheck('verified', false);
                                controller.setVerifyCheck('verifiedButExcluded', true);
                              }
                            }
                        ),),
                        Text('Verified But Excluded',style: TextStyle(fontSize: 12),)
                      ],
                    ),
                  ],
                ).marginOnly(top: 8):SizedBox(),
                ),
                GestureDetector(
                  onTap: ()async{
                    if(controller.nameOfProprietorTextController.text.isEmpty){
                      SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Proprietor Name');
                    }
                    else if(controller.principalBusinessOrProfessionTextController.text.isEmpty){
                      SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Principal Business or Profession');
                    }
                    else if(controller.businessNameTypeTextController.text.isEmpty){
                      SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Business Name or Type');
                    }
                    else if(controller.businessStartDateTextController.text.isEmpty){
                      SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Business Start Date');
                    }
                    else if(controller.subtotalRecent == 0.0 && controller.subtotalPrior == 0.0){
                      SnackBarApp().errorSnack('Info Incomplete', 'Please fill one of both Sch C forms or fill both to calculate your net Profit/Loss income');
                    }else if(controller.monthlyIncome == 0.0){
                      SnackBarApp().errorSnack('Info Incomplete', 'Please Enter No. of months to calculate average monthly income.');
                    }else{
                      FirestoreService().addScheduleCBusinessIncomeCalculator(
                        borrowerId,
                          controller.nameOfProprietorTextController.text,
                          controller.principalBusinessOrProfessionTextController.text,
                          controller.businessNameTypeTextController.text,
                          controller.businessStartDateTextController.text,
                          'Form 1040 & Sch C',
                          controller.currentlyActive.toString(),
                          controller.netProfitLossPrior.toString(),
                          controller.nonRecurringPrior.toString(),
                          controller.depletionPrior.toString(),
                          controller.depreciationPrior.toString(),
                          controller.mealsAndEntertainmentExclusionPrior.toString(),
                          controller.businessUseOfHomePrior.toString(),
                          controller.amortizationCasualtyLossOneTimeExpensePrior.toString(),
                          controller.businessMilesPrior.toString(),
                          controller.netProfitLossRecent.toString(),
                          controller.nonRecurringRecent.toString(),
                          controller.depletionRecent.toString(),
                          controller.depreciationRecent.toString(),
                          controller.mealsAndEntertainmentExclusionRecent.toString(),
                          controller.businessUseOfHomeRecent.toString(),
                          controller.amortizationCasualtyLossOneTimeExpenseRecent.toString(),
                          controller.businessMilesRecent.toString(),
                          controller.numberOfMonths.toString(),
                          controller.baseYear,
                          controller.w2Year,
                          controller.priorW2Year,
                          controller.businessStartDateStamp.value,
                          controller.greaterOrLessThen2Years.value,
                          controller.subtotalPrior,
                          controller.subtotalRecent,
                          controller.monthlyIncome,
                        verifyStatus,
                        controller.selectedAddedBy.value,
                          controller.moreThan5YearsOld

                      );
                    }
                  },
                  child: Container(
                    width: Get.width * 1,
                    height: 48,
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColor
                    ),
                    child: const Center(child: Text('Save',style: TextStyle(color: AppColors.whiteColor,fontWeight: FontWeight.bold),)),
                  ).paddingOnly(top: 16,bottom: 28),
                )
              ],
            ).paddingAll(16),
          ),
        ),
      )
    );

  }
}