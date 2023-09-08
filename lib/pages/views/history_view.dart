import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/history_view_controller.dart';

class HistoryView extends GetView<HistoryViewController>{
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HistoryViewController(),
        builder: (controller){
          return Container();
        }
    );
  }

}