import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_project2/notification/notification_badge.dart';
import 'package:firebase_project2/notification/notification_service.dart';
import 'package:firebase_project2/notification/push_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:overlay_support/overlay_support.dart';  // local_notification으로 대체

// message.title  message.body
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() =>  _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  void requestAndRegisterNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();
    await NotificationService().init();   
   
    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;
    
    // 3. On iOs, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
      String? token = await _messaging.getToken();
      print('The token is ' + token!);

      
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        //Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,          
        );
        // Forground 상태에서 Firebase에서 메시지가 들어왔을 때
        // Local Notificaion 실행
        NotificationService().showNotification(
            0,
            'TITLE: ${notification.title}',     // 메시지 중 title과 body를 분리하여 head up에 표시
            'BODY: ${notification.body}',
          );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });
        
        // if (_notificationInfo !=null) {
        //   NotificationService().showNotification(
        //     0,
        //     '새로운 알림이 있습니다.',
        //     '푸시 메시지가 도착했습니다',
        //   );
        // }
          // For displaying the notification as an overlay 오버레이를 이용한 헤드업 알림 (local_notification 없어도 간단하게 알림이 뜸)
          // showSimpleNotification(
          //   Text(_notificationInfo!.title!),
          //   leading: NotificationBadge(totalNotifications:  _totalNotifications),
          //   subtitle: Text(_notificationInfo!.body!),
          //   // background: Colors.white,
          //   background: Colors.cyan.shade700,
          //   duration: Duration(seconds: 2),
          // ) ; 
        
      });
    } else {
      print('user declined or has not accepted permission');
    }
  }

  @override
  void initState() {
    requestAndRegisterNotification();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,      
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
        
      });
    
    });    
    _totalNotifications = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notify'), 
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'App for capturing Firebase Push Notifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16.0),
          NotificationBadge(totalNotifications: _totalNotifications),
          SizedBox(height: 16.0),
          _notificationInfo !=null
                ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TITLE: ${_notificationInfo!.title}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'BODY: ${_notificationInfo!.body}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              )
            ],
          )
                : Container(),
        ],
      )
    );
  }
}