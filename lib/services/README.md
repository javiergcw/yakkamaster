# Servicio Global de API

Este servicio proporciona una interfaz unificada para realizar peticiones HTTP con manejo automático de headers, tokens, y detección de endpoints públicos.

## Características

- ✅ Headers automáticos (Content-Type, Accept)
- ✅ Header X-License-Key opcional
- ✅ Header Authorization: Bearer <token> opcional
- ✅ Detección de endpoints públicos mediante patrones RegExp
- ✅ Inyección de TokenProvider personalizable
- ✅ Serialización automática de query params y body JSON
- ✅ Manejo de timeout con http.Client + Future.timeout
- ✅ Manejo de errores 401 con callback onUnauthorized
- ✅ Clases de error personalizadas
- ✅ Métodos helper: get<T>, post<T>, put<T>, patch<T>, delete<T>

## Configuración

### 1. Inicializar el servicio

```dart
// En main.dart o en el binding inicial
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar el servicio de API
  Get.put(ApiService(), permanent: true);
  
  runApp(MyApp());
}
```

### 2. Configurar TokenProvider personalizado

```dart
class MyTokenProvider implements TokenProvider {
  @override
  Future<String?> getToken() async {
    // Implementar lógica para obtener JWT
    return await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString('jwt_token'));
  }
  
  @override
  Future<String?> getLicenseKey() async {
    // Implementar lógica para obtener license key
    return await SharedPreferences.getInstance()
        .then((prefs) => prefs.getString('license_key'));
  }
  
  // ... implementar otros métodos
}

// Configurar el provider
ApiService.instance.setTokenProvider(MyTokenProvider());
```

### 3. Configurar callback para errores 401

```dart
ApiService.instance.setOnUnauthorized(() {
  // Redirigir al login o limpiar tokens
  Get.offAllNamed('/login');
});
```

## Uso

### Peticiones GET

```dart
// Petición simple
final user = await ApiService.instance.get<Map<String, dynamic>>(
  '/api/users/123',
  requireAuth: true,
);

// Petición con query parameters
final users = await ApiService.instance.get<List<Map<String, dynamic>>>(
  '/api/users',
  queryParams: {
    'page': 1,
    'limit': 10,
    'search': 'john',
  },
  requireAuth: true,
);
```

### Peticiones POST

```dart
final newUser = await ApiService.instance.post<Map<String, dynamic>>(
  '/api/users',
  body: {
    'name': 'John Doe',
    'email': 'john@example.com',
  },
  requireAuth: true,
);
```

### Peticiones PUT/PATCH

```dart
// PUT - actualización completa
final updatedUser = await ApiService.instance.put<Map<String, dynamic>>(
  '/api/users/123',
  body: {
    'name': 'John Smith',
    'email': 'johnsmith@example.com',
  },
  requireAuth: true,
);

// PATCH - actualización parcial
final patchedUser = await ApiService.instance.patch<Map<String, dynamic>>(
  '/api/users/123',
  body: {
    'name': 'John Smith',
  },
  requireAuth: true,
);
```

### Peticiones DELETE

```dart
await ApiService.instance.delete<Map<String, dynamic>>(
  '/api/users/123',
  requireAuth: true,
);
```

### Endpoints Públicos

Los endpoints públicos se detectan automáticamente y no requieren autenticación:

```dart
// Este endpoint es público (patrón: /api/master/.*)
final countries = await ApiService.instance.get<List<Map<String, dynamic>>>(
  '/api/master/countries',
  requireAuth: false, // Opcional, se detecta automáticamente
);
```

## Manejo de Errores

```dart
try {
  final user = await ApiService.instance.get<Map<String, dynamic>>(
    '/api/users/123',
    requireAuth: true,
  );
} on ApiUnauthorizedError {
  // Manejar error 401
  print('Usuario no autorizado');
} on ApiNotFoundError {
  // Manejar error 404
  print('Usuario no encontrado');
} on ApiNetworkError {
  // Manejar error de red
  print('Error de conexión');
} on ApiTimeoutError {
  // Manejar timeout
  print('Tiempo de espera agotado');
} on ApiError catch (e) {
  // Manejar otros errores
  print('Error: ${e.message}');
}
```

## Configuración de Endpoints Públicos

Para agregar nuevos endpoints públicos, modifica el método `_setupPublicEndpoints()` en `ApiService`:

```dart
void _setupPublicEndpoints() {
  _publicEndpoints = [
    // Endpoints de autenticación
    const PublicEndpoint(pattern: r'/api/auth/login'),
    const PublicEndpoint(pattern: r'/api/auth/register'),
    
    // Listas maestras
    const PublicEndpoint(pattern: r'/api/master/.*'),
    
    // Nuevos endpoints públicos
    const PublicEndpoint(pattern: r'/api/public/.*'),
    const PublicEndpoint(pattern: r'/api/health'),
  ];
}
```

## Timeout Personalizado

```dart
final result = await ApiService.instance.get<Map<String, dynamic>>(
  '/api/slow-endpoint',
  timeout: const Duration(minutes: 2),
  requireAuth: true,
);
```

## Headers Personalizados

```dart
final result = await ApiService.instance.get<Map<String, dynamic>>(
  '/api/endpoint',
  headers: {
    'X-Custom-Header': 'custom-value',
  },
  requireAuth: true,
);
```
