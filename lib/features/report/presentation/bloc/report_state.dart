import 'package:equatable/equatable.dart';
import '../../domain/entities/report.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {
  final Report report;

  const ReportSuccess(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportFailure extends ReportState {
  final String message;

  const ReportFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ReportsLoaded extends ReportState {
  final List<Report> reports;

  const ReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

