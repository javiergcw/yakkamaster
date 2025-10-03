/// Constantes de API para builder
class ApiBuilderConstants {
  // Endpoints de builder
  static const String builderProfile = '/api/v1/profiles/builder';
  static const String jobsites = '/api/v1/jobsites';
  static const String jobs = '/api/v1/builder/jobs';
  static const String applicants = '/api/v1/builder/applicants';
  static const String authProfile = '/api/v1/auth/profile';
  static const String builderCompanies = '/api/v1/builder/companies';
  
  // Método para obtener endpoint de visibilidad de job
  static String jobVisibility(String jobId) => '/api/v1/builder/jobs/$jobId/visibility';
  
  // Método para obtener endpoint de decisión de contratación
  static String hireDecision(String applicationId) => '/api/v1/builder/applicants/$applicationId/decision';
}
