class LogModel {
  final int id;
  final int taskId;
  final String description;
  final String? photoUrl;
  final double? latitude;
  final double? longitude;
  final String status;
  final bool? isValidated; 
  final String? adminNote;
  final String? adminComment;


 

  LogModel({
    required this.id,
    required this.taskId,
    required this.description,
    this.photoUrl,
    this.latitude,
    this.longitude,
    required this.status,
    this.isValidated,
    this.adminNote,
    this.adminComment,

    
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
      adminComment: json['admin_comment'],


      isValidated: json['is_validated'] != null
          ? json['is_validated'] == true || json['is_validated'].toString() == 'true'
          : null,
      adminNote: json['admin_note'],

      
    );
  }
  LogModel copyWith({
  bool? isValidated,
  String? adminNote,
}) {
  return LogModel(
    id: id,
    taskId: taskId,
    description: description,
    photoUrl: photoUrl,
    latitude: latitude,
    longitude: longitude,
    status: status,
    adminComment: adminComment,
    isValidated: isValidated ?? this.isValidated,
    adminNote: adminNote ?? this.adminNote,
  );
}
}
