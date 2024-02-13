import 'package:flutter/material.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';

class PasswordTileWidget extends StatelessWidget {
  final String password;
  final String deskNumber;
  const PasswordTileWidget({
    super.key,
    required this.password,
    required this.deskNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: LabClinicasTheme.orangeColor,
        ),
      ),
      child: Column(
        children: [
          Text(
            password,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: LabClinicasTheme.blueColor,
            ),
          ),
          Text(
            'Guichê $deskNumber',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LabClinicasTheme.orangeColor,
            ),
          ),
        ],
      ),
    );
  }
}
