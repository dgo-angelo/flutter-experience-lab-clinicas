import 'dart:developer';

import 'package:lab_clinicas_adm/src/models/patient_information_form_model.dart';
import 'package:lab_clinicas_adm/src/repositories/attendant_desk_assignment/attendant_desk_assignment_repository.dart';
import 'package:lab_clinicas_adm/src/repositories/panel_repository/panel_repository.dart';
import 'package:lab_clinicas_adm/src/repositories/patient_information_form/patient_information_form_repository.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';

class CallNextPatientService {
  final PatientInformationFormRepository _patientInformationFormRepository;
  final AttendantDeskAssignmentRepository _attendantDeskAssignmentRepository;
  final PanelRepository _panelRepository;

  CallNextPatientService({
    required PatientInformationFormRepository patientInformationFormRepository,
    required AttendantDeskAssignmentRepository
        attendantDeskAssignmentRepository,
    required PanelRepository panelRepository,
  })  : _patientInformationFormRepository = patientInformationFormRepository,
        _attendantDeskAssignmentRepository = attendantDeskAssignmentRepository,
        _panelRepository = panelRepository;

  Future<Either<RepositoryException, PatientInformationFormModel?>>
      execute() async {
    final result = await _patientInformationFormRepository.callNextToCheckin();

    switch (result) {
      case Left(value: final exception):
        return Left(exception);
      case Right(value: final form?):
        return updatePanel(form);
      case Right():
        return Right(null);
    }
  }

  Future<Either<RepositoryException, PatientInformationFormModel?>> updatePanel(
      PatientInformationFormModel form) async {
    final resultDesk =
        await _attendantDeskAssignmentRepository.getDeskAssingment();

    const errorMessage = 'ATENÇÃO !! Não foi possível chamar o paciente. ';

    switch (resultDesk) {
      case Left(value: final exception):
        return Left(exception);
      case Right(value: final deskNumber):
        final panelResult =
            await _panelRepository.callOnPanel(form.password, deskNumber);
        switch (panelResult) {
          case Left(value: final exception):
            log(
              errorMessage,
              error: exception,
              stackTrace: StackTrace.fromString(errorMessage),
            );
            return Right(form);
          case Right():
            return Right(form);
        }
    }
  }
}
