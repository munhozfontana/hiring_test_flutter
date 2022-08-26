import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/data/helpers/websocket.dart';
import 'package:foxbit_hiring_test_template/data/repositories/heartbeat_repository.dart';
import 'package:foxbit_hiring_test_template/data/repositories/price_repository.dart';
import 'package:foxbit_hiring_test_template/domain/entities/price_entity.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/heartbeat_usecase.dart';
import 'package:foxbit_hiring_test_template/domain/usecases/list_prices_by_multi_id_usecase.dart';

class HomePresenter extends Presenter {
  FoxbitWebSocket ws;
  Function heartbeatOnComplete;
  Function listAllPriceOnComplete;
  Function(List<PriceEntity>) listAllPriceOnNext;

  HeartbeatUseCase _heartbeatUseCase;
  ListPricesByMultiIdUsecase _listAllPriceUsecase;

  Function(dynamic) heartbeatOnError;
  void Function(dynamic e) listAllPriceOnError;

  HomePresenter() {
    ws = FoxbitWebSocket();
    _heartbeatUseCase = HeartbeatUseCase(HeartbeatRepository(ws));
    _listAllPriceUsecase = ListPricesByMultiIdUsecase(PriceRepository(ws));
  }

  void sendHeartbeat() {
    _heartbeatUseCase.execute(_HeartBeatObserver(this));
  }

  void sendPrice() {
    _listAllPriceUsecase.execute(_ListAllPriceObserver(this), [
      // 1,
      // 2,
      // 4,
      // 6,
      // 10,
    ]);
  }

  @override
  void dispose() {
    _heartbeatUseCase.dispose();
    _listAllPriceUsecase.dispose();
  }
}

class _ListAllPriceObserver implements Observer<List<PriceEntity>> {
  HomePresenter presenter;

  _ListAllPriceObserver(this.presenter);

  @override
  void onNext(List<PriceEntity> res) {
    presenter.listAllPriceOnNext(res);
  }

  @override
  void onComplete() {
    assert(presenter.listAllPriceOnComplete != null);
    presenter.listAllPriceOnComplete();
  }

  @override
  void onError(dynamic e) {
    assert(presenter.listAllPriceOnError != null);
    presenter.listAllPriceOnError(e);
  }
}

class _HeartBeatObserver implements Observer<void> {
  HomePresenter presenter;

  _HeartBeatObserver(this.presenter);

  @override
  void onNext(_) {}

  @override
  void onComplete() {
    assert(presenter.heartbeatOnComplete != null);
    presenter.heartbeatOnComplete();
  }

  @override
  void onError(dynamic e) {
    assert(presenter.heartbeatOnError != null);
    presenter.heartbeatOnError(e);
  }
}
