import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/patient_model.dart';

import './patient_repository.dart';

class PatientRepositoryImpl implements PatientRepository {
  final RestClient restClient;

  PatientRepositoryImpl({required this.restClient});
  @override
  Future<Either<RepositoryException, PatientModel?>> findPatientByDocument(
      String document) async {
    try {
      final Response(:List data) = await restClient.auth.get(
        '/patients',
        queryParameters: {"document": document},
      );

      if (data.isEmpty) {
        return Right(null);
      }

      return Right(PatientModel.fromJson(data.first));
    } on DioException catch (e, s) {
      log('Falha ao buscar paciente por cpf', error: e, stackTrace: s);
      return Left(
          RepositoryException(message: 'Falha ao buscar paciente por cpf'));
    }
  }

  @override
  Future<Either<RepositoryException, Unit>> update(PatientModel patient) async {
    try {
      await restClient.auth.put(
        '/patients/${patient.id}',
        data: patient.toJson(),
      );

      return Right(unit);
    } on DioException catch (e, s) {
      log('Falha ao atualizar paciente', error: e, stackTrace: s);
      return Left(RepositoryException(message: 'Falha ao atualizar paciente'));
    }
  }

  @override
  Future<Either<RepositoryException, PatientModel>> register(
      RegisterPatientModel model) async {
    try {
      final Response(:data) = await restClient.auth.post(
        '/patients',
        data: {
          "name": model.name,
          "email": model.email,
          "phone_number": model.phoneNumber,
          "document": model.document,
          "address": {
            "cep": model.address.cep,
            "street_address": model.address.streetAddress,
            "number": model.address.number,
            "address_complement": model.address.addressComplement,
            "state": model.address.state,
            "city": model.address.city,
            "district": model.address.district
          },
          "guardian": model.guardian,
          "guardian_identification_number": model.guardianIdentificationNumber
        },
      );

      return Right(PatientModel.fromJson(data));
    } on DioException catch (e, s) {
      log('Falha ao cadastrar paciente', error: e, stackTrace: s);
      return Left(RepositoryException(message: 'Falha ao cadastrar paciente'));
    }
  }
}
