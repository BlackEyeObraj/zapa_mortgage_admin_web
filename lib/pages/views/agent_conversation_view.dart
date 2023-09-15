import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/agent_conversation_view_controller.dart';

import '../../res/app_colors.dart';

class AgentConversationView extends GetView<AgentConversationViewController>{
  final String borrowerId;
  final String borrowerPhoneNumber;
  AgentConversationView({required this.borrowerId, required this.borrowerPhoneNumber});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AgentConversationViewController(),
        builder: (controller){
        return Scaffold(
          body: Column(
            children: [
              Container(
                width: Get.width * 1,
                height: Get.height * .1,
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
                ),
                child: Center(
                  child: Text(
                    'Conversation with Agent',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: AppColors.textColorWhite
                    ),
                  ),
                ),
              ),
            ],
          ),

        );
        }
    );
  }

}