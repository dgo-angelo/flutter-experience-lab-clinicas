import 'package:asyncstate/asyncstate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_core/src/theme/lab_clinicas_theme.dart';

class LabClinicasCoreConfig extends StatelessWidget {
  const LabClinicasCoreConfig({
    super.key,
    this.bindings,
    this.pages,
    this.pagesBuilders,
    this.didStart,
    this.modules,
    required this.title,
  });

  final ApplicationBindings? bindings;
  final List<FlutterGetItPageRouter>? pages;
  final List<FlutterGetItPageBuilder>? pagesBuilders;
  final List<FlutterGetItModule>? modules;
  final String title;
  final VoidCallback? didStart;
  @override
  Widget build(BuildContext context) {
    return FlutterGetIt(
      bindings: bindings,
      pages: [...pages ?? [], ...pagesBuilders ?? []],
      modules: modules,
      debugMode: kDebugMode,
      builder: (context, routes, flutterGetItNavObserver) {
        return AsyncStateBuilder(
          loader: LabClinicasLoader(),
          builder: (navigatorObserver) {
            if (didStart != null) {
              didStart!();
            }
            return MaterialApp(
              theme: LabClinicasTheme.lightTheme,
              darkTheme: LabClinicasTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              title: title,
              navigatorObservers: [
                navigatorObserver,
                flutterGetItNavObserver,
              ],
              routes: routes,
            );
          },
        );
      },
    );
  }
}
