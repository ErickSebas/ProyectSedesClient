import "package:cloud_firestore/cloud_firestore.dart";

FirebaseFirestore db  = FirebaseFirestore.instance;

Future<List> getLocations() async {
  List locations = [];

  CollectionReference collectionReferenceLocations = db.collection('ubicacion');
  QuerySnapshot queryLocations = await collectionReferenceLocations.get();
  queryLocations.docs.forEach((documento) { 
    locations.add(documento.data());
  });
  return locations;
}