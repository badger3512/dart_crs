/// An extension to [proj4dart](https://pub.dev/packages/proj4dart) that embeds
/// all EPSG coordinate reference system definitions.

library dart_crs;

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:proj4dart/proj4dart.dart';
import 'package:sqflite/sqflite.dart';

part 'src/coordinate_reference_system.dart';
part 'src/crs_factory.dart';
part 'src/wkt_reader.dart';
part 'src/constants.dart';
part 'src/coordinate_transform.dart';
part 'src/invalid_argument_exception.dart';
