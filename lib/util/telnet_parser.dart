import 'dart:core';
import 'dart:typed_data';
import 'logger.dart';

class TelnetParser {

  Logger textLogger;
  Logger byteLogger;

  static const bool LOGGER_ENABLE = false;
  static const String TEXT_LOG_FILE = "LogFile_text.txt";
  static const String BYTE_LOG_FILE = "LogFile_byte.txt";

  TelnetParser() {
    textLogger = Logger(TEXT_LOG_FILE);
    byteLogger = Logger(BYTE_LOG_FILE);
  }

  // Parse the raw response from the disc server and return raw string to be
  // displayed
  String parse(Uint8List data) {
    if(data.isEmpty) { return ""; }

    // TODO: Filter telnet protocol commands
    String toReturn = new String.fromCharCodes(data).trim();


    // parse and remove all non ascii-letter characters
    toReturn = toReturn.replaceAll(new RegExp("[^\\x00-\\x7F]"), "");
    textLogger.logText(toReturn);
    return toReturn;
  }


}