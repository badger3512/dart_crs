part of '../dart_crs.dart';

/// Coordinate Reference System. Holds the associated projection;
class CoordinateReferenceSystem {
  Projection? projection;
  String? wkt;
  CoordinateReferenceSystem();
  CoordinateReferenceSystem.fromProjection(Projection proj) {
    projection = proj;
  }
  CoordinateReferenceSystem.fromWKT(String wkt){
    projection = Projection.parse(wkt);
  }
}
