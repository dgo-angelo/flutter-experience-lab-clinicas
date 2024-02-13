import 'package:asyncstate/asyncstate.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:lab_clinicas_self_service/src/models/patient_model.dart';
import 'package:lab_clinicas_self_service/src/models/self_service_model.dart';
import 'package:lab_clinicas_self_service/src/repositories/information_form/information_form_repository.dart';

enum FormSteps { none, whoIAm, findPatient, patient, documents, done, restart }

class SelfServiceController with MessageStateMixin {
  final InformationFormRepository informationFormRepository;
  SelfServiceController({
    required this.informationFormRepository,
  });

  final _step = ValueSignal(FormSteps.none);
  FormSteps get step => _step();

  var _model = const SelfServiceModel();
  var password = '';
  SelfServiceModel get model => _model;

  void startProcess() {
    _step.forceUpdate(FormSteps.whoIAm);
  }

  void setWhoIAmDataStepAndNext(String firstName, String lastName) {
    _model = _model.copyWith(
      firstName: () => firstName,
      lastName: () => lastName,
    );

    _step.forceUpdate(FormSteps.findPatient);
  }

  void clearForm() {
    _model = _model.clear();
  }

  void goToFormPatient(PatientModel? patient) {
    _model = _model.copyWith(patient: () => patient);
    _step.forceUpdate(FormSteps.patient);
  }

  void restartProcess() {
    _step.forceUpdate(FormSteps.restart);
    clearForm();
  }

  void updatePatientAndGoDocument(PatientModel? patient) {
    _model = _model.copyWith(patient: () => patient);
    _step.forceUpdate(FormSteps.documents);
  }

  void registerDocument(DocumentType type, String filePath) {
    final documents = _model.documents ?? {};

    if (type == DocumentType.healthInsuranceCard) {
      documents[type]?.clear();
    }
    final values = documents[type] ?? [];
    values.add(filePath);
    documents[type] = values;

    _model = _model.copyWith(documents: () => documents);
  }

  void clearDocuments() {
    _model = _model.copyWith(documents: () => {});
  }

  Future<void> completeRegistration() async {
    final result =
        await informationFormRepository.register(model).asyncLoader();

    switch (result) {
      case Left():
        showError("Erro ao finalizar formulário de auto atendimento");
      case Right():
        password = '${_model.firstName} ${_model.lastName}';
        _step.forceUpdate(FormSteps.done);
    }
  }
}
