import 'dart:async';

import 'package:fluttapp/services/firebase_service.dart';
import 'package:fluttapp/services/global_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static StreamController<String> _messageStream = new StreamController.broadcast();
  static Stream<String> get messagesStream=> _messageStream.stream;
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final LocalNotificationService localNotificationService = LocalNotificationService();



  static Future _backgroundHandler( RemoteMessage message )async{
    try{
      print('onBackGround Handler ${message.messageId}');
      var idPerson = message.data['idChat'];
      _messageStream.add(message.notification?.title ?? 'No title');
      print(idPerson);
      print(currentChatId);
      

      if(idPerson.toString()!=currentChatId.toString()){
        CustomNotification customNotification = CustomNotification(
          id: 0, 
          title: message.notification?.title,
          body: message.notification?.body,
        );
        localNotificationService.showNotification(customNotification, idPerson);
      }
    }catch(err){
      throw Exception(err);
    }

  }

  static Future _onMessageHandler(RemoteMessage message) async {
    try{
      print('onMessage Handler ${message.messageId}');
      var idPerson = message.data['idChat'];
      _messageStream.add(message.notification?.title ?? 'No title');
      print(idPerson);
      print(currentChatId);
      

      if(idPerson.toString()!=currentChatId.toString()){
        CustomNotification customNotification = CustomNotification(
          id: 0, 
          title: message.notification?.title,
          body: message.notification?.body,
        );
        localNotificationService.showNotification(customNotification, idPerson);
      }
    }catch(err){
      throw Exception(err);
    }

    
    
}


  static Future _onMessageOpenApp( RemoteMessage message )async{
    try{
      print('onMessageOpenApp Handler ${message.messageId}');
      var idPerson = message.data['idChat'];
      _messageStream.add(message.notification?.title ?? 'No title');
      print(idPerson);
      print(currentChatId);
      

      if(idPerson.toString()!=currentChatId.toString()){
        CustomNotification customNotification = CustomNotification(
          id: 0, 
          title: message.notification?.title,
          body: message.notification?.body,
        );
        localNotificationService.showNotification(customNotification, idPerson);
      }
    }catch(err){
      throw Exception(err);
    }
    
  }

  static Future initializeApp() async {
    token = await FirebaseMessaging.instance.getToken();

    print('token: $token');
    //var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    //var initializationSettingsIOS = DarwinInitializationSettings();
    //var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    //localNotificationsPlugin.initialize(initializationSettings);
    

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);


  }

  static closeStreams(){
    _messageStream.close();
  }
}