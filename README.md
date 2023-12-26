# dart_crs

This package extends [proj4dart](https://pub.dev/packages/proj4dart) by embedding the EPSG 
Geodetic Parameter Dataset maintained by the Geodesy Subcommittee of the 
IOGP Geomatics Committee. [epsg.org](https://epsg.org).

[![pub.dev](https://img.shields.io/pub/v/dart_crs.svg?label=Latest+Version)](https://pub.dev/packages/dart_crs)
[![stars](https://badgen.net/github/stars/badger3512/dart_crs?label=stars&color=green&icon=github)](https://github.com/badger3512/dart_crs/stargazers)
[![likes](https://img.shields.io/pub/likes/dart_crs?logo=flutter)](https://pub.dev/packages/dart_crs/score)
[![Open Issues](https://badgen.net/github/open-issues/badger3512/dart_crs?label=Open+Issues&color=green)](https://GitHub.com/badger3512/dart_crs/issues)

## Features
- Retrieve the WKT for an EPSG coordinate reference system definition.
- Transform coordinates between two EPSG coordinate reference systems
- Create a named proj4dart Projection using any of the EPSG defined codes.

## Getting started

To use this plugin, add `dart_crs` as a dependency in your pubspec.yaml file. For example:
```yaml
dependencies:
  dart_crs: '^1.0.0'
```
## Usage

Create a coordinate reference system:

```
CoordinateReferenceSystem crsLatLong = await CRSFactory.createCRS('EPSG:4326');
```
Transform a point between two coordinate reference systems.

```
CoordinateTransform transform = 
    await CRSFactory.createCoordinateTransformFromCodes('EPSG:4326','EPSG:3183');
Point geoPoint = Point(-45.2395,60.1425);
Point? gr96Point = transform!.transform(geoPoint);
Point? inversePoint = transform!.inverse(gr96Point!);
```
Extract a WKT definition:
```
String wkt1 = await WKTReader().fetchWkt('EPSG:4326');
```
## Additional information

Credit to [Geomatic Solutions](https://geomaticsolutions.com) for maintaining the EPSG dataset. The EPSG dataset version for this release is v11.001. The EPSG dataset is based on the ISO 19111:2019 international standard for referencing by coordinates, sometimes referred to as WKT2. Before embedding into this library, the data are converted to the ISO 19111:2007 international standard for enhanced compatibility with [proj4dart](https://pub.dev/packages/proj4dart).