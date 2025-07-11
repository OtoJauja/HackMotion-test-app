import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hack_motion_test/models/swing_capture.dart';
import 'package:path_provider/path_provider.dart';

// Handles loading, deleting, and restoring swing data
class SwingData extends Cubit<List<SwingCapture>> {
  SwingData() : super([]);

  // Loads swing data from local storage and emits the list
  Future<void> loadSwings() async {
  final docsDir = await getApplicationDocumentsDirectory();
  final swingsDir = Directory('${docsDir.path}/swings');

  // If the swings directory doesnt exist emit an empty list
  if (!await swingsDir.exists()) {
    emit([]); // No swings at all
    return;
  }

  // Read all json files from swings directory
  final files = swingsDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.json'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  // Parse the json files into SwingCapture objects
  final captures = <SwingCapture>[];
  for (final file in files) {
    final filename = file.uri.pathSegments.last;
    final swingNumber = filename.split('.').first;
    final raw = await file.readAsString();
    final map = json.decode(raw) as Map<String, dynamic>;
    captures.add(SwingCapture.fromJson(map, 'Swing $swingNumber', file));
  }

  emit(captures);
}
  // Deletes a specific swing file and reloads the list of swings
  Future<void> deleteSwing(SwingCapture swing) async {
    if (await swing.sourceFile.exists()) {
      await swing.sourceFile.delete();
      await loadSwings(); // refresh list after deletion
    }
  }

  // Restores original swing files from assets and reloads them - DEV TOOL
  Future<void> restoreSwings() async {
  final docsDir = await getApplicationDocumentsDirectory();
  final swingsDir = Directory('${docsDir.path}/swings');

  // Remove the swings directory if it exists
  if (await swingsDir.exists()) {
    await swingsDir.delete(recursive: true);
  }
  await swingsDir.create();

  // Copy asset json files into the swings directory
  for (int i = 1; i <= 5; i++) {
    final asset = await rootBundle.loadString('assets/swings/$i.json');
    final file = File('${swingsDir.path}/$i.json');
    await file.writeAsString(asset);
  }

  await loadSwings(); // Load them into the UI
}
}