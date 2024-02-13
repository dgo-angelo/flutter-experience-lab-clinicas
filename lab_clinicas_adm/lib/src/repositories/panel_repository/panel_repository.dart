import 'package:lab_clinicas_core/lab_clinicas_core.dart';

abstract interface class PanelRepository {
  Future<Either<RepositoryException, String>> callOnPanel(
      String password, String attendantDesk);
}
