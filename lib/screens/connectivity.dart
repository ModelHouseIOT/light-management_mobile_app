import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:light_management/screens/lights-list.dart';

class MyConnection extends StatefulWidget {
  const MyConnection({Key? key}) : super(key: key);

  @override
  State<MyConnection> createState() => _MyConnectionState();
}

class _MyConnectionState extends State<MyConnection> {
  String connectionStatus = "---";

  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("new connectivity status: $result");
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check Your WiFi Connection"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: checkStatus,
              child: Text('Check Status'),
            ),
            SizedBox(height: 20,),
            Text(connectionStatus, style: TextStyle(fontSize: 18),),
          ],
        ),
      ),
    );
  }

  void checkStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      print("connected to a mobile network");
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LightsList()),
            );
      setState(() {
        connectionStatus = "connected to a mobile network";
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print("connected to a wifi network");
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LightsList()),
            );
      setState(() {
        connectionStatus = "connected to a wifi network";
      });
    }
  }

}
