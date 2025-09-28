import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/dto/post_job_dto.dart';

class PostJobController extends GetxController {
  final _postJobData = PostJobDto().obs;
  final _currentStep = 1.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;

  // Getters
  PostJobDto get postJobData => _postJobData.value;
  int get currentStep => _currentStep.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  // Step management
  void nextStep() {
    if (_currentStep.value < 9) { // 9 pasos totales
      _currentStep.value++;
    }
  }

  void previousStep() {
    if (_currentStep.value > 1) {
      _currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 9) {
      _currentStep.value = step;
    }
  }

  // Método para manejar navegación hacia atrás
  void handleBackNavigation() {
    if (_currentStep.value > 1) {
      _currentStep.value--;
    }
  }

  // Data management
  void updateSelectedSkill(String skill) {
    _postJobData.value = _postJobData.value.copyWith(selectedSkill: skill);
  }

  void updateJobTitle(String title) {
    _postJobData.value = _postJobData.value.copyWith(jobTitle: title);
  }

  void updateJobDescription(String description) {
    _postJobData.value = _postJobData.value.copyWith(jobDescription: description);
  }

  void updateJobLocation(String location) {
    _postJobData.value = _postJobData.value.copyWith(jobLocation: location);
  }

  void updateJobSiteId(String jobSiteId) {
    _postJobData.value = _postJobData.value.copyWith(jobSiteId: jobSiteId);
  }

  void updateWorkersNeeded(int workers) {
    _postJobData.value = _postJobData.value.copyWith(workersNeeded: workers);
  }

  void updateHourlyRate(double rate) {
    _postJobData.value = _postJobData.value.copyWith(hourlyRate: rate);
  }

  void updateSiteAllowance(double allowance) {
    _postJobData.value = _postJobData.value.copyWith(siteAllowance: allowance);
  }

  void updateLeadingHandAllowance(double allowance) {
    _postJobData.value = _postJobData.value.copyWith(leadingHandAllowance: allowance);
  }

  void updateProductivityAllowance(double allowance) {
    _postJobData.value = _postJobData.value.copyWith(productivityAllowance: allowance);
  }

  void updateOvertimeRate(double rate) {
    _postJobData.value = _postJobData.value.copyWith(overtimeRate: rate);
  }

  void updateTravelAllowance(double allowance) {
    _postJobData.value = _postJobData.value.copyWith(travelAllowance: allowance);
  }

  void updateStartDate(DateTime date) {
    _postJobData.value = _postJobData.value.copyWith(startDate: date);
  }

  void updateEndDate(DateTime? date) {
    _postJobData.value = _postJobData.value.copyWith(endDate: date);
  }

  void updateStartTime(TimeOfDay time) {
    _postJobData.value = _postJobData.value.copyWith(startTime: time);
  }

  void updateEndTime(TimeOfDay time) {
    _postJobData.value = _postJobData.value.copyWith(endTime: time);
  }

  void updateJobType(String jobType) {
    _postJobData.value = _postJobData.value.copyWith(jobType: jobType);
  }

  void updateIsOngoingWork(bool isOngoing) {
    _postJobData.value = _postJobData.value.copyWith(isOngoingWork: isOngoing);
  }

  void updateWorkOnSaturdays(bool workOnSaturdays) {
    _postJobData.value = _postJobData.value.copyWith(workOnSaturdays: workOnSaturdays);
  }

  void updateWorkOnSundays(bool workOnSundays) {
    _postJobData.value = _postJobData.value.copyWith(workOnSundays: workOnSundays);
  }

  void updateRequirements(List<String> requirements) {
    _postJobData.value = _postJobData.value.copyWith(requirements: requirements);
  }

  void updatePayDay(DateTime payDay) {
    _postJobData.value = _postJobData.value.copyWith(payDay: payDay);
  }

  void updatePaymentFrequency(String frequency) {
    _postJobData.value = _postJobData.value.copyWith(paymentFrequency: frequency);
  }

  void updateRequiresSupervisorSignature(bool requires) {
    _postJobData.value = _postJobData.value.copyWith(requiresSupervisorSignature: requires);
  }

  void updateSupervisorName(String name) {
    _postJobData.value = _postJobData.value.copyWith(supervisorName: name);
  }

  void updateIsPublic(bool isPublic) {
    _postJobData.value = _postJobData.value.copyWith(isPublic: isPublic);
  }

  // Validation
  bool isStep1Valid() {
    return _postJobData.value.selectedSkill != null && 
           _postJobData.value.selectedSkill!.isNotEmpty;
  }

  bool isStep2Valid() {
    return _postJobData.value.workersNeeded != null && 
           _postJobData.value.workersNeeded! > 0;
  }

  bool isStep3Valid() {
    return _postJobData.value.hourlyRate != null && 
           _postJobData.value.hourlyRate! > 0;
  }

  bool isStep4Valid() {
    // Si es trabajo continuo, solo necesita fecha de inicio
    if (_postJobData.value.isOngoingWork == true) {
      return _postJobData.value.startDate != null;
    }
    // Si no es trabajo continuo, necesita fecha de inicio y fin
    return _postJobData.value.startDate != null && _postJobData.value.endDate != null;
  }

  bool isStep5Valid() {
    return _postJobData.value.startTime != null && 
           _postJobData.value.endTime != null &&
           _postJobData.value.jobType != null &&
           _postJobData.value.jobType!.isNotEmpty;
  }

  bool isStep6Valid() {
    return _postJobData.value.requirements != null && 
           _postJobData.value.requirements!.isNotEmpty;
  }

  bool isStep7Valid() {
    // Debe tener una frecuencia de pago seleccionada
    return _postJobData.value.paymentFrequency != null && 
           _postJobData.value.paymentFrequency!.isNotEmpty;
  }

  bool isStep8Valid() {
    // Debe tener una opción seleccionada
    if (_postJobData.value.requiresSupervisorSignature == null) {
      return false;
    }
    // Si requiere firma del supervisor, debe tener un nombre
    if (_postJobData.value.requiresSupervisorSignature == true) {
      return _postJobData.value.supervisorName != null && 
             _postJobData.value.supervisorName!.trim().isNotEmpty;
    }
    return true;
  }

  bool canProceedToNextStep() {
    switch (_currentStep.value) {
      case 1:
        return isStep1Valid();
      case 2:
        return isStep2Valid();
      case 3:
        return isStep3Valid();
      case 4:
        return isStep4Valid();
      case 5:
        return isStep5Valid();
      case 6:
        return isStep6Valid();
      case 7:
        return isStep7Valid();
      case 8:
        return isStep8Valid();
      default:
        return false;
    }
  }

  // Job posting
  Future<void> postJob() async {
    if (!canProceedToNextStep()) {
      _errorMessage.value = ' all required fields';
      return;
    }

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // TODO: Implement actual API call to post job
      await Future.delayed(Duration(seconds: 2)); // Simulate API call
      
      // Success - reset data
      reset();
      
    } catch (e) {
      _errorMessage.value = 'Error posting job: ${e.toString()}';
    } finally {
      _isLoading.value = false;
    }
  }

  // Reset
  void reset() {
    _postJobData.value = PostJobDto();
    _currentStep.value = 1;
    _errorMessage.value = '';
  }

  // Clear error
  void clearError() {
    _errorMessage.value = '';
  }

  @override
  void onClose() {
    // Clean up if needed
    super.onClose();
  }
}
