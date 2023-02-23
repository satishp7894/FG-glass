
class TravelRecord {
  TravelRecord({
    required this.userId,
    required this.start,
    required this.end,
    required this.startCoords,
    required this.endCoords,
    required this.distance,
    required this.unit,
    required this.path,
    required this.id,
    required this.dateTime,
    required this.startTime,
    required this.endTime,
  });

  int userId;
  String start;
  String end;
  Locations startCoords;
  Locations endCoords;
  double distance;
  String unit;
  List<Locations> path;
  int id;
  DateTime dateTime;
  DateTime startTime;
  DateTime endTime;

  factory TravelRecord.fromJson(Map<String, dynamic> json) => TravelRecord(
    userId: json["userID"],
    start: json["start"],
    end: json["end"],
    startCoords: Locations.fromJson(json["startCoords"]),
    endCoords: Locations.fromJson(json["endCoords"]),
    distance: json["distance"].toDouble(),
    unit: json["unit"],
    path: List<Locations>.from(json["path"].map((x) => Locations.fromJson(x))),
    id: json["ID"],
    dateTime: DateTime.parse(json["dateTime"]),
    startTime: DateTime.parse(json["startTime"]),
    endTime: DateTime.parse(json["endTime"]),
  );

  Map<String, dynamic> toJson() => {
    "userID": userId,
    "start": start,
    "end": end,
    "startCoords": startCoords.toJson(),
    "endCoords": endCoords.toJson(),
    "distance": distance,
    "unit": unit,
    "path": List<dynamic>.from(path.map((x) => x.toJson())),
    "ID": id,
    "dateTime": dateTime.toIso8601String(),
    "startTime": startTime.toIso8601String(),
    "endTime": endTime.toIso8601String(),
  };
}

class Locations {
  Locations({
     this.lat,
     this.lng,
  });

  double? lat;
  double? lng;

  factory Locations.fromJson(Map<String, dynamic> json) => Locations(
    lat: json["lat"],
    lng: json["lng"],
  );

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
  };
}


