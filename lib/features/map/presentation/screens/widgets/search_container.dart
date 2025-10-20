import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/features/map/presentation/cubits/place_cubit/place_cubit.dart';
import 'package:map_task/features/map/presentation/cubits/search_cubit.dart';
import 'package:map_task/features/map/presentation/cubits/search_state.dart';
import 'package:map_task/features/map/presentation/screens/history_screen.dart';


class SearchedTextField extends StatefulWidget {
  const SearchedTextField({super.key, required this.start, this.controller});
  final LatLng start;
  final controller;
  @override
  State<SearchedTextField> createState() => _SearchedTextFieldState();
}

class _SearchedTextFieldState extends State<SearchedTextField> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  animatToSeaarchedPlace(PlaceModel place, controller) async {
    final GoogleMapController googleMapController = await controller.future;

    googleMapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(place.lat, place.lon), 10),
    );
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (value.isEmpty) {
        // لو المستخدم مسح الكتابة، نمسح النتائج
        context.read<SearchCubit>().clearResults();
      } else {
        context.read<SearchCubit>().searchPlaces(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: .2, color: Colors.black26)],
          ),
          child: TextFormField(
            textDirection: TextDirection.rtl,
            controller: _controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "ابحث هنا",
              hintTextDirection: TextDirection.rtl,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.location_history,
                  color: Colors.blueAccent,
                ),
                onPressed: () async {
                  final PlaceModel? res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HistoryScreen();
                      },
                    ),
                  );
                  if (res != null) {
                    context.read<SearchCubit>().addMarker(res);
                    animatToSeaarchedPlace(res, widget.controller);
                    context.read<SearchCubit>().drowRouts(
                      widget.start,
                      LatLng(res.lat, res.lon),
                    );
                  }
                },
              ),
            ),
            onChanged: _onSearchChanged,
          ),
        ),

        const SizedBox(height: 10),

        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchSuccess) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final place = state.results[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        _controller.clear();
                        context.read<PlaceCubit>().addPlace(
                          PlaceModel(
                            name: place.name,
                            lat: place.lat,
                            lon: place.lon,
                          ),
                        );
                       
                        

                        context.read<SearchCubit>().clearResults();
                        context.read<SearchCubit>().addMarker(place);
                        animatToSeaarchedPlace(place, widget.controller);
                        context.read<SearchCubit>().drowRouts(
                          widget.start,
                          LatLng(place.lat, place.lon),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(blurRadius: .2, color: Colors.black26),
                          ],
                        ),
                        child: ListTile(
                          title: Text(place.name),
                          leading: const Icon(Icons.place, color: Colors.teal),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is SearchError) {
              return Text(
                "حصل خطأ: ${state.message}",
                style: const TextStyle(color: Colors.red),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
