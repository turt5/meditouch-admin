import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AppDateTimeFormat{
  String getCurrentFormattedDate() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('EEEE, d MMM');
    return formatter.format(now);
  }

  String getCurrentFormattedDateMY(DateTime now) {
    DateFormat formatter = DateFormat('MMM yyyy');
    return formatter.format(now);
  }


  String formatDateDOB(String date) {
    final DateTime parsedDate = DateTime.parse(date); // Convert String to DateTime
    final DateFormat formatter = DateFormat('MMMM d, yyyy'); // Define date format
    return formatter.format(parsedDate); // Format the parsed DateTime
  }

  String getFormattedTime12h(DateTime dateTime) {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }


  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Unknown time';
    }

    DateTime dateTime = timestamp.toDate(); // Convert Timestamp to DateTime
    // Format the DateTime as desired (e.g., "MM/dd/yyyy, hh:mm a")
    String formattedDate = DateFormat('MMMM dd, yyyy, hh:mm a').format(dateTime);
    return formattedDate;
  }

  String formatTime(String time){
    DateTime dateTime = DateTime.parse(time);
    DateFormat formatter = DateFormat('MMM dd, yyyy hh:mm a');

    return formatter.format(dateTime);
  }

}