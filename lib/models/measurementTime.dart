class MeasurementTimeModel {
  final int id;
  final int userId;
  final DateTime startTime;
  final DateTime duration;
  final double totalDose;
  MeasurementTimeModel(
    this.id,
    this.userId,
    this.startTime,
    this.duration,
    this.totalDose,
  );
}
