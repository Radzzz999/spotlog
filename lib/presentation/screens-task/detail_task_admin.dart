import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_bloc.dart';
import 'package:spotlog/logic/task-home-admin/bloc/task_admin_event.dart';
import 'package:spotlog/logic/task-home-admin/models/task.dart';
import 'package:spotlog/presentation/screens-task/Edit_task_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdminTaskDetailScreen extends StatelessWidget {
  final TaskModel task;
  final String token;

  const AdminTaskDetailScreen({required this.task, required this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text(task.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (task.description != null)
            Text('Deskripsi: ${task.description}'),
          const SizedBox(height: 12),
          Text('Assigned To: ${task.assignedUser?.id ?? 'User ID ${task.assignedTo}'}'),
          const SizedBox(height: 12),
         if (task.latitude != null && task.longitude != null)
          SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(task.latitude!, task.longitude!),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('taskLocation'),
                  position: LatLng(task.latitude!, task.longitude!),
                  infoWindow: InfoWindow(title: task.title),
                ),
              },
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Alamat (Koordinat):\nLatitude: ${task.latitude}, Longitude: ${task.longitude}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => EditTaskScreen(task: task, token: token),
                  ));
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text('Yakin ingin menghapus tugas ini?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.read<TaskBlocAdmin>().add(DeleteTaskEvent(task.id, token));
                            Navigator.pop(context);
                          },
                          child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}