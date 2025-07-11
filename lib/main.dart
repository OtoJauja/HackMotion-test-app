import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hack_motion_test/data/swing_data.dart';
import 'package:hack_motion_test/theme.dart';
import 'package:hack_motion_test/pages/home_page.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => SwingData()..loadSwings(),
      child: const SwingInspectorApp(),
    ),
  );
}

class SwingInspectorApp extends StatelessWidget {
  const SwingInspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swing Inspector',
      theme: lightMode,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}