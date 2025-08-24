import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Enum untuk merepresentasikan jenis laporan yang dipilih
enum ReportType { harian, mingguan, bulanan, produkTerlaris }

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  // State untuk melacak laporan yang sedang aktif/dipilih
  ReportType _selectedReport = ReportType.harian;

  // State untuk tanggal
  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();

  // Fungsi untuk mengubah laporan yang dipilih
  void _selectReport(ReportType reportType) {
    setState(() {
      _selectedReport = reportType;
    });
  }

  // Fungsi untuk mendapatkan judul laporan berdasarkan enum yang dipilih
  String _getReportTitle() {
    switch (_selectedReport) {
      case ReportType.harian:
        return 'Laporan Harian';
      case ReportType.mingguan:
        return 'Laporan Mingguan';
      case ReportType.bulanan:
        return 'Laporan Bulanan';
      case ReportType.produkTerlaris:
        return 'Laporan Produk Terlaris';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // Panel Kiri: Pilihan Laporan
          Expanded(
            flex: 2,
            child: _buildSelectionPanel(),
          ),
          // Garis pemisah vertikal
          const VerticalDivider(width: 1, thickness: 1),
          // Panel Kanan: Detail Laporan
          Expanded(
            flex: 3,
            child: _buildReportDetailsPanel(),
          ),
        ],
      ),
    );
  }

  // Widget untuk panel kiri (pemilihan)
  Widget _buildSelectionPanel() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Report',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(DateTime.now()),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          // Widget untuk memilih rentang tanggal
          _buildDatePickerRow(),
          const SizedBox(height: 24),
          // Grid untuk kartu pilihan laporan
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _ReportSelectionCard(
                  title: 'Laporan Harian',
                  icon: Icons.today,
                  isSelected: _selectedReport == ReportType.harian,
                  onTap: () => _selectReport(ReportType.harian),
                ),
                _ReportSelectionCard(
                  title: 'Laporan Mingguan',
                  icon: Icons.calendar_view_week,
                  isSelected: _selectedReport == ReportType.mingguan,
                  onTap: () => _selectReport(ReportType.mingguan),
                ),
                _ReportSelectionCard(
                  title: 'Laporan Bulanan',
                  icon: Icons.calendar_month,
                  isSelected: _selectedReport == ReportType.bulanan,
                  onTap: () => _selectReport(ReportType.bulanan),
                ),
                _ReportSelectionCard(
                  title: 'Produk Terlaris',
                  icon: Icons.star,
                  isSelected: _selectedReport == ReportType.produkTerlaris,
                  onTap: () => _selectReport(ReportType.produkTerlaris),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk baris date picker
  Widget _buildDatePickerRow() {
    return Row(
      children: [
        Expanded(
          child: _DatePickerField(
            label: 'From',
            date: _fromDate,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _fromDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  _fromDate = pickedDate;
                });
              }
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _DatePickerField(
            label: 'To',
            date: _toDate,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: _toDate,
                firstDate: _fromDate,
                lastDate: DateTime(2101),
              );
              if (pickedDate != null) {
                setState(() {
                  _toDate = pickedDate;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  // Widget untuk panel kanan (detail)
  Widget _buildReportDetailsPanel() {
    final formattedFromDate =
        DateFormat('d MMMM yyyy', 'id_ID').format(_fromDate);
    final formattedToDate = DateFormat('d MMMM yyyy', 'id_ID').format(_toDate);

    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getReportTitle(),
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  // TODO: Implement PDF export logic
                },
                icon: const Icon(Icons.download_for_offline_outlined),
                label: const Text('PDF'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                ),
              )
            ],
          ),
          Text(
            '$formattedFromDate to $formattedToDate',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          // Di sini Anda bisa menampilkan konten laporan yang berbeda
          // berdasarkan `_selectedReport`.
          // Untuk contoh ini, kita gunakan layout summary yang sama.
          Expanded(child: _buildSummaryContent()),
        ],
      ),
    );
  }

  // Placeholder konten summary
  Widget _buildSummaryContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
            )
          ]),
      child: Column(
        children: [
          const Text(
            'REVENUE: Rp. 0',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
          ),
          const SizedBox(height: 20),
          const Divider(thickness: 1),
          _buildSummaryRow('Subtotal', 'Rp. 0'),
          _buildSummaryRow('Discount', '- Rp. 0'),
          const Divider(),
          _buildSummaryRow('Tax', 'Rp. 0'),
          _buildSummaryRow('Service Charge', 'Rp. 0'),
          const Divider(thickness: 1),
          const SizedBox(height: 10),
          _buildSummaryRow('TOTAL', 'Rp. 0', isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String amount, {bool isTotal = false}) {
    final style = TextStyle(
      fontSize: isTotal ? 18 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: Colors.grey[800],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: style),
          Text(amount, style: style),
        ],
      ),
    );
  }
}

// Widget kustom untuk kartu pilihan laporan
class _ReportSelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReportSelectionCard({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade600,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.blue.shade800 : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget kustom untuk field tanggal
class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d MMM yyyy').format(date),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
