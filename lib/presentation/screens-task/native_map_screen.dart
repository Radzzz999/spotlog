import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NativeMap extends StatefulWidget {
  const NativeMap({super.key});

  @override
  State<NativeMap> createState() => _NativeMapState();
}

class _NativeMapState extends State<NativeMap> {
  final Completer<GoogleMapController> _ctrl = Completer();
  Marker? _pickedMarker;
  String? _pickedAddress;
  CameraPosition? _initialCamera;

  @override
  void initState() {
    super.initState();
    _setupLocation();
  }

  Future<void> _setupLocation() async {
    try {
      final pos = await getPermissions();
      _initialCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 16,
      );

      setState(() {});
    } catch (e) {
      _initialCamera = const CameraPosition(target: LatLng(0, 0), zoom: 2);
      setState(() {});
    }
  }

  Future<Position> getPermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw 'Location service belum aktif';
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
      if (perm == LocationPermission.denied) {
        throw 'Izin lokasi ditolak';
      }
    }

    if (perm == LocationPermission.deniedForever) {
      throw 'Izin lokasi ditolak permanen';
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _onTap(LatLng latlng) async {
    final placemarks = await placemarkFromCoordinates(
      latlng.latitude,
      latlng.longitude,
    );

    final p = placemarks.first;
    final marker = Marker(
      markerId: const MarkerId('picked'),
      position: latlng,
      infoWindow: InfoWindow(
        title: p.name?.isNotEmpty == true ? p.name : 'Lokasi dipilih',
        snippet: '${p.street}, ${p.locality}',
      ),
    );

    final ctrl = await _ctrl.future;
    await ctrl.animateCamera(CameraUpdate.newLatLngZoom(latlng, 16));

    setState(() {
      _pickedMarker = marker;
      _pickedAddress =
          '${p.name}, ${p.street}, ${p.locality}, ${p.country}, ${p.postalCode}';
    });
  }

  void _confirmSelection() {
    Navigator.pop(context, {
      'address': _pickedAddress,
      'latlng': _pickedMarker!.position,
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialCamera == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi')),
      body: GoogleMap(
        initialCameraPosition: _initialCamera!,
        myLocationEnabled: true,
        onMapCreated: (controller) => _ctrl.complete(controller),
        markers: _pickedMarker != null ? {_pickedMarker!} : {},
        onTap: _onTap,
      ),
      floatingActionButton: _pickedAddress != null
          ? FloatingActionButton.extended(
              onPressed: _confirmSelection,
              label: const Text('Pilih Lokasi Ini'),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
