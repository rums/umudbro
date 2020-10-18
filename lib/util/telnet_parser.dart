import 'dart:core';
import 'dart:typed_data';
import 'logger.dart';
import 'dart:collection';
import 'package:tuple/tuple.dart';

class TelnetParser {

  static const bool LOGGER_ENABLE = false;
  static const String TEXT_LOG_FILE = "LogFile_text.txt";
  static const String BYTE_LOG_FILE = "LogFile_byte.txt";

  Logger textLogger;
  Logger byteLogger;
  var commandQueue;

  TelnetParser() {
    textLogger = Logger(TEXT_LOG_FILE);
    byteLogger = Logger(BYTE_LOG_FILE);
    commandQueue = Queue<Tuple3<int, int, int>>();
  }

  // Parse the raw response from the disc server and return raw string to be
  // displayed
  String parse(Uint8List data) {
    if(data.isEmpty) { return ""; }
    filterCommands(data);

    // TODO: Filter telnet protocol commands
    //String toReturn = new String.fromCharCodes(data).trim();


    // parse and remove all non ascii-letter characters
    //toReturn = toReturn.replaceAll(new RegExp("[^\\x00-\\x7F]"), "");
    String toReturn = filterCommands(data);
    textLogger.logText(toReturn);
    return toReturn;
  }

  String filterCommands(Uint8List data) {
    // iterate through the data list looking for telnet commands
    String displayString = "";
    for(var i = 0; i < data.length; i++) {
      if(data[i] >= 240) { // Telnet commands >= 240
        // read the next three bytes
        commandQueue.add(Tuple3(data[i], data[i+1], data[i+2]));
        i += 3;
      }
      else {
        displayString += String.fromCharCode(data[i]);
      }
    }

    textLogger.logText(displayString);
    return displayString;
  }

  String printCommands() {
    String toReturn = "";
    for(var i = 0; i < commandQueue.length; i++) {
      var c1, c2, c3;
      c1 = commandQueue[i].item1;
      c2 = commandQueue[i].item2;
      c3 = commandQueue[i].item3;
      toReturn += "${c1}-${c2}-${c3}\n";
    }
    return toReturn;
  }

}