import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/data/repositories/price_repository.dart';
import 'package:foxbit_hiring_test_template/domain/entities/price_entity.dart';
import 'package:mockito/mockito.dart';

class _MockFoxbitWebSocket extends Mock implements FoxbitWebSocket {}

void main() {
  PriceRepository priceRepository;
  FoxbitWebSocket foxbitWebSocket;

  setUp(
    () {
      foxbitWebSocket = _MockFoxbitWebSocket();
      priceRepository = PriceRepository(foxbitWebSocket);
    },
  );

  test(
    'Should call findAll with no error',
    () async {
      when(foxbitWebSocket.lastId).thenAnswer(
        (realInvocation) => 0,
      );
      when(foxbitWebSocket.stream).thenAnswer((_) => Stream.value({
            "m": 0,
            "i": 0,
            "n": "getInstruments",
            "o": [
              {
                'InstrumentId': 1,
                'Symbol': 'BTC/BRL',
                'Product1Symbol': 'BTC',
              },
            ]
          }));
      final res = await priceRepository.findAll();
      expect(res, hasLength(1));
    },
  );

  test(
    'Should call findOne with no error',
    () async {
      when(foxbitWebSocket.lastId).thenAnswer(
        (realInvocation) => 0,
      );
      when(foxbitWebSocket.stream).thenAnswer((_) => Stream.value({
            "m": 0,
            "i": 0,
            "n": "SubscribeLevel1",
            "o": {
              'InstrumentId': 1,
              'LastTradedPx': 2.3,
              'Rolling24HrPxChange': 3.2,
            },
          }));
      final res = await priceRepository.findById(PriceEntity(id: 1));
      expect(res, isNotNull);
    },
  );
}
