import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/app_colors.dart';

class SnackBarApp{

  errorSnack(String title, String message){
    Get.snackbar('Info Incomplete', 'Please select asset type',
        backgroundColor: Colors.red,
        titleText: Text(title,style: const TextStyle(
            fontWeight: FontWeight.bold,color: AppColors.textColorWhite
        ),),
        messageText: Text(message,style: const TextStyle(
            fontWeight: FontWeight.normal,color: AppColors.textColorWhite
        ),),
        snackPosition: SnackPosition.TOP);
  }
  successSnack(String title, String message){
    Get.snackbar('Info Incomplete', 'Please select asset type',
        backgroundColor: Colors.green,
        titleText: Text(title,style: const TextStyle(
            fontWeight: FontWeight.bold,color: AppColors.textColorWhite
        ),),
        messageText: Text(message,style: const TextStyle(
            fontWeight: FontWeight.normal,color: AppColors.textColorWhite
        ),),
        snackPosition: SnackPosition.TOP);
  }
}