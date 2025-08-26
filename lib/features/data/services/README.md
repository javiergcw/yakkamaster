# Servicio de Subida de Archivos

Este servicio permite subir documentos al servidor de Yakka Sports.

## Configuración

### 1. Configurar la URL del servidor

Edita el archivo `lib/config/api_config.dart` y cambia la URL base según tu entorno:

```dart
// Para desarrollo
static const String currentBaseUrl = devBaseUrl;

// Para producción
static const String currentBaseUrl = productionBaseUrl;
```

### 2. Configurar el ID del usuario

En el controlador `DocumentController`, reemplaza `'current_user_id'` con el ID real del usuario:

```dart
userId: 'current_user_id', // Reemplazar con el ID real del usuario
```

## Uso

### 1. Inicializar el controlador

```dart
final DocumentController documentController = Get.put(DocumentController());
```

### 2. Subir un documento

```dart
await documentController.uploadDocument(index);
```

### 3. Eliminar un documento

```dart
await documentController.deleteDocument(index);
```

### 4. Observar el estado

```dart
Obx(() {
  if (documentController.isUploading.value) {
    // Mostrar progreso de subida
    return UploadProgressWidget(
      progress: documentController.uploadProgress.value,
      fileName: documentController.uploadingFileName.value,
    );
  }
  return const SizedBox.shrink();
})
```

## Endpoints del Servidor

El servicio espera que el servidor tenga los siguientes endpoints:

### POST /api/documents/upload
Sube un documento al servidor.

**Parámetros:**
- `file`: Archivo a subir (multipart/form-data)
- `documentType`: Tipo de documento
- `userId`: ID del usuario (opcional)

**Respuesta exitosa:**
```json
{
  "success": true,
  "data": {
    "documentId": "123",
    "fileUrl": "https://example.com/files/document.pdf"
  },
  "message": "Archivo subido exitosamente"
}
```

### DELETE /api/documents/{documentId}
Elimina un documento del servidor.

**Parámetros:**
- `documentId`: ID del documento a eliminar
- `userId`: ID del usuario (opcional)

### GET /api/documents
Obtiene la lista de documentos del usuario.

**Parámetros:**
- `userId`: ID del usuario (opcional)

**Respuesta exitosa:**
```json
{
  "success": true,
  "data": [
    {
      "id": "1",
      "type": "Resume",
      "fileName": "resume.pdf",
      "fileUrl": "https://example.com/files/resume.pdf",
      "fileSize": 1024000,
      "isUploaded": true,
      "uploadedAt": "2024-01-01T00:00:00Z",
      "serverId": "123"
    }
  ]
}
```

## Tipos de Archivo Soportados

- PDF (.pdf)
- Word (.doc, .docx)

## Manejo de Errores

El servicio maneja automáticamente los siguientes errores:

- Errores de conexión
- Timeouts
- Errores del servidor
- Errores de archivo

Los errores se muestran al usuario mediante SnackBars.

## Progreso de Subida

El servicio proporciona información en tiempo real sobre el progreso de subida:

- `isUploading`: Indica si hay una subida en progreso
- `uploadProgress`: Porcentaje de progreso (0-100)
- `uploadingFileName`: Nombre del archivo que se está subiendo

## Personalización

### Cambiar tipos de archivo permitidos

En el método `uploadDocument` del controlador:

```dart
FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['pdf', 'doc', 'docx'], // Modificar aquí
  allowMultiple: false,
);
```

### Cambiar timeouts

En `lib/config/api_config.dart`:

```dart
static const int connectionTimeout = 30; // segundos
static const int receiveTimeout = 30; // segundos
```

### Agregar headers personalizados

En el servicio `FileUploadService`:

```dart
_dio.options.headers['Authorization'] = 'Bearer $token';
```
