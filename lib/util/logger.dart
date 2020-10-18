import 'dart:io';

class Logger {

  static const String logDir = "logFiles";

  var outFile;
  IOSink out;
  Logger(String filename) {
    // Create log dir if none exists
    var tmp = Directory.systemTemp;

    var dirs = tmp.listSync();
    if(!dirs.contains(Directory(logDir))) {
      var dir = new Directory(tmp.path + "/" + logDir);
      tmp = dir;
      dir.createSync();
    }
    else {
      tmp = Directory(tmp.path + logDir);
    }

    outFile = new File(tmp.path + "/" + filename);
    out = outFile.openWrite();
  }

  openStream() {
    close();
    out = outFile.openWrite();
  }

  close() {
    out.close();
  }

  logText(data) {
    out.write(data);
    out.flush();
  }

  logBytes(data) {
    out.add(data);
    out.flush();
  }

}