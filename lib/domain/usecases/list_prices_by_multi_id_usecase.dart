import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/domain/entities/price_entity.dart';
import 'package:foxbit_hiring_test_template/domain/repositories/i_price_repository.dart';

class ListPricesByMultiIdUsecase extends CompletableUseCase<List<int>> {
  final IPriceRepository _repository;

  ListPricesByMultiIdUsecase(this._repository);

  @override
  Future<Stream<void>> buildUseCaseStream(List<int> params) async {
    final controller = StreamController<List<PriceEntity>>();

    try {
      Iterable<PriceEntity> resFindAll;

      if ((params ?? []).isNotEmpty) {
        resFindAll = (await _repository.findAll()).where((element) {
          return params.any((id) => element.id == id);
        });
      } else {
        resFindAll = await _repository.findAll();
      }

      final List<PriceEntity> list = [];
      for (final item in resFindAll) {
        list.add(await _repository.findById(item));
      }

      controller.add(list);
      controller.close();
    } catch (e) {
      controller.addError(e);
    }

    return controller.stream;
  }
}
