import 'dart:convert';
import 'package:fluttapp/Models/Profile.dart';
import 'package:fluttapp/presentation/littlescreens/validator.dart';
import 'package:fluttapp/presentation/screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ActualizarCliente extends StatefulWidget {
  final Member? datosClient;

  ActualizarCliente({required this.datosClient});

  @override
  _ActualizarClienteState createState() => _ActualizarClienteState();
}

class _ActualizarClienteState extends State<ActualizarCliente> {
  ValidadorCampos validador = ValidadorCampos();
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  DateTime? fechaNacimiento;
  TextEditingController correoController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController carnetController = TextEditingController();
  String? mensajeError;

  @override
  void initState() {
    super.initState();

    // Poblar los controladores con los datos del cliente
    nombreController.text = widget.datosClient?.names ?? '';
    apellidoController.text = widget.datosClient?.lastnames ?? '';
    correoController.text = widget.datosClient?.correo ?? '';
    fechaNacimientoController.text =
        widget.datosClient?.fechaNacimiento?.toString() ?? '';
    telefonoController.text = widget.datosClient?.telefono?.toString() ?? '';
    carnetController.text = widget.datosClient?.carnet?.toString() ?? '';
  }
Future<void> updatePerson(Member updatedPerson) async {
  final url = Uri.parse('http://192.168.100.8:3000/updatepersona/${updatedPerson.id}');

  final response = await http.put(
    url,
    body: jsonEncode({
      'id': updatedPerson.id,
      'Nombres': updatedPerson.names,
      'Apellidos': updatedPerson.lastnames,
      'FechaNacimiento': updatedPerson.fechaNacimiento.toIso8601String(),
      'Carnet': updatedPerson.carnet,
      'Telefono': updatedPerson.telefono,
      'IdRol': updatedPerson.role,// Aquí debes mapear el valor de `updatedPerson.role` a la correspondiente idRolSeleccionada, similar a lo que hace tu compañero en su método.
      'Latitud': updatedPerson.latitud,
      'Longitud': updatedPerson.longitud,
      'Correo': updatedPerson.correo,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    // Actualización exitosa
    print('Actualización exitosa');
  } else {
    // Error en la actualización
    print('Error en la actualización: ${response.statusCode}');
    throw Exception('Error al actualizar la persona');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/Splash.png'),
              fit: BoxFit.cover,
            ),
          ),
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
                    errorText: validador.mensajeErrorNombre,
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
                    errorText: validador.mensajeErrorApellido,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: fechaNacimientoController,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    labelText: 'Fecha de nacimiento',
                    hintText: fechaNacimiento != null
                        ? "${fechaNacimiento!.day}/${fechaNacimiento!.month}/${fechaNacimiento!.year}"
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
                    errorText: validador.mensajeErrorCorreo,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: telefonoController,
                  decoration: InputDecoration(
                    labelText: 'Telefono',
                    errorText: validador.mensajeErrorTelefono,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: carnetController,
                  decoration: InputDecoration(
                    labelText: 'Carnet',
                    errorText: validador.mensajeErrorTelefono,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.lightBlueAccent),
                    ),
                  ),
                ),
                if (mensajeError != null)
                  Text(
                    mensajeError!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
ElevatedButton(
  onPressed: () async {
    bool camposValidos = validarCampos();
    if (camposValidos) {
      // Crear una instancia de Member con los datos actualizados
      Member updatedMember = Member(
        id: widget.datosClient!.id,
        names: nombreController.text,
        lastnames: apellidoController.text,
        fechaNacimiento: fechaNacimiento!,
        correo: correoController.text,
        contrasena: widget.datosClient!.contrasena, 
        telefono: int.parse(telefonoController.text),
        carnet: carnetController.text,
        latitud: widget.datosClient!.latitud,
        longitud: widget.datosClient!.longitud,
        fechaCreacion: widget.datosClient!.fechaCreacion,
        status: widget.datosClient!.status,
        role: widget.datosClient!.role,
      );

      // Llamar a la función para actualizar el cliente
      await updatePerson(updatedMember);

      // Mostrar un mensaje de éxito o realizar otras acciones después de la actualización
      await mostrarFinalizar.Mostrar_Finalizados(
        context, "Actualizado con Éxito!",
      );

      // Redirigir a la pantalla de vista de cliente u otras acciones según tus necesidades
      Navigator.of(context).pushNamed("/viewClient");
    }
  },
  style: ElevatedButton.styleFrom(
    primary: Color(0xFF5C8ECB),
  ),
  child: Text('Actualizar Datos'),
),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamed("/viewClient");
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF5C8ECB),
                  ),
                  child: Text('Cancelar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
    bool telefonoValido = validador.validarTelefono(telefonoController.text);
    bool carnetValido = validador.validarTelefono(carnetController.text);
    bool fechaNacimientoValida = fechaNacimiento != null
        ? validador.validarFechaNacimiento(fechaNacimiento!)
        : false;

    setState(() {
      validador.mensajeErrorNombre =
          nombreValido ? null : validador.mensajeErrorNombre;
      validador.mensajeErrorApellido =
          apellidoValido ? null : validador.mensajeErrorApellido;
      validador.mensajeErrorCorreo =
          correoValido ? null : validador.mensajeErrorCorreo;
      validador.mensajeErrorTelefono =
          telefonoValido ? null : validador.mensajeErrorTelefono;
      validador.mensajeErrorTelefono = carnetValido
          ? null
          : validador.mensajeErrorTelefono; // Reemplazado por validarCarnet
      validador.mensajeErrorFechaNacimiento =
          fechaNacimientoValida ? null : validador.mensajeErrorFechaNacimiento;
    });

    return nombreValido &&
        apellidoValido &&
        correoValido &&
        telefonoValido &&
        carnetValido && // Agregado carnetValido
        fechaNacimientoValida;
  }
}
