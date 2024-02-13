import 'dart:typed_data';

import 'package:asyncstate/asyncstate.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import 'package:lab_clinicas_self_service/src/repositories/documents/documents_repository.dart';

class DocumentsScanConfirmController with MessageStateMixin {
  final pathRemoteStorage = signal<String?>(null);

  final DocumentsRepository documentsRepository;
  DocumentsScanConfirmController({
    required this.documentsRepository,
  });

  Future<void> uploadImage(Uint8List imageBytes, String fileName) async {
    final result = await documentsRepository
        .updloadImage(imageBytes, fileName)
        .asyncLoader();

    switch (result) {
      case Right(value: final pathFile):
        pathRemoteStorage.value = pathFile;
      case Left():
        showError("Erro ao realizar upload da imagem");
        return;
    }
  }
}
