import 'package:flutter/material.dart';
import 'package:light_management/screens/lights-list.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LightsList()),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.home),
          ),
        ),
      ],
      title: const Text('Lights Management'),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
