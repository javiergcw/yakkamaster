class BuilderProfileDto {
  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? phone;
  final String? email;
  final String? profileImagePath;
  final String? industry;
  final String? companySize;
  final String? companyAddress;
  final String? companyPhone;
  final String? website;
  final String? description;

  BuilderProfileDto({
    this.firstName,
    this.lastName,
    this.companyName,
    this.phone,
    this.email,
    this.profileImagePath,
    this.industry,
    this.companySize,
    this.companyAddress,
    this.companyPhone,
    this.website,
    this.description,
  });

  // Método para crear una copia con nuevos valores
  BuilderProfileDto copyWith({
    String? firstName,
    String? lastName,
    String? companyName,
    String? phone,
    String? email,
    String? profileImagePath,
    String? industry,
    String? companySize,
    String? companyAddress,
    String? companyPhone,
    String? website,
    String? description,
  }) {
    return BuilderProfileDto(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      companyName: companyName ?? this.companyName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      industry: industry ?? this.industry,
      companySize: companySize ?? this.companySize,
      companyAddress: companyAddress ?? this.companyAddress,
      companyPhone: companyPhone ?? this.companyPhone,
      website: website ?? this.website,
      description: description ?? this.description,
    );
  }

  // Método para convertir a Map (útil para APIs)
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'companyName': companyName,
      'phone': phone,
      'email': email,
      'profileImagePath': profileImagePath,
      'industry': industry,
      'companySize': companySize,
      'companyAddress': companyAddress,
      'companyPhone': companyPhone,
      'website': website,
      'description': description,
    };
  }

  // Método para crear desde Map
  factory BuilderProfileDto.fromMap(Map<String, dynamic> map) {
    return BuilderProfileDto(
      firstName: map['firstName'],
      lastName: map['lastName'],
      companyName: map['companyName'],
      phone: map['phone'],
      email: map['email'],
      profileImagePath: map['profileImagePath'],
      industry: map['industry'],
      companySize: map['companySize'],
      companyAddress: map['companyAddress'],
      companyPhone: map['companyPhone'],
      website: map['website'],
      description: map['description'],
    );
  }

  // Método para validar campos requeridos
  bool get isValid {
    return firstName != null && 
           firstName!.isNotEmpty &&
           lastName != null && 
           lastName!.isNotEmpty &&
           companyName != null && 
           companyName!.isNotEmpty &&
           industry != null &&
           companySize != null &&
           companyAddress != null &&
           companyAddress!.isNotEmpty;
  }

  // Método para obtener mensajes de error
  List<String> get validationErrors {
    List<String> errors = [];
    
    if (firstName == null || firstName!.isEmpty) {
      errors.add('First name is required');
    }
    
    if (lastName == null || lastName!.isEmpty) {
      errors.add('Last name is required');
    }
    
    if (companyName == null || companyName!.isEmpty) {
      errors.add('Company name is required');
    }
    
    if (industry == null) {
      errors.add('Industry is required');
    }
    
    if (companySize == null) {
      errors.add('Company size is required');
    }
    
    if (companyAddress == null || companyAddress!.isEmpty) {
      errors.add('Company address is required');
    }
    
    return errors;
  }

  @override
  String toString() {
    return 'BuilderProfileDto(firstName: $firstName, lastName: $lastName, companyName: $companyName, phone: $phone, email: $email, profileImagePath: $profileImagePath, industry: $industry, companySize: $companySize, companyAddress: $companyAddress, companyPhone: $companyPhone, website: $website, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BuilderProfileDto &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.companyName == companyName &&
        other.phone == phone &&
        other.email == email &&
        other.profileImagePath == profileImagePath &&
        other.industry == industry &&
        other.companySize == companySize &&
        other.companyAddress == companyAddress &&
        other.companyPhone == companyPhone &&
        other.website == website &&
        other.description == description;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        companyName.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        profileImagePath.hashCode ^
        industry.hashCode ^
        companySize.hashCode ^
        companyAddress.hashCode ^
        companyPhone.hashCode ^
        website.hashCode ^
        description.hashCode;
  }
}
