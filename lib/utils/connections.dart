
class Connections {

  static String url = 'http://182.71.107.238:88/api/QCAPI/';
  static String urlNew = 'https://fgapi.ddplapps.com/api/QCAPI/';
  static String url1 = 'https://fgglass.in:93/api/DailyVisitReport/';
  static String customerUrl = "https://fgapi.ddplapps.com/api/CustomerAPI/";

  static String login = url + 'ValidateLogin';
  static String addRoute = urlNew + 'AddRouteTrack';
  static String travelRoute = urlNew + 'TravelRouteTrack?userID=';

  static String addMark = urlNew + 'MarkLocation';
  static String addVisit = urlNew + 'DailyVisit';

  static String geocoding = 'https://maps.googleapis.com/maps/api/geocode/json?key=AIzaSyCkNrbAXPXJ1-PYYSPY5sSCUG_mF4BrXog&latlng=';

  // Constantsflutter
  static String locations = 'locations';
  static String multiLocations = 'multiLocations';
  static String currentAllLocations = 'currentAllLocations';
  static String lastLocationList = 'lastLocationList';
  static String records = 'records';
  static String temp = 'temp';

}