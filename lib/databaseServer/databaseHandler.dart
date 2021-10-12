/* === Communication to the server via API === */
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dosepix/models/measurement.dart';

// === GENERAL ===
const int BAD_DATA = -1;
const String HOST = 'localhost';
const int PORT = 8080;
const String URL = "http://$HOST:$PORT";
const String USERS_ROUTE = "/users";
const String DOSIMETERS_ROUTE = "/dosimeters";
const String MEASUREMENTS_ROUTE = "/measurements";
const String POINTS_ROUTE = "/points";

// === USER ===
class User {
  final int id;
  final String userName;
  final String fullName;
  final String email;
  final String password;

  // Constructor
  User({
    required this.id,
    required this.userName,
    required this.fullName,
    required this.email,
    required this.password,
  });

  // Full name, email, and password are never fetched from the server
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userName: json['name'],
      fullName: "hidden",
      email: "hidden",
      password: "",
    );
  }
}

class UsersCompanion {
  final int id;
  final String userName;
  final String fullName;
  final String email;
  final String password;

  UsersCompanion.insert({
    this.id = 0,
    required String userName,
    required String fullName,
    required String email,
    required String password,
  })  : userName = userName,
        fullName = fullName,
        email = email,
        password = password;

  String toJson() {
    return jsonEncode(<String, dynamic>
      {
        "user": {
          "name": this.userName,
          "fullName": this.fullName,
          "email": this.email,
          "password": this.password,
        }
      }
    );
  }
}

// DAO
class UsersDao {
  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse(URL + USERS_ROUTE));

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<User>.from(l.map((json) => User.fromJson(json)).toList());
    } else {
      throw Exception("Failed to get users");
    }
  }

  Stream<List<User>> watchUsers() async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return getUsers();
    }).asyncMap((event) async => await event);
  }

  Future<User> getUserById(int id) async {
    final response = await http.get(Uri.parse(URL + USERS_ROUTE + '/$id'));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get users");
    }
  }

  Future<void> insertUser(UsersCompanion user) async {
    final response = await http.post(
      Uri.parse(URL + USERS_ROUTE),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: user.toJson(),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception("Failed to create user");
    }
  }
}

// === DOSIMETER ===
class Dosimeter {
  final int id;
  final String name;
  final String color;
  final double totalDose;

  // Constructor
  Dosimeter({
    required this.id,
    required this.name,
    required this.color,
    required this.totalDose,
  });

  factory Dosimeter.fromJson(Map<String, dynamic> json) {
    return Dosimeter(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      totalDose: json['totalDose'],
    );
  }
}

class DosimetersCompanion {
  final int id;
  final String name;
  final String color;
  final double totalDose;

  DosimetersCompanion.insert({
    this.id = 0,
    required String name,
    required String color,
    required double totalDose,
  })  : name = name,
        color = color,
        totalDose = totalDose;

  String toJson() {
    return jsonEncode(<String, dynamic>
      {
        "dosimeter": {
          "name": this.name,
          "color": this.color,
          "totalDose": this.totalDose.toStringAsFixed(2),
        }
      }
    );
  }
}

class DosimetersDao {
  Future<void> insertDosimeter(DosimetersCompanion dosimeter) async {
    final response = await http.post(
      Uri.parse(URL + DOSIMETERS_ROUTE),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: dosimeter.toJson(),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception("Failed to create dosimeter");
    }
  }
}

// === MEASUREMENT ===
class Measurement {
  final int id;
  final String name;
  final int userId;
  final int dosimeterId;
  final double totalDose;

  // Constructor
  Measurement({
    required this.id,
    required this.name,
    required this.userId,
    required this.dosimeterId,
    required this.totalDose,
  });

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      dosimeterId: json['dosimeterId'],
      totalDose: json['totalDose'] + .0,
    );
  }
  String toJson() {
    return jsonEncode(<String, dynamic>
    {
      "dosimeter": {
        "id": this.id,
        "name": this.name,
        "userId": this.userId,
        "dosimeterId": this.dosimeterId,
        "totalDose": this.totalDose,
      }
    }
    );
  }

  Measurement copyWith(
      {int ?id, String ?name, int ?userId, int ?dosimeterId, double ?totalDose}) {
    return Measurement(
      id: id ?? 0,
      name: name ?? "",
      userId: userId ?? 0,
      dosimeterId: dosimeterId ?? 0,
      totalDose: totalDose ?? 0,
    );
  }
}

class MeasurementsCompanion {
  final int id;
  final String name;
  final int userId;
  final int dosimeterId;
  final double totalDose;

  MeasurementsCompanion.insert({
    this.id = 0,
    required String name,
    required int userId,
    required int dosimeterId,
    required double totalDose,
  })  : name = name,
        userId = userId,
        dosimeterId = dosimeterId,
        totalDose = totalDose;

  String toJson() {
    return jsonEncode(<String, dynamic>
      {
        "measurement": {
          "name": this.name,
          "userId": this.userId,
          "dosimeterId": this.dosimeterId,
          "totalDose": this.totalDose,
        }
      }
    );
  }
}

