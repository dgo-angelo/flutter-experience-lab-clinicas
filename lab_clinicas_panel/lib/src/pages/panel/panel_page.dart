import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_panel/src/models/panel_checkin_model.dart';
import 'package:lab_clinicas_panel/src/pages/panel/panel_controller.dart';
import 'package:lab_clinicas_panel/src/pages/panel/widgets/main_panel_widget.dart';
import 'package:lab_clinicas_panel/src/pages/panel/widgets/password_tile_widget.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PanelPage extends StatefulWidget {
  const PanelPage({super.key});

  @override
  State<PanelPage> createState() => _PanelPageState();
}

class _PanelPageState extends State<PanelPage> {
  final controller = Injector.get<PanelController>();

  @override
  void initState() {
    controller.listenerPanel();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PanelCheckinModel? current;
    final PanelCheckinModel? lastCall;
    final List<PanelCheckinModel>? others;

    final listPanel = controller.panelData.watch(context);

    current = listPanel.firstOrNull;
    if (listPanel.isNotEmpty) {
      listPanel.removeAt(0);
    }

    lastCall = listPanel.firstOrNull;
    if (listPanel.isNotEmpty) {
      listPanel.removeAt(0);
    }

    others = listPanel;

    return Scaffold(
      appBar: LabClinicasAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                lastCall != null
                    ? SizedBox(
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: MainPanelWidget(
                          passwordLabel: 'Senha anterior',
                          password: lastCall.password,
                          deskNumber: lastCall.attendantDesk.padLeft(2, "0"),
                          buttonColor: LabClinicasTheme.blueColor,
                          labelColor: LabClinicasTheme.orangeColor,
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 20,
                ),
                current != null
                    ? SizedBox(
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: MainPanelWidget(
                          passwordLabel: 'Chamando senha',
                          password: current.password,
                          deskNumber: current.attendantDesk.padLeft(2, "0"),
                          buttonColor: LabClinicasTheme.orangeColor,
                          labelColor: LabClinicasTheme.blueColor,
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const Divider(
              color: LabClinicasTheme.orangeColor,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Últimos chamados',
              style: TextStyle(
                color: LabClinicasTheme.orangeColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              runAlignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: others
                  .map(
                    (item) => PasswordTileWidget(
                      password: item.password,
                      deskNumber: item.attendantDesk.padLeft(2, "0"),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
