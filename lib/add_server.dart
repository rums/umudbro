import 'package:flutter/material.dart';

class AddServer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter server URL',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Enter server port',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(onPressed: () {}, child: Text('Submit')))
        ]));
  }
}
