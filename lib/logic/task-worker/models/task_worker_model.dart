class WorkerTaskModel {
  final int id;
  final String title;
  final String? description;
  final double? latitude;
  final double? longitude;

  WorkerTaskModel({
    required this.id,
    required this.title,
    this.description,
    this.latitude,
    this.longitude,
  });

  factory WorkerTaskModel.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return WorkerTaskModel(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'],
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
    );
  }
}
