import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/models/self_service_model.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/widgets/document_box_widget.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/widgets/lab_clinicas_self_service_app_bar.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with MessageViewMixin {
  final selfServiceController = Injector.get<SelfServiceController>();

  @override
  void initState() {
    super.initState();
    messageListener(selfServiceController);
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    final documents = selfServiceController.model.documents;
    final totalHealhInsuranceCard =
        documents?[DocumentType.healthInsuranceCard]?.length ?? 0;
    final totalMedicalOrder =
        documents?[DocumentType.medicalOrder]?.length ?? 0;
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
            child: Column(
              children: [
                Image.asset('assets/images/folder.png'),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'ADICIONAR DOCUMENTOS',
                  style: LabClinicasTheme.titleSmallStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  'Selecione o documento que deseja fotografar.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: LabClinicasTheme.blueColor,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: sizeOf.width * .8,
                  height: 241,
                  child: Row(
                    children: [
                      DocumentBoxWidget(
                        onTap: () async {
                          final filePath = await Navigator.of(context)
                              .pushNamed('/self-service/document/scan');
                          if (filePath != null && filePath != '') {
                            selfServiceController.registerDocument(
                              DocumentType.healthInsuranceCard,
                              filePath.toString(),
                            );

                            setState(() {});
                          }
                        },
                        uploaded: totalHealhInsuranceCard > 0,
                        icon: Image.asset('assets/images/id_card.png'),
                        label: 'CARTEIRINHA',
                        totalFiles: totalHealhInsuranceCard,
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      DocumentBoxWidget(
                        onTap: () async {
                          final filePath = await Navigator.of(context)
                              .pushNamed('/self-service/document/scan');
                          if (filePath != null && filePath != '') {
                            selfServiceController.registerDocument(
                              DocumentType.medicalOrder,
                              filePath.toString(),
                            );

                            setState(() {});
                          }
                        },
                        uploaded: totalMedicalOrder > 0,
                        icon: Image.asset('assets/images/document.png'),
                        label: 'PEDIDO MÉDICO',
                        totalFiles: totalMedicalOrder,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Visibility(
                  visible: totalMedicalOrder > 0 && totalHealhInsuranceCard > 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            selfServiceController.clearDocuments();
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            fixedSize: const Size.fromHeight(48),
                            foregroundColor: Colors.red,
                          ),
                          child: const Text(
                            'REMOVER TODOS',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await selfServiceController.completeRegistration();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: LabClinicasTheme.orangeColor,
                            fixedSize: const Size.fromHeight(48),
                          ),
                          child: const Text('FINALIZAR'),
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
    );
  }
}
