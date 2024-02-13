// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'panel_checkin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PanelCheckinModel _$PanelCheckinModelFromJson(Map<String, dynamic> json) =>
    PanelCheckinModel(
      json['id'] as String,
      json['password'] as String,
      json['attendant_desk'] as String,
    );

Map<String, dynamic> _$PanelCheckinModelToJson(PanelCheckinModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'password': instance.password,
      'attendant_desk': instance.attendantDesk,
    };
