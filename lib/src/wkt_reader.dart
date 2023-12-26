part of '../dart_crs.dart';

///Read an OGC WKT string for a given EPSG code
class WKTReader {
  WKTReader();
  Future<File> _checkWKT() async {
    final dbDir = await getDatabasesPath();
    final dbFile = File(join(dbDir, wktFileName));
    bool exists = await dbFile.exists();
    if (!exists) {
      return await _copyDbFile(dbFile);
    } else {
      return dbFile;
    }
  }

  Future<File> _copyDbFile(File dbFile) async {
    ByteData data = await rootBundle.load('packages/dart_crs/assets/epsg.db');
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await dbFile.writeAsBytes(bytes);
    return dbFile;
  }

  /// Retrieve a WKT string for a given plain code. (No EPSG: prefix)
  Future<String?> fetchWKT(String code) async {
    final dbFile = await _checkWKT();
    var db = await openDatabase(wktFileName);
    List<Map> rows =
        await db.rawQuery('select wkt from epsg where epsg=?', [code]);
    if (rows.isNotEmpty) {
      Map map = rows[0];
      final wkt = map['wkt'];
      db.close();
      return wkt;
    } else {
      return null;
    }
  }
}
