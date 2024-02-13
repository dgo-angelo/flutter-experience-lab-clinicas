import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import './documents_repository.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final RestClient _restClient;

  DocumentsRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;
  @override
  Future<Either<RepositoryException, String>> updloadImage(
      Uint8List file, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(file, filename: fileName),
      });

      final Response(data: {'url': pathImage}) = await _restClient.auth.post(
        '/uploads',
        data: formData,
      );
      return Right(pathImage);
    } on DioException catch (e, s) {
      log('Falha ao realizar upload do arquivo', error: e, stackTrace: s);
      return Left(
        RepositoryException(message: 'Falha ao realizar upload do arquivo'),
      );
    }
  }
}
