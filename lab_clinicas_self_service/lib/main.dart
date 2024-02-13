import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/auth/auth_module.dart';
import 'package:lab_clinicas_self_service/src/modules/home/home_module.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_module.dart';
import 'package:lab_clinicas_self_service/src/pages/splash_page/splash_page.dart';

import 'src/binding/lab_clinicas_application_binding.dart';

List<CameraDescription> _cameras = <CameraDescription>[];

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();

    runApp(const LabClinicasSelfServiceApp());
  }, (error, stack) {
    log(
      'Erro não esperado',
      error: error,
      stackTrace: stack,
    );
  });
}

class LabClinicasSelfServiceApp extends StatelessWidget {
  const LabClinicasSelfServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LabClinicasCoreConfig(
      title: "Lab Clinicas Auto Atendimento",
      bindings: LabClinicasApplicationBinding(),
      pagesBuilders: [
        FlutterGetItPageBuilder(
          page: (_) => const SplashPage(),
          path: "/",
        ),
      ],
      modules: [
        AuthModule(),
        HomeModule(),
        SelfServiceModule(),
      ],
      didStart: () {
        FlutterGetItBindingRegister.registerPermanentBinding(
          'CAMERAS',
          [
            Bind.lazySingleton((i) => _cameras),
          ],
        );
      },
    );
  }
}
