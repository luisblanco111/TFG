import 'dart:convert';
import 'package:http/http.dart' as http;

String url = "http://virtual.lab.inf.uva.es:20133";

llamada(datos) async{

  http.Response response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(datos));
  return response.body;
}