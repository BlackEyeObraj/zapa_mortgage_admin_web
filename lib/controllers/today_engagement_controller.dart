import 'package:get/get.dart';

class TodayEngagementController extends GetxController{

  final RxString _onHover = ''.obs;
  RxString _date = ''.obs;


  String get onHover => _onHover.value;
  String get date => _date.value;


  setHoverOption(String value){
    _onHover.value = value;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getDate();
    super.onInit();
  }

  void getDate() {
    _date.value = '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  }
}