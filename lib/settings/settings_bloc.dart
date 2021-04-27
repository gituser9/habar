import 'package:habar/model/settings.dart';
import 'package:habar/settings/settings_repository.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc {
  final _repo = SettingsRepo();
  final settingsStream = BehaviorSubject<Settings>();

  void dispose() {
    settingsStream.close();
    _repo.dispose();
  }
}
