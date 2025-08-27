class AppliedJobDto {
  final String id;
  final String companyName;
  final String jobTitle;
  final String location;
  final String status;
  final DateTime appliedDate;

  AppliedJobDto({
    required this.id,
    required this.companyName,
    required this.jobTitle,
    required this.location,
    required this.status,
    required this.appliedDate,
  });

  factory AppliedJobDto.fromJson(Map<String, dynamic> json) {
    return AppliedJobDto(
      id: json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      jobTitle: json['jobTitle'] ?? '',
      location: json['location'] ?? '',
      status: json['status'] ?? '',
      appliedDate: DateTime.parse(json['appliedDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'location': location,
      'status': status,
      'appliedDate': appliedDate.toIso8601String(),
    };
  }

  AppliedJobDto copyWith({
    String? id,
    String? companyName,
    String? jobTitle,
    String? location,
    String? status,
    DateTime? appliedDate,
  }) {
    return AppliedJobDto(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      location: location ?? this.location,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
    );
  }
}
