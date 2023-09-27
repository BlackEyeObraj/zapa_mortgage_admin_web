import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:zapa_mortgage_admin_web/services/firestore_service.dart';

class NotificationService{


  sendNotification(String notiType,admin,String token,String notificationTitle, String notificationBody,String borrowerId)async{
    var data = {
      'to' : token.toString(),
      'notification' : {
        'title' : notificationTitle,
        'body' : notificationBody
      },
      'data' : {
        'type' : notiType ,
        'id' : borrowerId ,
        'by' : admin
      }
    };

    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(data) ,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization' : 'key=AAAAC-SudfI:APA91bGs4zXMsEnFwRexWYmo1GNrWHA8s2qkCjA8__X-93aHhze7LyDkGRVh8dsPexLz-Rjitq2SSje-Fq7PR7-MO41LrWXLzyCyXlgc3q8JaRIo0f-RrkMnOP3dlvEqwDFqm_bXiaQu'
        }
    ).then((value)async{
      if (kDebugMode) {
      await FirestoreService().saveNotificationOfBorrower(borrowerId, notificationBody);
        print(value.body.toString());
      }
    }).onError((error, stackTrace){
      if (kDebugMode) {
        print(error);
      }
    });
  }

}