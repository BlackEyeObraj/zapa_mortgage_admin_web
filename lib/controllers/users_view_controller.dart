import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/firestore_service.dart';

class UsersViewController extends GetxController{

  final searchPhoneNumberTextController = TextEditingController();

  final RxString _onHover = ''.obs;
  final RxString _phoneNumber = ''.obs;
  final RxString selectedLOA = ''.obs;
  final RxString selectedBREA = ''.obs;
  final RxList adminFilter = [].obs;


  String get onHover => _onHover.value;
  String get phoneNumber => _phoneNumber.value;


  setHoverOption(String value){
    _onHover.value = value;
  }

  setPhoneNumber(String phoneNumber){
    _phoneNumber.value = phoneNumber;
  }

  setAdminFilterList()async{
    List<String> adminUsers = await FirestoreService().fetchAdminFilter();
    adminFilter.value = adminUsers;
  }
  @override
  void onInit() {
    setAdminFilterList();
    super.onInit();
  }
}