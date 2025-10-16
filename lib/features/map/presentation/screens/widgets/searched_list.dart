import 'package:flutter/material.dart';

import 'package:nominatim_flutter/model/response/nominatim_response.dart';

class SearchedList extends StatelessWidget {
  const SearchedList({super.key, required this.resList});
final List<NominatimResponse> resList;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      
      itemBuilder: (context, index) {
        
        return InkWell(
          onTap: () {
            
          },
          child: Container(
            width: double.infinity,
            height: 100,
            child: Row(
              children: [
                Text(resList[index].displayName!),
                IconButton(onPressed: (){}, icon: Icon(Icons.search))
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
      itemCount: resList.length,
    );
  }
}
