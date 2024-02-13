import 'package:flutter/material.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:lab_clinicas_adm/src/pages/login/login_controller.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with MessageViewMixin {
  final _emailEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Injector.get<LoginController>();

  @override
  void initState() {
    messageListener(controller);
    effect(() {
      if (controller.logged) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeOf = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: sizeOf.height),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background_login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              constraints: BoxConstraints(maxWidth: sizeOf.width * .4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Login',
                      style: LabClinicasTheme.titleStyle,
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    TextFormField(
                      controller: _emailEC,
                      validator: Validatorless.multiple([
                        Validatorless.required('E-mail é obrigatório'),
                        Validatorless.email('E-mail inválido'),
                      ]),
                      decoration: const InputDecoration(label: Text('E-mail')),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Watch(
                      (_) {
                        return TextFormField(
                          controller: _passwordEC,
                          obscureText: controller.obscurePassword,
                          validator:
                              Validatorless.required('Senha é obrigatória'),
                          decoration: InputDecoration(
                            label: const Text('Senha'),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.passwordToggle();
                              },
                              icon: Icon(
                                controller.obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: sizeOf.width * .8,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          final valid =
                              _formKey.currentState?.validate() ?? false;

                          if (valid) {
                            controller.login(_emailEC.text, _passwordEC.text);
                          }
                        },
                        child: const Text('ENTRAR'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
