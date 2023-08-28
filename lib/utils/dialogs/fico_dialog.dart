import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';

class FicoDialog {
  addFicoDialogue(String borrowerId,String value,String type) {
    final formKeyFico = GlobalKey<FormState>();
    final ficoScoreController = TextEditingController(text: value);

    Get.defaultDialog(
      title: 'Add / Edit FICO Score',
      titleStyle: const TextStyle(fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor),
      barrierDismissible: true,
      content: Form(
        key: formKeyFico,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: ficoScoreController,
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
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Enter Your Fico Score',
                    hintStyle: TextStyle(fontSize: 12),
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * .01, horizontal: Get.width * .02)
                ),
              ),
              SizedBox(
                width: Get.width * .2,
                height: Get.height * .1,
                child: ElevatedButton(
                    onPressed: () async{
                      if (formKeyFico.currentState!.validate()) {
                        await FirestoreService().addFicoScore(borrowerId,ficoScoreController.text,type);
                        Get.back();
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
                ).paddingOnly(top: Get.height * .04),
              )
            ],
          ).marginSymmetric(horizontal: 8),
        ),
      ),
    );
  }
}


