import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:laporin/theme.dart';
import 'calling_page.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  final TextEditingController _searchController = TextEditingController();
  
  // Segmented tab state: 0 = Layanan Publik, 1 = Kontak Pribadi
  int _activeTabIndex = 0;

  final List<Map<String, String>> _contacts = [
    {"name": "Brandon", "phone": "081382397623", "type": "Personal"},
    {"name": "Panggilan Darurat", "phone": "112", "type": "Umum"},
    {"name": "Kepolisian RI", "phone": "110", "type": "Umum"},
    {"name": "Ambulans & Medis", "phone": "118", "type": "Umum"},
    {"name": "Pemadam Kebakaran", "phone": "113", "type": "Umum"},
  ];

  // Realistic mock data for phone contacts database
  final List<Map<String, String>> _deviceContacts = [
    {"name": "Siti Aminah", "phone": "081234567890"},
    {"name": "Budi Santoso", "phone": "081398765432"},
    {"name": "Andi Wijaya", "phone": "085712345678"},
    {"name": "Dewi Lestari", "phone": "081987654321"},
    {"name": "Eko Prasetyo", "phone": "081298761234"},
    {"name": "Fani Rahmawati", "phone": "081312348765"},
    {"name": "Heri Kurniawan", "phone": "085298765432"},
    {"name": "Indah Permatasari", "phone": "081234560000"},
    {"name": "Joko Widodo", "phone": "081100223344"},
    {"name": "Rini Handayani", "phone": "087812345678"},
  ];

  List<Map<String, String>> _filteredContacts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _updateFilteredContacts();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _updateFilteredContacts();
  }

  void _updateFilteredContacts() {
    final query = _searchController.text.toLowerCase();
    final targetType = _activeTabIndex == 0 ? "Umum" : "Personal";
    
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        final matchesType = contact["type"] == targetType;
        if (!matchesType) return false;
        
        final name = contact["name"]!.toLowerCase();
        final phone = contact["phone"]!.toLowerCase();
        return name.contains(query) || phone.contains(query);
      }).toList();
    });
  }

  void _addNewContact(String name, String phone) {
    setState(() {
      _contacts.insert(0, {"name": name, "phone": phone, "type": "Personal"});
      _updateFilteredContacts();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Kontak '$name' berhasil ditambahkan!"),
        backgroundColor: const Color(0xFFCC2D30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final deviceSearchController = TextEditingController();
    
    List<Map<String, String>> filteredDeviceContacts = List.from(_deviceContacts);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void updateDeviceSearch(String q) {
              final query = q.toLowerCase();
              setModalState(() {
                filteredDeviceContacts = _deviceContacts.where((c) {
                  return c["name"]!.toLowerCase().contains(query) ||
                      c["phone"]!.contains(query);
                }).toList();
              });
            }

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Color(0xFFFBEAEA), // Light red-pink theme matching Lapor.In
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
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
                        "Tambah Kontak",
                        style: AppTextStyles.heading1.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Main Scrollable Area
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tab-like section indicator
                          const Text(
                            "Input Manual",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              "Nama Kontak",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: nameController,
                              style: AppTextStyles.bodyMedium,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                hintText: "Masukkan nama kontak",
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              "Nomor Telepon",
                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: phoneController,
                              style: AppTextStyles.bodyMedium,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                hintText: "Masukkan nomor telepon",
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                final name = nameController.text.trim();
                                final phone = phoneController.text.trim();
                                if (name.isNotEmpty && phone.isNotEmpty) {
                                  _addNewContact(name, phone);
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCC2D30),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "Simpan Kontak",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Sync from device section
                          Row(
                            children: [
                              const Icon(Icons.sync_rounded, color: Color(0xFFCC2D30), size: 18),
                              const SizedBox(width: 8),
                              const Text(
                                "Sinkronisasi dari Kontak HP",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: Colors.green, size: 12),
                                    SizedBox(width: 4),
                                    Text(
                                      "Tersinkron",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Search Device Contacts
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: TextField(
                              controller: deviceSearchController,
                              style: AppTextStyles.bodyMedium,
                              onChanged: updateDeviceSearch,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                                contentPadding: EdgeInsets.symmetric(vertical: 12),
                                hintText: "Cari nama kontak di HP...",
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // List of device contacts
                          if (filteredDeviceContacts.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: Text(
                                  "Tidak ada kontak ditemukan",
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ),
                            )
                          else
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredDeviceContacts.length,
                              separatorBuilder: (context, idx) => const SizedBox(height: 8),
                              itemBuilder: (context, idx) {
                                final devContact = filteredDeviceContacts[idx];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: const Color(0xFFFED7D7),
                                        radius: 18,
                                        child: Text(
                                          devContact["name"]![0].toUpperCase(),
                                          style: const TextStyle(
                                            color: Color(0xFFE53E3E),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              devContact["name"]!,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              devContact["phone"]!,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 11.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Quick Add Icon Button
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          _addNewContact(
                                            devContact["name"]!,
                                            devContact["phone"]!,
                                          );
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.add_rounded, size: 14),
                                        label: const Text("Tambah", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFFCC2D30),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _callContact(String name, String phone) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CallingPage(
          contactName: name,
          phoneNumber: phone,
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeTabIndex = 0;
                  _updateFilteredContacts();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _activeTabIndex == 0 ? const Color(0xFFCC2D30) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _activeTabIndex == 0
                      ? [
                          BoxShadow(
                            color: const Color(0xFFCC2D30).withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  "Layanan Publik",
                  style: TextStyle(
                    color: _activeTabIndex == 0 ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeTabIndex = 1;
                  _updateFilteredContacts();
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: _activeTabIndex == 1 ? const Color(0xFFCC2D30) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _activeTabIndex == 1
                      ? [
                          BoxShadow(
                            color: const Color(0xFFCC2D30).withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  "Kontak Pribadi",
                  style: TextStyle(
                    color: _activeTabIndex == 1 ? Colors.white : Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Kontak Darurat",
          style: AppTextStyles.heading1.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: Container(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 12),
                
                // Premium Segmented Tab Selector
                _buildSegmentedControl(),
                
                const SizedBox(height: 16),
                
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: AppTextStyles.bodyMedium,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: _activeTabIndex == 0
                          ? "Cari Layanan Publik..."
                          : "Cari Kontak Pribadi...",
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
                
                // Contact List
                Expanded(
                  child: _filteredContacts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _activeTabIndex == 0
                                    ? Icons.local_hospital_rounded
                                    : Icons.people_outline_rounded,
                                size: 48,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _activeTabIndex == 0
                                    ? "Layanan publik tidak ditemukan"
                                    : "Kontak pribadi belum ditambahkan",
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(bottom: 100),
                          physics: const BouncingScrollPhysics(),
                          itemCount: _filteredContacts.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = _filteredContacts[index];
                            final isPersonal = item["type"] == "Personal";

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.75),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      // Circular Avatar Indicator
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: isPersonal
                                              ? const Color(0xFFFED7D7)
                                              : const Color(0xFFE2E8F0),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isPersonal ? Icons.person_rounded : Icons.local_phone_rounded,
                                          color: isPersonal
                                              ? const Color(0xFFE53E3E)
                                              : const Color(0xFF4A5568),
                                          size: 22,
                                        ),
                                      ),
                                      const SizedBox(width: 14),
                                      // Contact Name and Phone
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item["name"]!,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item["phone"]!,
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Calling Action Icon
                                      IconButton(
                                        icon: const Icon(Icons.phone_enabled_rounded,
                                            color: Color(0xFFCC2D30), size: 24),
                                        onPressed: () => _callContact(item["name"]!, item["phone"]!),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      // FAB only displays for Kontak Pribadi tab to maintain clean UX boundaries
      floatingActionButton: _activeTabIndex == 1
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100.0, right: 8.0),
              child: FloatingActionButton.extended(
                onPressed: _showAddContactDialog,
                backgroundColor: const Color(0xFFCC2D30),
                foregroundColor: Colors.white,
                elevation: 4,
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  "Tambah Kontak",
                  style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2),
                ),
              ),
            )
          : null,
    );
  }
}
