import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Report extends Equatable {
  final String id;
  final String type;
  final String location;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final String status;

  const Report({
    required this.id,
    required this.type,
    required this.location,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": type == 'Kecelakaan'
          ? 'Kecelakaan Lalu Lintas'
          : type == 'Bencana Alam'
              ? 'Pohon Tumbang'
              : type == 'Lainnya'
                  ? 'Lampu Jalan Mati'
                  : type,
      "location": location,
      "description": description,
      "date": _formatDate(createdAt),
      "status": status,
      "color": _getStatusColor(status),
      "imageUrl": imageUrl,
    };
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return "${diff.inMinutes == 0 ? 1 : diff.inMinutes} menit lalu";
    } else if (diff.inHours < 24) {
      return "${diff.inHours} jam lalu";
    } else {
      return "${diff.inDays} hari lalu";
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Menunggu':
        return Colors.amber;
      case 'Diproses':
        return Colors.blue;
      case 'Selesai':
        return Colors.green;
      case 'Ditolak':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  List<Object?> get props => [id, type, location, description, imageUrl, createdAt, status];
}

