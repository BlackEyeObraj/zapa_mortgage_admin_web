import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';

class CoBorrowerDialog{

  editBorrower(String id,String borrowerFICO, String borrowerIncome, String borrowerLiability){
    final coBorrowerFICOTextController = TextEditingController(text: borrowerFICO == '0'?'':borrowerFICO);
    final coBorrowerIncomeTextController = TextEditingController(text: borrowerIncome == '0.00'?'':borrowerIncome);
    final coBorrowerLiabilityTextController = TextEditingController(text: borrowerLiability == '0.00'?'':borrowerLiability);
    final key = GlobalKey<FormState>();
    Get.defaultDialog(
      title: 'Edit Co-Borrower',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content:
      Flexible(
        child: SingleChildScrollView(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('Co-Borrower FICO',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                    fontSize: 12),).marginOnly(top: 8),
                TextFormField(
                  controller: coBorrowerFICOTextController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter fico score';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null) {
                      return 'Invalid number format';
                    }
                    if (intValue < 350) {
                      return 'The fico score must be greater than 350';
                    }
                    if (intValue > 850) {
                      return 'The fico score must be less than 850';
                    }
                    return null;

                  },
                  decoration: InputDecoration(
                      hintText: 'Enter FICO',
                      hintStyle: TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.height * .01, horizontal: Get.width * .02)
                  ),
                ),
                Text('Co-Borrower Income',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                    fontSize: 12),).marginOnly(top: 8),
                TextFormField(
                  controller: coBorrowerIncomeTextController,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Income';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Income',
                      hintStyle: TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.height * .01, horizontal: Get.width * .02)
                  ),
                ),
                Text('Co-Borrower Liability',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                    fontSize: 12),).marginOnly(top: 8),
                TextFormField(
                  controller: coBorrowerLiabilityTextController,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Liability';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Enter Liability',
                      hintStyle: TextStyle(fontSize: 12),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: Get.height * .01, horizontal: Get.width * .02)
                  ),
                ),
                SizedBox(
                  width: Get.width * .2,
                  height: 48,
                  child: ElevatedButton(
                      onPressed: () async{
                        if(key.currentState!.validate()){
                          FirestoreService().updateCoBorrower(
                              id,
                              coBorrowerFICOTextController.text.toString(),
                              coBorrowerIncomeTextController.text.toString(),
                              coBorrowerLiabilityTextController.text.toString(),
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
                      child: const Text('Update Co-Borrower',style: TextStyle(color: AppColors.textColorWhite),)
                  ).paddingOnly(top: Get.height * .02),
                )

              ],

            ),
          ),
        ),
      ),
    );
  }

}