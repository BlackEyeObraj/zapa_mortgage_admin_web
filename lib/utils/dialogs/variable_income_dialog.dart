import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zapa_mortgage_admin_web/controllers/variable_income_calcuator_controller.dart';

import '../../res/app_colors.dart';
import '../constants.dart';
import '../snack_bar.dart';
import '../widgets/text_widget.dart';

class VariableIncomeDialog{

  addVariableIncome(String borrowerId){
    final controller = VariableIncomeCalculatorController();
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
                  child: Text('Calculate Variable Income',style: TextStyle(
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
                        String startWorkDateVariableIncome = DateFormat('MM/dd/yyyy').format(selectedDate);
                        controller.employmentStartDateController.text = startWorkDateVariableIncome;
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
                      controller: controller.employmentStartDateController,
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
                            controller.employmentEndDateController.text = '';
                          }else{
                            controller.setCurrentWorkingFixed(false);
                            controller.employmentEndDateController.text = '';
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
                        String endWorkDateVariableIncome = DateFormat('MM/dd/yyyy').format(selectedDate);
                        controller.employmentEndDateController.text = endWorkDateVariableIncome;
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
                      controller: controller.employmentEndDateController,
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
                  value: 'Hourly',
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
                Obx(() =>controller.salaryCycle != 'Hourly'?  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => TextWidget(
                        text: 'Pay Rate Per ${controller.salaryCycle} Cycle',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontColor: AppColors.primaryColor,
                        textAlign: TextAlign.center),),


                  ],
                ).paddingOnly(top: Get.height * .02):const SizedBox(),),

                // Obx(() => controller.salaryCycle != 'Hourly'?
                // Text('* Please Select Salary Cycle of Weekly, Bi Weekly, Semi Monthly or Monthly to enter pay period cycle amount.',
                //   style: TextStyle(fontSize: 10.sp,color: AppColors.redColor),)
                //     .paddingOnly(bottom: Get.height * .01):const SizedBox(),),

