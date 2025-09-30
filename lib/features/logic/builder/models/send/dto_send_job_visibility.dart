/// DTO para actualizar la visibilidad de un job
class DtoSendJobVisibility {
  final String visibility;

  DtoSendJobVisibility({
    required this.visibility,
  });

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'visibility': visibility,
    };
  }

  /// Constructor desde JSON
  factory DtoSendJobVisibility.fromJson(Map<String, dynamic> json) {
    return DtoSendJobVisibility(
      visibility: json['visibility'] as String,
    );
  }

  /// Crea un DtoSendJobVisibility con visibilidad pública
  factory DtoSendJobVisibility.public() {
    return DtoSendJobVisibility(visibility: 'PUBLIC');
  }

  /// Crea un DtoSendJobVisibility con visibilidad privada
  factory DtoSendJobVisibility.private() {
    return DtoSendJobVisibility(visibility: 'PRIVATE');
  }

  /// Crea una copia con nuevos valores
  DtoSendJobVisibility copyWith({
    String? visibility,
  }) {
    return DtoSendJobVisibility(
      visibility: visibility ?? this.visibility,
    );
  }

  /// Valida que la visibilidad sea válida
  bool get isValid {
    return visibility == 'PUBLIC' || visibility == 'PRIVATE';
  }

  /// Obtiene si es público
  bool get isPublic => visibility == 'PUBLIC';

  /// Obtiene si es privado
  bool get isPrivate => visibility == 'PRIVATE';

  @override
  String toString() {
    return 'DtoSendJobVisibility(visibility: $visibility)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DtoSendJobVisibility && other.visibility == visibility;
  }

  @override
  int get hashCode => visibility.hashCode;
}
