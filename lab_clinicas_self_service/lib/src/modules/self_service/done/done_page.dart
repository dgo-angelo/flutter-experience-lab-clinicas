import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';

class DonePage extends StatelessWidget {
  final selfServiceController = Injector.get<SelfServiceController>();
  DonePage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: sizeOf.width * .8,
            margin: const EdgeInsets.only(top: 18),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: LabClinicasTheme.orangeColor,
              ),
            ),
            child: Column(
              children: [
                Image.asset('assets/images/stroke_check.png'),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'SUA SENHA',
                  style: LabClinicasTheme.titleSmallStyle,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  constraints:
                      const BoxConstraints(minHeight: 48, minWidth: 218),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 186, 97),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Text(
                    textAlign: TextAlign.center,
                    selfServiceController.password,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    style: TextStyle(
                      color: LabClinicasTheme.blueColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "AGUARDE\n",
                      ),
                      TextSpan(text: "Sua senha será chamada no painel"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {},
                        child: const Text("IMPRIMIR SENHA"),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size.fromHeight(48),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "ENVIAR SENHA VIA SMS",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      selfServiceController.restartProcess();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: LabClinicasTheme.orangeColor,
                      fixedSize: const Size.fromHeight(48),
                    ),
                    child: const Text(
                      "FINALIZAR",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
