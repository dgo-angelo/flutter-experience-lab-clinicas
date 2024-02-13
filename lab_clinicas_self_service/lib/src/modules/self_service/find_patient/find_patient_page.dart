import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/find_patient/find_patient_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/widgets/lab_clinicas_self_service_app_bar.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class FindPatientPage extends StatefulWidget {
  const FindPatientPage({super.key});

  @override
  State<FindPatientPage> createState() => _FindPatientPageState();
}

class _FindPatientPageState extends State<FindPatientPage>
    with MessageViewMixin {
  final _documentEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Injector.get<FindPatientController>();

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      final FindPatientController(:patient, :patientNotFound) = controller;

      if (patient != null || patientNotFound != null) {
        Injector.get<SelfServiceController>().goToFormPatient(patient);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _documentEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: LabClinicasSelfServiceAppBar(),
        body: LayoutBuilder(
          builder: (_, constrains) {
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(minHeight: constrains.maxHeight),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background_login.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    constraints:
                        BoxConstraints(maxWidth: constrains.maxWidth * .8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Image.asset('assets/images/logo_vertical.png'),
                          const SizedBox(
                            height: 48,
                          ),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              CpfInputFormatter(),
                            ],
                            controller: _documentEC,
                            validator: Validatorless.multiple([
                              Validatorless.required('CPF é obrigatório'),
                              // Validatorless.cpf('CPF inválido')
                            ]),
                            decoration: const InputDecoration(
                              label: Text('Digite o CPF do Paciente'),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Não sabe o CPF do paciente?",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LabClinicasTheme.blueColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  controller.continueWithoutDocument();
                                },
                                child: const Text(
                                  'Clique aqui',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: LabClinicasTheme.orangeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .8,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                final valid =
                                    _formKey.currentState?.validate() ?? false;

                                if (valid) {
                                  controller
                                      .findPatientByDocument(_documentEC.text);
                                }
                              },
                              child: const Text('CONTINUAR'),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
