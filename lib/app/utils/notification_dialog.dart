// import 'dart:convert';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'difenece_colors.dart';
// import 'difenece_text_style.dart';
// import 'start_patrol_popup.dart';
//
// class NotificationDialogService {
//   static bool _isDialogShowing = false;
//
//   static void showNotificationDialog(
//     BuildContext context,
//     RemoteMessage message, {
//     VoidCallback? onAction,
//   }) {
//     if (_isDialogShowing) {
//       return;
//     }
//
//     final title = message.notification?.title?.toLowerCase() ?? '';
//     final body = message.notification?.body?.toLowerCase() ?? '';
//
//     if (title.contains('sos') || title.contains('emergency')) {
//       _showSOSDialog(context, message, onAction: onAction);
//     } else if (title.contains('patrol') && body.contains('start')) {
//       // Show patrol start bottom sheet
//       _isDialogShowing = true;
//       PatrolStartModal.show(context, message);
//       // Reset flag when bottom sheet is closed
//       Future.delayed(const Duration(milliseconds: 500)).then((_) {
//         Navigator.of(context).popUntil((route) => route.isFirst);
//         _isDialogShowing = false;
//       });
//     } else if (title.contains('patrol')) {
//       PatrolStartModal.show(context, message);
//     } else {
//       _showGeneralDialog(context, message, onAction: onAction);
//     }
//   }
//
//   static Map<String, String> extractSosContentParts(String content) {
//     final parts = <String, String>{};
//
//     // Extract guard name and site from the beginning of the message
//     final guardSiteRegex = RegExp(r'^([^a]+)\s+at\s+([^!]+)');
//     final guardSiteMatch = guardSiteRegex.firstMatch(content);
//
//     if (guardSiteMatch != null) {
//       parts['guardName'] = guardSiteMatch.group(1)?.trim() ?? 'Unknown';
//       parts['siteName'] = guardSiteMatch.group(2)?.trim() ?? 'Unknown Site';
//     }
//
//     // Extract Guard Phone
//     final guardPhoneRegex1 = RegExp(r'Guard Phone Number:\s*(\d+)');
//     final guardPhoneRegex2 = RegExp(r'Assigned FO Phone:\s*(\d+)');
//     final guardPhoneRegex3 = RegExp(r'Guard Phone:\s*(\d+)');
//
//     final matches = [
//       guardPhoneRegex1.firstMatch(content),
//       guardPhoneRegex2.firstMatch(content),
//       guardPhoneRegex3.firstMatch(content),
//     ];
//
//     // Get the first non-null match
//     final guardPhoneMatch =
//         matches.firstWhere((match) => match != null, orElse: () => null);
//
//     if (guardPhoneMatch != null) {
//       parts['guardPhone'] = guardPhoneMatch.group(1)!;
//     }
//
//     // Extract Incharge Phone
//     final inchargePhoneRegex1 =
//         RegExp(r'Assigned Incharge Phn Number:\s*(\d+)');
//     final inchargePhoneRegex2 = RegExp(r'In‑Charge Phone:\s*(\d+)');
//     final inchargeMatch1 = inchargePhoneRegex1.firstMatch(content);
//     final inchargeMatch2 = inchargePhoneRegex2.firstMatch(content);
//     if (inchargeMatch1 != null) {
//       parts['inchargePhone'] = inchargeMatch1.group(1)!;
//     } else if (inchargeMatch2 != null) {
//       parts['inchargePhone'] = inchargeMatch2.group(1)!;
//     }
//
//     // Extract Date & Time
//     final dateTimeRegex1 = RegExp(r'Date and Time\s*:\s*([0-9\- :]+)');
//     final dateTimeRegex2 = RegExp(r'Date/Time\s*:\s*([0-9\-:]+)');
//     final dateTimeMatch1 = dateTimeRegex1.firstMatch(content);
//     final dateTimeMatch2 = dateTimeRegex2.firstMatch(content);
//     if (dateTimeMatch1 != null) {
//       parts['datetime'] = dateTimeMatch1.group(1)!;
//     } else if (dateTimeMatch2 != null) {
//       parts['datetime'] = dateTimeMatch2.group(1)!;
//     }
//
//     // Extract location (if available in the message)
//     final locationRegex = RegExp(r'Location[:\s]*([0-9.,\s]+)');
//     final locationMatch = locationRegex.firstMatch(content);
//     if (locationMatch != null) {
//       parts['location'] =
//           locationMatch.group(1)?.trim() ?? 'Location not available';
//     }
//
//     return parts;
//   }
//
//   static void _showSOSDialog(
//     BuildContext context,
//     RemoteMessage message, {
//     VoidCallback? onAction,
//   }) {
//     _isDialogShowing = true;
//
//     // Extract content from the message
//     final content = message.notification?.body ?? '';
//     // final extractedParts = extractSosContentParts(content);
//     // final extractedParts = content;
//     // Decode JSON payload from message.data
//     final Map<String, dynamic> extractedParts = message.data.isNotEmpty
//         ? message.data
//         : jsonDecode(message.notification?.body ?? '{}');
//     final String timeValue = extractedParts['ts'] ?? 'Time not available';
//     DateTime parsed = DateTime.parse(timeValue);
//     // Format to hh:mm AM/PM
//     final formattedTime = DateFormat('hh:mm a').format(parsed);
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.transparent,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: BeveledRectangleBorder(
//             borderRadius: BorderRadius.circular(4),
//             side: BorderSide(color: Colors.grey, width: 1)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.sos,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'SOS Triggered!',
//                 style: DifeneceTextStyle.KH_3_BOLD2.copyWith(
//                   color: Colors.red.shade800,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 Icons.notifications_active,
//                 color: Colors.red,
//                 size: 24,
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Guard Details Section
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.red.shade50,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade100),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (extractedParts['empName'] != null)
//                     _buildDetailRow(
//                         'Guard Name', extractedParts['empName'] ?? 'Unknown'),
//                   if (extractedParts['inchargeName'] != null)
//                     _buildDetailRow('Incharge Name',
//                         extractedParts['inchargeName'] ?? 'Unknown'),
//                   const SizedBox(height: 8),
//                   if (extractedParts['siteName'] != null)
//                     _buildDetailRow('Site Name',
//                         extractedParts['siteName'] ?? 'Unknown Site'),
//                   const SizedBox(height: 8),
//                   _buildDetailRow('Location',
//                       extractedParts['location'] ?? 'Location not available'),
//                   const SizedBox(height: 8),
//                   _buildDetailRow('Time', formattedTime),
//                   const SizedBox(height: 8),
//                   if (extractedParts['guardPhone'] != null)
//                     _buildDetailRow('Guard Phone',
//                         extractedParts['guardPhone'] ?? 'Not available'),
//                   const SizedBox(height: 8),
//                   _buildDetailRow('In-Charge Phone',
//                       extractedParts['inchargePhone'] ?? 'Not available'),
//                   const SizedBox(height: 8),
//                   if (extractedParts['foPhone'] != null)
//                     _buildDetailRow(
//                         'FO Number', extractedParts['foPhone'] ?? 'Unknown'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Action Buttons
//             Container(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: null,
//                 icon: const Icon(Icons.videocam, color: Colors.white),
//                 label: Text(
//                   'View Site Live',
//                   style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                     color: Colors.white,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   foregroundColor: Colors.white,
//                   maximumSize: MediaQuery.of(context).size,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Container(
//               width: double.infinity,
//               child: OutlinedButton.icon(
//                 onPressed: () {
//                   _isDialogShowing = false;
//                   Navigator.of(context).pop();
//                   onAction?.call();
//                   Get.snackbar(
//                     'SOS Alert',
//                     'Opening location tracking...',
//                     backgroundColor: Colors.green,
//                     colorText: Colors.white,
//                     duration: const Duration(seconds: 3),
//                   );
//                 },
//                 icon: Icon(Icons.location_on, color: Colors.blue),
//                 label: Text(
//                   'Track Location',
//                   style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                     color: Colors.blue,
//                   ),
//                 ),
//                 style: OutlinedButton.styleFrom(
//                   foregroundColor: Colors.blue,
//                   side: const BorderSide(color: Colors.blue),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _isDialogShowing = false;
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'Dismiss',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static Widget _buildDetailRow(String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           width: 80,
//           child: Text(
//             label,
//             style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//               color: Colors.grey.shade600,
//               fontSize: 12,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             value,
//             style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//               color: Colors.grey.shade800,
//               fontSize: 12,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   static void _showGeneralDialog(
//     BuildContext context,
//     RemoteMessage message, {
//     VoidCallback? onAction,
//   }) {
//     _isDialogShowing = true;
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.transparent,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.notifications,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'General Notification',
//                 style: DifeneceTextStyle.KH_3_BOLD2.copyWith(
//                   color: Colors.green.shade800,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 Icons.notifications_active,
//                 color: Colors.green,
//                 size: 24,
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               message.notification?.body ?? 'System notification received.',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.grey.shade700,
//                 fontSize: 14,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: Colors.green.shade200),
//               ),
//               child: Row(
//                 children: [
//                   Icon(Icons.info, color: Colors.green, size: 20),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'System maintenance scheduled for tonight at 2 AM. Some services may be temporarily unavailable.',
//                       style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                         color: Colors.green.shade700,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _isDialogShowing = false;
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'Dismiss',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               _isDialogShowing = false;
//               Navigator.of(context).pop();
//               onAction?.call();
//               Get.snackbar(
//                 'Notification',
//                 'Message acknowledged',
//                 backgroundColor: Colors.green,
//                 colorText: Colors.white,
//                 duration: const Duration(seconds: 3),
//               );
//             },
//             child: Text(
//               'OK',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Custom dialog for specific notification types
//   static void showCustomDialog(
//     BuildContext context, {
//     required String title,
//     required String message,
//     required String dialogType, // 'sos', 'patrol', 'general'
//     String? actionText,
//     VoidCallback? onAction,
//   }) {
//     if (_isDialogShowing) {
//       return;
//     }
//
//     _isDialogShowing = true;
//
//     if (dialogType == 'sos') {
//       _showCustomSOSDialog(context, title, message, actionText, onAction);
//     } else if (dialogType == 'patrol') {
//       _showCustomPatrolDialog(context, title, message, actionText, onAction);
//     } else {
//       _showCustomGeneralDialog(context, title, message, actionText, onAction);
//     }
//   }
//
//   static void _showCustomSOSDialog(
//     BuildContext context,
//     String title,
//     String message,
//     String? actionText,
//     VoidCallback? onAction,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.transparent,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.warning,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: DifeneceTextStyle.KH_3_BOLD2.copyWith(
//                   color: Colors.red.shade800,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.red.shade100,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Icon(
//                 Icons.notifications_active,
//                 color: Colors.red,
//                 size: 24,
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Guard Details Section
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.grey.shade200),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildDetailRow('Guard Name', 'John Doe'),
//                   const SizedBox(height: 8),
//                   _buildDetailRow('Site Name', 'Aparna Western Meadows'),
//                   const SizedBox(height: 8),
//                   _buildDetailRow('Location', '17.432812, 78.456781'),
//                   const SizedBox(height: 8),
//                   _buildDetailRow('Time', '25 July 2025, 11:42 AM'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Action Buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       _isDialogShowing = false;
//                       Navigator.of(context).pop();
//                       onAction?.call();
//                       Get.snackbar(
//                         'SOS Alert',
//                         'Opening site live view...',
//                         backgroundColor: Colors.blue,
//                         colorText: Colors.white,
//                         duration: const Duration(seconds: 3),
//                       );
//                     },
//                     icon: const Icon(Icons.videocam, color: Colors.white),
//                     label: Text(
//                       'View Site Live',
//                       style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                         color: Colors.white,
//                       ),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     onPressed: () {
//                       _isDialogShowing = false;
//                       Navigator.of(context).pop();
//                       onAction?.call();
//                       Get.snackbar(
//                         'SOS Alert',
//                         'Opening location tracking...',
//                         backgroundColor: Colors.green,
//                         colorText: Colors.white,
//                         duration: const Duration(seconds: 3),
//                       );
//                     },
//                     icon: Icon(Icons.location_on, color: Colors.blue),
//                     label: Text(
//                       'Track Location',
//                       style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                         color: Colors.blue,
//                       ),
//                     ),
//                     style: OutlinedButton.styleFrom(
//                       foregroundColor: Colors.blue,
//                       side: const BorderSide(color: Colors.blue),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _isDialogShowing = false;
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'Dismiss',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static void _showCustomPatrolDialog(
//     BuildContext context,
//     String title,
//     String message,
//     String? actionText,
//     VoidCallback? onAction,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierColor: Colors.transparent,
//       builder: (context) => AlertDialog(
//         backgroundColor: DifeneceColors.PBlueColor.withOpacity(0.05),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: DifeneceColors.PBlueColor,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.security,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: DifeneceTextStyle.KH_3_BOLD2.copyWith(
//                   color: DifeneceColors.PBlueColor,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           message,
//           style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//             color: Colors.grey.shade700,
//             fontSize: 14,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'Dismiss',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               onAction?.call();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: DifeneceColors.PBlueColor,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               actionText ?? 'View Details',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   static void _showCustomGeneralDialog(
//     BuildContext context,
//     String title,
//     String message,
//     String? actionText,
//     VoidCallback? onAction,
//   ) {
//     showDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierColor: Colors.transparent,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.notifications,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 title,
//                 style: DifeneceTextStyle.KH_3_BOLD2.copyWith(
//                   color: Colors.green.shade700,
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Text(
//           message,
//           style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//             color: Colors.grey.shade600,
//             fontSize: 14,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: Text(
//               'Dismiss',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               onAction?.call();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: Text(
//               actionText ?? 'OK',
//               style: DifeneceTextStyle.KH_3_BOLD.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
