
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/features/map/domain/repo/history_repo/history_repo.dart';

class GetPlacesUseCase {
final HistoryRepo historyRepo;

  GetPlacesUseCase({required this.historyRepo});
  Future<List<PlaceModel>> call(){
 return  historyRepo.getHistory();
  }
}