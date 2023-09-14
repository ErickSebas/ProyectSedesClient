import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:fluttapp/presentation/screens/Login.dart';
import 'package:fluttapp/presentation/screens/Carnetizador/RegisterPet.dart';
import 'package:fluttapp/presentation/screens/Cliente/HomeClient.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  ValidadorCampos validador = ValidadorCampos();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  DateTime? fechaNacimiento;
  TextEditingController correoController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController repetirContrasenaController = TextEditingController();
  String? mensajeError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/Splash.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/Univallenavbar.png",
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      errorText: validador
                          .mensajeErrorNombre, // Muestra el mensaje de error en rojo
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: apellidoController,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      errorText: validador
                          .mensajeErrorApellido, // Muestra el mensaje de error en rojo
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: fechaNacimientoController,
                    readOnly: true, // Para evitar la edición manual
                    onTap: () {
                      _selectDate(
                          context); // Abre el DatePicker para seleccionar la fecha de nacimiento
                    },
                    decoration: InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      hintText: fechaNacimiento != null
                          ? "${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}" // Formatea la fecha
                          : 'Seleccionar fecha de nacimiento',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  if (validador.mensajeErrorFechaNacimiento != null)
                    Text(
                      validador.mensajeErrorFechaNacimiento!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 10),
                  TextField(
                    controller: correoController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      errorText: validador
                          .mensajeErrorCorreo, // Muestra el mensaje de error en rojo
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    controller: contrasenaController,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      errorText: validador
                          .mensajeErrorContrasena, // Muestra el mensaje de error en rojo
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    controller: repetirContrasenaController,
                    decoration: InputDecoration(
                      labelText: 'Repite Contraseña',
                      errorText: validador.mensajeErrorContrasena,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.lightBlueAccent),
                      ),
                    ),
                  ),
                  // Mostrar mensaje de error general si existe
                  if (mensajeError != null)
                    Text(
                      mensajeError!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: Text(
                          '¿Ya tienes cuenta? Inicia sesión aquí',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      bool camposValidos = validarCampos();
                      if (camposValidos) {
                        await mostrarFinalizar.Mostrar_Finalizados(
                            context, "Registro Con Éxito!");
                        // Agregar aquí la lógica para registrar al usuario
                        Navigator.of(context).pushNamed("/viewClient");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          Color(0xFF5C8ECB), // Cambiar el color del botón aquí
                    ),
                    child: Text('Registrarse'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

// Función para seleccionar la fecha de nacimiento
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        fechaNacimiento = picked;
        fechaNacimientoController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  bool validarCampos() {
    bool nombreValido = validador.validarNombre(nombreController.text);
    bool apellidoValido = validador.validarApellido(apellidoController.text);
    bool correoValido = validador.validarCorreo(correoController.text);
    bool contrasenaValida =
        validador.validarContrasena(contrasenaController.text);
    bool fechaNacimientoValida = fechaNacimiento != null
        ? validador.validarFechaNacimiento(fechaNacimiento!)
        : false; // Verificar fecha de nacimiento
    setState(() {
      validador.mensajeErrorNombre =
          nombreValido ? null : validador.mensajeErrorNombre;
      validador.mensajeErrorApellido =
          apellidoValido ? null : validador.mensajeErrorApellido;
      validador.mensajeErrorCorreo =
          correoValido ? null : validador.mensajeErrorCorreo;
      validador.mensajeErrorContrasena =
          contrasenaValida ? null : validador.mensajeErrorContrasena;
      validador.mensajeErrorContrasena =
          contrasenaValida ? null : validador.mensajeErrorContrasena;
      validador.mensajeErrorFechaNacimiento =
          fechaNacimientoValida ? null : validador.mensajeErrorFechaNacimiento;
    });
    return nombreValido &&
        apellidoValido &&
        correoValido &&
        contrasenaValida &&
        fechaNacimientoValida;
  }
}
