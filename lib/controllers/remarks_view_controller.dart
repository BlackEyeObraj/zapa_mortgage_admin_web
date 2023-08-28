import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zapa_mortgage_admin_web/utils/constants.dart';

class RemarksViewController extends GetxController{
  final box = GetStorage();

  RxString userId = ''.obs;

  @override
  void onInit() async{
    userId.value = await box.read(Constants.USER_ID);
    super.onInit();

  }
}