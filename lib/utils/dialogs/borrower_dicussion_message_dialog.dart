import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';
import 'package:zapa_mortgage_admin_web/utils/dialogs/share_send_dialog.dart';
import 'package:zapa_mortgage_admin_web/utils/snack_bar.dart';

class BorrowerDiscussionMessageDialog {

  addMessageDialog(String borrowerId, String borrowerName, String borrowerPhoneNumber) {
    final messageTextController = TextEditingController();
    return Get.dialog(
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: 16.0, horizontal: Get.width * .18),
        // Add margin from all sides
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded edges
          ),
          child: Container(
            width: Get.width * 1, // Adjust the width as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Message',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close, color: AppColors.errorTextColor,))
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    width: Get.width * 1,
                    height: Get.height * 1,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextField(
                      controller: messageTextController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message here .....',
                      ),
                    ).paddingAll(16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Get.height * .06,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor
                              ),
                              onPressed: ()async {
                                if (messageTextController.text.isEmpty) {
                                  SnackBarApp().errorSnack('From Error',
                                      'Message field must not be empty.');
                                }else if (messageTextController.text.trim().isEmpty) {
                                  SnackBarApp().errorSnack('Form Error', 'Message field must not be empty.');
                                }else {
                                  ShareSendDialog().shareWithBorrowerAndAgent(messageTextController.text,borrowerId,borrowerName,borrowerPhoneNumber);
                                }
                              }, child: Text('Share with Borrower & Agent',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ),
                      // SizedBox(width: 16,),
                      SizedBox(
                        height: Get.height * .06,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor
                              ),
                              onPressed: ()async {
                                if (messageTextController.text.isEmpty) {
                                  SnackBarApp().errorSnack('From Error',
                                      'Message field must not be empty.');
                                }else if (messageTextController.text.trim().isEmpty) {
                                  SnackBarApp().errorSnack('Form Error', 'Message field must not be empty.');
                                }else {
                                  ShareSendDialog().shareWithBorrower(messageTextController.text,borrowerId,borrowerName,borrowerPhoneNumber);
                                }
                              }, child: Text('Share with Borrower',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ),
                      // SizedBox(width: 16,),
                      SizedBox(
                        height: Get.height * .06,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor
                              ),
                              onPressed: ()async {
                                if (messageTextController.text.isEmpty) {
                                  SnackBarApp().errorSnack('From Error',
                                      'Message field must not be empty.');
                                }else if (messageTextController.text.trim().isEmpty) {
                                  SnackBarApp().errorSnack('Form Error', 'Message field must not be empty.');
                                }else {
                                  ShareSendDialog().shareAndSend(messageTextController.text,borrowerId,borrowerName,borrowerPhoneNumber);
                                }
                              }, child: Text('Share with Agent',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ),
                      // SizedBox(width: 16,),
                      SizedBox(
                        height: Get.height * .06,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor
                              ),
                              onPressed: ()async {
                                if (messageTextController.text.isEmpty) {
                                  SnackBarApp().errorSnack('From Error',
                                      'Message field must not be empty.');
                                }else if (messageTextController.text.trim().isEmpty) {
                                  SnackBarApp().errorSnack('Form Error', 'Message field must not be empty.');
                                }else {
                                  await FirestoreService().addMessage(
                                      borrowerId,messageTextController.text);
                                }
                              }, child: Text('Only Add',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  editMessageDialog(String borrowerId,String id ,String message,) {
    final messageTextController = TextEditingController(text: message);
    return Get.dialog(
      Padding(
        padding: EdgeInsets.symmetric(
            vertical: 16.0, horizontal: Get.width * .18),
        // Add margin from all sides
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded edges
          ),
          child: Container(
            width: Get.width * 1, // Adjust the width as needed
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Edit Message',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.close, color: AppColors.errorTextColor,))
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    width: Get.width * 1,
                    height: Get.height * 1,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      controller: messageTextController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message here .....',
                      ),
                    ).paddingAll(16),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: Get.height * .06,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColor
                              ),
                              onPressed: () {
                                if (messageTextController.text.isEmpty) {
                                  SnackBarApp().errorSnack('From Error',
                                      'Message field must not be empty.');
                                } else {
                                  Map<String, dynamic> updatedData = {
                                    'message': messageTextController.text,
                                  };
                                  FirestoreService().editMessage(borrowerId,id, updatedData);
                                }
                              }, child: Text('Save Changes',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteMessageDialog(String borrowerId,String id) {
    return Get.defaultDialog(
        title: 'Delete Message',
        middleText: 'Are you sure you want to delete this message',
        confirm: TextButton(onPressed: ()async{
          FirestoreService().deleteMessage(id,borrowerId);
        }, child: Text('Yes')),
        cancel: TextButton(onPressed: ()async{
          Get.back();
        }, child: Text('No'))
    );
  }
}
