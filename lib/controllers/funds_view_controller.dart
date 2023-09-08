import 'package:get/get.dart';

class FundsViewController extends GetxController{

  final RxString selectedAssetTypeFund = ''.obs;
  final RxBool _selectedAssetTypeEnable = true.obs;
  final RxBool _verifiedCheck = true.obs;
  final RxBool _verifiedButExeCheck = false.obs;
  final RxString selectedAddedBy = 'processor'.obs;
  final RxString searchFilter = 'All'.obs;


  bool get selectedAssetTypeEnable => _selectedAssetTypeEnable.value;
  bool get verifiedCheck => _verifiedCheck.value;
  bool get verifiedButExeCheck => _verifiedButExeCheck.value;


  setSelectedAssetTypeEnableOrDisable(bool value) {
    _selectedAssetTypeEnable.value = value;
  }
  setVerifyCheck(String type, bool value){
    if(type == 'verified'){
      _verifiedCheck.value = value;
    }else{
      _verifiedButExeCheck.value = value;
    }
  }

}