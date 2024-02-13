import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lab_clinicas_adm/src/repositories/attendant_desk_assignment/attendant_desk_assignment_repository.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';

class AttendantDeskAssignmentRepositoryImpl
    implements AttendantDeskAssignmentRepository {
  final RestClient _restClient;

  AttendantDeskAssignmentRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;
  @override
  Future<Either<RepositoryException, Unit>> startService(
      String deskNumber) async {
    try {
      final result = await _clearDeskByUser();

      switch (result) {
        case Right():
          await _restClient.auth.post('/attendantDeskAssignment', data: {
            "user_id": "#userAuthRef",
            "desk_number": deskNumber,
            'date_created': DateTime.now().toIso8601String(),
            "status": "Available"
          });
          return Right(unit);
        case Left(value: final exception):
          return Left(exception);
      }
    } on DioException catch (e, s) {
      log('Falha ao iniciar serviço', error: e, stackTrace: s);

      return Left(
        RepositoryException(message: 'Falha ao iniciar serviço'),
      );
    }
  }

  Future<Either<RepositoryException, Unit>> _clearDeskByUser() async {
    try {
      final desk = await _getDeskByUser();

      if (desk != null) {
        await _restClient.auth.delete(
          '/attendantDeskAssignment/${desk.id}',
        );
      }

      return Right(unit);
    } on DioException catch (e, s) {
      log('Falha ao deletar número do guichê', error: e, stackTrace: s);

      return Left(
        RepositoryException(message: 'Falha ao deletar número do guichê'),
      );
    }
  }

  Future<({String id, String deskNumber})?> _getDeskByUser() async {
    final Response(:List data) = await _restClient.auth.get(
      '/attendantDeskAssignment',
      queryParameters: {
        'user_id': '#userAuthRef',
      },
    );

    if (data
        case List(
          isNotEmpty: true,
          first: {'id': String id, 'desk_number': String deskNumber},
        )) {
      return (
        id: id,
        deskNumber: deskNumber,
      );
    }

    return null;
  }

  @override
  Future<Either<RepositoryException, String>> getDeskAssingment() async {
    try {
      final Response(data: List(first: data)) = await _restClient.auth.get(
        '/attendantDeskAssignment',
        queryParameters: {
          'user_id': '#userAuthRef',
        },
      );

      return Right(data['desk_number']);
    } on DioException catch (e, s) {
      log(
        'Erro ao buscar número do guichê',
        error: e,
        stackTrace: s,
      );
      return Left(
        RepositoryException(message: 'Erro ao buscar número do guichê'),
      );
    }
  }
}
