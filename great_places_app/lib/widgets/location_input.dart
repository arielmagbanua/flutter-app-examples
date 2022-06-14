import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/map_screen.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  late String? _previewImageUrl;

  void _showPreview(double? lat, double? lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
      latitude: lat!,
      longitude: lng!,
    );

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();

    _showPreview(locData.latitude, locData.longitude);

    widget.onSelectPlace(
      locData.latitude,
      locData.longitude,
    );
  }

  Future<void> _selectOnMap() async {
    final LatLng? selectedLocation = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation == null) {
      return;
    }

    widget.onSelectPlace(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );

    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  void initState() {
    super.initState();

    _previewImageUrl = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: const Text('Select on Map'),
            ),
          ],
        )
      ],
    );
  }
}
