import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_adm/src/pages/home/home_controller.dart';

import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with MessageViewMixin {
  final _terminalNumberEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final homeController = Injector.get<HomeController>();

  @override
  void initState() {
    effect(() {
      if (homeController.informationForm != null) {
        Navigator.of(context).pushReplacementNamed('/pre-checkin',
            arguments: homeController.informationForm);
      }
    });
    messageListener(homeController);
    super.initState();
  }

  @override
  void dispose() {
    _terminalNumberEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: LabClinicasAppBar(),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          width: sizeOf.width * .4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: LabClinicasTheme.orangeColor),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Bem-vindo!",
                  style: LabClinicasTheme.titleStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "Preencha o número do guichê que você está atendendo",
                  style: LabClinicasTheme.subtitleSmallStyle,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: Validatorless.multiple(
                    [
                      Validatorless.required('Número do guichê é obrigatório'),
                      Validatorless.number('Informe apenas números'),
                    ],
                  ),
                  decoration: const InputDecoration(
                    label: Text('Número do guichê'),
                  ),
                  controller: _terminalNumberEC,
                ),
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final valid = _formKey.currentState?.validate() ?? false;

                      if (valid) {
                        homeController.startService(
                          _terminalNumberEC.text,
                        );
                      }
                    },
                    child: const Text('CHAMAR PRÓXIMO PACIENTE'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
