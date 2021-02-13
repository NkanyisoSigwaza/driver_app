

import 'package:driverapp/Requests/GoogleMapsServices.dart';
import 'package:driverapp/Shared/Database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
//import 'package:google_maps_webservice/directions.dart';



// Provider works inside build method. It needs the context in order to work

// instead of using init and init state we are using the provider
class AppState with ChangeNotifier {

  TextEditingController locationController = TextEditingController(); //take users current location
  TextEditingController destinationController = TextEditingController(); //take users current destination
  GoogleMapController _mapController;//provides different information about our map, position as well as where mobile of user is located on the map
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {}; //set is like a map. The only difference is that objects in a set are unique
  final Set<Polyline> _polyLines = {};//lines drawn on map from one point to another to show the route
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();

  // GETTERS
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  GoogleMapController get mapController => _mapController;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polyLines => _polyLines;
  LatLng get initialPosition => _initialPosition;  // getters
  LatLng get lastPosition => _lastPosition;
  BitmapDescriptor icon;


  AppState(){
    _getUserLocation();
    destinationIcon();
  }


  Future sendDriverLocation(String uid)async{
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    await DataBase().loadLocation(position.latitude,position.longitude,uid);
  }
  // TO GET USER'S LOCATION
  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print("__________________________coordinates______________________________________________");
    print(position.latitude);
    print(position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    try {
      List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
          position.latitude, position.longitude);

      locationController.text =
      "${placemark[0].name} ${placemark[0]
          .thoroughfare}"; //converts the position into an address
    }
    catch(e){
      print("nah bro: $e");
    }
    notifyListeners();  //NB Need This line

  }

  // get customers location


// TO CREATE ROUTE
  // Will draw lines on to map
  void _createRoute(String encodedPolly){

    _polyLines.add(
        Polyline(
          polylineId: PolylineId(_lastPosition.toString()),//why lastposition?
          width: 5,
          points: _convertToLatLng(_decodePoly(encodedPolly)),
          color:Colors.blue, // color of route

        )
    );
    notifyListeners();  //NB Need This line

  }

  // ADD A MARKER ON THE MAP
  void _addMarker(LatLng location) {

    _markers.add(
        Marker(
          markerId:MarkerId(_lastPosition.toString()),// where user is currently at
          position: location,
          infoWindow: InfoWindow(    //just adds more info
              title:"Cust",
              snippet:"Customer"
          ),
          icon:BitmapDescriptor.defaultMarker,  // just the default marker icon
        )
    );
    notifyListeners();  //NB Need This line

  }


   destinationIcon() async {

    BitmapDescriptor destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        "Picture/car_icon.png");
       icon = destinationIcon;
  }


  // CREATE A LATLNG LIST
  // This method will convert list of doubles (co ordinate values. problem : googleMaps expects LatLng object) into latlng (google algorithm returns list of doubles)

  List<LatLng> _convertToLatLng(List points){
    List<LatLng> result = <LatLng>[];
    for(int i=0;i<points.length;i++){
      if(i%2 !=0){
        // when i is even
        result.add(LatLng(points[i-1],points[i]));
      }
    }
    return result;
    notifyListeners();  //NB Need This line
  }

  // !DECODE POLY from google (algorithm to convert poly to long lat)
  List _decodePoly(String poly) {
    var list = poly.codeUnits;
    var lList = new List();
    int index = 0;
    int len = poly.length;
    int c = 0;
// repeating until all attributes are decoded
    do {
      var shift = 0;
      int result = 0;

      // for decoding value of one attribute
      do {
        c = list[index] - 63;
        result |= (c & 0x1F) << (shift * 5);
        index++;
        shift++;
      } while (c >= 32);
      /* if value is negetive then bitwise not the value */
      if (result & 1 == 1) {
        result = ~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    } while (index < len);

/*adding to previous value as done in encoding */
    for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];

    print(lList.toString());

    return lList;
  }


  void getAdress(double lat,double long)async{
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(lat, long);
    destinationController.text= "${placemark[0].name} ${placemark[0].thoroughfare}";
    //notifyListeners();  //NB Need This line

  }

  // SEND REQUEST
  // When user types something in destination filed
  void sendRequest(double latitude,double longitude)async{
    //List<Placemark> placemark = await Geolocator().placemarkFromAddress(intendedLocation);
    //double latitude = placemark[0].position.latitude;
    //double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude,longitude);
    _addMarker(destination);

    String route = await _googleMapsServices.getRouteCoordinates(_initialPosition, destination);
    _createRoute(route);
   // notifyListeners();  //NB Need This line





  }
  // ON CAMERA MOVE
  // Can't make private need to access from outside
  void onCameraMove(CameraPosition position) {

    _lastPosition = position.target;//position.target = position where user or device is at, at that specific moment
    notifyListeners();  //NB Need This line

  }

  // ON CREATED
  void onCreated(GoogleMapController controller) {

    _mapController = controller;
    notifyListeners();  //NB Need This line

  }

  void autoComplete(dynamic context)async{
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: "AIzaSyASIYsed8JC-nUwfXfUKXpMoxYykp3KrU4",
        language: "en",
        components: [Component(Component.country,"za")]
    );
    if (p!=null){
      destinationController.text=p.description;
    }
    else{
      destinationController.text = "Invalid Location!";
    }

    notifyListeners();


  }


}