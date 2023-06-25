import 'package:flutter/material.dart';
import 'package:light_management/components/custom-app-bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:light_management/screens/lights-list.dart';

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
  late bool light;
  final databaseRef = FirebaseDatabase.instance.ref();
  String deviceName = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      light = widget.ledState == 1 ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                'images/light.png', // Ruta de la imagen en los assets
                width: 200,
                fit: BoxFit.cover,
              ),
              Text('deviceID: ${widget.deviceId}'),
              Switch(
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
                      final deviceData =
                          dataSnapshot.value as Map<dynamic, dynamic>;
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
              ),
              InputOptions(
                  deviceId: widget.deviceId,
                  ledState: widget.ledState,
                  brightness: widget.brightness,
                  minutes: widget.minutes),
            ],
          ),
        ),
      ),
    );
  }
}

class InputOptions extends StatefulWidget {
  final String deviceId;
  final int ledState;
  final int brightness;
  final int minutes;
  const InputOptions(
      {super.key,
      required this.deviceId,
      required this.ledState,
      required this.brightness,
      required this.minutes});

  @override
  State<InputOptions> createState() => _InputOptionsState();
}

class _InputOptionsState extends State<InputOptions> {
  final List<String> _roomTypes = [
    'Living Room',
    'Bedroom',
    'Kitchen',
    'Bathroom',
  ];
  String? _roomType = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final databaseRef = FirebaseDatabase.instance.ref();
  String deviceName = '';

  @override
  void initState() {
    super.initState();
    _roomType = _roomTypes[0]; // Establecer un valor predeterminado válido
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _roomType,
            onChanged: (String? newValue) {
              setState(() {
                _roomType = newValue;
              });
            },
            items: _roomTypes.map((roomType) {
              return DropdownMenuItem(
                value: roomType,
                child: Text(roomType),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Room Type',
              border: OutlineInputBorder(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  _formKey.currentState?.save();

                  final devicesRef = databaseRef.child('devices');

                  devicesRef.onValue.listen((event) {
                    final dataSnapshot = event.snapshot;

                    if (dataSnapshot.value is Map) {
                      final deviceData =
                          dataSnapshot.value as Map<dynamic, dynamic>;
                      deviceData.forEach((key, value) {
                        if (value is Map && value['id'] == widget.deviceId) {
                          if (mounted) {
                            setState(() {
                              deviceName = key.toString();
                            });
                            FirebaseDatabase.instance.ref('/devices/').update({
                              deviceName: {
                                "id": widget.deviceId,
                                "LED": widget.ledState,
                                "brightess": widget.brightness,
                                "minutes": widget.minutes,
                                "room": _roomType,
                              }
                            });
                          }
                        }
                      });
                    }
                  });
                  DatabaseReference starCountRef =
                      FirebaseDatabase.instance.ref();
                  starCountRef.onValue.listen((DatabaseEvent event) {
                    final data = event.snapshot.value;
                    print(data);
                  });
                }
              },
              child: const Text(
                'Change room',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final devicesRef = databaseRef.child('devices');

              devicesRef.onValue.listen((event) {
                final dataSnapshot = event.snapshot;

                if (dataSnapshot.value is Map) {
                  final deviceData =
                      dataSnapshot.value as Map<dynamic, dynamic>;
                  deviceData.forEach((key, value) {
                    if (value is Map && value['id'] == widget.deviceId) {
                      if (mounted) {
                        setState(() {
                          deviceName = key.toString();
                        });
                        FirebaseDatabase.instance
                            .ref('/devices')
                            .child('/$deviceName/')
                            .remove();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LightsList()),
                        );
                      }
                    }
                  });
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red, // Establece el color de fondo del botón a rojo
            ),
            child: Text('Remove device'),
          ),
        ],
      ),
    );
  }
}
