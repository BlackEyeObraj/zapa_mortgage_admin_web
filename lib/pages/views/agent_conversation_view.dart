import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';
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
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Chat').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                      if (documents.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cancel,size: 100,color: AppColors.greyColor,),
                            SizedBox(height: 16,),
                            Text('No Chat found yet.'),
                          ],
                        );
                      }
                      return ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index){
                            Map<String, dynamic> data = documents[index].data() as Map<String, dynamic>;
                            return Container(
                              width: Get.width * 1,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2.0
                                  )
                                ],
                                border: Border.all(color: AppColors.primaryColor,width: 1),
                                borderRadius: BorderRadius.circular(10),

                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10000),
                                        child: data['borrowerImage'] != ''?
                                        ImageNetwork(image: data['borrowerImage'], height: 60, width: 60):
                                        Container(
                                            height: 60,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: AppColors.primaryColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(color: AppColors.primaryColor)
                                            ),
                                            child: Icon(Icons.person,color: AppColors.whiteColor,size: 28,).paddingAll(6)
                                        ),
                                      ),
                                      // CircleAvatar(
                                      //     radius: Get.height * .04,
                                      //     backgroundColor: AppColors.primaryColor,
                                      //     backgroundImage: data['userImage'] != ''
                                      //         ?
                                      //         // ? Image(image: NetworkImage(data['userImage']))
                                      //         : const AssetImage(AppImages.noUserImage) as ImageProvider
                                      // ),

                                      SizedBox(width: Get.width * .01,),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: 'Chat Room of: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(text: data['agentName'] != ''?data['agentName']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8,),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Borrower Name: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(text: data['borrowerName'] != ''?data['borrowerName']:'N/A', style: TextStyle(fontWeight: FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8,),
                                          RichText(
                                            text: TextSpan(
                                              text: 'Borrower Phone Number: ',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              children: <TextSpan>[
                                                TextSpan(text: data['borrowerPhoneNumber'], style: TextStyle(fontWeight: FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ).paddingSymmetric(vertical: 8)
                                    ],
                                  ),
                                  SizedBox(
                                    height: .1,
                                    child: ElevatedButton(onPressed: (){

                                    }, child: Row(
                                      children: [
                                        Text('Chat '),
                                        Icon(Icons.message,size: 16,),
                                      ],
                                    )),
                                  )
                                ],
                              ).paddingSymmetric(horizontal: 16),
                            ).paddingAll(16);
                          }
                      );
                    }
                  )
              )
            ],
          ),

        );
        }
    );
  }

}