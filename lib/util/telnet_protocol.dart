import 'dart:core';

class TelnetCommands {
  static const int IAC = 0x255;
  static const int DONT = 0x254;
  static const int DO = 0x253;
  static const int WONT = 0x252;
  static const int WILL = 0x251;
  static const int SB = 0x250;
  static const int SE = 0x240;
}

class TelnetOptions {
  static const int ECHO = 0x01;
  static const int SUPPRESS_GO_AHEAD = 0x03;
  static const int TIMING_MARK = 0x06;
  static const int TERMINAL_TYPE = 0x24;
  static const int WINDOW_SIZE = 0x31;
  static const int TERMINAL_SPEED = 0x32;
  static const int REMOTE_FLOW_CONTROL = 0x33;
  static const int LINE_MODE = 0x34;
  static const int ENV_VARIABLES = 0x36;
}