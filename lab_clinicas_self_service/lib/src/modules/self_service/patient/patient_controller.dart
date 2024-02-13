import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/patient_model.dart';
import 'package:lab_clinicas_self_service/src/repositories/patients/patient_repository.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PatientController with MessageStateMixin {
  final PatientRepository _patientRepository;
  PatientModel? patient;
  final _nextStep = signal<bool>(false);
  bool get nextStep => _nextStep();

  void goNextStep() {
    _nextStep.value = true;
  }

  PatientController({required PatientRepository patientRepository})
      : _patientRepository = patientRepository;
  Future<void> updateAndNext(PatientModel patient) async {
    final updateResult = await _patientRepository.update(patient);

    switch (updateResult) {
      case Left():
        showError("Falha ao atualizar dados do paciente, chame o atendente");
      case Right():
        showInfo("Dados do paciente atualizados com sucesso");
        this.patient = patient;
        goNextStep();
    }
  }

  Future<void> registerAndNext(RegisterPatientModel patient) async {
    final result = await _patientRepository.register(patient);

    switch (result) {
      case Left():
        showError("Falha ao cadastrar paciente, chame o atendente");
      case Right(value: final patient):
        showInfo("Paciente cadastrado com sucesso");
        this.patient = patient;
        goNextStep();
    }
  }
}
