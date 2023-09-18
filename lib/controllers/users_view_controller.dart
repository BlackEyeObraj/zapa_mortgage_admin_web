import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:rxdart/rxdart.dart';

import '../services/firestore_service.dart';

class UsersViewController extends GetxController{

  final searchPhoneNumberTextController = TextEditingController();



  final RxString _onHover = ''.obs;
  final RxString phoneNumbers = ''.obs;
  final RxString selectedLOA = ''.obs;
  final RxString selectedBREA = ''.obs;
  final RxString selectedLeadStage = ''.obs;
  final RxList adminFilter = [].obs;
  final RxList agentFilter = [].obs;


  String get onHover => _onHover.value;


  setHoverOption(String value){
    _onHover.value = value;
  }

  setPhoneNumber(String phoneNumber){
    phoneNumbers.value = phoneNumber;
  }
  setAdminFilterList()async{
    List<String> adminUsers = await FirestoreService().fetchAdminFilter();
    List<String> agentUsers = await FirestoreService().fetchAgentFilter();
    adminFilter.value = adminUsers;
    agentFilter.value = agentUsers;
  }

  @override
  void onInit() {
    setAdminFilterList();
    super.onInit();
  }
}