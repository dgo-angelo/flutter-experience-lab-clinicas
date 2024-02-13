import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_self_service/src/modules/self_service/self_service_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validatorless/validatorless.dart';

class WhoIAmPage extends StatefulWidget {
  const WhoIAmPage({super.key});

  @override
  State<WhoIAmPage> createState() => _WhoIAmPageState();
}

class _WhoIAmPageState extends State<WhoIAmPage> {
  final _firstName = TextEditingController();
  final _lastNameEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final controller = Injector.get<SelfServiceController>();

  @override
  void dispose() {
    _firstName.dispose();
    _lastNameEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        _firstName.text = '';
        _lastNameEC.text = '';
        controller.clearForm();
      },
      child: Scaffold(
          appBar: LabClinicasAppBar(
            actions: [
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 1,
                      onTap: () async {
                        final nav = Navigator.of(context);
                        await SharedPreferences.getInstance()
                            .then((sp) => sp.clear());
                        nav.pushNamedAndRemoveUntil('/', (route) => false);
                      },
                      child: const Text('Finalizar terminal'),
                    )
                  ];
                },
                child: const IconPopupMenuWidget(),
              )
            ],
          ),
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
                            const Text(
                              'Bem-vindo!',
                              style: LabClinicasTheme.titleStyle,
                            ),
                            const SizedBox(
                              height: 48,
                            ),
                            TextFormField(
                              controller: _firstName,
                              validator:
                                  Validatorless.required('Nome é obrigatório'),
                              decoration: const InputDecoration(
                                label: Text('Digite seu nome'),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            TextFormField(
                              controller: _lastNameEC,
                              validator: Validatorless.required(
                                  'Sobrenome é obrigatório'),
                              decoration: const InputDecoration(
                                label: Text('Digite seu sobrenome'),
                              ),
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
                                      _formKey.currentState?.validate() ??
                                          false;

                                  if (valid) {
                                    controller.setWhoIAmDataStepAndNext(
                                      _firstName.text,
                                      _lastNameEC.text,
                                    );
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
          )),
    );
  }
}
