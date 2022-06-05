import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/SupportTicket.dart';
import 'package:shopping_app_ui/OdooApiCall_DataMapping/SupportTicketandResPartner.dart';
import '../colors/Colors.dart';
import '../util/Util.dart';
import 'Styles.dart';

//For demo, we will set this value to const
const double CAMERA_ZOOM=17.0;
const double CAMERA_TILT=0;
const double CAMERA_BEARING=0;


class MapsWidget extends StatefulWidget {
  final SupportTicketResPartner supportticket;
  MapsWidget(this.supportticket, {Key key}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MapsWidgetState();
  }
}

class _MapsWidgetState extends State<MapsWidget> with AutomaticKeepAliveClientMixin, 
      WidgetsBindingObserver,AfterLayoutMixin
{
  BitmapDescriptor siteLocationIcon;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  GoogleMapController _googleMapController;
  Completer<GoogleMapController> _controller = Completer();
  var currentLong;
  var currentLat;

  get initialCameraPosition =>   
    CameraPosition(
    target: LatLng(widget.supportticket.partner_lat , widget.supportticket.partner_long), //this is sigma location
    zoom: CAMERA_ZOOM,
    bearing: CAMERA_BEARING,
    tilt: CAMERA_TILT
  );
  
    
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGeoLocatorPermission();
    print("what is my currentlat"+currentLat.toString());
    print('site lat long: '+ (widget.supportticket.partner_lat.toString()));
    
    //_setCustomMarker();
  }
  @override
  bool get wantKeepAlive => true;

  Future<void> _currentLocation() async {
   final GoogleMapController controller = await _controller.future;
   LocationData currentLocation;
   var location = new Location();
   try {
     currentLocation = await location.getLocation();
     setState(() {
       currentLat = currentLocation.latitude;
       currentLong = currentLocation.longitude;
     });
     } on Exception {
       currentLocation = null;
       }
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }
  void _setCustomMarker()async{
    siteLocationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),'assets/maps_images/purplemarker-site-location.png');
  }
  //to be called inside onMapCreated
  void _setMarkersAndCircles(GoogleMapController controller){
  setState((){
    _markers.add(
      Marker(
        markerId:MarkerId('id-1'),
        position:LatLng(widget.supportticket.partner_lat,widget.supportticket.partner_long), //or can be LatLng(widget.lat,widget.long) 
        //this is Site Lot Lang. should be set inside odoo. If failed to get Lat Lang from odoo, then no need to set circle, and just let the user check in from wherever theyare.  
        infoWindow:InfoWindow(
          title:'Sigma Office',
          snippet:'our office bro',
        ),
        icon: siteLocationIcon,        
      )
    );
    _circles.add(
    Circle(
      circleId: CircleId("circle-1"),
      center: LatLng(widget.supportticket.partner_lat, widget.supportticket.partner_long), //this is approx sigma location // Lat Lng should be called from _setmarkers.
      radius: 500, // 1000 = 1km; radius is meters as in documentation
      strokeWidth: 2,
      //fillColor:Color.fromARGB(248, 233, 219, 248)),
      fillColor: Color.fromARGB(255, 227, 198, 232).withOpacity(0.30))    
    );
  }); 
  

  Location location = new Location();
  //setup a stream subscription so that we can, cancel this on void dispose(), this is the only way  
  StreamSubscription<LocationData> locationSubscription = location.onLocationChanged.listen((LocationData currentLocation) {
    var distance = GeolocatorPlatform.instance.distanceBetween( widget.supportticket.partner_lat, widget.supportticket.partner_long,currentLocation.latitude, currentLocation.longitude);
    //Use current location
    //now check if distance is >= defined radius for circle
    var currentlocationLatstring = currentLocation.latitude;
    var currentlocationLongstring = currentLocation.longitude;
    print("value of current location.latitude: "+currentlocationLatstring.toString());
    print("value of current location.longitude: "+currentlocationLongstring.toString());
      if (distance < 1000){
        print
        ("return true: let this user check in ");
      }else{
        print("return false: do not let this user check in ");
      } 
    }
  );
    
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {

      _googleMapController.setMapStyle("[]");
    }
  }

  @override
  void afterFirstLayout (BuildContext context){
    _setCustomMarker();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); //ifnot mistaken this is so that maps wont return to blank if we tabout, and tab in back to the apps //TODO check its functionalities
    //locationSub
    locationSubscription.cancel();
    super.dispose();
  }
}

  void getGeoLocatorPermission() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    print(permission);
  }
  
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //get current location on load widget,, this is different from getting current location by clicking on it as that fucntion is manual
    //this location is auto start on load widget.
    return Scaffold(
        body: currentLat == null || currentLong == null
          ? Container() 
            : Container(
              width: MediaQuery.of(context).size.width,  // or use fixed size like 200
              height: MediaQuery.of(context).size.height,            
              child: GoogleMap(           
                circles: _circles,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                tiltGesturesEnabled: true,
                compassEnabled: false,
                markers: _markers,
                mapType: MapType.normal,
                zoomControlsEnabled: false,             
                initialCameraPosition: initialCameraPosition,
                //onMapCreated: _onMapCreated,   
                onMapCreated:(GoogleMapController controller){
                  _controller.complete(controller);
                  _setMarkersAndCircles(controller);
                },   
                    
              ),
              
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom:50.0),
              child: FloatingActionButton(
              onPressed: _currentLocation,
              child: Icon(Icons.my_location_outlined,
              color: primaryColor,),
              backgroundColor: Colors.white
              ),
            ),
      
    );
  }
}

  



