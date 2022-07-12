

import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class URLS {
  static const String BASE_URL = 'https://tnrd.gov.in/project/webservices_forms/pmay/kvvt_services.php';
}

class ApiService {
  static Future<List<dynamic>?> getEmployees() async {
    // RESPONSE JSON :
    // [{
    //    "id": "1",
    //   "employee_name": "",
    //   "employee_salary": "0",
    //   "employee_age": "0",
    //   "profile_image": ""
    // }]
    final response = await http.get('${URLS.BASE_URL}/employees');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }

  static  getImage(body) async {
    // BODY
    // {
    //   "name": "test",
    //   "age": "23"
    // }

    final response = await http.post('https://tnrd.gov.in/project/webservices_forms/pmay/kvvt_services.php',body: body);
    print( "req"+body.toString());
    print("get response : \n" + utf8.decode(response.bodyBytes));
    print( response);
    print( "response"+response.body.toString());

    if (response.statusCode == 200) {
      print( "response"+response.body.toString());
      print( "response"+json.decode(response.body));

    } else {
    }
  }
  static Future<String> getData(body) async {
    final url = Uri.parse('https://tnrd.gov.in/project/webservices_forms/pmay/kvvt_services.php');
    final headers = {'Content-Type': 'application/json;charset=UTF-8',
      'Charset': 'utf-8'};
    final response = await patch(url, headers: headers, body: json.encode(body));
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');
    return response.body;
  }

}