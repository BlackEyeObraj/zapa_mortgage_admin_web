import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../res/app_colors.dart';

class BorrowerDialog{
  addLiabilityDialog(){
    final box = GetStorage();
    PhoneController phoneNumberController = PhoneController(null);
    String phoneNumber = '';
    String countryCode = '+1';

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
              PhoneFormField(
                  controller: phoneNumberController,
                  defaultCountry: IsoCode.US,
                  decoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: Get.height * .02,horizontal: Get.width * .02)
                  ),
                  validator: PhoneValidator.validMobile(),
                  // isCountryChipPersistent: true, // default
                  // isCountrySelectionEnabled: true,
                  onChanged: (PhoneNumber? phone){
                    phoneNumber = phone!.nsn;
                    countryCode = phone.countryCode.toString();
                  }
              ),
              SizedBox(
                width: Get.width * .2,
                height: 48,
                child: ElevatedButton(
                    onPressed: (){},
                    child: Text('Add Borrower')),
              ).marginOnly(top: 16)
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );

  }


}