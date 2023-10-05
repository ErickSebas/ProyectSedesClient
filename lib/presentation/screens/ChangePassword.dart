import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/ProfilePage.dart';
import 'package:fluttapp/presentation/screens/Login.dart';
import 'package:fluttapp/presentation/services/services_firebase.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangePasswordPage extends StatefulWidget {
  final Member? member;

  ChangePasswordPage({this.member});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  String _code = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isValidCode = false;

  @override
  void initState() {
    super.initState();
  }

  String calculateMD5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void _validate() async {
    // Verificar si todos los campos están llenos
    if (_code.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingrese todos los dígitos del código.'),
        ),
      );
      return;
    }

    // Realizar una solicitud HTTP para validar el código
    final isValid = await validate(_code, widget.member?.id ?? 0);

    if (isValid) {
      // El código es válido, habilitar los campos de contraseña y repetir contraseña
      setState(() {
        _isValidCode = true;
      });
    } else {
      // El código no es válido, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('El código no es válido. Por favor, inténtelo de nuevo.'),
        ),
      );
    }
  }

  Future<bool> validate(String code, int userId) async {
    final url = Uri.parse(
        'http://10.253.1.91:3000/validateCode?userId=$userId&code=$code');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success']; // Debe devolver true si el código es válido
    } else {
      throw Exception('Error al validar el código OTP');
    }
  }

  Future<bool> changePassword(int userId, String newPassword) async {
    final url = Uri.parse('http://10.253.1.91:3000/changePassword');

    final response = await http.put(
      url,
      body: json.encode({
        'userId': userId,
        'newPassword': newPassword,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data[
          'success']; // Debe devolver true si la contraseña se cambió con éxito
    } else {
      throw Exception('Error al cambiar la contraseña');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4D6596),
        centerTitle: true,
        title: Text('Cambiar Contraseña'),
        leading: isLogin == 0
            ? Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfilePage(member: widget.member, carnetizadorMember: null,),
                      ),
                    );
                  },
                ),
              )
            : Container(),
      ),
      body: Container(
        color: Color(0xFF4D6596),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              PinCodeTextField(
                appContext: context,
                length: 5,
                onChanged: (value) {
                  setState(() {
                    _code = value;
                  });
                },
                onCompleted: (value) {
                  // Callback cuando se completa la entrada del código
                  // Puedes agregar lógica aquí
                },
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  borderWidth: 2,
                  activeFillColor: Colors.transparent,
                  inactiveFillColor: Colors.transparent,
                  selectedFillColor: Colors.transparent,
                ),
                cursorColor: Colors.white,
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                enableActiveFill: true,
              ),
              SizedBox(height: 16),
              _isValidCode
                  ? Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onChanged: (value) => _password = value,
                          validator: (value) =>
                              value!.isEmpty ? 'Campo requerido' : null,
                          obscureText: true,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            labelStyle:
                                TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          onChanged: (value) => _confirmPassword = value,
                          validator: (value) {
                            if (value!.isEmpty) return 'Campo requerido';
                            if (value != _password)
                              return 'Las contraseñas no coinciden';
                            return null;
                          },
                          obscureText: true,
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _isValidCode
                        ? () async {
                            // Verificar si las contraseñas coinciden
                            if (_password != _confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Las contraseñas no coinciden.'),
                                ),
                              );
                              return;
                            }

                            // Calcular el hash MD5 de la contraseña
                            final md5Password = calculateMD5(_password);

                            // Cambiar la contraseña
                            final isChanged = await changePassword(
                                widget.member?.id ?? 0, md5Password);
                            if (isChanged) {
                              if (isLogin == 0) {
                                // Navegar a Login.dart si isLogin es 1
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                      member: widget.member, carnetizadorMember: null,
                                    ),
                                  ),
                                );
                              } else {
                                // Navegar a otra página si isLogin no es 1
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LoginPage(), // Reemplaza con tu página deseada
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Error al cambiar la contraseña.'),
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text('Guardar'),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF1A2946),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isLogin == 0) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(member: widget.member, carnetizadorMember: null,),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      }
                    },
                    child: Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isValidCode ? null : _validate,
                    child: Text('Validar Código'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
