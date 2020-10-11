import 'package:flutter/material.dart';
import 'dart:io';

Socket socket;

class Terminal extends StatelessWidget {
  Terminal({Key key, this.buffer}) : super(key: key);
  final List<String> buffer;

  @override
  Widget build(BuildContext context) {
          return Text(buffer.join("\n"));
  }
}