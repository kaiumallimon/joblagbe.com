import 'package:intl/intl.dart';

class DateTimeFormatter {
  String getJobPostedTime(DateTime datetime) {
    Duration difference = DateTime.now().difference(datetime);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} week${(difference.inDays / 7).floor() > 1 ? 's' : ''} ago";
    } else {
      return "${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() > 1 ? 's' : ''} ago";
    }
  }

  String formatJobDeadline(DateTime datetime) {
    Duration difference = datetime.difference(DateTime.now());

    if (difference.inDays < 0) {
      return "Expired";
    } else if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Tomorrow";
    } else {
      return "${difference.inDays} days left";
    }
  }

  String getFormattedCurrentDateTime() {
    // return : Saturday, 25 May 2025
    return DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());
  }
}
