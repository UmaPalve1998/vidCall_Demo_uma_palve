import 'package:intl/intl.dart';

class DateFormatter {
  String convertToISOFormat(String date) {
    DateTime? parsedDate;
    try {
      parsedDate = DateFormat("dd MMM yyyy").parse(date);
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid date";
    }
    return DateFormat("yyyy-MM-dd").format(parsedDate);
  }

  String convertToDisplayFormat(String date) {
    DateTime? parsedDate;
    try {
      parsedDate = DateFormat("yyyy-MM-dd").parse(date);
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid date";
    }
    return DateFormat("dd-MM-yyyy").format(parsedDate);
  }

  String convertToDisplayDateTimeFormat(String date) {
    // DateTime? parsedDate;
    try {
      final parsedDate = DateTime.parse(date);
      if (date.length > 10) {
        return DateFormat("dd-MM-yyyy hh:mm a").format(parsedDate);
      } else {
        return DateFormat("dd-MM-yyyy").format(parsedDate);
      }
      // parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    } catch (e) {
      print("Error parsing date: $e");
      return "Invalid date";
    }
    // return DateFormat("dd-MM-yyyy hh:mm a").format(parsedDate);
  }

  String formatDate01(String dateString) {
    if (dateString.isNotEmpty) {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy, h:mm a').format(dateTime);
    } else {
      return "-";
    }
  }

  String formatDate03(String dateString, String time) {
    if (dateString.isNotEmpty && time.isNotEmpty) {
      DateTime dateTime = DateTime.parse("${dateString.trim()} ${time.trim()}");
      return DateFormat('dd-MM-yyyy, h:mm a').format(dateTime);
    } else {
      return "-";
    }
  }

  String formatDate02(String dateString) {
    if (dateString == null || dateString.isEmpty) {
      return "--";
    }
    try {
      // Parse the input string into a DateTime object
      DateTime dateTime = DateTime.parse(dateString);

      // Format the DateTime object into the desired format
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      // Return an error message or a default value in case of an exception
      print(e);
      return "Invalid date format";
    }
  }

  // String formatDate02(String dateString) {
  //   DateTime dateTime = DateTime.parse(dateString);
  //   return DateFormat('dd MMM yyyy').format(dateTime);
  // }
  String formatDate023(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  String formatTimeAMPM(String timeRange) {
    // Split the input string into start and end times
    List<String> times = timeRange.split(' - ');

    // Function to format a single time
    String formatSingleTime(String timeString) {
      // Parse the time string into a DateTime object
      List<String> timeParts = timeString.split(':');
      if (timeParts.length >= 3) {
        int hours = int.parse(timeParts[0]);
        int minutes = int.parse(timeParts[1]);
        String period = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12; // Convert to 12-hour format
        hours = hours == 0 ? 12 : hours; // Handle midnight
        return '${hours}:${minutes.toString().padLeft(2, '0')} $period';
      }
      return timeString; // Return original if format is unexpected
    }

    // Format the start and end times
    String formattedStartTime = formatSingleTime(times[0]);
    String formattedEndTime = formatSingleTime(times[1]);

    return '$formattedStartTime - $formattedEndTime';
  }

  String formatTimeAMPMForPatrol(String timeRange) {
    // Split the input string into start and end times
    List<String> times = timeRange.split(' - ');

    // Check if the timeRange contains exactly two parts
    if (times.length != 2) {
      return timeRange; // Return original if the format is incorrect
    }

    // Function to format a single time
    String formatSingleTime(String timeString) {
      // Split timeString by ":"
      List<String> timeParts = timeString.split(':');

      // Check if the timeString is in the correct format
      if (timeParts.length == 2) {
        int hours = int.parse(timeParts[0]);
        int minutes = int.parse(timeParts[1]);

        // Determine AM or PM
        String period = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12; // Convert to 12-hour format
        hours = hours == 0
            ? 12
            : hours; // Handle midnight (00:00 should be 12:00 AM)

        return '${hours}:${minutes.toString().padLeft(2, '0')} $period';
      }

      return timeString; // Return original if the format is unexpected
    }

    // Format the start and end times
    String formattedStartTime = formatSingleTime(times[0].trim());
    String formattedEndTime = formatSingleTime(times[1].trim());

    return '$formattedStartTime - $formattedEndTime';
  }

  String formatTime(String timeString) {
    List<String> timeParts = [];
    if (timeString.isNotEmpty) {
      timeParts = timeString.split(':');
    }
    if (timeParts.length >= 3) {
      int hours = int.parse(timeParts[0]);
      int minutes = int.parse(timeParts[1]);
      String period = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12; // Convert to 12-hour format
      hours = hours == 0 ? 12 : hours; // Handle midnight
      return '${hours}:${minutes.toString().padLeft(2, '0')} $period';
    }
    return timeString; // Return original if format is unexpected
  }

  String formatTime1(String timeString) {
    if (timeString == null || timeString.isEmpty) {
      return "--";
    }
    try {
      DateTime dateTime = DateTime.parse(timeString);
      int hours = dateTime.hour;
      int minutes = dateTime.minute;
      String period = hours >= 12 ? 'PM' : 'AM';
      hours = hours % 12 == 0 ? 12 : hours % 12; // Convert to 12-hour format
      return '$hours:${minutes.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return timeString; // Return original if parsing fails
    }
  }

  String formatDate(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return "--";
    }
    try {
      DateTime dateTime = DateTime.parse(timeString);
      return '${dateTime.day.toString().padLeft(2, '0')}-'
          '${dateTime.month.toString().padLeft(2, '0')}-'
          '${dateTime.year}';
    } catch (e) {
      return "--"; // Return "--" if parsing fails
    }
  }

