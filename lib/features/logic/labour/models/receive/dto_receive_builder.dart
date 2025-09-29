/// DTO para recibir información del builder desde el API
class DtoReceiveBuilder {
  final String builderId;
  final String companyName;
  final String displayName;
  final String location;
  final String? avatarUrl;

  DtoReceiveBuilder({
    required this.builderId,
    required this.companyName,
    required this.displayName,
    required this.location,
    this.avatarUrl,
  });

  /// Constructor desde JSON
  factory DtoReceiveBuilder.fromJson(Map<String, dynamic> json) {
    return DtoReceiveBuilder(
      builderId: json['builder_id']?.toString() ?? '',
      companyName: json['company_name']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString(),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'builder_id': builderId,
      'company_name': companyName,
      'display_name': displayName,
      'location': location,
      'avatar_url': avatarUrl,
    };
  }

  @override
  String toString() {
    return 'DtoReceiveBuilder(builderId: $builderId, companyName: $companyName, displayName: $displayName, location: $location, avatarUrl: $avatarUrl)';
  }
}
