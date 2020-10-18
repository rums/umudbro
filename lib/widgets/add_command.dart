import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/models/models.dart';

class AddCommand extends StatefulWidget {
  final Command command;
  final bool editing;

  const AddCommand({Key key, this.command, this.editing}) : super(key: key);
  @override
  _AddCommandState createState() => _AddCommandState();
}

class _AddCommandState extends State<AddCommand> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Command get _command => widget.command;
  bool get editing => widget.editing;
  String _name;
  String _commandText;
  List<String> _tags;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            initialValue: editing ? _command.name : '',
            decoration: InputDecoration(
              hintText: 'Enter name',
              labelText: 'Name',
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
            initialValue: editing ? _command.commandText : '',
            decoration: InputDecoration(
              hintText: 'Enter command',
              labelText: 'Command',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (value) => _commandText = value,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Command command = Command.from(
                        _command,
                        name: _name,
                        commandText: _commandText,
                      );
                        BlocProvider.of<CommandsBloc>(context)
                            .add(CommandSaved(command));
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Submit')))
        ],
      ),
    );
  }
}
