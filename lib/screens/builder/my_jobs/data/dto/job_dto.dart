class JobDto {
  final String id;
  final String title;
  final double rate;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String jobType;
  final String source;
  final DateTime postedDate;
  final bool isVisible;
  final bool isActive;

  JobDto({
    required this.id,
    required this.title,
    required this.rate,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.jobType,
    required this.source,
    required this.postedDate,
    required this.isVisible,
    required this.isActive,
  });

  JobDto copyWith({
    String? id,
    String? title,
    double? rate,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    String? jobType,
    String? source,
    DateTime? postedDate,
    bool? isVisible,
    bool? isActive,
  }) {
    return JobDto(
      id: id ?? this.id,
      title: title ?? this.title,
      rate: rate ?? this.rate,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      jobType: jobType ?? this.jobType,
      source: source ?? this.source,
      postedDate: postedDate ?? this.postedDate,
      isVisible: isVisible ?? this.isVisible,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'rate': rate,
      'location': location,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'jobType': jobType,
      'source': source,
      'postedDate': postedDate.toIso8601String(),
      'isVisible': isVisible,
      'isActive': isActive,
    };
  }

  factory JobDto.fromMap(Map<String, dynamic> map) {
    return JobDto(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      rate: map['rate']?.toDouble() ?? 0.0,
      location: map['location'] ?? '',
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      jobType: map['jobType'] ?? '',
      source: map['source'] ?? '',
      postedDate: DateTime.parse(map['postedDate']),
      isVisible: map['isVisible'] ?? true,
      isActive: map['isActive'] ?? true,
    );
  }

  @override
  String toString() {
    return 'JobDto(id: $id, title: $title, rate: $rate, location: $location, startDate: $startDate, endDate: $endDate, jobType: $jobType, source: $source, postedDate: $postedDate, isVisible: $isVisible, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobDto &&
        other.id == id &&
        other.title == title &&
        other.rate == rate &&
        other.location == location &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.jobType == jobType &&
        other.source == source &&
        other.postedDate == postedDate &&
        other.isVisible == isVisible &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        rate.hashCode ^
        location.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        jobType.hashCode ^
        source.hashCode ^
        postedDate.hashCode ^
        isVisible.hashCode ^
        isActive.hashCode;
  }
}
