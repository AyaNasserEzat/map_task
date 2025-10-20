import 'package:hive_flutter/adapters.dart';
import 'package:map_task/features/map/data/models/place_model.dart';

class HistoryLocalDataSource {
  final box = Hive.box<PlaceModel>("placeBox");

  Future<void> addPlace(PlaceModel place) async {
    final isExit = box.values.toList().indexWhere((e) => e.name == place.name);
    print("indexxxxx$isExit");
    if (isExit != -1) {
      final key = box.keyAt(isExit);
      await box.delete(key);

    }
    await box.add(place);
    print("lennnnnnnnnnnnnnnnnnnnnnnn places${box.values.toList().length}");
  }

  Future<List<PlaceModel>> getHistory() async {
    return box.values.toList();
  }

  Future<void> deletPlace(int index) async {
     final key = box.keyAt(index);
    await box.delete(key);
  }
}
