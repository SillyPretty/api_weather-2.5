import 'package:hive_flutter/adapters.dart';

part 'HiveGroup.g.dart';

@HiveType(typeId: 1)
class HiveGroup extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String country;
  @HiveField(2)
  final int temp;
  @HiveField(3)
  final String tempMaxMin;
  @HiveField(4)
  final String weather;
  @HiveField(5)
  final String time;

  HiveGroup({
    required this.name,
    required this.country,
    required this.temp,
    required this.tempMaxMin,
    required this.weather,
    required this.time,
  });
}
