import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:map_task/features/map/presentation/cubits/place_cubit/place_cubit.dart';
import 'package:map_task/features/map/presentation/cubits/search_cubit.dart';

import 'package:map_task/features/map/presentation/screens/map_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(PlaceModelAdapter());
  await Hive.openBox<PlaceModel>("placeBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchCubit()),
        BlocProvider(create: (_) => PlaceCubit()..getPlaces()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: const MapSample(),
      ),
    );
  }
}
