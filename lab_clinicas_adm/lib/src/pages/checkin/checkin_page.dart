import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_adm/src/pages/checkin/checkin_controller.dart';
import 'package:lab_clinicas_adm/src/pages/checkin/widgets/checkin_image_link.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../models/patient_information_form_model.dart';
import '../../shared/data_item.dart';

class CheckinPage extends StatefulWidget {
  const CheckinPage({super.key});

  @override
  State<CheckinPage> createState() => _CheckinPageState();
}

class _CheckinPageState extends State<CheckinPage> with MessageViewMixin {
  final controller = Injector.get<CheckinController>();

  @override
  void initState() {
    effect(() {
      if (controller.endProcess()) {
        Navigator.of(context).pushReplacementNamed('/end-checkin');
      }
    });
    messageListener(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var sizeOf = MediaQuery.sizeOf(context);
    final PatientInformationFormModel(
      :password,
      :patient,
      :medicalOrders,
      :healthInsuranceCard
    ) = controller.informationForm.watch(context)!;
    return Scaffold(
      appBar: LabClinicasAppBar(),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.all(40),
            margin: const EdgeInsets.only(top: 56),
            width: sizeOf.width * .5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Image.asset('assets/images/patient_avatar.png'),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'A senha chamada foi',
                  style: LabClinicasTheme.titleSmallStyle,
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: 218,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: LabClinicasTheme.orangeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    password,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: LabClinicasTheme.lightOrangeColor,
                      borderRadius: BorderRadius.circular(16)),
                  width: double.infinity,
                  child: Text(
                    'Cadastro',
                    style: LabClinicasTheme.subtitleSmallStyle.copyWith(
                      color: LabClinicasTheme.orangeColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                DataItem(
                  label: 'Nome do Paciente',
                  value: patient.name,
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
                DataItem(
                  label: 'E-mail',
                  value: patient.email,
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
                DataItem(
                  label: 'Telefone de Contato',
                  value: patient.phoneNumber,
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
                DataItem(
                  label: 'CPF',
                  value: patient.document,
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
                DataItem(
                  label: 'CEP',
                  value: patient.address.cep,
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
                DataItem(
                  label: 'Endereço',
                  value:
                      '${patient.address.streetAddress}, ${patient.address.number}, '
                      '${patient.address.addressComplement}, ${patient.address.district},'
                      '${patient.address.city}-${patient.address.state} ',
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
                DataItem(
                  label: 'Reponsável',
                  value: patient.guardian,
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
                DataItem(
                  label: 'Documento de Identificação',
                  value: patient.guardianIdentificationNumber,
                  padding: const EdgeInsets.only(
                    bottom: 24,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: LabClinicasTheme.lightOrangeColor,
                      borderRadius: BorderRadius.circular(16)),
                  width: double.infinity,
                  child: Text(
                    'Validar Imagens Exames',
                    style: LabClinicasTheme.subtitleSmallStyle.copyWith(
                      color: LabClinicasTheme.orangeColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CheckinImageLink(
                      label: 'Carteirinha',
                      image: healthInsuranceCard,
                    ),
                    Column(
                      children: [
                        for (final (index, medicalOrder)
                            in medicalOrders.indexed)
                          CheckinImageLink(
                            label: 'Pedido Médico ${index + 1}',
                            image: medicalOrder,
                          ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.endCheckin();
                    },
                    child: const Text('FINALIZAR ATENDIMENTO'),
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
