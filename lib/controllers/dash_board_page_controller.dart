import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../utils/routes/route_name.dart';

class DashBoardPageController extends GetxController{
  final box = GetStorage();
  late StreamSubscription<String> statusSubscription;
  final FirestoreService firestoreService = FirestoreService();

  final RxBool _usersOptionHover = false.obs;
  final RxBool _remarksOptionHover = false.obs;
  final RxBool _historyOptionHover = false.obs;
  final RxString _selectedTab = 'Borrowers'.obs;
  final RxString _userName = ''.obs;


  bool get userOptionHover => _usersOptionHover.value;
  bool get remarksOptionHover => _remarksOptionHover.value;
  bool get historyOptionHover => _historyOptionHover.value;
  String get selectedTab => _selectedTab.value;
  String get userName => _userName.value;

  @override
  void onInit() async{
    String status =await FirestoreService().getAccountStatus(box.read(Constants.USER_ID)??'');
    print(status);
    if(status == 'false'){
      Get.offAndToNamed(RouteName.signIn);
    }else{
      _userName.value = box.read(Constants.USER_NAME);
      statusSubscription = firestoreService.getAccountStatusStream(box.read(Constants.USER_ID)).listen((status) {
        print(status);
        if(status == 'inActive'){
          final box = GetStorage();
          box.write(Constants.USER_ID, '');
          box.write(Constants.USER_NAME, '');
          box.write(Constants.USER_EMAIL, '');
          FirestoreService().setLoginStatus(box.read(Constants.USER_ID), 'false');
          Get.offAndToNamed(RouteName.signIn);
        }
      });
    }
    super.onInit();
  }

  setHoverOption(String option,bool value){
    if(option == 'Borrowers'){
      _usersOptionHover.value = value;
    }else if(option == 'Remarks & Notes'){
      _remarksOptionHover.value = value;
    }else if(option == 'History'){
      _historyOptionHover.value = value;
    }
  }
  setTabOption(String option){
    _selectedTab.value = option;
  }

  logout()async{
    final box = GetStorage();
    await FirestoreService().historyDataAdd("${box.read(Constants.USER_NAME)} has logged out.");
    box.write(Constants.USER_ID, '');
    box.write(Constants.USER_NAME, '');
    box.write(Constants.USER_EMAIL, '');
    FirestoreService().setLoginStatus(box.read(Constants.USER_ID), 'false');
    Get.offAndToNamed(RouteName.signIn);
  }

  // @override
  // void onClose() {
  //   statusSubscription.cancel();
  //   super.onClose();
  // }
}
