import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_bloc.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_event.dart';
import 'package:spotlog/logic/task-home-admin/models/task.dart';
import 'package:spotlog/presentation/screens-task/native_map_screen.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskModel task;
  final String token;

  const EditTaskScreen({required this.task, required this.token, super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController assignedToController;
  LatLng? _pickedLatLng;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description ?? '');
    assignedToController = TextEditingController(text: widget.task.assignedTo.toString());
    _pickedLatLng = widget.task.latitude != null && widget.task.longitude != null
        ? LatLng(widget.task.latitude!, widget.task.longitude!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Tugas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: assignedToController,
              decoration: const InputDecoration(labelText: 'User ID Penerima Tugas'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Ubah Lokasi via Peta'),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NativeMap()),
                );
                if (result != null && result is Map<String, dynamic>) {
                  setState(() {
                    _pickedLatLng = result['latlng'];
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            if (_pickedLatLng != null)
              Text(
                'Lokasi baru:\nLat: ${_pickedLatLng!.latitude}, Lng: ${_pickedLatLng!.longitude}',
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<TaskBlocAdmin>().add(UpdateTaskEvent(
                  id: widget.task.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  assignedTo: int.tryParse(assignedToController.text) ?? widget.task.assignedTo,
                  latitude: _pickedLatLng?.latitude ?? widget.task.latitude,
                  longitude: _pickedLatLng?.longitude ?? widget.task.longitude,
                  token: widget.token,
                ));
                Navigator.pop(context); // kembali ke detail
              },
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}