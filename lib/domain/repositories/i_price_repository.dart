import 'package:foxbit_hiring_test_template/domain/entities/price_entity.dart';

abstract class IPriceRepository {
  Future<List<PriceEntity>> findAll();
  Future<PriceEntity> findById(PriceEntity priceEntity);
}
