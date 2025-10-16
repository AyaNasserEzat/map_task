import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/features/map/presentation/cubits/place_cubit/place_cubit.dart';
import 'package:map_task/features/map/presentation/cubits/place_cubit/place_state.dart';
import 'package:map_task/features/map/presentation/cubits/search_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("سجل البحث "), centerTitle: true,
      backgroundColor: Colors.white,),
      
      body: BlocBuilder<PlaceCubit, PlaceHistoryState>(
        builder: (context, state) {
          return state is PlaceLodding
              ? CircularProgressIndicator()
              : state is PlaceLoddedSuccess
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  itemCount: state.placeList.length,
                  itemBuilder: (context, index) {
                    final PlaceModel place = state.placeList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, place);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8,right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.location_on_outlined),
                             Expanded(
  child: Text(
    place.name,
    softWrap: true,
    overflow: TextOverflow.visible,
    maxLines: 2,
  ),
),
                         
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<PlaceCubit>(
                                    context,
                                  ).deletPlace(index);
                                },
                                child: Icon(Icons.close, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index) { 
                    return Divider();
                   },
                ),
              )
              : Center(child: Text("error"));
        },
      ),
    );
  }
}
