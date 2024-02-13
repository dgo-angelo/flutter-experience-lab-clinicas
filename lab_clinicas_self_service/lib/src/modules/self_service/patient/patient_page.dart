import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patient/patient_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/patient/patient_form_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/widgets/lab_clinicas_self_service_app_bar.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

import '../../../models/self_service_model.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage>
    with PatientFormController, MessageViewMixin {
  final formKey = GlobalKey<FormState>();
  final selfServiceController = Injector.get<SelfServiceController>();
  final controller = Injector.get<PatientController>();

  late bool patientFound;
  late bool enableForm;

  @override
  void initState() {
    messageListener(controller);
    final SelfServiceModel(:patient) = selfServiceController.model;

    patientFound = patient != null;
    enableForm = !patientFound;
    initializeForm(patient);

    effect(() {
      if (controller.nextStep) {
        selfServiceController.updatePatientAndGoDocument(controller.patient);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    disposeForm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: LabClinicasSelfServiceAppBar(),
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
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Visibility(
                    visible: patientFound,
                    replacement: Image.asset('assets/images/lupa_icon.png'),
                    child: Image.asset('assets/images/check_icon.png'),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    patientFound
                        ? 'Cadastro encontrado'
                        : 'Cadastro não encontrado',
                    style: LabClinicasTheme.titleSmallStyle,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text(
                    patientFound
                        ? 'Confirme os dados do seu cadastro.'
                        : 'Preencha o formulário abaixo para efetuar o seu cadastro.',
                    style: const TextStyle(
                      color: LabClinicasTheme.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    validator: Validatorless.required('Nome é obrigatório'),
                    controller: nameEC,
                    decoration: const InputDecoration(
                      label: Text('Nome Paciente'),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    validator: Validatorless.multiple(
                      [
                        Validatorless.required('E-mail é obrigatório'),
                        Validatorless.email('E-mail inválido'),
                      ],
                    ),
                    controller: emailEC,
                    decoration: const InputDecoration(
                      label: Text('E-mail'),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    validator: Validatorless.required('Telefone é obrigatório'),
                    controller: phoneEC,
                    decoration: const InputDecoration(
                      label: Text('Telefone de contato'),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    validator: Validatorless.required('CPF é obrigatório'),
                    controller: documentEC,
                    decoration: const InputDecoration(
                      label: Text('CPF'),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CepInputFormatter(),
                    ],
                    validator: Validatorless.required('CEP é obrigatório'),
                    controller: cepEC,
                    decoration: const InputDecoration(
                      label: Text('CEP'),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: TextFormField(
                          readOnly: !enableForm,
                          validator:
                              Validatorless.required('Endereço é obrigatório'),
                          controller: streetEC,
                          decoration: const InputDecoration(
                            label: Text('Endereço'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          readOnly: !enableForm,
                          validator:
                              Validatorless.required('Numero é obrigatório'),
                          controller: numberEC,
                          decoration: const InputDecoration(
                            label: Text('Número'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          controller: complementEC,
                          decoration: const InputDecoration(
                            label: Text('Complemento'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          validator:
                              Validatorless.required('Estado é obrigatório'),
                          controller: stateEC,
                          decoration: const InputDecoration(
                            label: Text('Estado'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          validator:
                              Validatorless.required('Cidade é obrigatório'),
                          controller: cityEC,
                          decoration: const InputDecoration(
                            label: Text('Cidade'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextFormField(
                          readOnly: !enableForm,
                          validator:
                              Validatorless.required('Bairro é obrigatório'),
                          controller: districtEC,
                          decoration: const InputDecoration(
                            label: Text('Bairro'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    controller: guardianEC,
                    decoration: const InputDecoration(
                      label: Text('Responsável'),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    readOnly: !enableForm,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: guardianIdentificationNumberEC,
                    decoration: const InputDecoration(
                      label: Text('Responsável  identificação'),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Visibility(
                    visible: !enableForm,
                    replacement: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final valid =
                              formKey.currentState?.validate() ?? false;

                          if (valid) {
                            if (patientFound) {
                              controller.updateAndNext(
                                updatePatient(
                                  selfServiceController.model.patient!,
                                ),
                              );
                            } else {
                              controller
                                  .registerAndNext(createPatientRegister());
                            }
                          }
                        },
                        child: Visibility(
                          visible: !patientFound,
                          replacement: const Text('SALVAR E CONTINUAR'),
                          child: const Text('CADASTRAR'),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  enableForm = true;
                                });
                              },
                              child: const Text('EDITAR'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 17,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.patient =
                                    selfServiceController.model.patient;
                                controller.goNextStep();
                              },
                              child: const Text('CONTINUAR'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
