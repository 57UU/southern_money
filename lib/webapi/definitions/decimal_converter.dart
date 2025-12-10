import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

/// Custom JsonConverter for Decimal type
class DecimalConverter implements JsonConverter<Decimal, String> {
  const DecimalConverter();

  @override
  Decimal fromJson(String json) => Decimal.parse(json);

  @override
  String toJson(Decimal object) => object.toString();
}