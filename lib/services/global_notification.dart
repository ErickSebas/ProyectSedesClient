
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class CustomNotification{
  final int id;
  final String? title;
  final String? body;
  
  CustomNotification({ required this.id, required this.title, required this.body});
}

class LocalNotificationService{
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  LocalNotificationService(){
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _initializeNotifications();
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: android,
      
    );

  await localNotificationsPlugin.initialize(
    initializationSettings,
  );


  }

  showNotification(CustomNotification notification, dynamic idChat){
    androidDetails = const AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: "Your description",
      importance: Importance.max,
      icon: 'icon',  
    );

    localNotificationsPlugin.show(notification.id, notification.title, notification.body, 
    NotificationDetails(
      android: androidDetails
    ));
    
  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if(details!=null&&details.didNotificationLaunchApp){
      //_onSelectNotification
    }
  }
/*
  Future<void> _onSelectNotification(String? payload) async {
  if (payload != null) {
    int? idChat = int.tryParse(payload);
    if (idChat != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChatScreenState()),
      );

      // Navega al chat específico
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(
            idChat: idChat,
            nombreChat: 'Soporte',
            idPersonDestino: 0,
          ),
        ),
      );
    }
  }
}*/

}