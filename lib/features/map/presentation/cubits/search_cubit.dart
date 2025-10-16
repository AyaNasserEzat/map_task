import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/funcations/search_places.dart';
import 'package:map_task/services/osrm_services.dart';
import 'package:nominatim_flutter/model/response/response.dart';

import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) return;

    emit(SearchLoading());
    try {
      final results = await search(query);
      emit(SearchSuccess(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void clearResults() {
    emit(SearchSuccess([])); // نرجع قائمة فاضية
  }

  Set<Marker> marker = {};
  addMarker(PlaceModel place) async {
    marker={};
    marker.add(
      Marker(
        markerId: MarkerId("marker id"),
        position: LatLng(place.lat, place.lon)
      ),
    );

    emit(AddMarkerState());
    print("mark adeeddddddddddddddddddddddddddddddddd");
  }

  Set<Polyline> polylines = {};
  drowRouts(LatLng start, LatLng end) async {
    OsrmServices osrmServices = OsrmServices();
    final routs = await osrmServices.getRouts(start, end);
    polylines.clear();
    polylines.add(
      Polyline(
        color: Colors.green,
        width: 4,
        polylineId: PolylineId("polylineId"), points: routs),
    );
    emit(AddPolyLineState());
  }

  
}
