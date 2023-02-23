
class Connections {

  static String url = 'http://182.71.107.238:88/api/QCAPI/';
  static String url1 = 'https://fgglass.in:93/api/DailyVisitReport/';

  static String login = url + 'ValidateLogin';
  static String addRoute = url + 'AddRouteTrack';
  static String travelRoute = url + 'TravelRouteTrack?userID=';

  static String addMark = url + 'MarkLocation';
  static String addVisit = url1 + 'DailyVisit';

  static String geocoding = 'https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCkNrbAXPXJ1-PYYSPY5sSCUG_mF4BrXog&latlng=';

  // Constantsflutter
  static String locations = 'locations';
  static String multiLocations = 'multiLocations';
  static String currentAllLocations = 'currentAllLocations';
  static String lastLocationList = 'lastLocationList';
  static String records = 'records';
  static String temp = 'temp';

}