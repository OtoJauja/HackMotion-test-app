import 'dart:io';

// Model representing a single swing capture loaded from json file
class SwingCapture {
  final String name;
  final Map<String, List<double>> parameters; // Measurement values
  final File sourceFile;

  // Constructor to initialize a SwingCapture manually
  SwingCapture(
      {required this.name, required this.parameters, required this.sourceFile});

  // Factory method to create a SwingCapture from json data
  // json is the parsed json map
  // name is the display name for the swing
  // sourceFile is the file from which the json was loaded
  factory SwingCapture.fromJson(
      Map<String, dynamic> json, String name, File sourceFile) {
    final params = <String, List<double>>{};
    final raw = json['parameters'];
    if (raw is Map<String, dynamic>) {
      raw.forEach((k, v) {
        if (v is Map<String, dynamic> && v['values'] is List) {
          params[k] = List<double>.from(v['values']);
        }
      });
    }
    return SwingCapture(name: name, parameters: params, sourceFile: sourceFile);
  }
}