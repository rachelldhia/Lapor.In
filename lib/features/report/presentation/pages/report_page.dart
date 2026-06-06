import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laporin/theme.dart';
import 'package:laporin/widgets/custom_button.dart';
import '../bloc/report_bloc.dart';
import '../bloc/report_event.dart';
import '../bloc/report_state.dart';
import 'success_page.dart';
import 'package:laporin/features/home/presentation/pages/map_page.dart';
import 'dart:developer' as developer;

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedType;
  File? _selectedImage;
  File? _selectedVideo;
  File? _selectedAudio;
  final ImagePicker _picker = ImagePicker();

  final List<String> _reportTypes = [
    'Kecelakaan',
    'Kebakaran',
    'Kriminalitas',
    'Bencana Alam',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _locationController.text = "Gunakan lokasi saat ini"; // Default matching design
  }

  @override
  void dispose() {
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Kirim Laporan",
          style: AppTextStyles.heading1.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SuccessPage()),
            );
          } else if (state is ReportFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.gradientColors,
              stops: AppColors.gradientStops,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _buildFormSection(),
                  const SizedBox(height: 24),
                  BlocBuilder<ReportBloc, ReportState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: state is ReportLoading ? "Mengirim..." : "Kirim",
                        onPressed: state is ReportLoading
                            ? null
                            : () {
                                if (_selectedType == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Pilih jenis kejadian terlebih dahulu')),
                                  );
                                  return;
                                }
                                context.read<ReportBloc>().add(
                                      ReportSubmitted(
                                        type: _selectedType!,
                                        location: _locationController.text,
                                        description: _descriptionController.text,
                                        imagePath: _selectedImage?.path,
                                      ),
                                    );
                              },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFBEAEA), // Light pink color matching design card background
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Jenis Kejadian"),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                hint: Text(
                  "Pilih jenis kejadian",
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade500),
                ),
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 28),
                items: _reportTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel("Lokasi Kejadian"),
              GestureDetector(
                onTap: () => _showLocationBottomSheet(context),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    "Change",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _showLocationBottomSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: TextField(
                        controller: _locationController,
                        style: AppTextStyles.bodyMedium,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.grey.shade600, size: 28),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          _buildLabel("Deskripsi"),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: "Jelaskan kejadian secara singkat...",
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey.shade500),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          _buildLabel("Foto/Bukti"),
          _buildThreeColumnUploadArea(),
          
          const SizedBox(height: 20),
          _buildWarningBanner(),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 14,
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Widget _buildThreeColumnUploadArea() {
    return Row(
      children: [
        // 1. Upload Image
        Expanded(
          child: _buildUploadCard(
            icon: Icons.camera_alt_outlined,
            label: "UPLOAD\nIMAGE",
            isSelected: _selectedImage != null,
            file: _selectedImage,
            onTap: _pickImage,
            onClear: () {
              setState(() {
                _selectedImage = null;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        // 2. Upload Video
        Expanded(
          child: _buildUploadCard(
            icon: Icons.videocam_outlined,
            label: "UPLOAD\nVIDEO",
            isSelected: _selectedVideo != null,
            file: _selectedVideo,
            onTap: () {
              // Simulate video pick
              developer.log("Pick video");
            },
            onClear: () {
              setState(() {
                _selectedVideo = null;
              });
            },
          ),
        ),
        const SizedBox(width: 12),
        // 3. Voice Recording
        Expanded(
          child: _buildUploadCard(
            icon: Icons.mic_none_outlined,
            label: "VOICE\nRECORDING",
            isSelected: _selectedAudio != null,
            file: _selectedAudio,
            onTap: () {
              // Simulate voice record
              developer.log("Record voice");
            },
            onClear: () {
              setState(() {
                _selectedAudio = null;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCard({
    required IconData icon,
    required String label,
    required bool isSelected,
    required File? file,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: _DashedRectPainter(color: const Color(0xFFFCA5A5)), // Red-pink dashed border
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFFEEAEA), // Light red-pink background matching mockup design
            borderRadius: BorderRadius.circular(16),
            image: isSelected && file != null
                ? DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: isSelected
              ? Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "READY",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: onClear,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 24, color: AppColors.primary),
                    const SizedBox(height: 6),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEEAEA), // Light red/pink warning background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Laporan palsu dapat dihukum menurut hukum. Gunakan layanan ini hanya untuk keadaan darurat yang sebenarnya membutuhkan bantuan segera.",
              style: TextStyle(
                color: Color(0xFF7F1D1D), // Dark red warning text
                fontSize: 10.5,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFBEAEA), // Light red-pink color matching card background
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.fromLTRB(24, 8, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Drag Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // 2. Header (Back Button + Title)
              Row(
                children: [
                  // Back Circular Card Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Pilih Lokasi Kejadian",
                    style: AppTextStyles.heading1.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // 3. Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  style: AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    hintText: "Search Address",
                    hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 4. Map Preview Stack
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 160,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // Map Background image
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/map_placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        
                        // Center Location Marker
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "Lokasi Terkini",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 36,
                              ),
                            ],
                          ),
                        ),
                        
                        // Lacak Lokasi Saya Floating Button (bottom right)
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade300, width: 1),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.gps_fixed, color: Colors.red, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  "Lacak Lokasi Saya",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // 5. Selected Location label and inputs
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Jl. Sudirman No. 12",
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Input 1: Sudirman (Red border, focused)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red, width: 1.5),
                ),
                child: TextField(
                  controller: TextEditingController(text: "Sudirman"),
                  style: AppTextStyles.bodyMedium,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Input 2: No 12
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: TextField(
                  controller: TextEditingController(text: "No 12"),
                  style: AppTextStyles.bodyMedium,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              
              // Input 3: 411038
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: TextField(
                  controller: TextEditingController(text: "411038"),
                  style: AppTextStyles.bodyMedium,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // 6. Action Button: Konfirmasi Lokasi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _locationController.text = "Jl. Sudirman No. 12";
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCC2D30),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  child: const Text("Konfirmasi Lokasi"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  _DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 6, dashSpace = 4;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    
    RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(16),
    );
    
    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();
    
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
