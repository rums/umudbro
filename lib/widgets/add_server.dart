import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/models/models.dart';

class AddServer extends StatefulWidget {
  final bool editing;
  final Server server;

  const AddServer({Key key, this.editing = false, this.server})
      : super(key: key);

  @override
  _AddServerState createState() => _AddServerState();
}

class _AddServerState extends State<AddServer> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;
  String _address;
  int _port;

  bool get isEditing => widget.editing;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServersBloc, ServersState>(
        builder: (context, state) {
          return SimpleDialog(
              children: [Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFormField(
                              initialValue: isEditing ? widget.server.name : '',
                              decoration: const InputDecoration(
                                  hintText: 'Enter name',
                                  labelText: 'Name'
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              onSaved: (value) => _name = value,
                            ),
                            TextFormField(
                              initialValue: isEditing
                                  ? widget.server.address
                                  : '',
                              decoration: const InputDecoration(
                                  hintText: 'Enter server address',
                                  labelText: 'Address *'
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
                              initialValue: isEditing ? widget.server.port
                                  .toString() : '',
                              decoration: const InputDecoration(
                                  hintText: 'Enter server port',
                                  labelText: 'Port *'
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        Server server = Server.from(
                                          widget.server,
                                          name: _name,
                                          address: _address,
                                          port: _port,
                                        );
                                        if (isEditing) {
                                          BlocProvider.of<ServersBloc>(context)
                                              .add(ServerUpdated(server));
                                        }
                                        else {
                                          BlocProvider.of<ServersBloc>(context)
                                              .add(ServerAdded(server));
                                        }
                                        Navigator.pop(context, true);
                                      }
                                    },
                                    child: Text('Submit')))
                          ])))
              ]);
        });
  }
}
