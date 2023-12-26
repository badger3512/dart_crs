part of '../dart_crs.dart';

/// Transform a point between coordinate reference systems
class CoordinateTransform {
  Projection? sourceProjection;
  Projection? targetProjection;
  bool isDefined = false;
  CoordinateTransform();
  CoordinateTransform.fromProjection(Projection source, Projection target) {
    sourceProjection = source;
    targetProjection = target;
  }

  /// Transform a point
  Point? transform(Point srcPoint) {
    late Point targetPoint;
    if (isDefined) {
      targetPoint = sourceProjection!.transform(targetProjection!, srcPoint);
    }
    return targetPoint;
  }

  /// Inverse transform
  Point? inverse(Point srcPoint) {
    late Point targetPoint;
    if (isDefined) {
      targetPoint = targetProjection!.transform(sourceProjection!, srcPoint);
    }
    return targetPoint;
  }
}
