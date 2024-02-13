import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';

class LabClinicasSelfServiceAppBar extends LabClinicasAppBar {
  LabClinicasSelfServiceAppBar({super.key})
      : super(
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 1,
                    onTap: () async {
                      Injector.get<SelfServiceController>().restartProcess();
                    },
                    child: const Text('Reiniciar processo'),
                  )
                ];
              },
              child: const IconPopupMenuWidget(),
            )
          ],
        );
}
