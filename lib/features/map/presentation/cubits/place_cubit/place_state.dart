import 'package:map_task/features/map/data/models/place_model.dart';

class PlaceHistoryState {}
class PlaceInit extends PlaceHistoryState{}
class PlaceLodding extends PlaceHistoryState{}
class PlaceLoddedSuccess extends PlaceHistoryState{

  final List<PlaceModel> placeList;

  PlaceLoddedSuccess({required this.placeList});

}
class PlaceHistoryFailuer extends PlaceHistoryState{
  final String errorMessage;

  PlaceHistoryFailuer({required this.errorMessage});
}


class PlaceAddedSucess extends PlaceHistoryState{}
class PlaceDeletedSuccess extends PlaceHistoryState{}