class ApplicantDto {
  final String id;
  final String name;
  final String jobRole;
  final double rating;
  final String profileImageUrl;
  final bool isNew; // Para mostrar el punto rojo

  ApplicantDto({
    required this.id,
    required this.name,
    required this.jobRole,
    required this.rating,
    required this.profileImageUrl,
    this.isNew = false,
  });

  ApplicantDto copyWith({
    String? id,
    String? name,
    String? jobRole,
    double? rating,
    String? profileImageUrl,
    bool? isNew,
  }) {
    return ApplicantDto(
      id: id ?? this.id,
      name: name ?? this.name,
      jobRole: jobRole ?? this.jobRole,
      rating: rating ?? this.rating,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isNew: isNew ?? this.isNew,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'jobRole': jobRole,
      'rating': rating,
      'profileImageUrl': profileImageUrl,
      'isNew': isNew,
    };
  }

  factory ApplicantDto.fromMap(Map<String, dynamic> map) {
    return ApplicantDto(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      jobRole: map['jobRole'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      profileImageUrl: map['profileImageUrl'] ?? '',
      isNew: map['isNew'] ?? false,
    );
  }

  @override
  String toString() {
    return 'ApplicantDto(id: $id, name: $name, jobRole: $jobRole, rating: $rating, profileImageUrl: $profileImageUrl, isNew: $isNew)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ApplicantDto &&
        other.id == id &&
        other.name == name &&
        other.jobRole == jobRole &&
        other.rating == rating &&
        other.profileImageUrl == profileImageUrl &&
        other.isNew == isNew;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        jobRole.hashCode ^
        rating.hashCode ^
        profileImageUrl.hashCode ^
        isNew.hashCode;
  }
}
