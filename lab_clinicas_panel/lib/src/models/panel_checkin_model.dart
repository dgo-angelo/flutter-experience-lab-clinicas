import 'package:json_annotation/json_annotation.dart';

part 'panel_checkin_model.g.dart';

@JsonSerializable()
class PanelCheckinModel {
  final String id;
  final String password;
  @JsonKey(name: 'attendant_desk')
  final String attendantDesk;
  factory PanelCheckinModel.fromJson(Map<String, dynamic> json) =>
      _$PanelCheckinModelFromJson(json);

  PanelCheckinModel(this.id, this.password, this.attendantDesk);

  Map<String, dynamic> toJson() => _$PanelCheckinModelToJson(this);
}
