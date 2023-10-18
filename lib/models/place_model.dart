class Place {
  final String placeId;
  final String name;
  final double lat;
  final double lon;
  Place(
      {this.placeId = '',
      this.name = '',
      required this.lat,
      required this.lon});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['place_id'],
      name: json['formatted_address'],
      lat: json['geometery']['location']['lat'],
      lon: json['geometery']['location']['lng'],
    );
  }
}
