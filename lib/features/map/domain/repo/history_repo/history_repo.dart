import 'package:map_task/features/map/data/models/place_model.dart';

abstract class HistoryRepo {
  Future<void> addPlace(PlaceModel place);
  Future<List<PlaceModel>> getHistory();
  Future<void> deletPlace(int index);
}
