import '../entities/report.dart';
import '../repositories/report_repository.dart';

class GetReports {
  final ReportRepository repository;

  GetReports(this.repository);

  List<Report> call() {
    return repository.getReports();
  }
}
