import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../data/dto/builder_profile_dto.dart';
import '../../data/repositories/builder_profile_repository.dart';

class BuilderProfileController extends GetxController {
  final BuilderProfileRepository _repository = BuilderProfileRepositoryImpl();
  
  // Observables para el estado
  final Rx<BuilderProfileDto> _profile = BuilderProfileDto().obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isSaving = false.obs;
  final RxBool _isUploadingImage = false.obs;
  final RxString _errorMessage = ''.obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);
  
  // Getters
  BuilderProfileDto get profile => _profile.value;
  bool get isLoading => _isLoading.value;
  bool get isSaving => _isSaving.value;
  bool get isUploadingImage => _isUploadingImage.value;
  String get errorMessage => _errorMessage.value;
  File? get selectedImage => _selectedImage.value;
  
  // Método para actualizar el perfil
  void updateProfile(BuilderProfileDto newProfile) {
    _profile.value = newProfile;
  }
  
  // Método para actualizar campos específicos
  void updateFirstName(String firstName) {
    _profile.value = _profile.value.copyWith(firstName: firstName);
  }
  
  void updateLastName(String lastName) {
    _profile.value = _profile.value.copyWith(lastName: lastName);
  }
  
  void updateCompanyName(String companyName) {
    _profile.value = _profile.value.copyWith(companyName: companyName);
  }
  
  void updatePhone(String phone) {
    _profile.value = _profile.value.copyWith(phone: phone);
  }
  
  void updateEmail(String email) {
    _profile.value = _profile.value.copyWith(email: email);
  }
  
  void updateIndustry(String industry) {
    _profile.value = _profile.value.copyWith(industry: industry);
  }
  
  void updateCompanySize(String companySize) {
    _profile.value = _profile.value.copyWith(companySize: companySize);
  }
  
  void updateCompanyAddress(String companyAddress) {
    _profile.value = _profile.value.copyWith(companyAddress: companyAddress);
  }
  
  void updateCompanyPhone(String companyPhone) {
    _profile.value = _profile.value.copyWith(companyPhone: companyPhone);
  }
  
  void updateWebsite(String website) {
    _profile.value = _profile.value.copyWith(website: website);
  }
  
  void updateDescription(String description) {
    _profile.value = _profile.value.copyWith(description: description);
  }
  
  // Método para seleccionar imagen
  void setSelectedImage(File? image) {
    _selectedImage.value = image;
    if (image != null) {
      _profile.value = _profile.value.copyWith(profileImagePath: image.path);
    }
  }
  
  // Método para cargar perfil existente
  Future<void> loadProfile(String userId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final loadedProfile = await _repository.getBuilderProfile(userId);
      
      if (loadedProfile != null) {
        _profile.value = loadedProfile;
      }
    } catch (e) {
      _errorMessage.value = 'Error loading profile: $e';
      print('Error loading profile: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Método para guardar perfil
  Future<bool> saveProfile() async {
    try {
      _isSaving.value = true;
      _errorMessage.value = '';
      
      // Validar perfil antes de guardar
      if (!_profile.value.isValid) {
        _errorMessage.value = 'Please fill in all required fields';
        return false;
      }
      
      // Subir imagen si hay una seleccionada
      if (_selectedImage.value != null) {
        _isUploadingImage.value = true;
        final imageUploaded = await _repository.uploadProfileImage(_selectedImage.value!.path);
        _isUploadingImage.value = false;
        
        if (!imageUploaded) {
          _errorMessage.value = 'Failed to upload profile image';
          return false;
        }
      }
      
      // Guardar perfil
      final success = await _repository.saveBuilderProfile(_profile.value);
      
      if (success) {
        Get.snackbar(
          'Success',
          'Builder profile saved successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        _errorMessage.value = 'Failed to save profile';
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Error saving profile: $e';
      print('Error saving profile: $e');
      return false;
    } finally {
      _isSaving.value = false;
    }
  }
  
  // Método para actualizar perfil existente
  Future<bool> updateExistingProfile(String userId) async {
    try {
      _isSaving.value = true;
      _errorMessage.value = '';
      
      // Validar perfil antes de actualizar
      if (!_profile.value.isValid) {
        _errorMessage.value = 'Please fill in all required fields';
        return false;
      }
      
      // Subir imagen si hay una nueva seleccionada
      if (_selectedImage.value != null) {
        _isUploadingImage.value = true;
        final imageUploaded = await _repository.uploadProfileImage(_selectedImage.value!.path);
        _isUploadingImage.value = false;
        
        if (!imageUploaded) {
          _errorMessage.value = 'Failed to upload profile image';
          return false;
        }
      }
      
      // Actualizar perfil
      final success = await _repository.updateBuilderProfile(userId, _profile.value);
      
      if (success) {
        Get.snackbar(
          'Success',
          'Builder profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        _errorMessage.value = 'Failed to update profile';
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Error updating profile: $e';
      print('Error updating profile: $e');
      return false;
    } finally {
      _isSaving.value = false;
    }
  }
  
  // Método para eliminar perfil
  Future<bool> deleteProfile(String userId) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      
      final success = await _repository.deleteBuilderProfile(userId);
      
      if (success) {
        // Limpiar estado local
        _profile.value = BuilderProfileDto();
        _selectedImage.value = null;
        
        Get.snackbar(
          'Success',
          'Builder profile deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        _errorMessage.value = 'Failed to delete profile';
        return false;
      }
    } catch (e) {
      _errorMessage.value = 'Error deleting profile: $e';
      print('Error deleting profile: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
  
  // Método para limpiar errores
  void clearError() {
    _errorMessage.value = '';
  }
  
  // Método para resetear el estado
  void reset() {
    _profile.value = BuilderProfileDto();
    _selectedImage.value = null;
    _errorMessage.value = '';
    _isLoading.value = false;
    _isSaving.value = false;
    _isUploadingImage.value = false;
  }
  
  // Método para validar perfil
  bool get isProfileValid => _profile.value.isValid;
  
  // Método para obtener errores de validación
  List<String> get validationErrors => _profile.value.validationErrors;
}
