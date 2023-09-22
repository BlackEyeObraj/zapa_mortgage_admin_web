import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/controllers/borrower_conversation_view_controller.dart';

import '../../res/app_colors.dart';
import '../../services/firestore_service.dart';
import '../../utils/snack_bar.dart';
import '../../utils/utils_mehtods.dart';

class BorrowerConversationView extends GetView<BorrowerConversationViewController>{
  final String borrowerId;
  final String borrowerPhoneNumber;
  final String borrowerName;
  BorrowerConversationView({required this.borrowerId, required this.borrowerPhoneNumber, required this.borrowerName});
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BorrowerConversationViewController(),
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
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'Borrower Chat',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: AppColors.textColorWhite
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text('Borrower Name: ',style: TextStyle(color: AppColors.textColorWhite,fontWeight: FontWeight.bold),),
                                Text(borrowerName.isNotEmpty?borrowerName:'N/A',style: TextStyle(color: AppColors.textColorWhite,fontWeight: FontWeight.normal),),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Borrower PhoneNumber: ',style: TextStyle(color: AppColors.textColorWhite,fontWeight: FontWeight.bold),),
                                Text(borrowerPhoneNumber.isNotEmpty?borrowerPhoneNumber:'N/A',style: TextStyle(color: AppColors.textColorWhite,fontWeight: FontWeight.normal),),
                              ],
                            ),
                          ],
                        ).marginOnly(left: 16),
                      )
                    ],
                  )

              ),
              Expanded(child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('users').doc(borrowerId).collection('BorrowerChat').orderBy('addedDateTime', descending: true).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the data is loading, show a loading indicator.
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    // Handle any errors that occurred while fetching the data.
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    // If there is no data, display a message.
                    return Center(child: Text('No messages found.'));
                  }

                  // If the data is loaded successfully, process and display it.
                  final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;

                  // Use the 'documents' list to display user data.
                  return ListView.builder(
                    reverse: true, // Start from the bottom
                    itemCount: documents.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final userData = documents[index].data();
                      final from = userData['from'];
                      final message = userData['message'];
                      final addedDateTime = userData['addedDateTime'];
                      // Determine the alignment based on the sender (admin or user)
                      final alignment = from == 'admin' ? Alignment.centerRight : Alignment.centerLeft;
                      // Display user information in ListTile or any other widget.
                      return Align(
                        alignment: alignment,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: from == 'admin' ? AppColors.primaryColor : Colors.grey.withOpacity(.2), // Customize the color
                          ),
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: from == 'admin' ? Colors.white : Colors.black, // Customize the text color
                                ),
                              ),
                              SizedBox(height: 8), // Add some spacing
                              Text(
                                '${UtilMethods().parseFirestoreTimestamp(addedDateTime)}', // Display the addedDateTime below the message
                                style: TextStyle(
                                  fontSize: 8,
                                  color: from == 'admin' ? Colors.white : Colors.black.withOpacity(.6), // Customize the text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ).paddingAll(16)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Type Message Here...'
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    if(controller.messageController.text.isEmpty){
                      SnackBarApp().errorSnack('Form Error ', 'Please enter a message to send');
                    }else{
                      FirestoreService().sendMessageBorrower(borrowerId,controller.messageController.text);
                      controller.messageController.clear();
                    }
                  }, icon: Icon(Icons.send))
                ],
              ).paddingAll(16)
            ],
          ),
        );
        }
    );
  }

}