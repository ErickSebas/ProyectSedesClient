# fluttapp

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


En terminal CMD ADMIN:

  keytool -genkey -v -keystore key\keystore.jks ^
          -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^
          -alias sedesdev

contrasena almacen de claves: s3d3s2023

christian montano
sedes
sedes
cochabamba
cochabamba

contransena de claves <sedesdev>
Alamacenado el key/keystore.jks

Resultado:

C:\SEDESAPPS\ProyectSedesClient> keytool -genkey -v -keystore key\keystore.jks ^
¿Más?          -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^
¿Más?          -alias sedesdev
Introduzca la contraseña del almacén de claves:
Volver a escribir la contraseña nueva:
¿Cuáles son su nombre y su apellido?
  [Unknown]:  christian montano
¿Cuál es el nombre de su unidad de organización?
  [Unknown]:  sedes
¿Cuál es el nombre de su organización?
  [Unknown]:  sedes
¿Cuál es el nombre de su ciudad o localidad?
  [Unknown]:  cochabamba
¿Cuál es el nombre de su estado o provincia?
  [Unknown]:  cochabamba
¿Cuál es el código de país de dos letras de la unidad?
  [Unknown]:  BO
¿Es correcto CN=christian montano, OU=sedes, O=sedes, L=cochabamba, ST=cochabamba, C=BO?
  [no]:  si

Generando par de claves RSA de 2.048 bits para certificado autofirmado (SHA256withRSA) con una validez de 10.000 días
        para: CN=christian montano, OU=sedes, O=sedes, L=cochabamba, ST=cochabamba, C=BO
Introduzca la contraseña de clave para <sedesdev>
        (INTRO si es la misma contraseña que la del almacén de claves):
Volver a escribir la contraseña nueva:
[Almacenando key\keystore.jks]

2da*******************************

Crear archivo key.properties en la carpeta android
copiamos el codigo

storePassword=<password-from-previous-step>
keyPassword=<password-from-previous-step>
keyAlias=upload
storeFile=<keystore-file-location>

reemplazamos

storePassword=s3d3s2023
keyPassword=s3d3s2023
keyAlias=sedesdev
storeFile=../../key/keystore.jks

Listo!

*************
Copiar algo de codigo:

En app gradle copiar:

def keystoreProperties = new Properties()
   def keystorePropertiesFile = rootProject.file('key.properties')
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   y tambien esto:

   signingConfigs {
       release {
           keyAlias keystoreProperties['keyAlias']
           keyPassword keystoreProperties['keyPassword']
           storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
           storePassword keystoreProperties['storePassword']
       }
   }
   buildTypes {
       release {
           signingConfig signingConfigs.release
       }
   }


Extra obtener el SHA1 y MD5 **********************

Ahora en la raiz de la app:
keytool -list -v -keystore key\keystore.jks -alias sedesdev
introducir la contrasena entonces:

Resultado:

PS C:\SEDESAPPS\ProyectSedesClient> keytool -list -v -keystore key\keystore.jks -alias sedesdev
Introduzca la contraseña del almacén de claves:  
Nombre de Alias: sedesdev
Fecha de Creación: 23-08-2023
Tipo de Entrada: PrivateKeyEntry
Longitud de la Cadena de Certificado: 1
Certificado[1]:
Propietario: CN=christian montano, OU=sedes, O=sedes, L=cochabamba, ST=cochabamba, C=BO
Emisor: CN=christian montano, OU=sedes, O=sedes, L=cochabamba, ST=cochabamba, C=BO     
Número de serie: 288e6816
Válido desde: Wed Aug 23 21:11:34 BOT 2023 hasta: Sun Jan 08 21:11:34 BOT 2051
Huellas digitales del Certificado:
         MD5: 9E:4A:FC:60:3A:22:D3:1B:4C:03:29:9C:B9:F2:8B:0B
         SHA1: 35:5E:99:ED:81:A4:93:B2:5B:A6:44:0A:6F:0B:78:A1:16:1F:22:30
         SHA256: 24:B8:75:4A:BF:5F:F1:F3:08:F6:13:AF:3D:D5:90:13:29:CA:BD:61:1B:3E:C2:FA:3D:B0:EA:68:FD:B3:CB:DC
         Nombre del Algoritmo de Firma: SHA256withRSA
         Versión: 3

Extensiones:

#1: ObjectId: 2.5.29.14 Criticality=false
SubjectKeyIdentifier [
KeyIdentifier [
0000: B6 DF 50 EC 52 6D A7 C3   EF CC C1 66 75 B6 6A 02  ..P.Rm.....fu.j.
0010: EF 6D E3 62                                        .m.b
]
]
