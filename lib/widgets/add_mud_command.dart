import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:umudbro/blocs/blocs.dart';
import 'package:umudbro/models/models.dart';

import 'mud_button.dart';

class AddMudCommand extends StatefulWidget {
  final MudCommandSlot slot;
  final bool isUpdate;

  const AddMudCommand({Key key, this.slot, this.isUpdate}) : super(key: key);

  @override
  _AddMudCommandState createState() => _AddMudCommandState();
}

class _AddMudCommandState extends State<AddMudCommand> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  MudCommandSlot get _slot => widget.slot;

  bool get isUpdate => widget.isUpdate;
  String _name;
  String _commandText;
  Color _foregroundColor;
  Color _backgroundColor;
  List<String> _tags;

  Color get backgroundColor =>
      _backgroundColor ?? Color(_slot?.backgroundColorInt ?? 0xFFFFFFFF) ?? Colors.white;

  Color get foregroundColor =>
      _foregroundColor ?? Color(_slot?.foregroundColorInt ?? 0xFF000000) ?? Colors.black;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            initialValue: isUpdate ? _slot?.mudCommand?.name : '',
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
            onChanged: (value) => setState(() =>_name = value),
            onSaved: (value) => _name = value,
          ),
          TextFormField(
            initialValue: isUpdate ? _slot?.mudCommand?.commandText : '',
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
          Row(
            children: <Widget>[
              Column(children: [
                Container(
                  width: 150.0,
                  child: RaisedButton(
                    child: Text("Foreground"),
                    color: foregroundColor,
                    onPressed: () => showMaterialSwatchPicker(
                      context: context,
                      selectedColor: foregroundColor,
                      onChanged: (value) =>
                          setState(() => _foregroundColor = value),
                    ),
                  ),
                ),
                Container(
                  width: 150.0,
                  child: RaisedButton(
                    child: Text("Background"),
                    color: backgroundColor,
                    onPressed: () => showMaterialPalettePicker(
                      context: context,
                      selectedColor: backgroundColor,
                      onChanged: (value) =>
                          setState(() => _backgroundColor = value),
                    ),
                  ),
                ),
              ]),
              Expanded(child: Container()),
              SlotButton(
                disabled: true,
                background: backgroundColor,
                foreground: foregroundColor,
                child: Text(_name ?? _slot?.mudCommand?.name ?? "Click me!"),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      MudCommandSlot command = MudCommandSlot.from(
                        _slot,
                        mudCommand: MudCommand.from(_slot.mudCommand,
                            name: _name, commandText: _commandText),
                        backgroundColor: backgroundColor.value,
                        foregroundColor: foregroundColor.value,
                      );
                      BlocProvider.of<MudCommandsBloc>(context)
                          .add(MudCommandSlotSaved(command));
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Submit')))
        ],
      ),
    );
  }
}
