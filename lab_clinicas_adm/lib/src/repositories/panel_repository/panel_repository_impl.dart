import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';

import './panel_repository.dart';

class PanelRepositoryImpl implements PanelRepository {
  final RestClient _restClient;

  PanelRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;
  @override
  Future<Either<RepositoryException, String>> callOnPanel(
      String password, String attendantDesk) async {
    const errorMessage = 'Falha ao chamar paciente no painel';
    try {
      final Response(data: {'id': String id}) =
          await _restClient.auth.post('/painelCheckin', data: {
        'password': password,
        'time_called': DateTime.now().toIso8601String(),
        'attendant_desk': attendantDesk
      });

      return Right(id);
    } on DioException catch (e, s) {
      log(errorMessage, error: e, stackTrace: s);
      return Left(RepositoryException(message: errorMessage));
    }
  }
}
