/// DTO para el request del endpoint /api/v1/auth/register
class DtoSendRegister {
  final String email;
  final String password;
  final bool autoVerify;

  DtoSendRegister({
    required this.email,
    required this.password,
    required this.autoVerify,
  });

  /// Constructor desde JSON
  factory DtoSendRegister.fromJson(Map<String, dynamic> json) {
    return DtoSendRegister(
      email: json['email'] as String,
      password: json['password'] as String,
      autoVerify: json['auto_verify'] as bool,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'auto_verify': autoVerify,
    };
  }

  @override
  String toString() {
    return 'DtoSendRegister(email: $email, password: [HIDDEN], autoVerify: $autoVerify)';
  }
}
