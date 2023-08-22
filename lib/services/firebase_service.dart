import "dart:convert";
import 'package:http/http.dart' as http;
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";

FirebaseFirestore db  = FirebaseFirestore.instance;
FirebaseStorage storage  = FirebaseStorage.instance;



Future<List> getByFile() async {

  List locations = [];

  Reference ref = storage.ref().child('ubications.json');

  var dataURL = await ref.getDownloadURL();
  var response = await http.get(Uri.parse(dataURL));

  if (response.statusCode == 200) {
    var jsonList = jsonDecode(response.body) as List;
    locations = jsonList.map((item) => item).toList();
  }
  return locations;

}

 