import 'package:dio/dio.dart';
import 'package:lab_clinicas_core/lab_clinicas_core.dart';
import 'package:lab_clinicas_panel/src/core/env.dart';
import 'package:lab_clinicas_panel/src/models/panel_checkin_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import './panel_checkin_repository.dart';
import 'package:intl/intl.dart';

class PanelCheckinRepositoryImpl implements PanelCheckinRepository {
  final RestClient _restClient;

  PanelCheckinRepositoryImpl({required RestClient restClient})
      : _restClient = restClient;

  @override
  ({WebSocketChannel channel, Function dispose}) openChannelSocket() {
    final channel = WebSocketChannel.connect(
      Uri.parse(
          '${Env.backendBaseUrl.replaceAll('http', 'ws')}?tables=painelCheckin'),
    );

    return (
      channel: channel,
      dispose: () {
        channel.sink.close();
      }
    );
  }

  @override
  Stream<List<PanelCheckinModel>> getTodayPanel(
      WebSocketChannel channel) async* {
    yield await requestData();
    yield* channel.stream.asyncMap(
      (_) async => requestData(),
    );
  }

  Future<List<PanelCheckinModel>> requestData() async {
    final dateFormat = DateFormat('y-MM-dd');
    final Response(:List data) = await _restClient.auth.get(
      '/painelCheckin',
      queryParameters: {
        'time_called': dateFormat.format(
          DateTime.now(),
        ),
      },
    );

    return data.reversed
        .take(7)
        .map((e) => PanelCheckinModel.fromJson(e))
        .toList();
  }
}
