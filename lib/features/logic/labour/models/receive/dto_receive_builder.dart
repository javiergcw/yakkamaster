/// DTO para recibir información del builder desde el API
class DtoReceiveBuilder {
  final String id;
  final String companyName;
  final String displayName;
  final String? location;
  final String? avatarUrl;

  DtoReceiveBuilder({
    required this.id,
    required this.companyName,
    required this.displayName,
    this.location,
    this.avatarUrl,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilder.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilder(
      id: json['id']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      location: json['location']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_name': companyName,
      'display_name': displayName,
      'location': location,
      'avatar_url': avatarUrl,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveBuilder(id: $id, companyName: $companyName, displayName: $displayName, location: $location, avatarUrl: $avatarUrl)';
  }
}
