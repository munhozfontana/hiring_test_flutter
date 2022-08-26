import 'package:flutter/cupertino.dart';

class PriceEntity {
  int id;
  String pathImage;
  String name;
  String type;
  num appreciation;
  num currentValue;

  PriceEntity({
    @required this.id,
    this.pathImage,
    this.name,
    this.type,
    this.appreciation,
    this.currentValue,
  });

  PriceEntity copyWith({
    int id,
    String pathImage,
    String name,
    String type,
    num appreciation,
    num value,
  }) {
    return PriceEntity(
      id: id ?? this.id,
      pathImage: pathImage ?? this.pathImage,
      name: name ?? this.name,
      type: type ?? this.type,
      appreciation: appreciation ?? this.appreciation,
      currentValue: value ?? currentValue,
    );
  }
}
