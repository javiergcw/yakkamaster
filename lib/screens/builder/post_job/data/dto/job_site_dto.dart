enum JobSiteStatus { inProgress, finished }

class JobSiteDto {
  final String id;
  final String name;
  final String city;
  final String address;
  final String code;
  final String location;
  final String description;
  final JobSiteStatus status;
  final bool isSelected;

  JobSiteDto({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.code,
    required this.location,
    required this.description,
    this.status = JobSiteStatus.inProgress,
    this.isSelected = false,
  });

  JobSiteDto copyWith({
    String? id,
    String? name,
    String? city,
    String? address,
    String? code,
    String? location,
    String? description,
    JobSiteStatus? status,
    bool? isSelected,
  }) {
    return JobSiteDto(
      id: id ?? this.id,
      name: name ?? this.name,
      city: city ?? this.city,
      address: address ?? this.address,
      code: code ?? this.code,
      location: location ?? this.location,
      description: description ?? this.description,
      status: status ?? this.status,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
      'code': code,
      'location': location,
      'description': description,
      'status': status.name,
      'isSelected': isSelected,
    };
  }

  factory JobSiteDto.fromMap(Map<String, dynamic> map) {
    return JobSiteDto(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      address: map['address'] ?? '',
      code: map['code'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      status: map['status'] == 'finished' ? JobSiteStatus.finished : JobSiteStatus.inProgress,
      isSelected: map['isSelected'] ?? false,
    );
  }

  @override
  String toString() {
    return 'JobSiteDto(id: $id, name: $name, city: $city, address: $address, code: $code, location: $location, description: $description, status: $status, isSelected: $isSelected)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobSiteDto &&
        other.id == id &&
        other.name == name &&
        other.city == city &&
        other.address == address &&
        other.code == code &&
        other.location == location &&
        other.description == description &&
        other.status == status &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        city.hashCode ^
        address.hashCode ^
        code.hashCode ^
        location.hashCode ^
        description.hashCode ^
        status.hashCode ^
        isSelected.hashCode;
  }
}
