import 'package:hive_flutter/adapters.dart';
import 'package:map_task/features/map/data/models/place_model.dart';

class HistoryLocalDataSource {

final box= Hive.box<PlaceModel>("placeBox");
  Future<void> addPlace(PlaceModel place)async{

await box.add(place);
  }

 Future<List<PlaceModel>> getHistory()async{
    return  box.values.toList();
  }

 Future<void> deletPlace(int index)async{
 
   await box.delete(index);
  }
}