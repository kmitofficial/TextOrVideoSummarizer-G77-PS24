//Make a underprogress screen

import 'package:flutter/material.dart';

class UnderProgress extends StatelessWidget {
  const UnderProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.warning,
              size: 100,
              color: Colors.red,
            ),
            Text(
              'This feature is under progress',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
