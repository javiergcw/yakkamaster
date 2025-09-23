/// DTO para la respuesta del endpoint /health
class DtoReceiveHealth {
  final String status;
  final String timestamp;
  final String version;
  final HealthData data;

  DtoReceiveHealth({
    required this.status,
    required this.timestamp,
    required this.version,
    required this.data,
  });

  /// Constructor desde JSON
  factory DtoReceiveHealth.fromJson(Map<String, dynamic> json) {
    return DtoReceiveHealth(
      status: json['status'] as String,
      timestamp: json['timestamp'] as String,
      version: json['version'] as String,
      data: HealthData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp,
      'version': version,
      'data': data.toJson(),
    };
  }

  /// Verifica si el servicio está saludable
  bool get isHealthy => status == 'healthy';

  /// Obtiene la fecha de timestamp como DateTime
  DateTime get timestampAsDateTime {
    try {
      return DateTime.parse(timestamp);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  String toString() {
    return 'DtoReceiveHealth(status: $status, timestamp: $timestamp, version: $version, data: $data)';
  }
}

/// Datos adicionales del health check
class HealthData {
  final String license;
  final String uptime;

  HealthData({
    required this.license,
    required this.uptime,
  });

  /// Constructor desde JSON
  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      license: json['license'] as String,
      uptime: json['uptime'] as String,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'license': license,
      'uptime': uptime,
    };
  }

  /// Verifica si la licencia es válida
  bool get isLicenseValid => license.isNotEmpty;

  /// Verifica si el servicio está corriendo
  bool get isRunning => uptime == 'running';

  @override
  String toString() {
    return 'HealthData(license: $license, uptime: $uptime)';
  }
}
