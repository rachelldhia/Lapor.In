import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:laporin/theme.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List<Map<String, dynamic>> _addresses = [
    {
      "id": "1",
      "tag": "Rumah",
      "isPrimary": true,
      "recipient": "Eve",
      "phone": "+628123456789",
      "address": "Jl. Sudirman No. 12, Blok C3, Karet Semanggi, Kecamatan Setiabudi, Kota Jakarta Selatan, DKI Jakarta 12930",
    },
    {
      "id": "2",
      "tag": "Kantor",
      "isPrimary": false,
      "recipient": "Eve (Office)",
      "phone": "+628123456789",
      "address": "Menara BTPN Lt. 30, Jl. Dr. Ide Anak Agung Gde Agung Kav 5.5-5.6, Mega Kuningan, Kecamatan Setiabudi, Kota Jakarta Selatan, DKI Jakarta 12950",
    },
  ];

  void _saveAddress({
    String? id,
    required String tag,
    required String recipient,
    required String phone,
    required String address,
    required bool isPrimary,
  }) {
    setState(() {
      if (isPrimary) {
        for (var addr in _addresses) {
          addr["isPrimary"] = false;
        }
      }

      if (id != null) {
        final index = _addresses.indexWhere((a) => a["id"] == id);
        if (index != -1) {
          _addresses[index] = {
            "id": id,
            "tag": tag,
            "isPrimary": isPrimary,
            "recipient": recipient,
            "phone": phone,
            "address": address,
          };
        }
      } else {
        _addresses.add({
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "tag": tag,
          "isPrimary": isPrimary,
          "recipient": recipient,
          "phone": phone,
          "address": address,
        });
      }
    });
  }

  void _showAddressBottomSheet(BuildContext context, {Map<String, dynamic>? address}) {
    final formKey = GlobalKey<FormState>();
    final tagController = TextEditingController(text: address?["tag"] ?? "");
    final recipientController = TextEditingController(text: address?["recipient"] ?? "");
    final phoneController = TextEditingController(text: address?["phone"] ?? "");
    final addressController = TextEditingController(text: address?["address"] ?? "");
    bool isPrimary = address?["isPrimary"] ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFBEAEA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.fromLTRB(24, 8, 24, MediaQuery.of(context).viewInsets.bottom + 24),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        address == null ? "Tambah Alamat Baru" : "Ubah Alamat",
                        style: AppTextStyles.heading1.copyWith(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: tagController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: "Label Alamat (cth: Rumah, Kantor)",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC2D30)),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Label tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: recipientController,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: "Nama Penerima",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC2D30)),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Nama penerima tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: "Nomor Telepon",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC2D30)),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Nomor telepon tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: addressController,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          labelText: "Alamat Lengkap",
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFCC2D30)),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? "Alamat tidak boleh kosong" : null,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile.adaptive(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "Jadikan Alamat Utama",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        activeTrackColor: const Color(0xFFCC2D30).withValues(alpha: 0.5),
                        activeThumbColor: const Color(0xFFCC2D30),
                        value: isPrimary,
                        onChanged: (val) {
                          setState(() {
                            isPrimary = val;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCC2D30),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;
                            _saveAddress(
                              id: address?["id"],
                              tag: tagController.text.trim(),
                              recipient: recipientController.text.trim(),
                              phone: phoneController.text.trim(),
                              address: addressController.text.trim(),
                              isPrimary: isPrimary,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(this.context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  address == null ? "Alamat baru ditambahkan!" : "Alamat berhasil diperbarui!",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text("Simpan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: AlertDialog(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
            ),
            title: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC2D30).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Color(0xFFCC2D30),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Hapus Alamat",
                  style: AppTextStyles.heading1.copyWith(fontSize: 18),
                ),
              ],
            ),
            content: const Text(
              "Apakah Anda yakin ingin menghapus alamat ini?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 13),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  "Batal",
                  style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCC2D30),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  setState(() {
                    _addresses.removeWhere((a) => a["id"] == id);
                  });
                  Navigator.pop(dialogContext);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Alamat berhasil dihapus!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text("Hapus"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Alamat",
          style: AppTextStyles.heading1.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          child: Stack(
            children: [
              _addresses.isEmpty
                  ? Center(
                      child: Text(
                        "Belum ada alamat tersimpan",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daftar Alamat Tersimpan",
                            style: AppTextStyles.heading2.copyWith(fontSize: 15, color: Colors.black87),
                          ),
                          const SizedBox(height: 16),
                          ..._addresses.map((address) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildAddressCard(
                                address: address,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
              Positioned(
                bottom: 24,
                left: 24,
                right: 24,
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFCC2D30), Color(0xFFE53E3E)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCC2D30).withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      _showAddressBottomSheet(context);
                    },
                    icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white),
                    label: const Text(
                      "Tambah Alamat Baru",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard({
    required Map<String, dynamic> address,
  }) {
    final String tag = address["tag"];
    final bool isPrimary = address["isPrimary"];
    final String recipient = address["recipient"];
    final String phone = address["phone"];
    final String addressText = address["address"];
    final String id = address["id"];

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isPrimary ? const Color(0xFFCC2D30).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isPrimary ? const Color(0xFFCC2D30) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: isPrimary ? Colors.white : Colors.grey.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isPrimary)
                    const Text(
                      "Utama",
                      style: TextStyle(
                        color: Color(0xFFCC2D30),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                recipient,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                addressText,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showAddressBottomSheet(context, address: address);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFFCC2D30)),
                    label: const Text(
                      "Ubah",
                      style: TextStyle(color: Color(0xFFCC2D30), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: () {
                      _showDeleteConfirmDialog(context, id);
                    },
                    icon: Icon(Icons.delete_outline_rounded, size: 16, color: Colors.grey.shade600),
                    label: Text(
                      "Hapus",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

