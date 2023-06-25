import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:light_management/components/custom-app-bar.dart';
import 'package:uuid/uuid.dart';

class AddLight extends StatefulWidget {
  const AddLight({super.key});

  @override
  State<AddLight> createState() => _AddLightState();
}

class _AddLightState extends State<AddLight> {
  var uuid = const Uuid();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _device = '';
  String? _roomType = '';

  final List<String> _roomTypes = [
    'Living Room',
    'Bedroom',
    'Kitchen',
    'Bathroom',
  ];

  @override
  void initState() {
    super.initState();
    _roomType = _roomTypes[0]; // Establecer un valor predeterminado válido
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Add new device", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Device Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) {
                      _device = value!;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                  if (_formKey.currentState!.validate()) {
                    // Process data.
                    _formKey.currentState?.save();
                    FirebaseDatabase.instance.ref('/devices/').update({
                      _device: {
                        "id": uuid.v4(),
                        "LED": 0,
                        "brightness": 102,
                        "minutes": 0,
                        "room": _roomType,
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
                child: const Text('Submit',style: TextStyle(fontSize: 16),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
