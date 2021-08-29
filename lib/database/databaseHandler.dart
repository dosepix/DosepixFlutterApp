import 'package:rxdart/rxdart.dart' as Rx;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'dart:io';
import 'package:dosepix/models/measurement.dart';
part 'databaseHandler.g.dart';

const int BAD_DATA = -1;
Point dummyPoint = Point(id: BAD_DATA,
    measurementId: BAD_DATA, time: BAD_DATA, dose: 0);

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userName => text().withLength(min: 6).customConstraint('UNIQUE')();
  TextColumn get fullName => text().withLength(min: 6)();
  TextColumn get email => text().withLength()();
  TextColumn get password => text().withLength(min: 6)();
}

class Dosimeters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 6).customConstraint('UNIQUE')();
  TextColumn get color => text().withLength()();
  RealColumn get totalDose => real()();
}

class Measurements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get userId => integer().customConstraint('REFERENCES users(id)')();
  IntColumn get dosimeterId => integer().customConstraint('REFERENCES dosimeters(id)')();
  RealColumn get totalDose => real()();
}

class Points extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get measurementId => integer().customConstraint('REFERENCES measurements(id)')();
  IntColumn get time => integer()();
  RealColumn get dose => real()();
}

@UseDao(tables: [Users])
class UsersDao extends DatabaseAccessor<DoseDatabase> with _$UsersDaoMixin {
  UsersDao(DoseDatabase db) : super(db);

  Stream<List<User>> watchUsers() => select(users).watch();
  Future<List<User>> getUsers() => select(users).get();
  Future<User> getUserById(int id) {
    return (select(users)..where((t) => t.id.equals(id))).getSingle();
  }
  Stream<User> watchUserById(int id) {
    return (select(users)..where((t) => t.id.equals(id))).watchSingle();
  }
  Future<void> insertUser(Insertable<User> user) => into(users).insert(user);
  Future<void> updateUser(Insertable<User> user) => update(users).replace(user);
  Future<void> deleteUser(Insertable<User> user) => delete(users).delete(user);
}

@UseDao(tables: [Dosimeters])
class DosimetersDao extends DatabaseAccessor<DoseDatabase> with _$DosimetersDaoMixin {
  DosimetersDao(DoseDatabase db) : super(db);

  Stream<List<Dosimeter>> watchDosimeters() => select(dosimeters).watch();
  Future<List<Dosimeter>> getDosimeters() => select(dosimeters).get();
  Future<Dosimeter> getDosimeterById(int id) {
    return (select(dosimeters)..where((t) => t.id.equals(id))).getSingle();
  }
  Future<void> insertDosimeter(Insertable<Dosimeter> dosimeter) => into(dosimeters).insert(dosimeter);
  Future<void> updateDosimeter(Insertable<Dosimeter> dosimeter) => update(dosimeters).replace(dosimeter);
  Future<void> deleteDosimeter(Insertable<Dosimeter> dosimeter) => delete(dosimeters).delete(dosimeter);
}

@UseDao(tables: [Measurements, Users, Dosimeters])
class MeasurementsDao extends DatabaseAccessor<DoseDatabase> with _$MeasurementsDaoMixin {
  MeasurementsDao(DoseDatabase db) : super(db);

  Future<List<Measurement>> getMeasurements() => select(measurements).get();
  Future<List<Measurement>> getMeasurementsOfUser(int userId) => (select(measurements)..where((m) => m.userId.equals(userId))).get();
  Future<Measurement> getMeasurementsOfId(int id) => (select(measurements)..where((m) => m.id.equals(id))).getSingle();
  Stream<List<Measurement>> watchMeasurements() => select(measurements).watch();
  Future<void> insertMeasurement(Insertable<Measurement> measurement) => into(measurements).insert(measurement);
  Future<Measurement> insertReturningMeasurement(Insertable<Measurement> measurement) => into(measurements).insertReturning(measurement);
  Future<void> updateMeasurement(Insertable<Measurement> measurement) => update(measurements).replace(measurement);
  Future<void> deleteMeasurement(Insertable<Measurement> measurement) => delete(measurements).delete(measurement);
}

class MeasurementsWithPoints {
  final Measurement measurement;
  final Point point;
  MeasurementsWithPoints(this.measurement, this.point);
}

class MeasurementWithImportantPoints {
  final Measurement measurement;
  final List<Point> points;
  MeasurementWithImportantPoints(this.measurement, this.points);
}

@UseDao(tables: [Points, Measurements, Users])
class PointsDao extends DatabaseAccessor<DoseDatabase> with _$PointsDaoMixin {
  PointsDao(DoseDatabase db) : super(db);

  Future<List<Point>> getPoints() => select(points).get();
  Future<List<Point>> getPointsOfMeasurementId(int measId) {
    return (select(points)..where((p) => p.measurementId.equals(measId))).get();
  }
  Stream<List<MeasurementDataPoint>> loadDataPointsOfMeasurementId(int measId) {
    final query = (select(points)..where((p) => p.measurementId.equals(measId)));
    Stream<List<MeasurementDataPoint>> dps = query.watch().map((rows) {
      return rows.map((row) {
        return MeasurementDataPoint(
          row.time - rows.first.time, row.dose,
        );
      }).toList();
    });
    return dps;
  }

  Future<void> insertPoint(Insertable<Point> point) => into(points).insert(point);
  Future<void> updatePoint(Insertable<Point> point) => update(points).replace(point);
  Future<void> deletePoint(Insertable<Point> point) => delete(points).delete(point);

  // Get Measurements with corresponding data points
  Stream<List<MeasurementsWithPoints>> measurementsWithPoints() {
    final query = select(measurements).join([
      leftOuterJoin(points, points.measurementId.equalsExp(measurements.id))
    ]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return MeasurementsWithPoints(
          row.readTable(measurements),
          row.readTable(points),
        );
      }).toList();
    });
  }

  Stream<List<MeasurementWithImportantPoints>> measurementsWithImportantPoints({int fromUser=BAD_DATA}) {
    final Stream<List<Measurement>> measurementsStream = fromUser == BAD_DATA
        ? select(measurements).watch()
        : (select(measurements)..where((m) => m.userId.equals(fromUser))).watch();
    final Stream<List<Point>> pointsStream = select(points).watch();
    return Rx.CombineLatestStream.combine2(
      measurementsStream, pointsStream, (List<Measurement> ms, List<Point> ps) {
        return ms.map((Measurement m) {
          List<Point> pSelect = ps.where((p) => p.measurementId == m.id).toList();
          if(pSelect.isNotEmpty) {
            return MeasurementWithImportantPoints(m, [pSelect.first, pSelect.last]);
          } else {
            return MeasurementWithImportantPoints(m, [dummyPoint, dummyPoint]);
          }
        }).toList();
    });
  }
}

// Specify name and location of database
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
   final dbFolder = await getApplicationDocumentsDirectory();
   final file = File(p.join(dbFolder.path, 'db.sqlite'));
   print(file);
   return VmDatabase(file);
  });
}

@UseMoor(tables: [Users, Dosimeters, Measurements, Points],
    daos: [UsersDao, DosimetersDao, MeasurementsDao, PointsDao])
class DoseDatabase extends _$DoseDatabase {
  DoseDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        await m.addColumn(measurements, measurements.name);
        await m.addColumn(measurements, measurements.totalDose);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
