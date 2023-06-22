import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> notificationApiCall(
    String title, String body, String token) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAARTIsSDc:APA91bFw1QbXvXlzMDSHLdN7_IBEd0lZK2bBvzApttUkfKv8QY_TRWnIoIM9nH7GN0_g594_tOZzMNiYZwL9aATHRPPv9ozuvuZ0yMd9omxFCjLsDas8blg3QTlO48emK3Mbgk9WRVor',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          "to": token,
        },
      ),
    );

    return true;
  } catch (e) {
    return false;
  }
}
