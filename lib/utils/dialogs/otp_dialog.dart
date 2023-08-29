import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';

class OtpDialog{
  otpDialog(String borrowerName, String verificationId, ConfirmationResult confirmationResult, FirebaseAuth auth){
    final formKeyOtp = GlobalKey<FormState>();
    final otpController = TextEditingController();
    StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
    Get.defaultDialog(
      title: 'Enter 6 digit Otp code received to Borrower ',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content: Flexible(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKeyOtp,
                child: PinCodeTextField(
                  controller: otpController,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter otp code';
                    }else if(value.length < 6){
                      return 'Enter complete otp code';
                    }else{
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveFillColor: Colors.transparent,
                      activeFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      selectedColor: AppColors.primaryColor,
                      disabledColor: Colors.white,
                      activeColor: AppColors.primaryColor,
                      inactiveColor: Colors.grey
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  // backgroundColor: Colors.blue.shade50,
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  // controller: textEditingController,
                  onCompleted: (v) {
                  },
                  onChanged: (value) {
                  },
                  beforeTextPaste: (text) {
                    return true;
                  }, appContext: Get.context!,
                ).marginOnly(top: Get.height * .08),
              ),


              SizedBox(
                width: Get.width * .2,
                height: 48,
                child: ElevatedButton(
                    onPressed: ()async{
                      if(formKeyOtp.currentState!.validate()){
                        FirestoreService().verifyOtpCode(verificationId,otpController.text.toString(),borrowerName,confirmationResult,auth);
                        // UserCredential userCredential = await confirmationResult.confirm(otpController.text.toString());
                      }
                    },
                    child: Text('Add Borrower')),
              ).marginOnly(top: 16)
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );

  }

}