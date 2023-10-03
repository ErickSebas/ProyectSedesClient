import 'dart:convert';

import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:fluttapp/Models/Conversation.dart';
import 'package:http/http.dart' as http;



Future<List<Chat>> fetchChats() async {
  final response = await http.get(Uri.parse(
      'http://181.188.191.35:3000/getchats/' +
          miembroActual!.id.toString()));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Chat.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load chats');
  }
}


Future<List<Chat>> fetchChatsClient() async {
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:3000/getchatcliente/' +
          miembroActual!.id.toString()));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => Chat.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load chats');
  }
}


Future<List<dynamic>> fetchNamesPersonDestino(int idPersonDestino) async {
  final response = await http.get(Uri.parse(
      'http://181.188.191.35:3000/getnamespersondestino/' +
          idPersonDestino.toString()));
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse;
  } else {
    throw Exception('Failed to load chats');
  }
}
