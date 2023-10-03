import 'dart:convert';

import 'package:fluttapp/Models/ChatModel.dart';
import 'package:fluttapp/Models/Conversation.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:http/http.dart' as http;  
  
  
  Future<List<ChatMessage>> fetchMessage(int idChat) async {
  final response = await http
      .get(Uri.parse('http://181.188.191.35:3000/getmessage/'+idChat.toString())); //192.168.14.112
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => ChatMessage.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load campaigns');
  }
}

  Future<int> getLastIdChat() async {
  final response = await http
      .get(Uri.parse('http://181.188.191.35:3000/lastidchat/')); //192.168.14.112
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    var res = jsonResponse[0]['AUTO_INCREMENT'];
    return res;
  } else {
    throw Exception('Failed to load id');
  }
}

  Future<int> getIdPersonByEMail(String correo) async {
  final response = await http
      .get(Uri.parse('http://181.188.191.35:3000/getpersonbyemail/'+correo)); //192.168.14.112
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse[0]['idPerson']);
    var res = jsonResponse[0]['idPerson'];
    return res;
  } else {
    return 0;
  }
}

  Future<void> deleteChat(int idChat) async {
  final response = await http
      .put(Uri.parse('http://181.188.191.35:3000/deletechat/'+idChat.toString())); //192.168.14.112
   if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(response);
  }
}

  Future<int> getIdRolByIdPerson(int id) async {
  final response = await http
      .get(Uri.parse('http://181.188.191.35:3000/getidrol/'+id.toString())); //192.168.14.112
  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse[0]['idRol']);
    var res = jsonResponse[0]['idRol'];
    return res;
  } else {
    return 0;
  }
}


Future<void> registerNewChat(Chat newChat) async {
  // Convertir tu objeto Campaign a JSON.
  final campaignJson = json.encode({
//'idCampañas': newCampaign.id,
    'idPerson': newChat.idPerson,
    'idPersonDestino': newChat.idPersonDestino,
  });
  final response = await http.post(
    Uri.parse('http://181.188.191.35:3000/insertchat'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: campaignJson,
  );
  if (response.statusCode != 200 && response.statusCode != 201) {
    throw Exception(response);
  }
}

  Future<void> sendMessage(int idPerson, String mensaje, int idChat) async {
    final url = 'http://181.188.191.35:3000/sendmessage';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'idPerson': idPerson,
        'mensaje': mensaje,
        'idChat': idChat,
        'Nombres': miembroActual!.names,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar el mensaje');
    }
  }


