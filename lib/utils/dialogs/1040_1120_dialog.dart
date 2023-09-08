import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/form_1120_calculator_controller.dart';
import '../../res/app_colors.dart';
import '../snack_bar.dart';
import '../utils_mehtods.dart';
import '../widgets/text_widget.dart';

class Form10401120IncomeDialog{
  
  addIncome(String borrowerId){
    final controller = From1120CalculatorController();
    controller.getCurrentAndPreviousYears();
    Get.dialog(
      Dialog(
          insetPadding: EdgeInsets.zero,
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
                    child: Text('Calculate 1040 & 1120 Income',style: TextStyle(
                        fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                        fontSize: 28
                    ),),
                  ),
                  Container(
                    width: Get.width * .4,
                    height: Get.height * .001,
                    color: AppColors.primaryColor.withOpacity(.4),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TextWidget(
                          text: "Name",
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          fontColor: AppColors.primaryColor,
                          textAlign: TextAlign.center).marginOnly(top: 16),
                    ],
                  ),
                  TextFormField(
                    controller: controller.nameTextController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Enter Name',
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
                          text: "Business Name/Type",
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
                      textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
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
                            String startWorkDateFixesIncome =
                            DateFormat('MM/dd/yyyy').format(selectedDate);
                            controller.businessStartDateTextController.text =
                                startWorkDateFixesIncome;
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

                  /// Form 1040
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
                                text: "Form 1040",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.textColorWhite,
                                textAlign: TextAlign.center)
                                .paddingSymmetric(vertical: 6),
                          ),
                        ),
                        Column(
                          children: [
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
                                const TextWidget(
                                    text: "W-2 Income from Self Employment",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center),
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
                                          .w2IncomeFromSelfEmploymentMostRecentTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.w2IncomeFromSelfEmploymentRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1040SubTotalAmount('recent');
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
                                          controller.w2IncomeFromSelfEmploymentRecentSubTotal < 0?controller.w2IncomeFromSelfEmploymentRecentSubTotal.toString():UtilMethods().formatNumberWithCommas(controller.w2IncomeFromSelfEmploymentRecentSubTotal),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:controller.w2IncomeFromSelfEmploymentRecentSubTotal < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                                  text: "Prior Year (${controller.priorW2Year})",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TextWidget(
                                    text: "W-2 Income from Self Employment",
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center),
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
                                          .w2IncomeFromSelfEmploymentPriorTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.w2IncomeFromSelfEmploymentPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1040SubTotalAmount('prior');
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
                                          controller.w2IncomeFromSelfEmploymentPriorSubTotal < 0?controller.w2IncomeFromSelfEmploymentPriorSubTotal.toString():UtilMethods().formatNumberWithCommas(controller.w2IncomeFromSelfEmploymentPriorSubTotal),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:controller.w2IncomeFromSelfEmploymentPriorSubTotal < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                  ).paddingOnly(top: Get.height * .010),

                  /// Form 1120
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
                                text: "Form 1120",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontColor: AppColors.textColorWhite,
                                textAlign: TextAlign.center)
                                .paddingSymmetric(vertical: 6),
                          ),
                        ),
                        Column(
                          children: [
                            /// Recent Year ///
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
                                  child: Text('Taxable Income (Line 30)',style: GoogleFonts.roboto(
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
                                      controller: controller.taxableIncomeRecentTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.taxableIncomeRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  child: Text('Total Tax (Line 31)',style: GoogleFonts.roboto(
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
                                      controller: controller.totalTaxRecentTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.totalTaxRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  child: Text('Non-Recurring (Gain) Loss (Line 8 & 9)',style: GoogleFonts.roboto(
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
                                      controller: controller.nonRecurringGainLossRecentTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.nonRecurringGainLossRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  child: Text('Non-Recurring Other (Income) Loss (Line 10)',style: GoogleFonts.roboto(
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
                                      controller: controller.nonRecurringOtherIncomeLossRecentTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.nonRecurringOtherIncomeLossRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  child: Text('Depreciation (Line 20)',style: GoogleFonts.roboto(
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
                                      controller: controller.depreciationRecentTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.depreciationRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  child: Text('Depletion (line 21)',style: GoogleFonts.roboto(
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
                                      controller: controller.depletionRecentTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.depletionRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  Text('Amortization/Casualty Loss/One Time Expense (Line 26)',style: GoogleFonts.roboto(
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
                                      controller: controller.amortizationCasualtyLossOneTimeExpenseRecentIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.amortizationCasualtyLossOneTimeExpenseRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  Text('Net Operating Loss and Special Deductions (Line 29c)',style: GoogleFonts.roboto(
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
                                      controller: controller.netOperatingLossAndSpecialDeductionsRecentIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.netOperatingLossAndSpecialDeductionsRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  child: Text('Mortgage Payable in Less than 1 year Execution (Schedule L, Line 17, Column D)',style: GoogleFonts.roboto(
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
                                      controller: controller.mortgagePayableInLessThanOneYearRecentIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.mortgagePayableInLessThanOneYearRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                  child: Text('Travel & Entertainment Execution (Schedule M1, Line 5c)',style: GoogleFonts.roboto(
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
                                      controller: controller.travelAndEntertainmentExecutionRecentIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.mealsAndEntertainmentRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('recent');
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
                                          controller.from1120RecentSubtotal < 0?controller.from1120RecentSubtotal.toString():UtilMethods().formatNumberWithCommas(controller.from1120RecentSubtotal),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:controller.from1120RecentSubtotal < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                                Expanded(
                                  child: Text('Ownership Percentage ( Listed on From 1125-E )',style: GoogleFonts.roboto(
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
                                      Icons.percent,
                                      color: AppColors.primaryColor,
                                    ), // Replace with your desired icon
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller.ownershipPercentageRecentIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.ownershipPercentageRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateOwnerShipPercentageTotalAmount('recent');
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Enter Percentage',
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const TextWidget(
                                  text: "Modified Subtotal",
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
                                          controller.cashFlowRecentSubtotal < 0?controller.cashFlowRecentSubtotal.toString():UtilMethods().formatNumberWithCommas(controller.cashFlowRecentSubtotal),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:controller.cashFlowRecentSubtotal < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                                Expanded(
                                  child: Text('Dividends Paid to Borrower ( Line 5 of Schedule B )',style: GoogleFonts.roboto(
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
                                      Icons.attach_money_outlined,
                                      color: AppColors.primaryColor,
                                    ), // Replace with your desired icon
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller.dividendsPaidToBorrowerRecentIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.dividendsPaidToBorrowerRecent.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateTotalCorpIncome('recent');
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Enter Amount',
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const TextWidget(
                                  text: "Total Corporate Income",
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
                                          controller.totalCorpIncomeRecent < 0?controller.totalCorpIncomeRecent.toString():UtilMethods().formatNumberWithCommas(controller.totalCorpIncomeRecent),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:controller.totalCorpIncomeRecent < 0? AppColors.errorTextColor:AppColors.primaryColor,
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

                            /// Prior Year ///
                            Align(
                              alignment: Alignment.center,
                              child: TextWidget(
                                  text: "Prior Year (${controller.priorW2Year})",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text('Taxable Income (Line 30)',style: GoogleFonts.roboto(
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
                                      controller: controller.taxableIncomePriorTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.taxableIncomePrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  child: Text('Total Tax (Line 31)',style: GoogleFonts.roboto(
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
                                      controller: controller.totalTaxPriorTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.totalTaxPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  child: Text('Non-Recurring (Gain) Loss (Line 8 & 9)',style: GoogleFonts.roboto(
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
                                      controller: controller.nonRecurringGainLossPriorTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.nonRecurringGainLossPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  child: Text('Non-Recurring Other (Income) Loss (Line 10)',style: GoogleFonts.roboto(
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
                                      controller: controller.nonRecurringOtherIncomeLossPriorTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.nonRecurringOtherIncomeLossPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  child: Text('Depreciation (Line 20)',style: GoogleFonts.roboto(
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
                                      controller: controller.depreciationPriorTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.depreciationPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  child: Text('Depletion (line 21)',style: GoogleFonts.roboto(
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
                                      controller: controller.depletionPriorTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.depletionPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  Text('Amortization/Casualty Loss/One Time Expense (Line 26)',style: GoogleFonts.roboto(
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
                                      controller: controller.amortizationCasualtyLossOneTimeExpensePriorIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.amortizationCasualtyLossOneTimeExpensePrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  Text('Net Operating Loss and Special Deductions (Line 29c)',style: GoogleFonts.roboto(
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
                                      controller: controller.netOperatingLossAndSpecialDeductionsPriorIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.netOperatingLossAndSpecialDeductionsPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  child: Text('Mortgage Payable in Less than 1 year Execution (Schedule L, Line 17, Column D)',style: GoogleFonts.roboto(
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
                                      controller: controller.mortgagePayableInLessThanOneYearPriorIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.mortgagePayableInLessThanOneYearPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                  child: Text('Travel & Entertainment Execution (Schedule M1, Line 5c)',style: GoogleFonts.roboto(
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
                                      controller: controller.travelAndEntertainmentExecutionPriorIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.mealsAndEntertainmentPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateForm1120SubTotalAmount('prior');
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
                                          controller.from1120PriorSubtotal < 0?controller.from1120PriorSubtotal.toString():UtilMethods().formatNumberWithCommas(controller.from1120PriorSubtotal),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:controller.from1120PriorSubtotal < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                                Expanded(
                                  child: Text('Ownership Percentage ( Listed on From 1125-E )',style: GoogleFonts.roboto(
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
                                      Icons.percent,
                                      color: AppColors.primaryColor,
                                    ), // Replace with your desired icon
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller.ownershipPercentagePriorIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.ownershipPercentagePrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateOwnerShipPercentageTotalAmount('prior');
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Enter Percentage',
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const TextWidget(
                                  text: "Modified Subtotal",
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
                                          controller.cashFlowPriorSubtotal < 0?controller.cashFlowPriorSubtotal.toString():UtilMethods().formatNumberWithCommas(controller.cashFlowPriorSubtotal),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:controller.cashFlowPriorSubtotal < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                                Expanded(
                                  child: Text('Dividends Paid to Borrower ( Line 5 of Schedule B )',style: GoogleFonts.roboto(
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
                                      Icons.attach_money_outlined,
                                      color: AppColors.primaryColor,
                                    ), // Replace with your desired icon
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: controller.dividendsPaidToBorrowerPriorIncomeTextController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        controller.dividendsPaidToBorrowerPrior.value = value.isNotEmpty? double.parse(value): 0.0;
                                        controller.calculateTotalCorpIncome('prior');
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText: 'Enter Amount',
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const TextWidget(
                                  text: "Total Corporate Income",
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
                                          controller.totalCorpIncomePrior < 0?controller.totalCorpIncomePrior.toString():UtilMethods().formatNumberWithCommas(controller.totalCorpIncomePrior),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color:controller.totalCorpIncomePrior < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                  ).paddingOnly(top: Get.height * .010),


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
                                      controller.personalTaxReturnsPrior < 0?controller.personalTaxReturnsPrior.toString():UtilMethods().formatNumberWithCommas(controller.personalTaxReturnsPrior),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:controller.personalTaxReturnsPrior < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                                text: "Corporation Returns",
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
                                      controller.totalCorpIncomePrior == 0.0 ? controller.cashFlowPriorSubtotal < 0?controller.cashFlowPriorSubtotal.toString():UtilMethods().formatNumberWithCommas(controller.cashFlowPriorSubtotal):controller.totalCorpIncomePrior < 0?controller.totalCorpIncomePrior.toString():UtilMethods().formatNumberWithCommas(controller.totalCorpIncomePrior),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:controller.cashFlowPriorSubtotal < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                          fontSize: 14),
                                    ),)
                                  ],
                                ),
                              ],
                            ).paddingSymmetric(horizontal: Get.width * .02),
                          ),
                        ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() =>  Checkbox(
                              value: controller.addPartnershipReturnsPrior,
                              onChanged: (value) {
                                controller.setPartnerShipReturns('prior', value!);
                              },
                            ),),
                            const TextWidget(
                                text: "Check To Add Corporation Returns",
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                fontColor: AppColors.primaryColor,
                                textAlign: TextAlign.center)

                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const TextWidget(
                        //         text: "Total Income Form Tax Returns",
                        //         fontSize: 12,
                        //         fontWeight: FontWeight.w900,
                        //         fontColor: AppColors.primaryColor,
                        //         textAlign: TextAlign.center)
                        //         .marginOnly(top: 8),
                        //     AppToolTips()
                        //         .showToolTip(Constants().employerNameTip)
                        //   ],
                        // ),
                        // Container(
                        //   width: Get.width * 1,
                        //   height: Get.height * .05,
                        //   decoration: BoxDecoration(
                        //       color: AppColors.viewColor.withOpacity(.8),
                        //       borderRadius: BorderRadius.circular(6)),
                        //   child: SingleChildScrollView(
                        //     scrollDirection: Axis.horizontal,
                        //     child: Row(
                        //       mainAxisAlignment:
                        //       MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           children: [
                        //             const Icon(
                        //               Icons.attach_money,
                        //               color: AppColors.primaryColor,
                        //             ),
                        //             Text(
                        //               '0.00',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold,
                        //                   color: AppColors.primaryColor,
                        //                   fontSize: 14.sp),
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ).paddingSymmetric(horizontal: Get.width * .02),
                        //   ),
                        // ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),
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
                                      controller.totalOfTaxReturnAndGrandTotalPrior < 0?controller.totalOfTaxReturnAndGrandTotalPrior.toString():UtilMethods().formatNumberWithCommas(controller.totalOfTaxReturnAndGrandTotalPrior),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:controller.totalOfTaxReturnAndGrandTotalPrior < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                                      controller.personalTaxReturnsRecent < 0?controller.personalTaxReturnsRecent.toString():UtilMethods().formatNumberWithCommas(controller.personalTaxReturnsRecent),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:controller.personalTaxReturnsRecent < 0? AppColors.errorTextColor:AppColors.primaryColor,
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
                                text: "Corporation Returns",
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
                                      controller.totalCorpIncomeRecent == 0.0 ? controller.cashFlowRecentSubtotal < 0?controller.cashFlowRecentSubtotal.toString():UtilMethods().formatNumberWithCommas(controller.cashFlowRecentSubtotal):controller.totalCorpIncomeRecent < 0?controller.totalCorpIncomeRecent.toString():UtilMethods().formatNumberWithCommas(controller.totalCorpIncomeRecent),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:controller.cashFlowRecentSubtotal < 0? AppColors.errorTextColor:AppColors.primaryColor,
                                          fontSize: 14),
                                    ),)
                                  ],
                                ),
                              ],
                            ).paddingSymmetric(horizontal: Get.width * .02),
                          ),
                        ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Obx(() =>  Checkbox(
                              value: controller.addPartnershipReturnsRecent,
                              onChanged: (value) {
                                controller.setPartnerShipReturns('recent', value!);
                              },
                            ),),
                            const TextWidget(
                                text: "Check To Add Corporation Returns",
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                fontColor: AppColors.primaryColor,
                                textAlign: TextAlign.center)

                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     const TextWidget(
                        //         text: "Total Income Form Tax Returns",
                        //         fontSize: 12,
                        //         fontWeight: FontWeight.w900,
                        //         fontColor: AppColors.primaryColor,
                        //         textAlign: TextAlign.center)
                        //         .marginOnly(top: 8),
                        //     AppToolTips()
                        //         .showToolTip(Constants().employerNameTip)
                        //   ],
                        // ),
                        // Container(
                        //   width: Get.width * 1,
                        //   height: Get.height * .05,
                        //   decoration: BoxDecoration(
                        //       color: AppColors.viewColor.withOpacity(.8),
                        //       borderRadius: BorderRadius.circular(6)),
                        //   child: SingleChildScrollView(
                        //     scrollDirection: Axis.horizontal,
                        //     child: Row(
                        //       mainAxisAlignment:
                        //       MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           children: [
                        //             const Icon(
                        //               Icons.attach_money,
                        //               color: AppColors.primaryColor,
                        //             ),
                        //             Text(
                        //               '0.00',
                        //               style: TextStyle(
                        //                   fontWeight: FontWeight.bold,
                        //                   color: AppColors.primaryColor,
                        //                   fontSize: 14.sp),
                        //             ),
                        //           ],
                        //         ),
                        //       ],
                        //     ).paddingSymmetric(horizontal: Get.width * .02),
                        //   ),
                        // ).paddingOnly(top: Get.height * .004).marginOnly(top: 4),
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
                                      controller.totalOfTaxReturnAndGrandTotalRecent < 0?controller.totalOfTaxReturnAndGrandTotalRecent.toString():UtilMethods().formatNumberWithCommas(controller.totalOfTaxReturnAndGrandTotalRecent),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:controller.totalOfTaxReturnAndGrandTotalRecent < 0? AppColors.errorTextColor:AppColors.primaryColor,
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text('No of months determine for average monthly income',)
                            Expanded(
                              child:
                              Text('No. of months determine for average monthly income',
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
                              Expanded(
                                child: TextFormField(
                                  // controller: controller
                                  // .numberOfMonthsTextController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (String value) {
                                    controller.numberOfMonths.value = value.isNotEmpty? double.parse(value): 0.0;
                                    controller.calculateMonthlyIncome();
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Enter Number of Months',
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
                        ).paddingOnly(top: Get.height * .004),
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

                  InkWell(
                    onTap: ()async{
                      if(controller.nameTextController.text.isEmpty){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Name');
                      }
                      else if(controller.businessNameTypeTextController.text.isEmpty){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please Enter Business Name');
                      }
                      else if(controller.businessStartDateTextController.text.isEmpty){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please Select Business Start Date');
                      }
                      else if(controller.totalOfTaxReturnAndGrandTotalRecent == 0.0 && controller.totalOfTaxReturnAndGrandTotalPrior == 0.0){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please fill one of both Form 1040 or Form 1065 of any year or fill both to calculate your net Profit/Loss income');
                      }
                      else if(controller.monthlyIncome == 0.0){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please Enter No. of months to calculate average monthly income.');
                      }else{
                        // FirestoreService().add10401120BusinessIncomeCalculator(
                        //     controller.nameTextController.text,
                        //     controller.businessNameTypeTextController.text,
                        //     controller.businessStartDateTextController.text,
                        //     incomeType,
                        //     controller.currentlyActive.toString(),
                        //     controller.w2IncomeFromSelfEmploymentPrior.toString(),
                        //     controller.w2IncomeFromSelfEmploymentRecent.toString(),
                        //     controller.taxableIncomePrior.toString(),
                        //     controller.totalTaxPrior.toString(),
                        //     controller.nonRecurringGainLossPrior.toString(),
                        //     controller.nonRecurringOtherIncomeLossPrior.toString(),
                        //     controller.depreciationPrior.toString(),
                        //     controller.depletionPrior.toString(),
                        //     controller.amortizationCasualtyLossOneTimeExpensePrior.toString(),
                        //     controller.netOperatingLossAndSpecialDeductionsPrior.toString(),
                        //     controller.mortgagePayableInLessThanOneYearPrior.toString(),
                        //     controller.mealsAndEntertainmentPrior.toString(),
                        //     controller.ownershipPercentagePrior.toString(),
                        //     controller.dividendsPaidToBorrowerPrior.toString(),
                        //     controller.taxableIncomeRecent.toString(),
                        //     controller.totalTaxRecent.toString(),
                        //     controller.nonRecurringGainLossRecent.toString(),
                        //     controller.nonRecurringOtherIncomeLossRecent.toString(),
                        //     controller.depreciationRecent.toString(),
                        //     controller.depletionRecent.toString(),
                        //     controller.amortizationCasualtyLossOneTimeExpenseRecent.toString(),
                        //     controller.netOperatingLossAndSpecialDeductionsRecent.toString(),
                        //     controller.mortgagePayableInLessThanOneYearRecent.toString(),
                        //     controller.mealsAndEntertainmentRecent.toString(),
                        //     controller.ownershipPercentageRecent.toString(),
                        //     controller.dividendsPaidToBorrowerRecent.toString(),
                        //     controller.numberOfMonths.toString(),
                        //     controller.baseYear,
                        //     controller.w2Year,
                        //     controller.priorW2Year,
                        //     controller.businessStartDateStamp.value,
                        //     controller.greaterOrLessThen2Years.value,
                        //     controller.totalOfTaxReturnAndGrandTotalPrior,
                        //     controller.totalOfTaxReturnAndGrandTotalRecent,
                        //     controller.monthlyIncome,
                        //     controller.addPartnershipReturnsPrior,
                        //     controller.addPartnershipReturnsRecent
                        // );
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
          )
      )
    );
  }
}