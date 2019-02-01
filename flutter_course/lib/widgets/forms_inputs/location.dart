import 'package:flutter/material.dart';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  GoogleMapController mapController;
  final LatLng center = const LatLng(-33.86711, 151.1947171);

  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);

    super.initState();
  }

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  void _updateLocation() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          focusNode: _addressInputFocusNode,
        ),
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: getStaticMap(),
          ),
        ),
      ],
    );
  }

  Widget getStaticMap() {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(-33.852, 151.211),
        zoom: 11.0,
      ),
      onMapCreated: (controller) {
        setState(() {
          mapController = controller;
        });
        mapController.addMarker(
          MarkerOptions(
            position: LatLng(
              center.latitude,
              center.longitude,
            ),
            infoWindowText: InfoWindowText('Marker #1', '*'),
          ),
        );
      },
    );
  }
}
