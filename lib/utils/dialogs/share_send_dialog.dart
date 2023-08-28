import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/app_colors.dart';

class ShareSendDialog{
  shareAndSend() {
    return Get.defaultDialog(
      title: 'Agents',
      titleStyle: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor),
      content: SizedBox(
        height: Get.height * .6,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryColor,width: 1),
                  borderRadius: BorderRadius.circular(20)
                ),
              ),
            ),
            SizedBox(height: 8,),
            SizedBox(
              width: Get.width * .3,
              height: Get.height * .06,
              child: ElevatedButton(onPressed: (){

              }, child: Text('Share & Send Message',style: TextStyle(color: AppColors.textColorWhite),)),
            )
          ],
        ),
      )
    );
  }

}