import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtilMethods{

  String parseFirestoreTimestamp(Timestamp firestoreTimestamp) {
    final dateTime = firestoreTimestamp.toDate();
    return DateFormat("dd-MMMM-yyyy / hh:mm a").format(dateTime);
  }

  String parseFirestoreTimestampString(String dateTimeString) {
    // Parse the DateTime from the string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Format DateTime as a string
    String formattedDate = DateFormat('dd-MMMM-yyyy / hh:mm a').format(dateTime);

    return formattedDate;
  }
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat.jm().format(dateTime); // "jm" stands for 12-hour format
  }
  String formatDate(DateTime dateTime) {
    return DateFormat('dd-MMMM-yyyy').format(dateTime);
  }
  String formatNumberWithCommas(double number) {
    String numString = number.toStringAsFixed(2); // Convert to string with 2 decimal places
    List<String> parts = numString.split('.');

    String wholeNumber = parts[0];
    String decimal = parts.length > 1 ? '.${parts[1]}' : '';

    String result = '';
    int count = 0;
    for (int i = wholeNumber.length - 1; i >= 0; i--) {
      result = wholeNumber[i] + result;
      count++;
      if (count % 3 == 0 && i > 0) {
        result = ',$result';
      }
    }
    return result + decimal;
  }
  bool isDifferenceGreaterThanTwoYears(String dateString) {
    DateTime dateFromDB = DateTime.parse(dateString);
    DateTime currentDate = DateTime.now();
    print('year ${dateFromDB.year}');
    print('date ${dateFromDB.day}');
    print('month ${dateFromDB.month}');

    int diffYears = currentDate.year - dateFromDB.year;
    int diffMonths = currentDate.month - dateFromDB.month;
    int diffDays = currentDate.day - dateFromDB.day;

    if (diffMonths < 0 || (diffMonths == 0 && diffDays < 0)) {
      diffYears--;
    }

    return diffYears >= 2;
  }
}