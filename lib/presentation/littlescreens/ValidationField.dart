import 'package:flutter/material.dart';

class ValidationPage extends StatefulWidget {
  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Ingrese un correo electrónico';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Ingrese una contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  String? _validateName(String value) {
    if (value.isEmpty) {
      return 'Ingrese su nombre';
    }
    return null;
  }

  String? _validateLastName(String value) {
    if (value.isEmpty) {
      return 'Ingrese su apellido';
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  } 
}
