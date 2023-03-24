// import 'package:firebase_project2/notification_service.dart';
import 'package:firebase_project2/notification/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_project2/page/myhomepage.dart';
// import 'package:overlay_support/overlay_support.dart';

// 앱이 terminated state 일때 구동하기 위한 세팅
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();                                              // firebase initialize
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);  // - terminated state 세팅
  await NotificationService().init();                                          // notification initialize
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Firebase push notification test',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      );
    
  }
}

// overlay support를 사용하기 위해서 MaterialApp을 OverlaySupport.global()로 감싸줬었으나 필요가 없을듯 하여 제거
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return OverlaySupport.global(
//       child: MaterialApp(
//         title: 'Firebase push notification test',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         debugShowCheckedModeBanner: false,
//         home: const MyHomePage(),
//       ),
//     );
//   }
// }



