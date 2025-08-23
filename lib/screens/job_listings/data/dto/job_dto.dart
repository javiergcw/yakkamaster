class JobDto {
  final String id;
  final String title;
  final double hourlyRate;
  final String location;
  final String dateRange;
  final String jobType;
  final String source;
  final String postedDate;
  final bool isRecommended;

  JobDto({
    required this.id,
    required this.title,
    required this.hourlyRate,
    required this.location,
    required this.dateRange,
    required this.jobType,
    required this.source,
    required this.postedDate,
    this.isRecommended = false,
  });

  factory JobDto.fromJson(Map<String, dynamic> json) {
    return JobDto(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      hourlyRate: (json['hourlyRate'] ?? 0.0).toDouble(),
      location: json['location'] ?? '',
      dateRange: json['dateRange'] ?? '',
      jobType: json['jobType'] ?? '',
      source: json['source'] ?? '',
      postedDate: json['postedDate'] ?? '',
      isRecommended: json['isRecommended'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'hourlyRate': hourlyRate,
      'location': location,
      'dateRange': dateRange,
      'jobType': jobType,
      'source': source,
      'postedDate': postedDate,
      'isRecommended': isRecommended,
    };
  }

  JobDto copyWith({
    String? id,
    String? title,
    double? hourlyRate,
    String? location,
    String? dateRange,
    String? jobType,
    String? source,
    String? postedDate,
    bool? isRecommended,
  }) {
    return JobDto(
      id: id ?? this.id,
      title: title ?? this.title,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      location: location ?? this.location,
      dateRange: dateRange ?? this.dateRange,
      jobType: jobType ?? this.jobType,
      source: source ?? this.source,
      postedDate: postedDate ?? this.postedDate,
      isRecommended: isRecommended ?? this.isRecommended,
    );
  }
}
