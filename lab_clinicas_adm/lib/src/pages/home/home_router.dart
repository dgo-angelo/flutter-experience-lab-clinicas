import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_adm/src/pages/home/home_controller.dart';
import 'package:lab_clinicas_adm/src/pages/home/home_page.dart';

class HomeRouter extends FlutterGetItPageRouter {
  const HomeRouter({super.key});

  @override
  List<Bind<Object>> get bindings => [
        Bind.lazySingleton<HomeController>(
          (i) => HomeController(
            attendantDeskAssignmentRepository: i(),
            callNextPatientService: i(),
          ),
        ),
      ];

  @override
  String get routeName => '/home';

  @override
  WidgetBuilder get view => (context) => const HomePage();
}
