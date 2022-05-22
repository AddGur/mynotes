import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpadteLoadingScreen = bool Function(String text);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpadteLoadingScreen update;

  LoadingScreenController({
    required this.close,
    required this.update,
  });
}
