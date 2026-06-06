import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_report.dart';
import '../../domain/usecases/get_reports.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final SubmitReport submitReport;
  final GetReports getReports;

  ReportBloc({
    required this.submitReport,
    required this.getReports,
  }) : super(ReportInitial()) {
    on<LoadReports>((event, emit) {
      final reports = getReports();
      emit(ReportsLoaded(List.from(reports)));
    });

    on<ReportSubmitted>((event, emit) async {
      emit(ReportLoading());
      final result = await submitReport(
        type: event.type,
        location: event.location,
        description: event.description,
        imagePath: event.imagePath,
      );
      
      result.fold(
        (failure) => emit(ReportFailure(failure)),
        (report) {
          emit(ReportSuccess(report));
          // Emit updated reports list so any list builders immediately get the new report
          emit(ReportsLoaded(List.from(getReports())));
        },
      );
    });
  }
}

