import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/self_service_model.dart';

import '../../models/patient_model.dart';
import './information_form_repository.dart';

class InformationFormRepositoryImpl implements InformationFormRepository {
  final RestClient _restClient;

  InformationFormRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;
  @override
  Future<Either<RepositoryException, Unit>> register(
      SelfServiceModel model) async {
    final SelfServiceModel(
      :firstName!,
      :lastName!,
      patient: PatientModel(id: patientId)!,
      documents: {
        DocumentType.healthInsuranceCard: List(
          first: healthInsuranceCardDocument
        ),
        DocumentType.medicalOrder: medicalOrdersDocuments,
      }!
    ) = model;

    try {
      await _restClient.auth.post('/patientInformationForm', data: {
        'patient_id': patientId,
        'health_insurance_card': healthInsuranceCardDocument,
        'medical_order': medicalOrdersDocuments,
        'password': '$firstName $lastName',
        'date_create': DateTime.now().toIso8601String(),
        'status': 'Waiting',
        'tests': [],
      });

      return Right(unit);
    } on DioException catch (e, s) {
      log(
        "Erro ao finalizar formulário de auto atendimento",
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(
            message: "Erro ao finalizar formulário de auto atendimento"),
      );
    }
  }
}
