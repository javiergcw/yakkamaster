/// Constantes de API para masters
class ApiMasterConstants {
  // Endpoints de masters
  static const String experienceLevels = '/api/v1/experience-levels';
  static const String licenses = '/api/v1/licenses';
  static const String skillCategories = '/api/v1/skill-categories';
  static const String skillSubcategories = '/api/v1/skill-subcategories';
  static const String skills = '/api/v1/skills';
  static const String paymentConstants = '/api/v1/payment-constants';
  static const String jobRequirements = '/api/v1/job-requirements';
  static const String jobTypes = '/api/v1/job-types';
  static const String companies = '/api/v1/companies';
  
  // Método para construir endpoint de subcategorías por categoría
  static String skillSubcategoriesByCategory(String categoryId) {
    return '/api/v1/skill-categories/$categoryId/subcategories';
  }
}
