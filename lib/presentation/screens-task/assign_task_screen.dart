import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spotlog/logic/task/bloc/task_bloc.dart';
import 'package:spotlog/logic/task/bloc/task_event.dart';
import 'package:spotlog/logic/task/bloc/task_state.dart';
import 'native_map_screen.dart'; 

class AssignTaskScreen extends StatefulWidget {
  final String token;

  const AssignTaskScreen({required this.token, super.key});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final assignedToController = TextEditingController();

  LatLng? _pickedLatLng;
  String? _pickedAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign Task')),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tugas berhasil dibuat!')),
            );
            titleController.clear();
            descriptionController.clear();
            assignedToController.clear();
            setState(() {
              _pickedLatLng = null;
              _pickedAddress = null;
            });
          } else if (state is TaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },

        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: titleController, decoration: InputDecoration(labelText: 'Title')),
                TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Description')),
                TextField(controller: assignedToController, decoration: InputDecoration(labelText: 'Assigned User ID')),
                SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: Icon(Icons.map),
                  label: Text('Pilih Lokasi di Peta'),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NativeMap()),
                    );

                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        _pickedAddress = result['address'];
                        _pickedLatLng = result['latlng'];
                      });
                    }
                  },
                ),

                SizedBox(height: 10),
                if (_pickedAddress != null)
                  Text(
                    'Alamat dipilih:\n$_pickedAddress',
                    textAlign: TextAlign.center,
                  ),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_pickedLatLng == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Silakan pilih lokasi di peta')),
                      );
                      return;
                    }

                    context.read<TaskBloc>().add(
                          AssignTaskEvent(
                            title: titleController.text,
                            description: descriptionController.text,
                            assignedTo: int.parse(assignedToController.text),
                            latitude: _pickedLatLng!.latitude,
                            longitude: _pickedLatLng!.longitude,
                            token: widget.token,
                          ),
                        );
                  },
                  child: state is TaskLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Submit Task'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
