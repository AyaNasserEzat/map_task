import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_task/features/map/presentation/cubits/search_cubit.dart';
import 'package:map_task/features/map/presentation/cubits/search_state.dart';
import 'package:map_task/funcations/get_location.dart';
import 'package:map_task/features/map/presentation/screens/widgets/search_container.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> completerController =
      Completer<GoogleMapController>();
  Position? position;
  LatLng? currentLatLng;

  static const CameraPosition _initialCamera = CameraPosition(
    target: LatLng(30.0444, 31.2357), // القاهرة كإفتراضي
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    goToCurrentLocation();
  }

  void goToCurrentLocation() async {
    Position? pos = await determinePositionSafely(context);
    if (pos == null) {
      // المستخدم رفض، أو الخدمة مطفية، أو حصل خطأ — متحطيش ماركر ولا تعمل animate
      return;
    }

    // لو جاب الموقع نستخدمه
    final LatLng latLng = LatLng(pos.latitude, pos.longitude);

    final GoogleMapController controller = await completerController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));

    setState(() {
      currentLatLng = latLng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocListener<SearchCubit, SearchState>(
            listener: (context, state) async {
              //             if(state is AddMarkerState){

              // final GoogleMapController controller = await _controller.future;
              // controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
              // }
            },
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  initialCameraPosition: _initialCamera,

                  onMapCreated: (GoogleMapController controller) {
                    if (!completerController.isCompleted) {
                      completerController.complete(controller);
                    }
                  },
                  polylines: BlocProvider.of<SearchCubit>(context).polylines,
                  markers:
                      currentLatLng == null
                          ? {}
                          : BlocProvider.of<SearchCubit>(context).marker,
                );
              },
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: SearchedTextField(
              start: currentLatLng ?? LatLng(30.8773326, -89.1772449),
              controller: completerController,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToCurrentLocation,
        child:
            currentLatLng == null
                ? Icon(Icons.location_disabled_sharp)
                : Icon(Icons.location_searching_outlined),
      ),
    );
  }
}
