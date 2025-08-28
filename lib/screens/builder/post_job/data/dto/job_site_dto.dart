class JobSiteDto {
  final String id;
  final String name;
  final String location;
  final String description;
  final bool isSelected;

  JobSiteDto({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    this.isSelected = false,
  });

  JobSiteDto copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    bool? isSelected,
  }) {
    return JobSiteDto(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'isSelected': isSelected,
    };
  }

  factory JobSiteDto.fromMap(Map<String, dynamic> map) {
    return JobSiteDto(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      isSelected: map['isSelected'] ?? false,
    );
  }

  @override
  String toString() {
    return 'JobSiteDto(id: $id, name: $name, location: $location, description: $description, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobSiteDto &&
        other.id == id &&
        other.name == name &&
        other.location == location &&
        other.description == description &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location.hashCode ^
        description.hashCode ^
        isSelected.hashCode;
  }
}
