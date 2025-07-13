class LogModel {
  final int id;
  final int taskId;
  final String description;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final String status;
 

  LogModel({
    required this.id,
    required this.taskId,
    required this.description,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.status,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      id: json['id'],
      taskId: int.parse(json['task_id'].toString()),
      description: json['description'],
      photoUrl: json['photo_url'],
      latitude: double.tryParse(json['latitude'].toString()),
      longitude: double.tryParse(json['longitude'].toString()),
      status: json['status'],
    );
  }
}
