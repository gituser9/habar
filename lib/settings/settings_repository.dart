import 'package:habar/model/settings.dart';
import 'package:rxdart/subjects.dart';

class SettingsRepo {
  final settingsStream = BehaviorSubject<Settings>();

  void dispose() {
    settingsStream.close();
  }
}
