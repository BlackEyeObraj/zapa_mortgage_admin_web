import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';

class EngagementStatusDialog{

  showDialog(String borrowerId, String userName, String phoneNumber){
    Get.defaultDialog(
      title: 'Change Engagement Status',
      middleText: 'Please note that if the status is changed to Engaged then it can not be set back.',
      confirm: TextButton(onPressed: (){
        FirestoreService().setEngagementStatus(borrowerId,userName,phoneNumber);
      }, child: Text('Change')),
      cancel: TextButton(
          onPressed: (){
            Get.back();
          },
          child: Text('Cancel')
      )
    );
  }
}