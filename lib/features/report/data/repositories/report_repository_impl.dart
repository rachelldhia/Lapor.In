import 'package:dartz/dartz.dart';
import '../../domain/entities/report.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final List<Report> _reports = [
    Report(
      id: "1",
      type: "Kecelakaan",
      location: "Jl. Sudirman No. 12",
      description: "Telah terjadi kecelakaan tabrakan beruntun melibatkan 3 kendaraan (2 mobil dan 1 motor) di jalur cepat. Korban mengalami cedera ringan dan membutuhkan penanganan medis segera.",
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      status: "Menunggu",
    ),
    Report(
      id: "2",
      type: "Bencana Alam",
      location: "Jl. Diponegoro",
      description: "Pohon tumbang menghalangi jalan utama dari arah Diponegoro menuju pusat kota. Mengakibatkan kemacetan parah dan kabel listrik PLN terputus.",
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      status: "Diproses",
    ),
    Report(
      id: "3",
      type: "Lainnya",
      location: "Jl. Sudirman",
      description: "Lampu penerangan jalan umum mati di sepanjang jalan Sudirman dekat halte busway, menyebabkan kondisi jalan menjadi gelap gulita dan rawan kriminalitas.",
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      status: "Selesai",
    ),
    Report(
      id: "4",
      type: "Lainnya",
      location: "Kec. Sukasari",
      description: "Pipa air bersih PDAM mengalami kebocoran di pinggir jalan raya Sukasari menyebabkan air bersih terbuang sia-sia dan menggenangi aspal.",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: "Selesai",
    ),
    Report(
      id: "5",
      type: "Kriminalitas",
      location: "Pasar Baru",
      description: "Sampah rumah tangga dan pasar menumpuk di depan gang masuk Pasar Baru menyebabkan bau busuk menyengat dan mengundang lalat penyakit.",
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: "Ditolak",
    ),
  ];

  @override
  List<Report> getReports() {
    return _reports;
  }

  @override
  Future<Either<String, Report>> submitReport({
    required String type,
    required String location,
    required String description,
    String? imagePath,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    final newReport = Report(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      location: location,
      description: description,
      imageUrl: imagePath,
      createdAt: DateTime.now(),
      status: "Menunggu",
    );

    // Insert at the beginning of the list (so it shows as newest)
    _reports.insert(0, newReport);
    
    return Right(newReport);
  }
}

