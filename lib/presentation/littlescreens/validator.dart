class ValidadorCampos {
  String? nombre;
  String? apellido;
  String? telefono;
  String? correo;
  String? contrasena;
  String? descripcion;
  
  String? mensajeErrorFechaNacimiento;
  String? mensajeErrorNombre;
  String? mensajeErrorApellido;
  String? mensajeErrorTelefono;
  String? mensajeErrorCorreo;
  String? mensajeErrorContrasena;
  String? mensajeErrorDescripcion; // Nuevo campo para la descripción

  bool validarNombre(String value) {
    if (value.isEmpty) {
      mensajeErrorNombre = 'El nombre es obligatorio.';
      return false;
    } else if (contieneNumeros(value)) {
      mensajeErrorNombre = 'El nombre no puede contener números.';
      return false;
    }
    nombre = value;
    mensajeErrorNombre = null;
    return true;
  }

  bool validarApellido(String value) {
    if (value.isEmpty) {
      mensajeErrorApellido = 'El apellido es obligatorio.';
      return false;
    } else if (contieneNumeros(value)) {
      mensajeErrorApellido = 'El apellido no puede contener números.';
      return false;
    }
    apellido = value;
    mensajeErrorApellido = null;
    return true;
  }

  bool validarTelefono(String value) {
    if (value.isEmpty) {
      mensajeErrorTelefono = 'El teléfono es obligatorio.';
      return false;
    } else if (!contieneSoloNumeros(value)) {
      mensajeErrorTelefono = 'El teléfono solo debe contener números.';
      return false;
    } else if (value.length != 10 || !value.startsWith('6')) {
      mensajeErrorTelefono = 'El teléfono debe tener 10 dígitos y comenzar con 6.';
      return false;
    }
    telefono = value;
    mensajeErrorTelefono = null;
    return true;
  }

  bool validarCorreo(String value) {
    final correoRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!correoRegex.hasMatch(value)) {
      mensajeErrorCorreo = 'El correo electrónico no es válido.';
      return false;
    }
    correo = value;
    mensajeErrorCorreo = null;
    return true;
  }

  bool validarContrasena(String value) {
    if (value.isEmpty) {
      mensajeErrorContrasena = 'La contraseña es obligatoria.';
      return false;
    } else if (value.length < 8) {
      mensajeErrorContrasena = 'La contraseña debe tener al menos 8 caracteres.';
      return false;
    }
    contrasena = value;
    mensajeErrorContrasena = null;
    return true;
  }

  // Función auxiliar para verificar si una cadena contiene solo números
  bool contieneSoloNumeros(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  // Función auxiliar para verificar si una cadena contiene números
  bool contieneNumeros(String value) {
    return RegExp(r'[0-9]').hasMatch(value);
  }
  bool validarFechaNacimiento(DateTime fechaNacimiento) {
    final edadMinima = DateTime.now().subtract(Duration(days: 3650)); // 10 años en días
    if (fechaNacimiento.isAfter(edadMinima)) {
      mensajeErrorFechaNacimiento = 'Debes tener al menos 10 años.';
      return false;
    }
    mensajeErrorFechaNacimiento = null;
    return true;
  }
  bool validarDescripcion(String value) {
    if (value.length > 200) {
      mensajeErrorDescripcion = 'La descripción es demasiado larga.';
      return false;
    }
    descripcion = value;
    mensajeErrorDescripcion = null;
    return true;
  }
}
class ValidadorCamposMascota {
  String? nombreMascota;
  String? descripcionMascota;
  int? edadMascota;
  String? razaMascota;
  String? colorMascota;

  String? mensajeErrorNombreMascota;
  String? mensajeErrorDescripcionMascota;
  String? mensajeErrorEdadMascota;
  String? mensajeErrorRazaMascota;
  String? mensajeErrorColorMascota;

  bool validarNombreMascota(String value) {
    if (value.isEmpty) {
      mensajeErrorNombreMascota = 'El nombre de la mascota es obligatorio.';
      return false;
    }
    nombreMascota = value;
    mensajeErrorNombreMascota = null;
    return true;
  }

  bool validarDescripcionMascota(String value) {
    if (value.isEmpty) {
      mensajeErrorDescripcionMascota = 'La descripción de la mascota es obligatoria.';
      return false;
    } else if (value.length > 200) {
      mensajeErrorDescripcionMascota = 'La descripción es demasiado larga.';
      return false;
    }
    descripcionMascota = value;
    mensajeErrorDescripcionMascota = null;
    return true;
  }

  bool validarEdadMascota(String value) {
    if (value.isEmpty) {
      mensajeErrorEdadMascota = 'La edad de la mascota es obligatoria.';
      return false;
    } else if (!contieneSoloNumeros(value)) {
      mensajeErrorEdadMascota = 'La edad de la mascota solo debe contener números.';
      return false;
    }
    edadMascota = int.tryParse(value);
    if (edadMascota == null || edadMascota! <= 0) {
      mensajeErrorEdadMascota = 'La edad de la mascota debe ser un número válido.';
      return false;
    }
    mensajeErrorEdadMascota = null;
    return true;
  }

  bool validarRazaMascota(String value) {
    if (value.isEmpty) {
      mensajeErrorRazaMascota = 'La raza de la mascota es obligatoria.';
      return false;
    }
    razaMascota = value;
    mensajeErrorRazaMascota = null;
    return true;
  }

  bool validarColorMascota(String value) {
    if (value.isEmpty) {
      mensajeErrorColorMascota = 'El color de la mascota es obligatorio.';
      return false;
    }
    colorMascota = value;
    mensajeErrorColorMascota = null;
    return true;
  }

  // Función auxiliar para verificar si una cadena contiene solo números
  bool contieneSoloNumeros(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }
}