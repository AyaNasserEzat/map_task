
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/features/map/domain/repo/history_repo/history_repo.dart';


class DeletePlaceUseCase {
final HistoryRepo historyRepo;

  DeletePlaceUseCase({required this.historyRepo});
  Future<void> call(int index){
return  historyRepo.deletPlace(index);
  }
}