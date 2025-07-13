import 'package:spotlog/logic/task-worker/models/task_worker_model.dart';

class TaskModel {
  final int id;
  final String title;
  final String? description;
  final double? latitude;
  final double? longitude;
  final int assignedTo;
  final WorkerTaskModel? assignedUser;
  final String? status;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
    required this.assignedTo,
    this.assignedUser,
    this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      latitude: json['latitude'] != null ? double.tryParse(json['latitude'].toString()) : null,
      longitude: json['longitude'] != null ? double.tryParse(json['longitude'].toString()) : null,
      assignedTo: json['assigned_to'],
      assignedUser: json['assigned_user'] != null
          ? WorkerTaskModel.fromJson(json['assigned_user'])
          : null,
    );
  }
}