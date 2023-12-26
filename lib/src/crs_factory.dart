part of '../dart_crs.dart';

/// A factory class that creates CoordinateReferenceSystems and CoordinateTransforms
class CRSFactory {
  /// Create a coordinate reference system from a code, e.g., EPSG:3857.
  /// At the present time, only EPSG codes are accepted
  /// Throws InvalidArgumentException
  static Future<CoordinateReferenceSystem> createCRS(String crsCode) async {
    final parsed = crsCode.split(':');
    if (parsed.isNotEmpty && parsed.length == 2) {
      final wktString = await WKTReader().fetchWKT(parsed[1]);
      if (wktString == null) {
        throw InvalidArgumentException('Missing or invalid EPSG code');
      }
      final proj = Projection.add(parsed[1], wktString);
      return CoordinateReferenceSystem.fromProjection(proj);
    } else {
      throw InvalidArgumentException('Missing or invalid EPSG code');
    }
  }

  /// Create a coordinate transform from source and target CRS
  static CoordinateTransform createCoordinateTransform(
      CoordinateReferenceSystem source, CoordinateReferenceSystem target) {
    final result = CoordinateTransform.fromProjection(
        source.projection!, target.projection!);
    return result;
  }

  /// Create a coordinate transform from source and target codes
  /// Throws InvalidArgumentException
  static Future<CoordinateTransform> createCoordinateTransformFromCodes(
      String sourceCode, String targetCode) async {
    try {
      final sourceCrs = await createCRS(sourceCode);
      final targetCrs = await createCRS(targetCode);
      final result = CoordinateTransform.fromProjection(
          sourceCrs.projection!, targetCrs.projection!);
      result.isDefined = true;
      return result;
    } on InvalidArgumentException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
