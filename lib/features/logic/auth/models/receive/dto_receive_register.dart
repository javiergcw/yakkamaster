import 'dto_receive_login.dart';

/// DTO para la respuesta del endpoint /api/v1/auth/register
class DtoReceiveRegister {
  final DtoReceiveUser user;
  final String message;
  final bool autoVerified;

  DtoReceiveRegister({
    required this.user,
    required this.message,
    required this.autoVerified,
  });

  /// Constructor desde JSON
  factory DtoReceiveRegister.fromJson(Map<String, dynamic> json) {
    return DtoReceiveRegister(
      user: DtoReceiveUser.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String,
      autoVerified: json['auto_verified'] as bool,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'message': message,
      'auto_verified': autoVerified,
    };
  }

  /// Verifica si el usuario fue verificado automáticamente
  bool get wasAutoVerified => autoVerified;

  /// Verifica si el usuario está listo para hacer login
  bool get isReadyForLogin => autoVerified && user.isActive;

  @override
  String toString() {
    return 'DtoReceiveRegister(user: $user, message: $message, autoVerified: $autoVerified)';
  }
}
