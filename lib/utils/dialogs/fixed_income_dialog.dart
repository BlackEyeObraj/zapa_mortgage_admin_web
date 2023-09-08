import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zapa_mortgage_admin_web/controllers/fixed_income_calculator_controller.dart';

import '../../res/app_colors.dart';
import '../constants.dart';
import '../snack_bar.dart';
import '../widgets/text_widget.dart';

class FixedIncomeDialog{

  addFixedIncome(String borrowerId){
    final controller = FixedIncomeCalculatorController();
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Calculate Fixed Income',style: TextStyle(
                    fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 28
                ),),
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
                        text: "Employer Name",
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center).marginOnly(top: 16),

                  ],
                ),
                TextFormField(
                  controller: controller.employerNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: 'Your Employer Name',
                      hintStyle: TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.height * .01, horizontal: Get.width * .02)
                  ),
                ).paddingOnly(top: Get.height * .004),
                GestureDetector(
                  onTap: (){
                    showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        String startWorkDateFixesIncome = DateFormat('MM/dd/yyyy').format(selectedDate);
                        controller.employerStartDateController.text = startWorkDateFixesIncome;
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
                      controller: controller.employerStartDateController,
                      enabled: false,
                      style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Work Start Date',
                        hintStyle: TextStyle(fontSize: 12,color: AppColors.blackColor.withOpacity(.6)),
                        prefixIcon: Icon(Icons.calendar_month,color: AppColors.blackColor.withOpacity(.4),),
                        border: InputBorder.none, // Remove the default border
                      ),
                    ),
                  ).paddingOnly(top: Get.height * .02),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() =>  Checkbox(
                        value: controller.currentWorkingFixedIncome,
                        activeColor: AppColors.primaryColor,
                        onChanged: (value){
                          if(controller.currentWorkingFixedIncome == false){
                            controller.setCurrentWorkingFixed(true);
                            controller.employerEndDateController.text = '';
                          }else{
                            controller.setCurrentWorkingFixed(false);
                            controller.employerEndDateController.text = '';
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
                Obx(() => controller.currentWorkingFixedIncome == false?GestureDetector(
                  onTap: (){
                    showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        String endWorkDateFixesIncome = DateFormat('MM/dd/yyyy').format(selectedDate);
                        controller.employerEndDateController.text = endWorkDateFixesIncome;
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
                      controller: controller.employerEndDateController,
                      enabled: false,
                      style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Work End Date',
                        hintStyle: TextStyle(fontSize: 12,color: AppColors.blackColor.withOpacity(.6)),
                        prefixIcon: Icon(Icons.calendar_month,color: AppColors.blackColor.withOpacity(.4),),
                        border: InputBorder.none, // Remove the default border
                      ),
                    ),
                  ).paddingOnly(top: Get.height * .01),
                ):
                const SizedBox(),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                        text: 'Date of Pay Check',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),
                  ],
                ).paddingOnly(top: Get.height * .02),
                GestureDetector(
                  onTap: (){
                    showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        String dateOfPayCheck = DateFormat('MM/dd/yyyy').format(selectedDate);
                        controller.dateOfPayCheckController.text = dateOfPayCheck;
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
                      controller: controller.dateOfPayCheckController,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                        text: 'Pay Period End Date',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),

                  ],
                ).paddingOnly(top: Get.height * .01),
                GestureDetector(
                  onTap: (){
                    showDatePicker(
                      context: Get.context!,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        String payPeriodEndDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                        controller.payPeriodEndDateController.text = payPeriodEndDate;
                        controller.setSelectedPayPeriodEndDateDayAndMonth(selectedDate.day, selectedDate.month);
                        controller.calculateMonthlyIncome(controller.payRatePerCycleController.text);
                        controller.calculateBaseIncomeYTD(controller.baseIncomeYearToDateController.text);
                        controller.calculateTotalSummaryIncome();
                        // print(controller.selectedPayPeriodEndDateMonth);
                        // print(controller.selectedPayPeriodEndDateDay);
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
                      controller: controller.payPeriodEndDateController,
                      enabled: false,
                      style: const TextStyle(color: AppColors.primaryColor,fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: 'Select Date',
                        hintStyle: TextStyle(fontSize: 12,color: AppColors.blackColor.withOpacity(.6)),
                        prefixIcon: Icon(Icons.calendar_month,color: AppColors.blackColor.withOpacity(.4),),
                        border: InputBorder.none,
                      ),
                    ),
                  ).paddingOnly(top: Get.height * .002),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextWidget(
                        text: 'Salary Cycle',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),

                  ],
                ).paddingOnly(top: Get.height * .02),
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
                    'Select Pay Cycle',
                    style: TextStyle(fontSize: 12),
                  ),
                  items: Constants().payPerCycleTypes
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
                      return 'Select Pay Cycle';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    controller.setSalaryCycle(value.toString()) ;
                  },
                  onSaved: (value) {
                    controller.setSalaryCycle(value.toString()) ;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => TextWidget(
                        text: 'Pay Rate Per ${controller.salaryCycle} Cycle',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),),


                  ],
                ).paddingOnly(top: Get.height * .02),

                Obx(() => controller.salaryCycle == ''?
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('* Please choose Salary Cycle to enter Pay Rate Cycle Amount.',
                    style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                      .paddingOnly(bottom: Get.height * .01),
                ):const SizedBox(),),

                Container(
                  height: Get.height * .06,
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
                        child:Obx(() => TextFormField(
                          controller: controller.payRatePerCycleController,
                          keyboardType: TextInputType.number,
                          enabled: controller.salaryCycle == '' ? false:true,
                          onChanged: (String annualIncome){
                            controller.calculateMonthlyIncome(annualIncome);
                            // controller.calculateDifference();
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

                        ),),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => TextWidget(
                        text: 'Base Income (YTD) (${controller.baseYear.toString()})',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),),


                  ],
                ).paddingOnly(top: Get.height * .02),
                Obx(() => controller.selectedPayPeriodEndDateDay == 0?
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('* Please Select Pay Period End Date to enter Base Income Amount.',
                    style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                      .paddingOnly(bottom: Get.height * .01),
                ):const SizedBox(),),
                Container(
                  height: Get.height * .06,
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
                        child:Obx(() => TextFormField(
                          enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                          controller: controller.baseIncomeYearToDateController,
                          keyboardType: TextInputType.number,
                          onChanged: (String baseIncome){
                            controller.calculateBaseIncomeYTD(baseIncome);
                            // controller.calculateDifference();
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

                        ),),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() =>  TextWidget(
                        text: "Latest Year's W2 Box 5 Income (${controller.w2Year.toString()})",
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),),

                  ],
                ).paddingOnly(top: Get.height * .02),
                Container(
                  height: Get.height * .06,
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
                          controller: controller.latestYearsW2Box5IncomeController,
                          keyboardType: TextInputType.number,
                          onChanged: (String w2Income){
                            controller.calculateW2Income(w2Income);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => TextWidget(
                        text: "Prior Year's W2 Box 5 Income (${controller.priorW2Year.toString()})",
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),),


                  ],
                ).paddingOnly(top: Get.height * .02),
                Container(
                  height: Get.height * .06,
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
                          controller: controller.priorYearsW2Box5IncomeController,
                          keyboardType: TextInputType.number,
                          onChanged: (String priorW2Income){
                            controller.calculatePriorW2Income(priorW2Income);
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(() =>  Checkbox(
                            value: controller.additionalW2IncomeTypes,
                            activeColor: AppColors.primaryColor,
                            onChanged: (value){
                              if(controller.additionalW2IncomeTypes == false){
                                controller.setAdditionalW2IncomeTypes(true);
                                // controller.companyEndDateFixedIncomeController.text = '';
                                controller.calculateTotalSummaryIncome();
                              }else{
                                controller.setAdditionalW2IncomeTypes(false);
                                controller.calculateTotalSummaryIncome();
                                // controller.companyEndDateFixedIncomeController.text = '';
                              }
                            }
                        ),),
                        const TextWidget(
                            text: 'Include Additional W2 Income Types',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontColor: AppColors.textColorBlack,
                            textAlign: TextAlign.center)
                      ],
                    ),
                  ],
                ).paddingOnly(top: Get.height * .02),
                Obx(() =>controller.additionalW2IncomeTypes == true? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Note: ',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.errorTextColor,fontSize: 12),),
                        Expanded(
                          child: Text(Constants().note,
                            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12),),
                        ),
                      ],
                    ),
                    Obx(() => controller.selectedPayPeriodEndDateDay == 0?
                    Text('* Please Select Pay Period End Date to enter Additional W2s Incomes.',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                              child: Center(child:  Obx(() => TextWidget(
                                  text: controller.baseYear.toString(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),),),
                            )),
                        Expanded(
                            child: SizedBox(
                              child: Center(child:  Obx(() => TextWidget(
                                  text: controller.w2Year.toString(),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),),),
                            )),
                        Expanded(
                            child: SizedBox(child: Center(child:  Obx(() => TextWidget(
                                text: controller.priorW2Year.toString(),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontColor: AppColors.primaryColor,
                                textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),),),)),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: '(YTD) Overtime',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.baseOverTimeFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String overTimeFirst)async{
                                          if(overTimeFirst.isEmpty){
                                            await controller.setAdditionalIncomesValues('baseOverTime', 0.0);
                                            controller.calculateAdditionalMethod('overTime');
                                            // await controller.setBaseOverTime(0.0);
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('baseOverTime', double.parse(overTimeFirst));
                                            controller.calculateAdditionalMethod('overTime');
                                            // await controller.setBaseOverTime(double.parse(overTimeFirst));
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Overtime',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.w2OverTimeFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String overTimeFirst)async{
                                          if(overTimeFirst.isEmpty){
                                            await controller.setAdditionalIncomesValues('w2OverTime', 0.0);
                                            controller.calculateAdditionalMethod('overTime');
                                            // await controller.setW2OverTime(0.0);
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('w2OverTime', double.parse(overTimeFirst));
                                            controller.calculateAdditionalMethod('overTime');
                                            // await controller.setW2OverTime(double.parse(overTimeFirst));
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Overtime',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.priorW2OverTimeFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String overTimeSecond)async{
                                          if(overTimeSecond.isEmpty){
                                            await controller.setAdditionalIncomesValues('priorW2OverTime', 0.0);
                                            controller.calculateAdditionalMethod('overTime');
                                            // await controller.setPriorW2OverTime(0.0);
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('priorW2OverTime', double.parse(overTimeSecond));
                                            controller.calculateAdditionalMethod('overTime');
                                            // await controller.setPriorW2OverTime(double.parse(overTimeSecond));
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
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

                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: '(YTD) Bonus',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),

                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.baseBonusFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String bonusIncome)async{
                                          if(bonusIncome.isEmpty){
                                            await controller.setAdditionalIncomesValues('baseBonus', 0.0);
                                            controller.calculateAdditionalMethod('bonus');
                                            // await controller.setBaseBonus(0.0);
                                            // controller.calculateBonusIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('baseBonus', double.parse(bonusIncome));
                                            controller.calculateAdditionalMethod('bonus');
                                            // await controller.setBaseBonus(double.parse(bonusIncome));
                                            // controller.calculateBonusIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
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

                            ],
                          ),
                        ),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Bonus',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),

                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.w2BonusFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String bonusIncome)async{
                                          if(bonusIncome.isEmpty){
                                            await controller.setAdditionalIncomesValues('w2Bonus', 0.0);
                                            controller.calculateAdditionalMethod('bonus');
                                            // await controller.setW2Bonus(0.0);
                                            // Logs().showLog(controller.baseBonus.toString());
                                            // controller.calculateBonusIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('w2Bonus', double.parse(bonusIncome));
                                            controller.calculateAdditionalMethod('bonus');
                                            // await controller.setW2Bonus(double.parse(bonusIncome));
                                            // controller.calculateBonusIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
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

                            ],
                          ),
                        ),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Bonus',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),

                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.priorW2BonusFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String bonusIncome)async{
                                          if(bonusIncome.isEmpty){
                                            await controller.setAdditionalIncomesValues('priorW2Bonus', 0.0);
                                            controller.calculateAdditionalMethod('bonus');
                                            // await controller.setPriorW2Bonus(0.0);
                                            // Logs().showLog(controller.baseBonus.toString());
                                            // controller.calculateBonusIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('priorW2Bonus', double.parse(bonusIncome));
                                            controller.calculateAdditionalMethod('bonus');
                                            // await controller.setPriorW2Bonus(double.parse(bonusIncome));
                                            // controller.calculateBonusIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
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

                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: '(YTD) Commission',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),

                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.baseCommissionFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String commissionIncome)async{
                                          if(commissionIncome.isEmpty){
                                            await controller.setAdditionalIncomesValues('baseCommission', 0.0);
                                            controller.calculateAdditionalMethod('commission');
                                            // await controller.setBaseCommission(0.0);
                                            // Logs().showLog(controller.baseCommission.toString());
                                            // controller.calculateCommissionIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('baseCommission', double.parse(commissionIncome));
                                            controller.calculateAdditionalMethod('commission');
                                            // await controller.setBaseCommission(double.parse(commissionIncome));
                                            // controller.calculateCommissionIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
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
                            ],
                          ),
                        ),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Commission',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),

                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.w2CommissionFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String commissionIncome)async{
                                          if(commissionIncome.isEmpty){
                                            await controller.setAdditionalIncomesValues('w2Commission', 0.0);
                                            controller.calculateAdditionalMethod('commission');
                                            // await controller.setW2Commission(0.0);
                                            // Logs().showLog(controller.w2Commission.toString());
                                            // controller.calculateCommissionIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('w2Commission', double.parse(commissionIncome));
                                            controller.calculateAdditionalMethod('commission');
                                            // await controller.setW2Commission(double.parse(commissionIncome));
                                            // controller.calculateCommissionIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
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
                            ],
                          ),
                        ),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextWidget(
                                  text: 'Commission',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),

                              Container(
                                height: Get.height * .06,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 1.0),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                        controller: controller.priorW2CommissionFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String commissionIncome)async{
                                          if(commissionIncome.isEmpty){
                                            await controller.setAdditionalIncomesValues('priorW2Commission', 0.0);
                                            controller.calculateAdditionalMethod('commission');
                                            // await controller.setPriorW2Commission(0.0);
                                            // Logs().showLog(controller.priorW2Commission.toString());
                                            // controller.calculateCommissionIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('priorW2Commission', double.parse(commissionIncome));
                                            controller.calculateAdditionalMethod('commission');
                                            // await controller.setPriorW2Commission(double.parse(commissionIncome));
                                            // controller.calculateCommissionIncomeTestTwo();
                                          }
                                        },
                                        style: TextStyle(fontSize: 15),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: '0.0',
                                          hintStyle: TextStyle(fontSize: 14),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const TextWidget(
                                    text: '(YTD) Tips',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                                Container(
                                  height: Get.height * .06,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                          controller: controller.baseTipsFixedController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (String tipsIncome)async{
                                            if(tipsIncome.isEmpty){
                                              await controller.setAdditionalIncomesValues('baseTips', 0.0);
                                              controller.calculateAdditionalMethod('tips');
                                              // await controller.setBaseTips(0.0);
                                              // Logs().showLog(controller.baseTips.toString());
                                              // controller.calculateTipsIncomeTestTwo();
                                            }else{
                                              await controller.setAdditionalIncomesValues('baseTips', double.parse(tipsIncome));
                                              controller.calculateAdditionalMethod('tips');
                                              // await controller.setBaseTips(double.parse(tipsIncome));
                                              // controller.calculateTipsIncomeTestTwo();
                                            }
                                          },
                                          style: TextStyle(fontSize: 15),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: '0.0',
                                            hintStyle: TextStyle(fontSize: 14),
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
                              ],
                            )
                        ),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const TextWidget(
                                    text: 'Tips',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                                Container(
                                  height: Get.height * .06,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                          controller: controller.w2TipsFixedController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (String tipsIncome)async{
                                            if(tipsIncome.isEmpty){
                                              await controller.setAdditionalIncomesValues('w2Tips', 0.0);
                                              controller.calculateAdditionalMethod('tips');
                                              // await controller.setW2Tips(0.0);
                                              // Logs().showLog(controller.w2Tips.toString());
                                              // controller.calculateTipsIncomeTestTwo();
                                            }else{
                                              await controller.setAdditionalIncomesValues('w2Tips', double.parse(tipsIncome));
                                              controller.calculateAdditionalMethod('tips');
                                              // await controller.setW2Tips(double.parse(tipsIncome));
                                              // controller.calculateTipsIncomeTestTwo();
                                            }
                                          },
                                          style: TextStyle(fontSize: 15),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: '0.0',
                                            hintStyle: TextStyle(fontSize: 14),
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
                              ],
                            )
                        ),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const TextWidget(
                                    text: 'Tips',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                                Container(
                                  height: Get.height * .06,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                          controller: controller.priorW2TipsFixedController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (String tipsIncome)async{
                                            if(tipsIncome.isEmpty){
                                              await controller.setAdditionalIncomesValues('priorW2Tips', 0.0);
                                              controller.calculateAdditionalMethod('tips');
                                              // await controller.setPriorW2Tips(0.0);
                                              // Logs().showLog(controller.priorW2Tips.toString());
                                              // controller.calculateTipsIncomeTestTwo();
                                            }else{
                                              await controller.setAdditionalIncomesValues('priorW2Tips', double.parse(tipsIncome));
                                              controller.calculateAdditionalMethod('tips');
                                              // await controller.setPriorW2Tips(double.parse(tipsIncome));
                                              // controller.calculateTipsIncomeTestTwo();
                                            }
                                          },
                                          style: TextStyle(fontSize: 15),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: '0.0',
                                            hintStyle: TextStyle(fontSize: 14),
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
                              ],
                            )
                        ),
                      ],
                    ),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const TextWidget(
                                    text: '(YTD) Other Income',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                                Container(
                                  height: Get.height * .06,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                          controller: controller.baseOthersFixedController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (String otherIncome)async{
                                            if(otherIncome.isEmpty){
                                              await controller.setAdditionalIncomesValues('baseOthers', 0.0);
                                              controller.calculateAdditionalMethod('other');
                                              // await controller.setBaseOthers(0.0);
                                              // Logs().showLog(controller.baseOthers.toString());
                                              // controller.calculateOthersIncomeTestTwo();
                                            }else{
                                              await controller.setAdditionalIncomesValues('baseOthers', double.parse(otherIncome));
                                              controller.calculateAdditionalMethod('other');
                                              // await controller.setBaseOthers(double.parse(otherIncome));
                                              // controller.calculateOthersIncomeTestTwo();
                                            }
                                          },
                                          style: TextStyle(fontSize: 15),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: '0.0',
                                            hintStyle: TextStyle(fontSize: 14),
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
                              ],
                            )),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const TextWidget(
                                    text: 'Other Income',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                                Container(
                                  height: Get.height * .06,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                          controller: controller.w2OthersFixedController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (String otherIncome)async{
                                            if(otherIncome.isEmpty){
                                              await controller.setAdditionalIncomesValues('w2Others', 0.0);
                                              controller.calculateAdditionalMethod('other');
                                              // await controller.setW2Others(0.0);
                                              // Logs().showLog(controller.w2Others.toString());
                                              // controller.calculateOthersIncomeTestTwo();
                                            }else{
                                              await controller.setAdditionalIncomesValues('w2Others', double.parse(otherIncome));
                                              controller.calculateAdditionalMethod('other');
                                              // await controller.setW2Others(double.parse(otherIncome));
                                              // controller.calculateOthersIncomeTestTwo();
                                            }
                                          },
                                          style: TextStyle(fontSize: 15),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: '0.0',
                                            hintStyle: TextStyle(fontSize: 14),
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
                              ],
                            )),
                        SizedBox(width: Get.width * .04,),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const TextWidget(
                                    text: 'Other Income',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                                Container(
                                  height: Get.height * .06,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(left: 2.0),
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,), // Replace with your desired icon
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0 ?false: true,
                                          controller: controller.priorW2OthersFixedController,
                                          keyboardType: TextInputType.number,
                                          onChanged: (String otherIncome)async{
                                            if(otherIncome.isEmpty){
                                              await controller.setAdditionalIncomesValues('priorW2Others', 0.0);
                                              controller.calculateAdditionalMethod('other');
                                              // await controller.setPriorW2Others(0.0);
                                              // Logs().showLog(controller.priorW2Others.toString());
                                              // controller.calculateOthersIncomeTestTwo();
                                            }else{
                                              await controller.setAdditionalIncomesValues('priorW2Others', double.parse(otherIncome));
                                              controller.calculateAdditionalMethod('other');
                                              // await controller.setPriorW2Others(double.parse(otherIncome));
                                              // controller.calculateOthersIncomeTestTwo();
                                            }
                                          },
                                          style: TextStyle(fontSize: 15),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: '0.0',
                                            hintStyle: TextStyle(fontSize: 14),
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
                              ],
                            )),

                      ],
                    )
                  ],
                ):const SizedBox(),),

                Align(
                    alignment: Alignment.centerLeft,
                  child: const TextWidget(
                      text: "Monthly Income",
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontColor: AppColors.primaryColor,
                      textAlign: TextAlign.center).paddingOnly(top: Get.height * .02),
                ),
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
                            Obx(() => Text(
                              controller.calculatedMonthlyIncomeFixed == '0.0'?'0.00':controller.calculatedMonthlyIncomeFixed,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                fontSize: 14),),)
                          ],
                        ),
                        Text('/ per month',style: TextStyle(fontSize: 10),)

                      ],).paddingSymmetric(horizontal: Get.width * .02),
                  ),
                ).paddingOnly(top: Get.height * .004),
                Obx(() => Align(
                  alignment: Alignment.centerLeft,
                  child: TextWidget(
                      text: "Calculated Income (YTD) (${controller.baseYear.toString()})",
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontColor: AppColors.primaryColor,
                      textAlign: TextAlign.center).paddingOnly(top: Get.height * .02),
                ),),

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
                            Obx(() => Text(controller.calculatedBaseIncomeYTDFixed == '0.0'?'0.00':controller.calculatedBaseIncomeYTDFixed,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                fontSize: 14),),)

                          ],
                        ),
                        Text('/ per month',style: TextStyle(fontSize: 10),)

                      ],).paddingSymmetric(horizontal: Get.width * .02),
                  ),
                ).paddingOnly(top: Get.height * .004),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const TextWidget(
                      text: "YTD Difference",
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontColor: AppColors.primaryColor,
                      textAlign: TextAlign.center).paddingOnly(top: Get.height * .02),
                ),
                Container(
                    width: Get.width * 1,
                    height: Get.height * .06,
                    decoration:  BoxDecoration(
                        color:AppColors.viewColor.withOpacity(.8),
                        borderRadius: BorderRadius.circular(6)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.attach_money,color: AppColors.primaryColor,),
                            Obx(() => Text(controller.calculatedDifference == '0.0'?'0.00':controller.calculatedDifference,style: TextStyle(fontWeight: FontWeight.bold,
                                color:controller.calculatedDifferenceValueType == 'negative'?
                                AppColors.errorTextColor:controller.calculatedDifferenceValueType == 'positive'?
                                AppColors.textColorGreen:AppColors.primaryColor,
                                fontSize: 14),),),
                            Text('/ per month',style: TextStyle(fontSize: 10),)
                          ],
                        ),
                        Obx(() => controller.calculatedDifferenceValueType == 'negative'?const Icon(Icons.arrow_downward,
                          color: AppColors.errorTextColor,):
                        controller.calculatedDifferenceValueType == 'positive'?const Icon(Icons.arrow_upward,
                          color: AppColors.textColorGreen,):const SizedBox()

                        )
                      ],).paddingSymmetric(horizontal: 10)
                  // child: SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           const Icon(Icons.attach_money,color: AppColors.primaryColor,),
                  //           Obx(() => Text(controller.calculatedDifference,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  //               fontSize: 14.sp),),),
                  //
                  //         ],
                  //       ),
                  //       Text('/ per month',style: TextStyle(fontSize: 10.sp),)
                  //
                  //     ],).paddingSymmetric(horizontal: Get.width * .02),
                  // ),
                ).paddingOnly(top: Get.height * .004),
                Obx(() =>  Align(
                    alignment: Alignment.centerLeft,
                  child: TextWidget(
                      text: "W2 Income (${controller.w2Year.toString()})",
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontColor: AppColors.primaryColor,
                      textAlign: TextAlign.center).paddingOnly(top: Get.height * .02),
                ),),
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
                            Obx(() => Text(controller.calculatedW2Fixed == '0.0'?'0.00':controller.calculatedW2Fixed,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                fontSize: 14),),)

                          ],
                        ),
                        Text('/ per month',style: TextStyle(fontSize: 10),)

                      ],).paddingSymmetric(horizontal: Get.width * .02),
                  ),
                ).paddingOnly(top: Get.height * .004),
                Obx(() => Align(
                    alignment: Alignment.centerLeft,
                  child: TextWidget(
                      text: "W2 Income For 2 Years (${controller.priorW2Year.toString()})",
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontColor: AppColors.primaryColor,
                      textAlign: TextAlign.center).paddingOnly(top: Get.height * .02),
                ),),

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
                            Obx(() => Text(controller.calculatedPriorW2Fixed == '0.0'?'0.00':controller.calculatedPriorW2Fixed,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                fontSize: 14),),)

                          ],
                        ),
                        Text('/ per month',style: TextStyle(fontSize: 10),)

                      ],).paddingSymmetric(horizontal: Get.width * .02),
                  ),
                ).paddingOnly(top: Get.height * .004),
                controller.additionalW2IncomeTypes == true? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextWidget(
                        text: "Additional W2 Incomes (Calculated)",
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center).paddingOnly(top: Get.height * .02),
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
                                Obx(() => Text(controller.totalAdditionalW2sAmount,style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),),)
                              ],
                            ),
                            Text('/ per month',style: TextStyle(fontSize: 10),)

                          ],).paddingSymmetric(horizontal: Get.width * .02),
                      ),
                    ).paddingOnly(top: Get.height * .004),
                  ],
                ):const SizedBox(),
                Align(
                  alignment: Alignment.centerLeft,
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
                      border: Border.all(color: AppColors.primaryColor,width: 2),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Base Income: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center),
                          Row(
                            children: [
                              Obx(() => TextWidget(
                                  text: "\$${controller.calculatedMonthlyIncomeFixed == '0.0'?'0.00':controller.calculatedMonthlyIncomeFixed}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center)),
                              SizedBox(width: Get.width * .02,),
                            ],
                          ),

                        ],
                      ),
                      // Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingSymmetric(vertical: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Over Time: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center),
                          Row(
                            children: [
                              Obx(() => TextWidget(
                                  text: "\$${controller.additionalW2IncomeTypes == true?controller.totalOverTime.toStringAsFixed(2):'0.00'}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center)),
                              SizedBox(width: Get.width * .02,),
                            ],
                          )

                        ],
                      ).paddingOnly(top: 5),
                      // Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingSymmetric(vertical: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Bonus: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center),
                          Row(
                            children: [
                              Obx(() => TextWidget(
                                  text: "\$${controller.additionalW2IncomeTypes == true?controller.totalBonus.toStringAsFixed(2):'0.00'}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center)),
                              SizedBox(width: Get.width * .02,),
                            ],
                          )
                        ],
                      ).paddingOnly(top: 5),
                      // Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingSymmetric(vertical: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Commission: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center),
                          Row(
                            children: [
                              Obx(() => TextWidget(
                                  text: "\$${controller.additionalW2IncomeTypes == true?controller.totalCommission.toStringAsFixed(2):'0.00'}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center)),
                              SizedBox(width: Get.width * .02,),
                            ],
                          ),

                        ],
                      ).paddingOnly(top: 5),
                      // Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingSymmetric(vertical: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Tips: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center),
                          Row(
                            children: [
                              Obx(() => TextWidget(
                                  text: "\$${controller.additionalW2IncomeTypes == true?controller.totalTips.toStringAsFixed(2):'0.00'}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center)),
                              SizedBox(width: Get.width * .02,),
                            ],
                          )

                        ],
                      ).paddingOnly(top: 5),
                      // Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingSymmetric(vertical: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Others: ",
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center),
                          Row(
                              children: [
                                Obx(() => TextWidget(
                                    text: "\$${controller.additionalW2IncomeTypes == true?controller.totalOthers.toStringAsFixed(2):'0.00'}",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center)),
                                SizedBox(width: Get.width * .02,),
                              ]
                          )

                        ],
                      ).paddingOnly(top: 5),
                      Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingSymmetric(vertical: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextWidget(
                              text: "Total Income: ",
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              fontColor: AppColors.textColorBlack,
                              textAlign: TextAlign.center),
                          Row(
                            children: [
                              Obx(() =>  TextWidget(
                                  text: "\$${controller.summaryTotal == '0.0'?'0.00':controller.summaryTotal}",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  fontColor: AppColors.primaryColor,
                                  textAlign: TextAlign.center)),
                              SizedBox(width: Get.width * .02,),
                            ],
                          )


                        ],
                      ).paddingOnly(top: 4),
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
                SizedBox(
                  height: Get.height * .01,
                ),

                SizedBox(
                  width: Get.width * 1,
                  height: Get.height * .08,
                  child: ElevatedButton(
                      onPressed: () async{
                        if(controller.employerNameController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please type you employer name');
                        }else if(controller.employerStartDateController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please select your employment start date');
                        }else if(controller.dateOfPayCheckController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please select date of pay check');
                        }else if(controller.payPeriodEndDateController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please select date of pay period end date');
                        }else if(controller.payPeriodEndDateController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please select date of pay period end date');
                        }else if(controller.payRatePerCycleController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please type amount of pay rate per cycle');
                        }else if(controller.baseIncomeYearToDateController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please type amount of base income ( YTD )');
                        }else if(controller.latestYearsW2Box5IncomeController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please type amount of w2 from box 5 of your w2 form');
                        }else if(controller.priorYearsW2Box5IncomeController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please type amount of prior w2 from box 5 of your prior w2 form');
                        }else if(controller.additionalW2IncomeTypes == true){
                          if(controller.totalOverTime == 0.0 && controller.totalBonus == 0.0 && controller.totalCommission == 0.0
                              && controller.totalTips == 0.0 && controller.totalOthers == 0.0){
                            SnackBarApp().errorSnack('Form Error', 'Please add one or more additional w2 incomes');
                          }else{
                            controller.addIncome(borrowerId,verifyStatus,controller.selectedAddedBy.value);
                          }
                        }
                        else{
                          controller.addIncome(borrowerId,verifyStatus,controller.selectedAddedBy.value);
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
                ).paddingOnly(bottom: Get.height * .06)

              ],
            ).paddingAll(16),
          ),
        ),
      )
    );
  }
}