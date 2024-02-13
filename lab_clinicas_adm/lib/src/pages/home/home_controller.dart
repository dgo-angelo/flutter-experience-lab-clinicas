import 'package:asyncstate/asyncstate.dart' as asyncstate;
import 'package:lab_clinicas_adm/src/models/patient_information_form_model.dart';
import 'package:lab_clinicas_adm/src/repositories/attendant_desk_assignment/attendant_desk_assignment_repository.dart';
import 'package:lab_clinicas_adm/src/services/call_next_patient/call_next_patient_service.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

class HomeController with MessageStateMixin {
  final AttendantDeskAssignmentRepository _attendantDeskAssignmentRepository;
  final CallNextPatientService _callNextPatientService;
  final _informationForm = signal<PatientInformationFormModel?>(null);
  PatientInformationFormModel? get informationForm => _informationForm();

  HomeController({
    required AttendantDeskAssignmentRepository
        attendantDeskAssignmentRepository,
    required CallNextPatientService callNextPatientService,
  })  : _attendantDeskAssignmentRepository = attendantDeskAssignmentRepository,
        _callNextPatientService = callNextPatientService;

  Future<void> startService(String deskNumber) async {
    asyncstate.AsyncState.show();
    final result =
        await _attendantDeskAssignmentRepository.startService(deskNumber);

    switch (result) {
      case Left():
        asyncstate.AsyncState.hide();
        showError('Erro ao iniciar guichê');
      case Right():
        final resultNextPatient = await _callNextPatientService.execute();

        switch (resultNextPatient) {
          case Left():
            showError('Erro ao chamar o próximo paciente');
          case Right(value: final form?):
            asyncstate.AsyncState.hide();
            _informationForm.value = form;
          case Right(value: _):
            asyncstate.AsyncState.hide();
            showInfo('Nenhum paciente aguardando.');
        }
    }
  }
}
