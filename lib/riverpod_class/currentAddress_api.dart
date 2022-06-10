import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../riverpod_model/address.dart';
import 'currentLocation_api.dart';

//we will create a provider to consume our currentlocationfutureprovider
final currentaddressFutureProvider = FutureProvider<List<Placemark>>((ref) async {
  //we use ref.watch to listen to another provider, and we passed it to the
  //provider that we want to consume Here:currentlocationFutureprovider
  double latitude;
  double longitude;

  final currentlocation = await ref.watch(currentlocationFutureProvider.future);
  latitude = currentlocation.latitude;
  longitude = currentlocation.longitude;
  return fetchCurrentAddress(latitude, longitude);
});

Future<List<Placemark>> fetchCurrentAddress(latitude, longitude) async {
  List <Placemark> placemark = await placemarkFromCoordinates(latitude, longitude);
  return placemark;
}

