import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:light_management/screens/connectivity.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "ocL8ltSlCFTLliWSGQyVKHY2eMflRKkbxu7Ho58V",
          appId: "1:594004003725:android:2d68d1762a97c253d4cbc4",
          messagingSenderId: "594004003725",
          projectId: "model-house-iot",
          databaseURL: "https://model-house-iot-default-rtdb.firebaseio.com"
      )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyConnection(),
    );
  }
}