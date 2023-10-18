import 'package:tiffin_express_app/models/place_model.dart';

import '../../models/place_autocomplete_model.dart';

abstract class BasePlacesRepository {
  Future<List<PlaceAutocomplete>?> getAutocomplete(String searchInput);

  Future<Place?> getPlace(String placeId) async {}
}
