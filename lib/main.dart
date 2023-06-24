import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';


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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const WelcomeApplication(),
      home: const Main(),
    );
  }
}


class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  bool ledOn = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String device;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text('First Project'),
      ),
      body: Column(
        children: [
          const Text('Click the button'),
          TextButton(
            onPressed: () {
              ledOn = !ledOn;
              int boolString = ledOn ? 1: 0;
              FirebaseDatabase.instance.ref().child('/ESP/').update({'LED': boolString});
              print('clicked');
            },
            child: const Text('çlick me'),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter the name of your device',
            ),
            onSaved: (value){
                device = value!;
                print(device);
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {
                  // Process data.
                  FirebaseDatabase.instance.ref().set({
                    device:{
                      "LED": 0,
                      "brightess": 30,
                      "minutes": 0,
                    }
                  });
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
