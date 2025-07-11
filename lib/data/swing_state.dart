import 'package:hack_motion_test/models/swing_capture.dart';

abstract class SwingState {}

class SwingLoading extends SwingState {}

class SwingLoaded extends SwingState {
  final List<SwingCapture> swings;
  SwingLoaded(this.swings);
}

class SwingError extends SwingState {
  final String message;
  SwingError(this.message);
}