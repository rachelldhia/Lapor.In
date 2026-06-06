import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:laporin/features/report/domain/entities/report.dart';
import 'package:laporin/features/report/domain/repositories/report_repository.dart';
import 'package:laporin/features/report/domain/usecases/submit_report.dart';
import 'package:laporin/features/report/domain/usecases/get_reports.dart';
import 'package:laporin/features/report/presentation/bloc/report_bloc.dart';
import 'package:laporin/features/report/presentation/bloc/report_event.dart';
import 'package:laporin/features/report/presentation/bloc/report_state.dart';

class FakeReportRepository implements ReportRepository {
  final List<Report> reportsList = [];

  @override
  List<Report> getReports() {
    return reportsList;
  }

  @override
  Future<Either<String, Report>> submitReport({
    required String type,
    required String location,
    required String description,
    String? imagePath,
  }) async {
    final report = Report(
      id: '123',
      type: type,
      location: location,
      description: description,
      imageUrl: imagePath,
      createdAt: DateTime(2026, 6, 6),
      status: 'Menunggu',
    );
    reportsList.add(report);
    return Right(report);
  }
}

void main() {
  late ReportBloc reportBloc;
  late SubmitReport submitReport;
  late GetReports getReports;
  late FakeReportRepository fakeReportRepository;

  setUp(() {
    fakeReportRepository = FakeReportRepository();
    submitReport = SubmitReport(fakeReportRepository);
    getReports = GetReports(fakeReportRepository);
    reportBloc = ReportBloc(submitReport: submitReport, getReports: getReports);
  });

  tearDown(() {
    reportBloc.close();
  });

  test('initial state should be ReportInitial', () {
    expect(reportBloc.state, equals(ReportInitial()));
  });

  group('LoadReports', () {
    test('should emit ReportsLoaded with current reports', () async {
      final mockReport = Report(
        id: '1',
        type: 'Kecelakaan',
        location: 'Location 1',
        description: 'Description 1',
        createdAt: DateTime.now(),
        status: 'Menunggu',
      );
      fakeReportRepository.reportsList.add(mockReport);

      final expectedStates = [
        ReportsLoaded([mockReport]),
      ];

      expectLater(reportBloc.stream, emitsInOrder(expectedStates));

      reportBloc.add(const LoadReports());
    });
  });

  group('ReportSubmitted', () {
    test('should emit ReportLoading, ReportSuccess, and then ReportsLoaded on success', () async {
      final expectedReport = Report(
        id: '123',
        type: 'Kecelakaan',
        location: 'Jl. Sudirman',
        description: 'Ada kecelakaan beruntun',
        imageUrl: 'image.png',
        createdAt: DateTime(2026, 6, 6),
        status: 'Menunggu',
      );

      final expectedStates = [
        ReportLoading(),
        ReportSuccess(expectedReport),
        ReportsLoaded([expectedReport]),
      ];

      expectLater(reportBloc.stream, emitsInOrder(expectedStates));

      reportBloc.add(const ReportSubmitted(
        type: 'Kecelakaan',
        location: 'Jl. Sudirman',
        description: 'Ada kecelakaan beruntun',
        imagePath: 'image.png',
      ));
    });
  });
}
