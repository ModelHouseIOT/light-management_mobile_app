import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:light_management/components/custom-app-bar.dart';
import 'package:light_management/screens/add-light.dart';

import 'device-detail.dart';

class LightsList extends StatefulWidget {
  const LightsList({Key? key}) : super(key: key);

  @override
  State<LightsList> createState() => _LightsListState();
}

class _LightsListState extends State<LightsList> {
  bool ledOn = true;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('/devices/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Column(
        children: [
          StreamBuilder(
            stream: _databaseReference.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data!.snapshot.value != null &&
                  snapshot.data!.snapshot.value is Map) {
                Map<dynamic, dynamic> devices =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

                // Filtrar los dispositivos por room
                Map<String, List<dynamic>> devicesByRoom = {};
                devices.forEach((key, value) {
                  String room = value['room'];
                  if (!devicesByRoom.containsKey(room)) {
                    devicesByRoom[room] = [];
                  }
                  devicesByRoom[room]!.add(value);
                });
                if (devicesByRoom.isEmpty) {
                  return Center(
                    child: Text('No devices found.'),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: devicesByRoom.length,
                    itemBuilder: (context, index) {
                      String room = devicesByRoom.keys.elementAt(index);
                      List<dynamic> roomDevices = devicesByRoom[room]!;
                      // print(devicesByRoom);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              room,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: roomDevices.length,
                            itemBuilder: (context, subIndex) {
                              Map<dynamic, dynamic> device =
                                  roomDevices[subIndex]
                                      as Map<dynamic, dynamic>;
                              String deviceId = device['id'];
                              int ledState = device['LED'] as int? ?? 0;
                              int brightness =
                                  device['brightness'] as int? ?? 0;
                              int minutes = device['minutes'] as int? ?? 0;


                              String brightnessValue = brightness <= 102? 'Low': brightness == 153 ? 'Medium' : 'Hight';
                              String ledStateValue = ledState==1?'On':'Off';

                              return ListTile(
                                title: Text('Device ID: $deviceId'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('LED State: $ledStateValue'),
                                    Text('Brightness: $brightnessValue'),
                                    Text('Minutes: $minutes'),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DeviceDetail(
                                        deviceId: deviceId,
                                        ledState: ledState,
                                        brightness: brightness,
                                        minutes: minutes,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddLight()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}


