class DigitalIdDto {
  final String id;
  final String name;
  final String avatarUrl;
  final String qrCodeData;
  final String identificationNumber;

  DigitalIdDto({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.qrCodeData,
    required this.identificationNumber,
  });

  factory DigitalIdDto.fromJson(Map<String, dynamic> json) {
    return DigitalIdDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      qrCodeData: json['qrCodeData'] ?? '',
      identificationNumber: json['identificationNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'qrCodeData': qrCodeData,
      'identificationNumber': identificationNumber,
    };
  }
}
