import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:phone_form_field/phone_form_field.dart';
import 'package:zapa_mortgage_admin_web/controllers/users_view_controller.dart';

import '../../res/app_colors.dart';

class BorrowerDialog{
  addLiabilityDialog(){
    final box = GetStorage();

    Get.defaultDialog(
      title: 'Create Borrower Account',
      titleStyle: const TextStyle(fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textColorBlack),
      barrierDismissible: true,
      content: Flexible(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone Number *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),),
              // PhoneFormField(
              //     controller: Get.put(UsersViewController()).phoneNumberController,
              //     defaultCountry: IsoCode.US,
              //     decoration: InputDecoration(
              //         hintText: 'Phone Number',
              //         border: const OutlineInputBorder(),
              //         contentPadding: EdgeInsets.symmetric(vertical: Get.height * .02,horizontal: Get.width * .02)
              //     ),
              //     validator: PhoneValidator.validMobile(),
              //     isCountryChipPersistent: true, // default
              //     isCountrySelectionEnabled: true,
              //     onChanged: (PhoneNumber? phone){
              //       Get.put(UsersViewController()).setPhoneNumber(phone!.nsn);
              //       Get.put(UsersViewController()).setCountryCode(phone.countryCode.toString());
              //     }
              // ),
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );

  }


}