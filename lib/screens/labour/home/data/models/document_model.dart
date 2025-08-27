class DocumentModel {
  final String id;
  final String type;
  final String fileName;
  final String? fileUrl;
  final String? localPath;
  final int? fileSize;
  final bool isUploaded;
  final DateTime? uploadedAt;
  final String? serverId;

  DocumentModel({
    required this.id,
    required this.type,
    required this.fileName,
    this.fileUrl,
    this.localPath,
    this.fileSize,
    required this.isUploaded,
    this.uploadedAt,
    this.serverId,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'],
      localPath: json['localPath'],
      fileSize: json['fileSize'],
      isUploaded: json['isUploaded'] ?? false,
      uploadedAt: json['uploadedAt'] != null 
          ? DateTime.parse(json['uploadedAt']) 
          : null,
      serverId: json['serverId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'localPath': localPath,
      'fileSize': fileSize,
      'isUploaded': isUploaded,
      'uploadedAt': uploadedAt?.toIso8601String(),
      'serverId': serverId,
    };
  }

  DocumentModel copyWith({
    String? id,
    String? type,
    String? fileName,
    String? fileUrl,
    String? localPath,
    int? fileSize,
    bool? isUploaded,
    DateTime? uploadedAt,
    String? serverId,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      localPath: localPath ?? this.localPath,
      fileSize: fileSize ?? this.fileSize,
      isUploaded: isUploaded ?? this.isUploaded,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      serverId: serverId ?? this.serverId,
    );
  }

  @override
  String toString() {
    return 'DocumentModel(id: $id, type: $type, fileName: $fileName, isUploaded: $isUploaded)';
  }
}
