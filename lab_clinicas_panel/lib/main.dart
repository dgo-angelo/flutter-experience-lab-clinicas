import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_panel/src/bindings/lab_clinicas_panel_application_binding.dart';
import 'package:lab_clinicas_panel/src/pages/login/login_router.dart';
import 'package:lab_clinicas_panel/src/pages/panel/panel_router.dart';
import 'package:lab_clinicas_panel/src/pages/splash/splash_page.dart';

void main() {
  runApp(const LabClinicasPanelApp());
}

class LabClinicasPanelApp extends StatelessWidget {
  const LabClinicasPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LabClinicasCoreConfig(
      title: 'Lab Clinicas Panel',
      bindings: LabClinicasPanelApplicationBinding(),
      pagesBuilders: [
        FlutterGetItPageBuilder(
          page: (_) => const SplashPage(),
          path: "/",
        ),
      ],
      pages: const [
        LoginRouter(),
        PanelRouter(),
      ],
    );
  }
}
