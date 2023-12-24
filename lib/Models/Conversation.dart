

class Chat {
  final int idChats;
  final int? idPerson;
  final int idPersonDestino;
  final DateTime fechaActualizacion;

  Chat(
      {required this.idChats,
      required this.idPerson,
      required this.idPersonDestino,
      required this.fechaActualizacion});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      idChats: json['idChats'],
      idPerson: json['idPerson'],
      idPersonDestino: json['idPersonDestino'],
      fechaActualizacion: DateTime.parse(json['fechaActualizacion']),
    );
  }

  @override
  String toString() {
    return 'ChatMessage(idChats: $idChats, idPerson: $idPerson, idPersonDestino: $idPersonDestino)';
  }
}
