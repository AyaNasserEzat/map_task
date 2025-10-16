
import 'package:map_task/features/map/data/models/place_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<PlaceModel> results;
  SearchSuccess(this.results);
}
class AddFromSearch extends SearchState {
  final List<PlaceModel> results;
  AddFromSearch(this.results);
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
class AddMarkerState extends SearchState {
  // final Set<Marker> marker;

  // AddMarkerState({required this.marker});

}
class AddPolyLineState extends SearchState {

}