                Obx(() => controller.salaryCycle == 'Hourly'? const SizedBox():Container(
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
                        child: Obx(() => TextFormField(
                          enabled: controller.salaryCycle == '' || controller.salaryCycle == 'Hourly'?false:true,
                          controller: controller.payRatePerCycleController,
                          keyboardType: TextInputType.number,
                          onChanged: (String annualIncome){

                            controller.calculatePayRate();
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
                )),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                              child: Center(child:  Column(
                                children: [
                                  Obx(() => TextWidget(
                                      text: controller.baseYear.toString(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontColor: AppColors.primaryColor,
                                      textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),),
                                  const TextWidget(
                                      text: 'Base',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      fontColor: AppColors.primaryColor,
                                      textAlign: TextAlign.center)
                                ],
                              ),),
                            )),
                        Expanded(
                            child: SizedBox(
                              child: Center(child:  Column(
                                children: [
                                  Obx(() => TextWidget(
                                      text: controller.w2Year.toString(),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontColor: AppColors.primaryColor,
                                      textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),),
                                  const TextWidget(
                                      text: 'W2',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                      fontColor: AppColors.primaryColor,
                                      textAlign: TextAlign.center)
                                ],
                              ),),
                            )),
                        Expanded(
                            child: SizedBox(child: Center(child:  Column(
                              children: [
                                Obx(() => TextWidget(
                                    text: controller.priorW2Year.toString(),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),),
                                const TextWidget(
                                    text: 'Prior W2',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    fontColor: AppColors.primaryColor,
                                    textAlign: TextAlign.center)
                              ],
                            ),),)),
                      ],
                    ),
                    // Obx(() => controller.salaryCycle != 'Hourly'?
                    // Text('* Please Select Salary Cycle of Hourly to enter YTD Income, W2 Income and Prior W2 Income.',
                    //   style: TextStyle(fontSize: 10.sp,color: AppColors.redColor),)
                    //     .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    // Obx(() => controller.selectedPayPeriodEndDateDay == 0 ?
                    // Text('* Please Select Select Pay Period End Date',
                    //   style: TextStyle(fontSize: 10.sp,color: AppColors.redColor),)
                    //     .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Obx(() => controller.salaryCycle == 'Hourly'? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('(YTD) Income',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),
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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.salaryCycle != 'Hourly' || controller.selectedPayPeriodEndDateDay == 0 ?false:true,
                                        controller: controller.baseIncomeController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String incomeFirst)async{
                                          if(incomeFirst.isEmpty){
                                            await controller.setAdditionalIncomesValues('baseIncome', 0.0);
                                            controller.calculateAdditionalMethod('income');
                                            // await controller.setBaseOverTime(0.0);
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('baseIncome', double.parse(incomeFirst));
                                            controller.calculateAdditionalMethod('income');
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

                                      ),),
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

                              const Text('Income',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.salaryCycle != 'Hourly' || controller.selectedPayPeriodEndDateDay == 0?false:true,
                                        controller: controller.w2IncomeController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String incomeSecond)async{
                                          if(incomeSecond.isEmpty){
                                            await controller.setAdditionalIncomesValues('w2Income', 0.0);
                                            controller.calculateAdditionalMethod('income');
                                            // await controller.setBaseOverTime(0.0);
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('w2Income', double.parse(incomeSecond));
                                            controller.calculateAdditionalMethod('income');
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

                                      ),),
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
                              const Text('Income',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.salaryCycle != 'Hourly' || controller.selectedPayPeriodEndDateDay == 0?false:true,
                                        controller: controller.priorW2IncomeController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String incomeThird)async{
                                          if(incomeThird.isEmpty){
                                            await controller.setAdditionalIncomesValues('priorW2Income', 0.0);
                                            controller.calculateAdditionalMethod('income');
                                            // await controller.setBaseOverTime(0.0);
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('priorW2Income', double.parse(incomeThird));
                                            controller.calculateAdditionalMethod('income');
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

                                      ),),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ):const SizedBox(),
                    ),
                    Obx(() =>controller.salaryCycle == 'Hourly' &&  controller.selectedPayPeriodEndDateDay == 0?
                    Text('* Select pay period end date',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Obx(() => controller.salaryCycle == 'Hourly' && controller.baseIncome == 0.0?
                    Text('* Base Income must not be empty',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Obx(() => controller.salaryCycle == 'Hourly' && controller.w2Income == 0.0?
                    Text('* W2 Income must not be empty',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Obx(() => controller.salaryCycle == 'Hourly' && controller.priorW2Income == 0.0?
                    Text('* Prior W2 Income must not be empty',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('(YTD) Overtime',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 13),).paddingOnly(top: Get.height * .01),
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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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

                                      ),),
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

                              const Text('Overtime',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
                                        controller: controller.w2OverTimeFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String overTimeSecond)async{
                                          if(overTimeSecond.isEmpty){
                                            await controller.setAdditionalIncomesValues('w2OverTime', 0.0);
                                            controller.calculateAdditionalMethod('overTime');
                                            // await controller.setW2OverTime(0.0);
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('w2OverTime', double.parse(overTimeSecond));
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

                                      ),),
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
                              // const TextWidget(
                              //     text: '(YTD) Overtime',
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w900,
                              //     fontColor: AppColors.primaryColor,
                              //     textAlign: TextAlign.center).paddingOnly(top: Get.height * .01),
                              const Text('Overtime',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
                                        controller: controller.priorW2OverTimeFixedController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (String overTimeThird)async{
                                          if(overTimeThird.isEmpty){
                                            await controller.setAdditionalIncomesValues('priorW2OverTime', 0.0);
                                            controller.calculateAdditionalMethod('overTime');
                                            // await controller.setPriorW2OverTime(0.0);
                                            // controller.calculateOverTimeIncomeTestTwo();
                                          }else{
                                            await controller.setAdditionalIncomesValues('priorW2OverTime', double.parse(overTimeThird));
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
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),

                    Obx(() =>controller.selectedPayPeriodEndDateDay == 0?
                    Text('* Select pay period end date',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('(YTD) Bonus',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),),
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
                              const Text('Bonus',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),),
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
                              const Text('Bonus',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                    Obx(() =>controller.selectedPayPeriodEndDateDay == 0?
                    Text('* Select pay period end date',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('(YTD) Commission',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 12),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),),
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
                              const Text('Commission',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),),
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
                              const Text('Commission',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                  fontSize: 14),).paddingOnly(top: Get.height * .01),

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
                                      child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                    ),
                                    Expanded(
                                      child:Obx(() => TextFormField(
                                        enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                          contentPadding: const EdgeInsets.only(bottom: 4),
                                          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                        ),

                                      ),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Obx(() =>controller.selectedPayPeriodEndDateDay == 0?
                    Text('* Select pay period end date',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('(YTD) Tips',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),).paddingOnly(top: Get.height * .01),
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
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                      ),
                                      Expanded(
                                        child:Obx(() => TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                            contentPadding: const EdgeInsets.only(bottom: 4),
                                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                          ),

                                        ),),
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

                                const Text('Tips',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),).paddingOnly(top: Get.height * .01),
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
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                      ),
                                      Expanded(
                                        child:Obx(() => TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                            contentPadding: const EdgeInsets.only(bottom: 4),
                                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                          ),

                                        ),),
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

                                const Text('Tips',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),).paddingOnly(top: Get.height * .01),
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
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                      ),
                                      Expanded(
                                        child:Obx(() => TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                            contentPadding: const EdgeInsets.only(bottom: 4),
                                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                          ),

                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                    Obx(() =>controller.selectedPayPeriodEndDateDay == 0?
                    Text('* Select pay period end date',
                      style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                        .paddingOnly(top: Get.height * .01):const SizedBox(),),
                    Container(width: Get.width * 1,height: Get.height * .001,color: AppColors.greyColor,).paddingOnly(top: Get.height * .02),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                const Text('(YTD) Others',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),).paddingOnly(top: Get.height * .01),
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
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                      ),
                                      Expanded(
                                        child:Obx(() => TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                            contentPadding: const EdgeInsets.only(bottom: 4),
                                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                          ),

                                        ),),
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

                                const Text('Others',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),).paddingOnly(top: Get.height * .01),
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
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                      ),
                                      Expanded(
                                        child:Obx(() => TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                            contentPadding: const EdgeInsets.only(bottom: 4),
                                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                          ),

                                        ),),
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

                                const Text('Others',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                                    fontSize: 14),).paddingOnly(top: Get.height * .01),
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
                                        child: const Icon(Icons.attach_money,color: AppColors.primaryColor,size: 16,),
                                      ),
                                      Expanded(
                                        child:Obx(() => TextFormField(
                                          enabled: controller.selectedPayPeriodEndDateDay == 0?false:true,
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
                                            contentPadding: const EdgeInsets.only(bottom: 4),
                                            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                                          ),
                                        ),),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),

                      ],
                    )
                  ],
                ).paddingOnly(top: Get.height * .01),
                Obx(() =>controller.selectedPayPeriodEndDateDay == 0?
                Text('* Select pay period end date',
                  style: TextStyle(fontSize: 10,color: AppColors.redColor),)
                    .paddingOnly(top: Get.height * .01):const SizedBox(),),
                const TextWidget(
                    text: 'Summary of income (Calculated)',
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontColor: AppColors.textColorApp,
                    textAlign: TextAlign.center).marginOnly(top: Get.height * .03),
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
                                  text: "\$${controller.totalIncome == 0.0?'0.00':controller.totalIncome.toStringAsFixed(2)}",
                                  // text: "\$0.0",
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
                                  text: "\$${controller.totalOverTime.toStringAsFixed(2)}",
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
                                  text: "\$${controller.totalBonus.toStringAsFixed(2)}",
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
                                  text: "\$${controller.totalCommission.toStringAsFixed(2)}",
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
                                  text: "\$${controller.totalTips.toStringAsFixed(2)}",
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
                                    text: "\$${controller.totalOthers.toStringAsFixed(2)}",
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
                  width: Get.width * 1,
                  height: Get.height * .08,
                  child: ElevatedButton(
                      onPressed: () async{
                        if(controller.employerNameController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please type you employer name');
                        }else if(controller.employmentStartDateController.text.isEmpty){
                          SnackBarApp().errorSnack('Form Error', 'Please select your employment start date');
                        }else if(controller.totalIncome == 0.0){
                          SnackBarApp().errorSnack('Form Error', "You don't base income to save this income.");
                        }else{
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