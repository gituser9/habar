import 'dart:convert';

import 'package:get/get.dart';
import 'package:habar/common/services/hive_service.dart';
import 'package:habar/model/hub_list.dart';
import 'package:habar/model/pin_hub.dart';

class PinHubService extends GetxService {
  final _hiveService = Get.put(HiveService());
  final _savedHubAliases = <String>{}.obs;

  Future openBox() async {
    await _hiveService.openBoxes('pin_hub');

    final hubs = _hiveService.getAll<PinHub>(_hiveService.pinHubBox);
    _savedHubAliases.value = hubs.map((hub) => hub.alias).toSet();
  }

  RxSet<String> get savedIds => _savedHubAliases;

  bool isSaved(String alias) {
    return _savedHubAliases.contains(alias);
  }

  List<PinHub> getAll() {
    return _hiveService.getAll<PinHub>(_hiveService.pinHubBox);
  }

  HubList getList() {
    var hubList = HubList(pagesCount: 1, hubIds: [], hubRefs: {});
    var pinned = getAll();

    if (pinned.isEmpty) {
      return hubList;
    }

    for (final pin in pinned) {
      String js = json.encode(pin.data);
      var hubRef = HubRef.fromJson(js);

      hubList.hubIds.add(pin.alias);
      hubList.hubRefs[pin.alias] = hubRef;
    }

    return hubList;
  }

  Future save(HubRef hub) async {
    var pin = PinHub(
      alias: hub.alias,
      data: hub.toMap(),
    );

    await _hiveService.save<PinHub>(_hiveService.pinHubBox, pin.alias, pin);
    _savedHubAliases.add(hub.alias);
  }

  Future deleteById(String alias) async {
    await _hiveService.deleteByKey(_hiveService.pinHubBox, alias);
    _savedHubAliases.remove(alias);
  }
}
