import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/firestore_service.dart';
import '../utils/constants.dart';
import '../utils/routes/route_name.dart';

class UserDetailPageController extends GetxController{
  final box = GetStorage();
  late StreamSubscription<String> statusSubscription;
  final FirestoreService firestoreService = FirestoreService();

  RxString _borrowerId = ''.obs;
  RxString _borrowerPhoneNumber = ''.obs;
  RxString _borrowerName = ''.obs;
  final RxString _selectedTab = 'Summary'.obs;
  final RxBool _summaryOptionHover = false.obs;
  final RxBool _ficoOptionHover = false.obs;
  final RxBool _incomeOptionHover = false.obs;
  final RxBool _liabilityOptionHover = false.obs;
  final RxBool _fundsOptionHover = false.obs;
  final RxBool _scenarioOptionHover = false.obs;
  final RxBool _coBorrowersOptionHove = false.obs;
  final RxBool _borrowerDiscussionsOptionHover = false.obs;


  String get borrowerId => _borrowerId.value;
  String get borrowerPhoneNumber => _borrowerPhoneNumber.value;
  String get borrowerName => _borrowerName.value;
  String get selectedTab => _selectedTab.value;
  bool get summaryOptionHover => _summaryOptionHover.value;
  bool get ficoOptionHover => _ficoOptionHover.value;
  bool get incomeOptionHover => _incomeOptionHover.value;
  bool get liabilityOptionHover => _liabilityOptionHover.value;
  bool get fundsOptionHover => _fundsOptionHover.value;
  bool get scenarioOptionHover => _scenarioOptionHover.value;
  bool get coBorrowersOptionHove => _coBorrowersOptionHove.value;
  bool get borrowerDiscussionsOptionHover => _borrowerDiscussionsOptionHover.value;

  @override
  void onInit() async{
    String status =await FirestoreService().getAccountStatus(box.read(Constants.USER_ID)??'');
    print(status);
    if(status == 'false'){
      Get.offAndToNamed(RouteName.signIn);
    }else{
      _borrowerId.value  = Get.arguments['borrowerId'];
      _borrowerPhoneNumber.value  = Get.arguments['borrowerPhoneNumber'];
      _borrowerName.value  = Get.arguments['borrowerUserName'];
      FirestoreService().setLastViewedBy(borrowerId, box.read(Constants.USER_NAME),DateTime.now());
      statusSubscription = firestoreService.getAccountStatusStream(box.read(Constants.USER_ID)).listen((status) {
        if(status == 'inActive'){
          final box = GetStorage();
          box.write(Constants.USER_ID, '');
          box.write(Constants.USER_NAME, '');
          box.write(Constants.USER_EMAIL, '');
          FirestoreService().setLoginStatus(box.read(Constants.USER_ID), 'false');
          Get.toNamed(RouteName.signIn);
        }
      });
    }


    super.onInit();
  }
  setTabOption(String option){
    _selectedTab.value = option;
  }
  setHoverOption(String option,bool value){
    if(option == 'Summary'){
      _summaryOptionHover.value = value;
    }else if(option == 'FICO'){
      _ficoOptionHover.value = value;
    }else if(option == 'Income'){
      _incomeOptionHover.value = value;
    }else if(option == 'Liability'){
      _liabilityOptionHover.value = value;
    }else if(option == 'Funds'){
      _fundsOptionHover.value = value;
    }else if(option == 'Scenario'){
      _scenarioOptionHover.value = value;
    }else if(option == 'coBorrowers'){
      _coBorrowersOptionHove.value = value;
    }else if(option == 'BorrowerDiscussions'){
      _borrowerDiscussionsOptionHover.value = value;
    }
  }
  @override
  void onClose() {
    // statusSubscription.cancel();
    super.onClose();
  }
}