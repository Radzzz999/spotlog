import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:spotlog/logic/task-worker/models/task_worker_model.dart';

class TaskDetailScreen extends StatefulWidget {
  final WorkerTaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  String _address = 'Loading address...';

  @override
  void initState() {
    super.initState();
    _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    if (widget.task.latitude != null && widget.task.longitude != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.task.latitude!,
          widget.task.longitude!,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _address =
                '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
          });
        } else {
          setState(() {
            _address = 'Address not found';
          });
        }
      } catch (e) {
        setState(() {
          _address = 'Failed to get address';
        });
      }
    } else {
      setState(() {
        _address = 'No location provided';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng taskPosition = LatLng(
      widget.task.latitude ?? 0.0,
      widget.task.longitude ?? 0.0,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Task Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${widget.task.title}', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Description: ${widget.task.description ?? "No description"}'),
            const SizedBox(height: 20),

            // Google Maps View (mini)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: taskPosition,
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('task_location'),
                    position: taskPosition,
                  )
                },
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
              ),
            ),

            const SizedBox(height: 12),
            const Text('Address:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_address, style: TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
