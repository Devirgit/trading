import 'package:firebase_analytics/firebase_analytics.dart';

class Logging {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static void error(Map<String, Object?>? parameters) {
    _analytics.logEvent(name: 'error-bloc-event', parameters: parameters);
  }
}
