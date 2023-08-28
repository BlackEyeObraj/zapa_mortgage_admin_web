import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';

class NickNameDialog{

addNickName(String userId, String nickName){
  final nickNameTextController = TextEditingController(text: nickName);

  return Get.defaultDialog(
    title: 'Add / Edit Nick Name',
    titleStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
    content: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: TextFormField(
            controller: nickNameTextController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Enter Nick Name',
              hintStyle: TextStyle(fontSize: 12),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  bottom: 12,top: 12,left: 8,right: 8),
            ),

          ),
        ),

      ],
    ),
      confirm: TextButton(onPressed: (){
        Map<String, dynamic> updatedData = {
          'nickName': nickNameTextController.text,
        };
        FirestoreService().addEditUserNickName(userId,updatedData);
      }, child: Text('Add / Update')),
    cancel: TextButton(onPressed: () => Get.back(), child: Text('Cancel'))
  );
}
}