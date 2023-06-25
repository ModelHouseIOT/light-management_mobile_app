import 'package:flutter/material.dart';
import 'package:light_management/components/custom-app-bar.dart';
import 'package:firebase_database/firebase_database.dart';

class DeviceDetail extends StatefulWidget {
  final String deviceId;
  final int ledState;
  final int brightness;
  final int minutes;
  const DeviceDetail(
      {super.key,
      required this.deviceId,
      required this.ledState,
      required this.brightness,
      required this.minutes});

  @override
  State<DeviceDetail> createState() => _DeviceDetailState();
}

class _DeviceDetailState extends State<DeviceDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'images/light.png', // Ruta de la imagen en los assets
              width: 200,
              fit: BoxFit.cover,
            ),
            SwitchExample(deviceId: widget.deviceId, ledState: widget.ledState,),
          ],
        ),
      ),
    );
  }
}

class SwitchExample extends StatefulWidget {
  final String deviceId;
  final int ledState;
  const SwitchExample({super.key, required this.deviceId, required this.ledState});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  late bool light;
  final databaseRef = FirebaseDatabase.instance.ref();
  String deviceName = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      light = widget.ledState==1? true:false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        setState(() {
          light = value;
          print(light);
        });

        final devicesRef = databaseRef.child('devices');

        devicesRef.onValue.listen((event) {
          final dataSnapshot = event.snapshot;

          if (dataSnapshot.value is Map) {
            final deviceData = dataSnapshot.value as Map<dynamic, dynamic>;
            deviceData.forEach((key, value) {
              if (value is Map && value['id'] == widget.deviceId) {
                if (mounted) {
                  setState(() {
                    deviceName = key.toString();
                  });
                  FirebaseDatabase.instance
                        .ref('/devices')
                        .child('/$deviceName/')
                        .update({'LED': light ? 1 : 0});
                }
              }
            });
          }
        });

        // This is called when the user toggles the switch.
      },
    );
  }
}
