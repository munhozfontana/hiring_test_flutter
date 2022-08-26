import 'package:flutter_test/flutter_test.dart';
import 'package:foxbit_hiring_test_template/domain/entities/price_entity.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/i_price_repository.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/list_prices_by_multi_id_usecase.dart';
import 'package:mockito/mockito.dart';

class MockIPriceRepository extends Mock implements IPriceRepository {}

void main() {
  MockIPriceRepository mockIPriceRepository;
  ListPricesByMultiIdUsecase stub;

  setUp(
    () {
      mockIPriceRepository = MockIPriceRepository();
      stub = ListPricesByMultiIdUsecase(
        mockIPriceRepository,
      );
    },
  );

  test('Should emit event from usecase with no erros', () async {
    when(mockIPriceRepository.findAll()).thenAnswer((_) async => [
          PriceEntity(id: 1),
        ]);
    when(mockIPriceRepository.findById(any))
        .thenAnswer((_) async => PriceEntity(id: 1));
    when(mockIPriceRepository.findById(any))
        .thenAnswer((_) async => PriceEntity(id: 2));

    stub.buildUseCaseStream([1, 2, 3]);

    expect(await stub.controller.stream.first, hasLength(1));
  });

  test('Should emit event full list from usecase with no erros', () async {
    when(mockIPriceRepository.findAll()).thenAnswer((_) async => [
          PriceEntity(id: 1),
          PriceEntity(id: 2),
        ]);
    when(mockIPriceRepository.findById(any))
        .thenAnswer((_) async => PriceEntity(id: 1));
    when(mockIPriceRepository.findById(any))
        .thenAnswer((_) async => PriceEntity(id: 2));

    stub.buildUseCaseStream([]);

    expect(await stub.controller.stream.first, hasLength(2));
  });

  test('Should throw error and cathc exption', () async {
    when(mockIPriceRepository.findAll())
        .thenThrow((_) async => [Exception('AnyError')]);

    stub.buildUseCaseStream([]);

    stub.controller.stream.handleError((error) => expect(error, 'AnyError'));
  });
}
