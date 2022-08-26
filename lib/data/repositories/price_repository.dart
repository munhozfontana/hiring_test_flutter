import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/domain/entities/price_entity.dart';

import '../../domain/repositories/i_price_repository.dart';

class PriceRepository implements IPriceRepository {
  final FoxbitWebSocket ws;

  PriceRepository(this.ws);

  final String _eventGetInstruments = "GetInstruments";
  final String _eventSubscribeLevel = "SubscribeLevel1";

  @override
  Future<List<PriceEntity>> findAll() {
    ws.send(_eventGetInstruments, {});

    return ws.stream
        .where(isInstruments)
        .where((message) => message['i'] == ws.lastId)
        .asyncMap((event) => (event['o'] as List)
            .map((item) => PriceEntity(
                id: item['InstrumentId'] as int,
                pathImage: 'assets/images/${item['InstrumentId']}.png',
                name: item['Symbol'] as String,
                type: item['Product1Symbol'] as String))
            .toList())
        .first;
  }

  @override
  Future<PriceEntity> findById(PriceEntity priceEntity) async {
    ws.send(_eventSubscribeLevel, {'InstrumentId': priceEntity.id});

    final res = await ws.stream
        .where(isInstrumentId)
        .where((message) => message['i'] == ws.lastId)
        .where((event) => (event['o'] as Map)['InstrumentId'] == priceEntity.id)
        .asyncMap((event) {
      final obj = event['o'] as Map;

      return priceEntity.copyWith(
        value: obj['LastTradedPx'] as num,
        appreciation: obj['Rolling24HrPxChange'] as num,
      );
    }).first;

    return res;
  }

  bool isInstrumentId(Map event) {
    return event['n'].toString().toUpperCase() ==
        _eventSubscribeLevel.toUpperCase();
  }

  bool isInstruments(Map event) {
    return event['n'].toString().toUpperCase() ==
        _eventGetInstruments.toUpperCase();
  }
}
