
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/features/map/domain/repo/history_repo/history_repo.dart';

class AddPlaceUseCase {
final HistoryRepo historyRepo;

  AddPlaceUseCase({required this.historyRepo});
  Future<void> call(PlaceModel place){
    
return  historyRepo.addPlace(place);
  }
}