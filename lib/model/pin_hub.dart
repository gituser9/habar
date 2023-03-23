import 'package:hive/hive.dart';

part 'pin_hub.g.dart';

@HiveType(typeId: 16)
class PinHub {
  @HiveField(0)
  final String alias;

  @HiveField(1)
  final Map<String, dynamic> data;

  PinHub({required this.alias, required this.data});
}
