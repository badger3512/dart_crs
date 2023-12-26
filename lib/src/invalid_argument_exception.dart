part of '../dart_crs.dart';

/// Exception thrown when an invalid or missing EPSG code is used
class InvalidArgumentException implements Exception {
  String reason;
  InvalidArgumentException(this.reason);
}