  String formatHours(String timeString) {
    if (timeString.isNotEmpty) {
      List<String> timeParts = timeString.split(':');
      if (timeParts.length >= 3) {
        return '${timeParts[0]}:${timeParts[1]} Hrs'; // Use hours and minutes
      }
    }
    return timeString ?? ""; // Return original if format is unexpected
  }

  String convertDate2(String inputDate) {
    try {
      // Parse the input date assuming it's in 'dd MMM yyyy' format
      DateTime parsedDate = DateFormat('dd MMM yyyy').parse(inputDate);

      // Format it to 'yyyy-MM-dd' (without time)
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return ""; // Return empty string or handle error
    }
  }

  String convertDateTime(String inputDate) {
    try {
      // Parse the input date assuming it's in 'dd MMM yyyy' format
      String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String parsedDate = DateFormat('hh:mm a').format(
          DateFormat('yyyy-MM-dd HH:mm:ss')
              .parse("${date.trim()} ${inputDate.trim()}"));

      // Format it to 'yyyy-MM-dd' (without time)
      return parsedDate;
    } catch (e) {
      print("Error parsing date: $e");
      return ""; // Return empty string or handle error
    }
  }

  String convertDate(String inputDate) {
    // Parse the input date string
    DateTime parsedDate = DateFormat('dd MMM yyyy').parse(inputDate);

    // Format the DateTime into the desired format
    String formattedDate =
        DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(parsedDate);

    // Add a default time if needed
    DateTime finalDate = DateTime.parse(formattedDate)
        .add(const Duration(hours: 5, minutes: 30));

    return finalDate.toString();
  }

  String convert_DDMMYYYY(String inputDate) {
    String formattedDate = "";
    // Parse the input date string
    if (inputDate != null && inputDate.isNotEmpty) {
      DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(inputDate);

      // Format the DateTime into the desired format
      formattedDate = DateFormat('dd-MMM-yyyy').format(parsedDate);
    }

    // Add a default time if needed
    return formattedDate;
  }

  String convert_DDMMYYYYTime(String inputDate) {
    String formattedDate = "";
    // Parse the input date string
    if (inputDate != null && inputDate.isNotEmpty) {
      DateTime parsedDate = DateFormat('yyyy-MM-ddTHH:mm').parse(inputDate);

      // Format the DateTime into the desired format
      formattedDate = DateFormat('dd-MMM-yyyy HH:mm a').format(parsedDate);
    }

    // Add a default time if needed
    return formattedDate;
  }
}

extension DateTimeExtension on DateTime {
  String format12Hour() {
    return "${hour == 0 ? 12 : hour > 12 ? hour - 12 : hour}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}";
  }
}

int getDayNumber(String day) {
  print("day: $day");
  switch (day.toLowerCase()) {
    case "sunday":
      return 1;
    case "monday":
      return 2;
    case "tuesday":
      return 3;
    case "wednesday":
      return 4;
    case "thursday":
      return 5;
    case "friday":
      return 6;
    case "saturday":
      return 7;
    default:
      return 0;
  }
}
