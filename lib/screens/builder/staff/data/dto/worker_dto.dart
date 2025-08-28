class WorkerDto {
  final String id;
  final String name;
  final String role;
  final String hourlyRate;
  final String imageUrl;
  final bool isActive;
  final String jobsiteId;
  final String jobsiteName;

  WorkerDto({
    required this.id,
    required this.name,
    required this.role,
    required this.hourlyRate,
    required this.imageUrl,
    required this.isActive,
    required this.jobsiteId,
    required this.jobsiteName,
  });

  factory WorkerDto.fromJson(Map<String, dynamic> json) {
    return WorkerDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      hourlyRate: json['hourlyRate'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      isActive: json['isActive'] ?? true,
      jobsiteId: json['jobsiteId'] ?? '',
      jobsiteName: json['jobsiteName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'hourlyRate': hourlyRate,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'jobsiteId': jobsiteId,
      'jobsiteName': jobsiteName,
    };
  }
}
