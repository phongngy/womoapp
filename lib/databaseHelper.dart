import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const _databaseName = "womoapp.db";
  static const _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB(_databaseName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    print(dbPath);
    final path = join(dbPath, filePath);

    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _createDB,
        onConfigure: _onConfigure);
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    await db.execute('CREATE TABLE Stellplatz ('
        'StellplatzID INTEGER PRIMARY KEY autoincrement, '
        'Bezeichner TEXT not null, '
        'GPSLongitude REAL not null, '
        'GPSLatitude REAL not null, '
        'Toilette INTEGER not null, '
        'Dusche INTEGER not null, '
        'Entsorgung INTEGER not null, '
        'Frischwasser INTEGER not null'
        ')');

    await db.execute('CREATE TABLE Besuche ('
        'Datum TEXT, '
        'StellplatzID INTEGER, '
        'PRIMARY KEY (Datum, StellplatzID), '
        'FOREIGN KEY (StellplatzID) REFERENCES Stellplatz (StellplatzID) '
        ')');

    await db.execute('CREATE TABLE Bild ('
        'ID INTEGER PRIMARY KEY autoincrement, '
        'StellplatzID INTEGER, '
        'Bild BLOB not null, '
        'FOREIGN KEY (StellplatzID) REFERENCES Stellplatz (StellplatzID) '
        ')');

    await db.execute('CREATE TABLE Stellplatz_Ausstattung ('
        'ID INTEGER PRIMARY KEY autoincrement, '
        'StellplatzID INTEGER, '
        'Bezeichner TEXT not null, '
        'Angekreuzt INTEGER not null, '
        'FOREIGN KEY (StellplatzID) REFERENCES Stellplatz (StellplatzID) '
        ')');
  }

  Future insertStellplatzKomplett(
      String bezeichner,
      double longitude,
      double latitude,
      bool toilette,
      bool dusche,
      bool entsorgung,
      bool frischwasser,
      List<String> datum,
      List bilder) async {
    final stellplatzID = await insertStellplatz(bezeichner, longitude, latitude,
        toilette, dusche, entsorgung, frischwasser);
    for (var datum in datum) {
      insertBesuche(datum, stellplatzID);
    }
    for (var bild in bilder) {
      insertBild(stellplatzID, bild);
    }
    //insertStellplatz_Ausstattung noch implementieren
  }

  Future insertStellplatz(String bezeichner, double longitude, double latitude,
      bool toilette, bool dusche, bool entsorgung, bool frischwasser) async {
    Database db = await instance.database;
    num longitudeNum = doubleToNum(longitude);
    num latitudeNum = doubleToNum(latitude);
    int toiletteInt = boolToInt(toilette);
    int duscheInt = boolToInt(dusche);
    int entsorgungInt = boolToInt(entsorgung);
    int frischwasserInt = boolToInt(frischwasser);

    return db.rawInsert('''
    INSERT INTO Stellplatz(Bezeichner, GPSLongitude, GPSLatitude, Toilette, Dusche, Entsorgung, Frischwasser)
    VALUES(?,?,?,?,?,?,?)''', [
      bezeichner,
      longitudeNum,
      latitudeNum,
      toiletteInt,
      duscheInt,
      entsorgungInt,
      frischwasserInt
    ]);
  }

  Future insertBesuche(String datum, int stellplatzID) async {
    Database db = await instance.database;
    db.rawInsert('''
    INSERT INTO Besuche(Datum, StellplatzID) 
    VALUES(?,?)
    ''', [datum, stellplatzID]);
  }

  Future insertBild(int stellplatzID, Uint8List bild) async {
    Database db = await instance.database;
    db.rawInsert('''
    INSERT INTO Bild(StellplatzID, Bild) 
    VALUES(?,?)
    ''', [stellplatzID, bild]);
  }

  Future insertStellplatzAusstattung(
      int stellplatzID, String bezeichner, bool angekreuzt) async {
    Database db = await instance.database;
    int angekreuztInt = boolToInt(angekreuzt);
    db.rawInsert('''
    INSERT INTO Stellplatz_Ausstattung(StellplatzID, Bezeichner, Angekreuzt) 
    VALUES(?,?,?)
    ''', [stellplatzID, bezeichner, angekreuztInt]);
  }

  num doubleToNum(double wert) {
    return num.parse(wert.toString());
  }

  int boolToInt(bool wert) {
    if (wert == true) {
      return 1;
    } else {
      return 0;
    }
  }
}
