import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_task/features/map/data/data_source/history_local_data_source.dart';
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/features/map/data/repo/history_repo_impl.dart';


import 'package:map_task/features/map/domain/use_cases/add_place_use_case.dart';
import 'package:map_task/features/map/domain/use_cases/delete_place_use_case.dart';
import 'package:map_task/features/map/domain/use_cases/get_places_use_case.dart';
import 'package:map_task/features/map/presentation/cubits/place_cubit/place_state.dart';

class PlaceCubit extends Cubit<PlaceHistoryState> {
  PlaceCubit (): super (PlaceInit());

  Future<void> addPlace(PlaceModel place) async {
    AddPlaceUseCase(
      historyRepo: HistoryRepoImpl(
        historyLocalDataSource: HistoryLocalDataSource(),
      ),
    ).call(place);
    
    emit(PlaceAddedSucess());
 await   getPlaces();
  }

  Future<void> deletPlace(int index) async {
    DeletePlaceUseCase(
      historyRepo: HistoryRepoImpl(
        historyLocalDataSource: HistoryLocalDataSource(),
      )
    ).call(index);

    emit(PlaceDeletedSuccess());
         await getPlaces();
    print("dellllllerllllllllllllllllll");
  
  }

  Future<void> getPlaces() async {
    emit(PlaceLodding());
    final listHistory =
        await GetPlacesUseCase(
          historyRepo: HistoryRepoImpl(
            historyLocalDataSource: HistoryLocalDataSource(),
          ),
        ).call();

    emit(PlaceLoddedSuccess(placeList: listHistory));
  }
}
