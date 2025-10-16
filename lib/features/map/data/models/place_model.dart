
import 'package:hive/hive.dart';
part 'place_model.g.dart';
@HiveType(typeId: 0)
class PlaceModel extends HiveObject {
  @HiveField(1)
  final String name;
   @HiveField(2)
  final double lat;
   @HiveField(3)
  final double lon;

  PlaceModel({required this.name, required this.lat, required this.lon});

}