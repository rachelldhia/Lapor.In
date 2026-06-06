import 'package:dartz/dartz.dart';
import '../entities/report.dart';

abstract class ReportRepository {
  Future<Either<String, Report>> submitReport({
    required String type,
    required String location,
    required String description,
    String? imagePath,
  });

  List<Report> getReports();
}

