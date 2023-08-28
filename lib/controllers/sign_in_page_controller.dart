import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';
import 'package:zapa_mortgage_admin_web/utils/constants.dart';
import 'package:zapa_mortgage_admin_web/utils/routes/route_name.dart';

class SignInPageController extends GetxController {
  final box = GetStorage();
  final RxBool _isLoading = false.obs;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  bool get isLoading => _isLoading.value;

  @override
  void onInit() async{
    String status =await FirestoreService().getAccountStatus(box.read(Constants.USER_ID)?? 'null');
    if(status != 'false'){
      Get.offAndToNamed(RouteName.dashboard);
    }
    super.onInit();
  }

  setLoading(bool value) {
    _isLoading.value = value;
  }

}
