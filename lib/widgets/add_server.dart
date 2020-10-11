import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';

class AddServer extends StatefulWidget {
  @override
  _AddServerState createState() => _AddServerState();
}

class _AddServerState extends State<AddServer> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _address;
  int _port;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServersBloc, ServersState>(
        builder: (context, state) {
      return Card(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                  key: _formKey,
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
                          onSaved: (value) => _address = value,
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
                          onSaved: (value) => _port = int.parse(value),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    BlocProvider.of<ServersBloc>(context)
                                        .add(ServerAddedEvent(_address, _port));
                                  }
                                },
                                child: Text('Submit')))
                      ]))));
    });
  }
}
