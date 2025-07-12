import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? selectedLocation;
  String? address;

  Future<void> _getAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        setState(() {
          address =
              "${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}";
        });
      }
    } catch (e) {
      setState(() => address = "Gagal mendapatkan alamat");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-6.200000, 106.816666), // Jakarta
              zoom: 15,
            ),
            onTap: (position) {
              setState(() {
                selectedLocation = position;
                address = null;
              });
              _getAddress(position.latitude, position.longitude);
            },
            markers: selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: selectedLocation!,
                    )
                  }
                : {},
          ),
          if (address != null)
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Card(
                color: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    address!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (selectedLocation != null) {
            Navigator.pop(context, {
              'lat': selectedLocation!.latitude,
              'lng': selectedLocation!.longitude,
              'address': address ?? '',
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Silakan pilih lokasi di peta')),
            );
          }
        },
        icon: const Icon(Icons.check),
        label: const Text('Pilih Lokasi'),
      ),
    );
  }
}
