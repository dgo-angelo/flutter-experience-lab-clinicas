import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/documents/scan_confirm/documents_scan_confirm_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../widgets/lab_clinicas_self_service_app_bar.dart';

class DocumentsScanConfirmPage extends StatelessWidget {
  DocumentsScanConfirmPage({super.key});

  final controller = Injector.get<DocumentsScanConfirmController>();

  @override
  Widget build(BuildContext context) {
    final photo = ModalRoute.of(context)!.settings.arguments as XFile;
    final sizeOf = MediaQuery.sizeOf(context);

    controller.pathRemoteStorage.listen(context, () {
      Navigator.of(context).pop();
      Navigator.of(context).pop(controller.pathRemoteStorage.value);
    });
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
                Image.asset('assets/images/foto_confirm_icon.png'),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'CONFIRA SUA FOTO',
                  style: LabClinicasTheme.titleSmallStyle,
                ),
                const SizedBox(
                  height: 32,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: sizeOf.width * .5,
                    child: DottedBorder(
                      dashPattern: const [1, 10, 1, 3],
                      radius: const Radius.circular(16),
                      color: LabClinicasTheme.orangeColor,
                      borderType: BorderType.RRect,
                      strokeCap: StrokeCap.square,
                      strokeWidth: 4,
                      child: Image.file(
                        File(photo.path),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size.fromHeight(48),
                        ),
                        child: const Text('TIRAR OUTRA'),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final imageBytes = await photo.readAsBytes();
                          final fileName = photo.name;
                          await controller.uploadImage(imageBytes, fileName);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LabClinicasTheme.blueColor,
                          fixedSize: const Size.fromHeight(48),
                        ),
                        child: const Text('SALVAR'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
