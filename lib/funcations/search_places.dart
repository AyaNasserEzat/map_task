
import 'package:map_task/features/map/data/models/place_model.dart';
import 'package:nominatim_flutter/model/request/request.dart';
import 'package:nominatim_flutter/model/response/nominatim_response.dart';
import 'package:nominatim_flutter/nominatim_flutter.dart';
 Future<List<PlaceModel>> search(String query) async {
  final searchRequest = SearchRequest(
    query: query,
    limit: 5,
    addressDetails: true,
    extraTags: true,
    nameDetails: true,
  );

  final searchResult = await NominatimFlutter.instance.search(
    searchRequest: searchRequest,
    language: 'en-US,en;q=0.5',
  );

final List<PlaceModel> resultList=[];

  for (var result in searchResult) {

resultList.add(PlaceModel(name: result.displayName!, lat: double.parse(result.lat!), lon: double.parse(result.lon!)));
  }
  print(resultList[0].name);
return resultList;
}
