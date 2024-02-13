import 'package:json_annotation/json_annotation.dart';

import 'package:lab_clinicas_adm/src/models/patient_model.dart';

part 'patient_information_form_model.g.dart';

@JsonEnum(valueField: 'id')
enum PatientInformationFormStatus {
  waiting('Waiting'),
  checkIn('Checked In'),
  beingAttended('Being Attended');

  final String id;
  const PatientInformationFormStatus(this.id);
}

@JsonSerializable()
class PatientInformationFormModel {
  final String id;
  final PatientModel patient;
  @JsonKey(name: 'health_insurance_card')
  final String healthInsuranceCard;
  @JsonKey(name: 'medical_order')
  final List<String> medicalOrders;
  final String password;
  @JsonKey(name: 'date_create')
  final DateTime dateCreate;

  final PatientInformationFormStatus status;

  factory PatientInformationFormModel.fromJson(Map<String, dynamic> json) =>
      _$PatientInformationFormModelFromJson(json);

  PatientInformationFormModel({
    required this.id,
    required this.patient,
    required this.healthInsuranceCard,
    required this.medicalOrders,
    required this.password,
    required this.dateCreate,
    required this.status,
  });

  Map<String, dynamic> toJson() => _$PatientInformationFormModelToJson(this);
}
