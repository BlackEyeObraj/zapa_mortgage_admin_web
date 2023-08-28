import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zapa_mortgage_admin_web/res/app_colors.dart';
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';
import 'package:zapa_mortgage_admin_web/utils/snack_bar.dart';

class RemarksAndNotesDialog {

  addRemarksAndNotesDialog() {
    final remarkAndNoteTextController = TextEditingController();
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
                        'Add Remarks / Notes',
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
                      controller: remarkAndNoteTextController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your remark / note here .....',
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
                                if (remarkAndNoteTextController.text.isEmpty) {
                                  SnackBarApp().errorSnack('From Error',
                                      'Remarks or note field must not be empty.');
                                }else if (remarkAndNoteTextController.text.trim().isEmpty) {
                                  SnackBarApp().errorSnack('Form Error', 'Remarks or note field must not be empty.');
                                }else {
                                  FirestoreService().addRemarksAndNotes(
                                      remarkAndNoteTextController.text);
                                }
                              }, child: Text('Add Remark / Note',
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
  editRemarksAndNotesDialog(String id ,String remarkAndNote,) {
    final remarkAndNoteTextController = TextEditingController(text: remarkAndNote);
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
                        'Edit Remarks / Notes',
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
                      controller: remarkAndNoteTextController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(fontSize: 18),
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your remark / note here .....',
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
                                if (remarkAndNoteTextController.text.isEmpty) {
                                  SnackBarApp().errorSnack('From Error',
                                      'Remarks or note field must not be empty.');
                                } else {
                                  Map<String, dynamic> updatedData = {
                                    'remarkAndNote': remarkAndNoteTextController.text,
                                  };
                                  FirestoreService().editRemarksAndNotes(id, updatedData);
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

  deleteRemarksAndNotesDialog(String id) {
    return Get.defaultDialog(
        title: 'Delete Remark / Note',
        middleText: 'Are you sure you want to delete this remark',
      confirm: TextButton(onPressed: ()async{
        FirestoreService().deleteRemarksAndNotes(id);
      }, child: Text('Yes')),
        cancel: TextButton(onPressed: ()async{
      Get.back();
    }, child: Text('No'))
    );
  }
}
