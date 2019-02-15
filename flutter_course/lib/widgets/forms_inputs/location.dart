import 'package:flutter/material.dart';
import 'package:flutter_course/shared/global_config.dart';
import 'package:map_view/map_view.dart';
import '../../models/location_data.dart';
import '../../models/product.dart';
import 'package:location/location.dart' as geoloc;

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class LocationInput extends StatefulWidget {
  final Function setLocation;
  final Product product;

  LocationInput(this.setLocation, this.product);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  Uri _staticMapUri;
  final FocusNode _addressInputFocusNode = FocusNode();
  final TextEditingController _addressInputController = TextEditingController();
  LocationData _locationData;

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    if (widget.product != null) {
      _getStaticMap(widget.product.location.address, geocode: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _getStaticMap(String address,
      {bool geocode = true, double lat, double lng}) async {
    if (address.isEmpty) {
      setState(() {
        _staticMapUri = null;
      });
      widget.setLocation(null);
      return;
    }

    if (geocode) {
      final Uri uri =
          Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
        'address': address,
        'key': apiKey,
      });

      final http.Response response = await http.get(uri);
      final decodedResponse = json.decode(response.body);
      final formattedAddress =
          decodedResponse['results'][0]['formatted_address'];
      final coords = decodedResponse['results'][0]['geometry']['location'];
      _locationData = LocationData(
          address: formattedAddress,
          latitude: coords['lat'],
          longitude: coords['lng']);
    } else if (lat == null && lng == null) {
      _locationData = widget.product.location;
    } else {
      _locationData =
          LocationData(address: address, longitude: lng, latitude: lat);
    }
    if (mounted) {
      final StaticMapProvider staticMapViewProvider = StaticMapProvider(
        apiKey,
      );

      final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
        [
          Marker('position', 'Position', _locationData.latitude,
              _locationData.longitude),
        ],
        center: Location(_locationData.latitude, _locationData.longitude),
        width: 500,
        height: 300,
        maptype: StaticMapViewType.roadmap,
      );

      widget.setLocation(_locationData);

      setState(() {
        _addressInputController.text = _locationData.address;
        _staticMapUri = staticMapUri;
      });
    }
  }

  _getUserLocation() async {
    final geoloc.Location location = geoloc.Location();
    try {
      final currentLocation = await location.getLocation();
      final String address = await _getAddress(
          currentLocation['latitude'], currentLocation['longitude']);

      _getStaticMap(
        address,
        geocode: false,
        lat: currentLocation['latitude'],
        lng: currentLocation['longitude'],
      );
    } catch (error) {
      showDialog(
          context: context,
          builder: (BuildContext contenxt) {
            return AlertDialog(
              title: Text('Could not fetch Location'),
              content: Text('Please add an adddress manually!'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }

  Future<String> _getAddress(double lat, double lng) async {
    final Uri uri = Uri.https('maps.googleapis.com', '/maps/api/geocode/json', {
      'latlng': '${lat.toString()},${lng.toString()}',
      'key': apiKey,
    });
    final http.Response response = await http.get(uri);
    final decodedResponse = json.decode(response.body);
    final formattedAddress = decodedResponse['results'][0]['formatted_address'];
    return formattedAddress;
  }

  void _updateLocation() {
    if (!_addressInputFocusNode.hasFocus) {
      _getStaticMap(_addressInputController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInputFocusNode,
          controller: _addressInputController,
          decoration: InputDecoration(labelText: 'Address'),
          validator: (String value) {
            if (_locationData == null || value.isEmpty) {
              return 'No valida location found.';
            }
          },
        ),
        SizedBox(height: 10.0),
        FlatButton(
          child: Text('Locate User'),
          onPressed: _getUserLocation,
        ),
        SizedBox(
          height: 10.0,
        ),
        _staticMapUri != null
            ? Image.network(_staticMapUri.toString())
            : Container(),
      ],
    );
  }
}
