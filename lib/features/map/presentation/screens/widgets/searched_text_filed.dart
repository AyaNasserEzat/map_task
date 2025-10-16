import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_task/features/map/presentation/cubits/search_cubit.dart';
import 'package:map_task/funcations/search_places.dart';

class SearchedTextFiled extends StatefulWidget {
  const SearchedTextFiled({super.key});

  @override
  State<SearchedTextFiled> createState() => _SearchedTextFiledState();
}

class _SearchedTextFiledState extends State<SearchedTextFiled> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () {
      if (value.isNotEmpty) {
        context.read<SearchCubit>().searchPlaces(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      onChanged:_onSearchChanged,
      decoration: InputDecoration(
         border: InputBorder.none,
        hintText: "ابحث هنا",
        hintTextDirection: TextDirection.rtl,
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            await search(_controller.text);
          },
        ),
      ),
    );
  }
}
