import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:spotlog/logic/log-worker/bloc/log_bloc.dart';
import 'package:spotlog/logic/log-worker/bloc/log_event.dart';
import 'package:spotlog/logic/log-worker/bloc/log_state.dart';

import 'location_picker_screen.dart'; // Pastikan ini import ke file kamu

class CreateLogScreen extends StatefulWidget {
  final String token;
  final int taskId;

  const CreateLogScreen({
    super.key,
    required this.token,
    required this.taskId,
  });

  @override
  State<CreateLogScreen> createState() => _CreateLogScreenState();
}

class _CreateLogScreenState extends State<CreateLogScreen> {
  final descCtrl = TextEditingController();
  XFile? photo;
  double? lat, long;
  String? address;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  final file = await picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, file);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final file = await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, file);
                },
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        photo = picked;
      });
    }
  }

  Future<void> _pickLocationFromMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationPickerScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        lat = result['lat'];
        long = result['lng'];
        address = result['address'];
      });
    }
  }

  void _submit() {
    context.read<LogBloc>().add(CreateLogRequested(
          token: widget.token,
          taskId: widget.taskId,
          description: descCtrl.text,
          photoPath: photo!.path,
          latitude: lat,
          longitude: long,
          // Kalau kamu ingin kirim address, tambahkan ke event/model
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Log')),
      body: BlocListener<LogBloc, LogState>(
        listener: (context, state) {
          if (state is LogCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Log submitted successfully')),
            );
            Navigator.pop(context);
          } else if (state is LogFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_camera),
                label: Text(photo == null ? 'Pick Photo' : 'Photo Selected'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _pickLocationFromMap,
                icon: const Icon(Icons.location_on),
                label: Text(
                  lat != null && long != null
                      ? 'Location: ${lat!.toStringAsFixed(6)}, ${long!.toStringAsFixed(6)}'
                      : 'Pick Location from Map',
                ),
              ),
              if (address != null) ...[
                const SizedBox(height: 8),
                Text(
                  address!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: photo != null && descCtrl.text.isNotEmpty && lat != null
                    ? _submit
                    : null,
                child: const Text('Submit Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
