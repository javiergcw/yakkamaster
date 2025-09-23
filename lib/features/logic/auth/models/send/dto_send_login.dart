/// DTO para el request del endpoint /api/v1/auth/login
class DtoSendLogin {
  final String email;
  final String password;

  DtoSendLogin({
    required this.email,
    required this.password,
  });

  /// Constructor desde JSON
  factory DtoSendLogin.fromJson(Map<String, dynamic> json) {
    return DtoSendLogin(
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'DtoSendLogin(email: $email, password: [HIDDEN])';
  }
}