class MeasurementsDao {
  Future<List<Measurement>> getMeasurements() async {
    final response = await http.get(Uri.parse(URL + MEASUREMENTS_ROUTE));

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<Measurement>.from(l.map((json) => Measurement.fromJson(json)));
    } else {
      throw Exception("Failed to get measurements");
    }
  }

  Future<Measurement> getMeasurementsOfId(int id) async {
    final response = await http.get(Uri.parse(URL + MEASUREMENTS_ROUTE + '/$id'));

    if (response.statusCode == 200) {
      return Measurement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to get measurement by id");
    }
  }

  Future<Measurement> insertReturningMeasurement(MeasurementsCompanion measurement) async {
    final response = await http.post(
      Uri.parse(URL + MEASUREMENTS_ROUTE),
      body: measurement.toJson(),
    );
    if (response.statusCode == 201) {
      return Measurement.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to update measurement");
    }
  }

  Future<void> updateMeasurement(Measurement measurement) async {
    final response = await http.put(
      Uri.parse(URL + MEASUREMENTS_ROUTE),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: measurement.toJson(),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to update measurement");
    }
  }
}

// === POINTS ===
class Point {
  final int id;
  final int measurementId;
  final int time;
  final double dose;

  // Constructor
  Point({
    required this.id,
    required this.measurementId,
    required this.time,
    required this.dose,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'],
      measurementId: json['measurementId'],
      time: json['time'],
      dose: json['dose'],
    );
  }
}

class PointsCompanion {
  final int id;
  final int measurementId;
  final int time;
  final double dose;

  PointsCompanion.insert({
    this.id = 0,
    required int measurementId,
    required int time,
    required double dose,
  })  : measurementId = measurementId,
        time = time,
        dose = dose;

  String toJson() {
    return jsonEncode(<String, dynamic>
    {
      "point": {
        "measurementId": this.measurementId,
        "time": this.time,
        "dose": this.dose + .0,
      }
    }
    );
  }
}

class MeasurementWithImportantPoints {
  final Measurement measurement;
  final List<Point> points;
  MeasurementWithImportantPoints(this.measurement, this.points);
}

class PointsDao {
  Future<List<Point>> getPoints() async {
    final response = await http.get(Uri.parse(URL + POINTS_ROUTE));

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<Point>.from(l.map((json) => Point.fromJson(json)));
    } else {
      throw Exception("Failed to get points");
    }
  }

  Future<void> insertPoint(PointsCompanion point) async {
    final response = await http.post(
      Uri.parse(URL + POINTS_ROUTE),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: point.toJson(),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception("Failed to create point");
    }
  }

  Future<List<MeasurementDataPoint>> loadDataPointsOfMeasurementIdSingle(int measId) async {
    final response = await http.get(Uri.parse(URL + POINTS_ROUTE + '?measurementId=$measId'));

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      return List<MeasurementDataPoint>.from(l.map((json) => MeasurementDataPoint.fromJson(json)));
    } else {
      throw Exception("Failed to get measurement by id");
    }
  }

  Stream<List<MeasurementDataPoint>> loadDataPointsOfMeasurementId (int measId) async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return loadDataPointsOfMeasurementIdSingle(measId);
    }).asyncMap((event) async => await event);
  }

  Future<List<MeasurementWithImportantPoints>> measurementsWithImportantPointsSingle({int fromUser=BAD_DATA}) async {
    // Get measurements
    var response;
    if (fromUser != BAD_DATA) {
      response = await http.get(Uri.parse(URL + MEASUREMENTS_ROUTE + '?userId=$fromUser'));
    } else {
      response = await http.get(Uri.parse(URL + MEASUREMENTS_ROUTE));
    }

    final List<Measurement> measurements;
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      measurements = List<Measurement>.from(l.map((json) => Measurement.fromJson(json)));
    } else {
      throw Exception("Measurement not found");
    }

    // Get ids of measurements to fetch corresponding points
    List<int> measurementIds = measurements.map((value) => value.id).toList();

    // Get points
    List<MeasurementWithImportantPoints> measPoints = [];
    for (var idx = 0; idx < measurementIds.length; idx++) {
      response = await http.get(Uri.parse(URL + POINTS_ROUTE + '?measurementId=${measurementIds[idx]}'));
      if (response.statusCode == 200) {
        Iterable l = jsonDecode(response.body);
        final points = List<Point>.from(l.map((json) => Point.fromJson(json)));
        print(points);
        measPoints.add(MeasurementWithImportantPoints(measurements[idx], points));
      } else {
        throw Exception("Failed to get points");
      }
    }
    return measPoints;
  }

  Stream<List<MeasurementWithImportantPoints>> measurementsWithImportantPoints({int fromUser=BAD_DATA}) async* {
    yield* Stream.periodic(Duration(seconds: 1), (_) {
      return measurementsWithImportantPointsSingle(fromUser: fromUser);
    }).asyncMap((event) async => await event);
  }
}

// === DOSE DATABASE ===
class DoseDatabase  {
  final usersDao = UsersDao();
  final dosimetersDao = DosimetersDao();
  final measurementsDao = MeasurementsDao();
  final pointsDao = PointsDao();
}
