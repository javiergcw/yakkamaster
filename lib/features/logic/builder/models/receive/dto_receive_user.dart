/// DTO para recibir información del usuario
class DtoReceiveUser {
  final String id;
  final String email;
  final String? phone;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? photo;
  final String status;
  final String role;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? roleChangedAt;

  DtoReceiveUser({
    required this.id,
    required this.email,
    this.phone,
    this.firstName,
    this.lastName,
    this.address,
    this.photo,
    required this.status,
    required this.role,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.roleChangedAt,
  });

  /// Constructor desde JSON
  factory DtoReceiveUser.fromJson(Map<String, dynamic> json) {
    return DtoReceiveUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      address: json['address']?.toString(),
      photo: json['photo']?.toString(),
      status: json['status']?.toString() ?? 'inactive',
      role: json['role']?.toString() ?? '',
      lastLoginAt: json['last_login_at'] != null 
          ? DateTime.tryParse(json['last_login_at'].toString()) 
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ?? DateTime.now(),
      roleChangedAt: json['role_changed_at'] != null 
          ? DateTime.tryParse(json['role_changed_at'].toString()) 
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'photo': photo,
      'status': status,
      'role': role,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'role_changed_at': roleChangedAt?.toIso8601String(),
    };
  }

  /// Obtiene el nombre completo del usuario
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return email.split('@').first; // Usar email como fallback
  }

  /// Obtiene las iniciales del usuario
  String get initials {
    if (firstName != null && lastName != null) {
      return '${firstName!.substring(0, 1).toUpperCase()}${lastName!.substring(0, 1).toUpperCase()}';
    } else if (firstName != null) {
      return firstName!.substring(0, 1).toUpperCase();
    } else if (lastName != null) {
      return lastName!.substring(0, 1).toUpperCase();
    }
    return email.substring(0, 1).toUpperCase();
  }

  /// Verifica si el usuario está activo
  bool get isActive => status == 'active';

  /// Verifica si es un builder
  bool get isBuilder => role == 'builder';

  /// Verifica si es un labour
  bool get isLabour => role == 'labour';

  /// Obtiene el avatar del usuario
  String get avatarUrl {
    if (photo != null && photo!.isNotEmpty) {
      return photo!;
    }
    // Generar avatar por defecto con iniciales
    return 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=$initials';
  }

  /// Obtiene el tiempo desde el último login
  Duration? get timeSinceLastLogin {
    if (lastLoginAt == null) return null;
    return DateTime.now().difference(lastLoginAt!);
  }

  /// Obtiene el tiempo desde que cambió de rol
  Duration? get timeSinceRoleChange {
    if (roleChangedAt == null) return null;
    return DateTime.now().difference(roleChangedAt!);
  }

  @override
  String toString() {
    return 'DtoReceiveUser(id: $id, email: $email, role: $role, status: $status)';
  }
}
