import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class ReportSubmitted extends ReportEvent {
  final String type;
  final String location;
  final String description;
  final String? imagePath;

  const ReportSubmitted({
    required this.type,
    required this.location,
    required this.description,
    this.imagePath,
  });

  @override
  List<Object?> get props => [type, location, description, imagePath];
}

class LoadReports extends ReportEvent {
  const LoadReports();
}

