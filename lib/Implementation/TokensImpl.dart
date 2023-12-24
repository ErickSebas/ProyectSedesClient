
import 'dart:convert';

import 'package:fluttapp/services/firebase_service.dart';
import 'package:http/http.dart' as http;


  Future<void> tokenClean() async {
    final url = 'http://181.188.191.35:3000/logouttoken';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'token': token,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar el mensaje');
    }
  }