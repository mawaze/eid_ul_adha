import 'package:flutter/material.dart';
import '../../../core/constants/app_dimensions.dart';

enum SplashState { idle, animating, done }

class SplashViewModel extends ChangeNotifier {
  SplashState _state = SplashState.idle;
  SplashState get state => _state;

  /// Call once after the widget's [initState] completes.
  Future<void> startSplash() async {
    _state = SplashState.animating;
    notifyListeners();

    await Future.delayed(
      const Duration(milliseconds: AppDimensions.splashDuration),
    );

    _state = SplashState.done;
    notifyListeners();
  }
}
