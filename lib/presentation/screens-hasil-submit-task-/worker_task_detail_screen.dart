import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../logic/task-worker/models/task_worker_model.dart';
import '../../logic/log-worker/models/log_model.dart';

class WorkerTaskDetailScreen extends StatefulWidget {
  final WorkerTaskModel task;
  final LogModel? log;

  const WorkerTaskDetailScreen({super.key, required this.task, this.log});

  @override
  State<WorkerTaskDetailScreen> createState() => _WorkerTaskDetailScreenState();
}

class _WorkerTaskDetailScreenState extends State<WorkerTaskDetailScreen> {
  String _logAddress = 'Memuat alamat...';

  @override
  void initState() {
    super.initState();
    _getLogAddress();
  }

  Future<void> _getLogAddress() async {
    if (widget.log?.latitude != null && widget.log?.longitude != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          widget.log!.latitude!,
          widget.log!.longitude!,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _logAddress =
                '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
          });
        } else {
          setState(() {
            _logAddress = 'Alamat tidak ditemukan';
          });
        }
      } catch (e) {
        setState(() {
          _logAddress = 'Gagal memuat alamat';
        });
      }
    } else {
      setState(() {
        _logAddress = 'Tidak ada koordinat log';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas & Log')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📌 Judul Tugas: ${task.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('📝 Deskripsi: ${task.description ?? "-"}'),

            const SizedBox(height: 16),
            if (task.latitude != null && task.longitude != null) ...[
              const Text('📍 Lokasi Tugas di Peta:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(task.latitude!, task.longitude!),
                    zoom: 15,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('task_location'),
                      position: LatLng(task.latitude!, task.longitude!),
                      infoWindow: const InfoWindow(title: 'Lokasi Tugas'),
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
            ],

            const SizedBox(height: 24),
            const Divider(),
            const Text('📄 Log Anda:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            if (log != null) ...[
              const SizedBox(height: 8),
              Text('📝 Deskripsi Log: ${log.description}'),
              Text('⏳ Status: ${log.status}'),

              if (log.latitude != null && log.longitude != null) ...[
                const SizedBox(height: 16),
                const Text('🗺 Lokasi Log di Peta:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(log.latitude!, log.longitude!),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('log_location'),
                        position: LatLng(log.latitude!, log.longitude!),
                        infoWindow: const InfoWindow(title: 'Lokasi Log'),
                      ),
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('📍 Alamat Log:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_logAddress),
              ],

              const SizedBox(height: 16),
              if (log.photoUrl != null) ...[
                const Text('📷 Foto Log:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    log.photoUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Text('Gagal memuat gambar'),
                  ),
                ),
              ],
            ] else ...[
              const SizedBox(height: 12),
              const Text('🚫 Belum ada log yang dikirim untuk tugas ini.'),
            ],
          ],
        ),
      ),
    );
  }
}
