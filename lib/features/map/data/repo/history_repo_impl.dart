import 'package:map_task/features/map/data/data_source/history_local_data_source.dart';
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/features/map/domain/repo/history_repo/history_repo.dart';

class HistoryRepoImpl extends HistoryRepo{
 final HistoryLocalDataSource historyLocalDataSource;

  HistoryRepoImpl({required this.historyLocalDataSource});
  @override
  Future<void> addPlace(PlaceModel place)async {
await historyLocalDataSource.addPlace(place);
  }

  @override
  Future<void> deletPlace(int index)async {
await historyLocalDataSource.deletPlace(index);
  }

  @override
  Future<List<PlaceModel>> getHistory() async{
 return await historyLocalDataSource.getHistory();
  }
}