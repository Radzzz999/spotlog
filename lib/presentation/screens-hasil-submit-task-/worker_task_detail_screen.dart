import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/task-worker/models/task_worker_model.dart';
import '../../logic/log-worker/models/log_model.dart';
import '../../logic/log-worker/bloc/log_bloc.dart';
import '../../logic/log-worker/bloc/log_event.dart';
import '../../logic/log-worker/bloc/log_state.dart';

class WorkerTaskDetailScreen extends StatefulWidget {
  final WorkerTaskModel task;
  final LogModel? log;
  final String role;
  final String token;

  const WorkerTaskDetailScreen({
    super.key,
    required this.task,
    this.log,
    required this.role,
    required this.token,
  });

  @override
  State<WorkerTaskDetailScreen> createState() => _WorkerTaskDetailScreenState();
}

class _WorkerTaskDetailScreenState extends State<WorkerTaskDetailScreen> {
  String _logAddress = 'Memuat alamat...';
  bool? _logIsValid;
  final TextEditingController _adminNoteController = TextEditingController();
  LogModel? _updatedLog;

  @override
  void initState() {
    super.initState();
    _loadLatestLogFromBloc();
    _getLogAddress();
  }

  void _loadLatestLogFromBloc() {
    if (widget.log != null) {
      final blocState = context.read<LogBloc>().state;
      if (blocState is LogsLoaded) {
        _updatedLog = blocState.logs.firstWhere(
          (l) => l.id == widget.log!.id,
          orElse: () => widget.log!,
        );
      } else {
        _updatedLog = widget.log;
      }
    }

    if (widget.role != 'admin' && _updatedLog != null) {
      _logIsValid = _updatedLog!.isValidated;
      _adminNoteController.text = _updatedLog!.adminNote ?? '';
    }
  }

  Future<void> _getLogAddress() async {
    if (_updatedLog?.latitude != null && _updatedLog?.longitude != null) {
      try {
        final placemarks = await placemarkFromCoordinates(
          _updatedLog!.latitude!,
          _updatedLog!.longitude!,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          setState(() {
            _logAddress =
                '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
          });
        } else {
          _logAddress = 'Alamat tidak ditemukan';
        }
      } catch (_) {
        _logAddress = 'Gagal memuat alamat';
      }
    } else {
      _logAddress = 'Tidak ada koordinat log';
    }
  }

  @override
  void dispose() {
    _adminNoteController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  final task = widget.task;
  final log = _updatedLog;

  return Scaffold(
    appBar: AppBar(title: const Text('Detail Tugas & Log')),
    body: log == null
        ? const Center(child: Text('🚫 Belum ada log untuk tugas ini.'))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🗂️ Detail Tugas
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📌 Judul Tugas',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(task.title,
                            style: const TextStyle(fontWeight: FontWeight.bold)),

                        const SizedBox(height: 12),
                        Text('📝 Deskripsi Tugas',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text(task.description ?? "-"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🗺 Lokasi Tugas
                if (task.latitude != null && task.longitude != null) ...[
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('📍 Lokasi Tugas di Peta',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 200,
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
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // 📄 Log Anda
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('📄 Log Anda',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('📝 Deskripsi Log: ${log.description}'),
                        Text('⏳ Status: ${log.status}'),

                        if (log.latitude != null && log.longitude != null) ...[
                          const SizedBox(height: 12),
                          const Text('🗺 Lokasi Log di Peta:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 200,
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

                        if (log.photoUrl != null) ...[
                          const SizedBox(height: 16),
                          const Text('📷 Foto Log:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              log.photoUrl!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Text('⚠️ Gagal memuat gambar'),
                            ),
                          ),
                        ],

                        if (log.adminComment?.isNotEmpty == true) ...[
                          const SizedBox(height: 16),
                          const Text('💬 Komentar Admin:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(log.adminComment!),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🧾 Evaluasi Admin
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('🧾 Evaluasi Admin',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),

                        if (widget.role == 'admin') ...[
                          Row(
                            children: [
                              ChoiceChip(
                                label: const Text('✅ Valid'),
                                selected: _logIsValid == true,
                                onSelected: (_) => setState(() => _logIsValid = true),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: const Text('❌ Tidak Valid'),
                                selected: _logIsValid == false,
                                onSelected: (_) => setState(() => _logIsValid = false),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _adminNoteController,
                            decoration: const InputDecoration(
                              labelText: 'Catatan/koreksi untuk user',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text('Simpan Evaluasi'),
                              onPressed: () {
                                if (_logIsValid != null &&
                                    _adminNoteController.text.isNotEmpty) {
                                  final updatedLog = log.copyWith(
                                    isValidated: _logIsValid,
                                    adminNote: _adminNoteController.text,
                                  );
                                  setState(() => _updatedLog = updatedLog);

                                  context.read<LogBloc>().add(SaveLogEvaluation(
                                        logId: log.id!,
                                        isValidated: _logIsValid!,
                                        adminNote: _adminNoteController.text,
                                      ));

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Log ditandai ${_logIsValid! ? "valid" : "tidak valid"}'),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Mohon isi status dan catatan terlebih dahulu'),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Status: ${_updatedLog?.isValidated == true ? "✅ Valid" : _updatedLog?.isValidated == false ? "❌ Tidak Valid" : "⏳ Belum Dievaluasi"}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          if (_updatedLog?.adminNote?.isNotEmpty == true)
                            Text('Catatan Admin: ${_updatedLog!.adminNote}'),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}
}