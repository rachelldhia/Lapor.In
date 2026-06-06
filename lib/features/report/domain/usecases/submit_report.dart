import 'package:dartz/dartz.dart';
import '../entities/report.dart';
import '../repositories/report_repository.dart';

class SubmitReport {
  final ReportRepository repository;

  SubmitReport(this.repository);

  Future<Either<String, Report>> call({
    required String type,
    required String location,
    required String description,
    String? imagePath,
  }) {
    return repository.submitReport(
      type: type,
      location: location,
      description: description,
      imagePath: imagePath,
    );
  }
}
