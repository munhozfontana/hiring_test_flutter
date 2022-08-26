import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:foxbit_hiring_test_template/app/pages/home/home_presenter.dart';
import 'package:foxbit_hiring_test_template/domain/entities/price_entity.dart';

class HomeController extends Controller {
  final HomePresenter presenter;

  List<PriceEntity> list = [];

  HomeController() : presenter = HomePresenter() {
    presenter.ws.connect();
    presenter.sendHeartbeat();
    presenter.sendPrice();
  }

  @override
  void onDisposed() {
    presenter.ws.disconnect();
    super.onDisposed();
  }

  @override
  void initListeners() {
    presenter.listAllPriceOnNext = listAllPriceOnNext;
    presenter.listAllPriceOnComplete = listAllPriceOnComplete;
    presenter.listAllPriceOnError = listAllPriceOnError;

    presenter.heartbeatOnComplete = heartbeatOnComplete;
    presenter.heartbeatOnError = heartbeatOnError;
  }

  void heartbeatOnComplete() {
    _scheduleNextHeartbeat();
  }

  void listAllPriceOnComplete() {
    presenter.sendHeartbeat();
  }

  void listAllPriceOnNext(List<PriceEntity> res) {
    list = res;
    notifyListeners();
  }

  void listAllPriceOnError(e) {}

  void heartbeatOnError(dynamic e) {
    (getStateKey().currentState as ScaffoldState).showSnackBar(const SnackBar(
        duration: Duration(seconds: 10),
        content: Text('Não foi possível enviar a mensagem: [PING]')));

    _scheduleNextHeartbeat();
  }

  void _scheduleNextHeartbeat() {
    Timer(const Duration(seconds: 30), () {
      presenter.sendHeartbeat();
    });
  }
}
