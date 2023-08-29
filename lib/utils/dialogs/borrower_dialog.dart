import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';
import '../../res/app_colors.dart';
import '../snack_bar.dart';

class BorrowerDialog{
  addBorrowerDialog(){
    PhoneController phoneNumberController = PhoneController(null);
    final borrowerTextController = TextEditingController(text: '');
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
              Text('Borrower Name',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),),
              TextFormField(
                controller: borrowerTextController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    hintText: 'Type Name',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),
              Text('Phone Number *',style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.primaryColor,
                  fontSize: 12),).marginOnly(top: 8),
              PhoneFormField(
                  controller: phoneNumberController,
                  defaultCountry: IsoCode.US,
                  decoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: Get.height * .02,horizontal: Get.width * .01)
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
                    onPressed: (){
                      if(phoneNumber.isEmpty){
                        SnackBarApp().errorSnack('Info Incomplete', 'Please enter borrower phone number');
                      }else{
                        FirestoreService().phoneAuthService(borrowerTextController.text, "+${countryCode}${phoneNumber}");
                      }
                    },
                    child: Text('Send Verification Code')),
              ).marginOnly(top: 16)
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );

  }


}