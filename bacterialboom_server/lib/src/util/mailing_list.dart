import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

const _endpoint = 'https://us10.api.mailchimp.com/3.0/lists/3d7f127837/members';

Future<bool> addToMailingList(String email, String firstName) async {
  var password = Serverpod.instance!.getPassword('mailchimp');
  var basicAuth = 'Basic ${base64Encode(utf8.encode('anystring:$password'))}';

  var response = await http.post(
    Uri.parse(_endpoint),
    headers: {
      'authorization': basicAuth,
    },
    body: jsonEncode({
      'email_address': email,
      'email_type': 'html',
      'status': 'subscribed',
      'merge_fields': {
        'FNAME': firstName,
      },
      'tags': ['App'],
    }),
  );

  return response.statusCode == 200;
}
