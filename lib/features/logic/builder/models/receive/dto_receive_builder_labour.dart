/// DTO para recibir información del labour en aplicaciones del builder
class DtoReceiveBuilderLabour {
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final String? phone;
  final String email;

  DtoReceiveBuilderLabour({
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    this.phone,
    required this.email,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilderLabour.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilderLabour(
      userId: json['user_id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString() ?? '',
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'phone': phone,
      'email': email,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveBuilderLabour(userId: $userId, fullName: $fullName, email: $email)';
  }
}
