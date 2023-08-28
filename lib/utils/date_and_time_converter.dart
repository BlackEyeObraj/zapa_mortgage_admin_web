import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeConverter {
  static Timestamp convertToTimestamp(String firestoreDateTimeString) {
    List<String> parts = firestoreDateTimeString.split(" / ");
    String datePart = parts[0]; // "26-August-2023"
    String timePart = parts[1]; //
    print('date part $datePart');// "7:59 PM"
    print('time part $timePart');// "7:59 PM"

    DateTime parsedDateTime = _parseDateTime(datePart, timePart);

    return Timestamp.fromDate(parsedDateTime);
  }

  static DateTime _parseDateTime(String datePart, String timePart) {
    List<String> dateParts = datePart.split("-");
    int day = int.parse(dateParts[0]);
    String month = dateParts[1];
    int year = int.parse(dateParts[2]);

    List<String> timeParts = timePart.split(" "); // Split time from AM/PM

    // Replace non-breaking space with regular space in the time part
    String time = timeParts[0].replaceAll('\u200B', ''); // Remove non-breaking space
    String meridiem = timeParts[1]; // "PM"

    List<String> timeComponents = time.split(":");
    int hour = int.parse(timeComponents[0]);
    int minute = int.parse(timeComponents[1]);

    if (meridiem == "PM" && hour < 12) {
      hour += 12;
    }

    return DateTime(year, _getMonthNumber(month), day, hour, minute);
  }


  static bool isDateTimeEqualOrFuture(Timestamp timestamp) {
    DateTime currentDateTime = DateTime.now();
    DateTime convertedDateTime = timestamp.toDate();

    return convertedDateTime.isAfter(currentDateTime) || convertedDateTime.isAtSameMomentAs(currentDateTime);
  }
  static int _getMonthNumber(String month) {
    switch (month) {
      case "January":
        return 1;
      case "February":
        return 2;
      case "March":
        return 3;
      case "April":
        return 4;
      case "May":
        return 5;
      case "June":
        return 6;
      case "July":
        return 7;
      case "August":
        return 8;
      case "September":
        return 9;
      case "October":
        return 10;
      case "November":
        return 11;
      case "December":
        return 12;
      default:
        return 1;
    }
  }

// Rest of the code...
}
