import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CattleFormPage extends StatefulWidget {
  @override
  State<CattleFormPage> createState() => _CattleFormPageState();
}

class _CattleFormPageState extends State<CattleFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Section 1 (Disabled - Read only)
  final _idController = TextEditingController(text: "12345");
  final _receptionIdController = TextEditingController(text: "RCP-001");
  final _supplierIdController = TextEditingController(text: "SUP-009");
  final _breedIdController = TextEditingController(text: "BRD-005");

  // Section 2 (Editable)
  final _barnIdController = TextEditingController();
  final _penIdController = TextEditingController();
  final _levelIdController = TextEditingController();
  final _earTagController = TextEditingController();
  final _initialWeightController = TextEditingController();
  final _initialPriceController = TextEditingController();
  final _medicalNotesController = TextEditingController();

  void _showBottomSheet({
    required String title,
    required String message,
    required String lottieAsset,
    Color? backgroundColor,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(lottieAsset, width: 100, repeat: false),
              SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Tutup'),
              )
            ],
          ),
        );
      },
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _showBottomSheet(
        title: "Validasi Gagal",
        message: "Beberapa field wajib masih kosong. Silakan lengkapi terlebih dahulu.",
        lottieAsset: 'assets/animations/error.json',
        backgroundColor: Colors.red.shade50,
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() => _isSubmitting = false);

    _showBottomSheet(
      title: "Berhasil!",
      message: "Data sapi telah berhasil disimpan.",
      lottieAsset: 'assets/animations/success.json',
      backgroundColor: Colors.green.shade50,
    );
  }

  Widget _buildReadOnlyTile(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey.shade600)),
                Text(value, style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: isRequired
            ? (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeColor = Color(0xFFFF6B6B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Form Input Sapi"),
        backgroundColor: themeColor,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            Text("🔒 Data Otomatis", style: theme.textTheme.titleMedium),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildReadOnlyTile("ID", _idController.text, Icons.info_outline),
                  _buildReadOnlyTile("Reception ID", _receptionIdController.text, Icons.how_to_reg),
                  _buildReadOnlyTile("Supplier ID", _supplierIdController.text, Icons.person),
                  _buildReadOnlyTile("Breed ID", _breedIdController.text, Icons.pets),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text("📋 Data Editable", style: theme.textTheme.titleMedium),
            SizedBox(height: 12),
            _buildFormField(label: "Barn ID", icon: Icons.home_work, controller: _barnIdController, isRequired: true),
            _buildFormField(label: "Pen ID", icon: Icons.cabin, controller: _penIdController, isRequired: true),
            _buildFormField(label: "Level ID", icon: Icons.layers, controller: _levelIdController, isRequired: true, keyboardType: TextInputType.number),
            _buildFormField(label: "Ear Tag", icon: Icons.tag, controller: _earTagController, isRequired: true),
            _buildFormField(label: "Initial Weight", icon: Icons.line_weight, controller: _initialWeightController, keyboardType: TextInputType.number),
            _buildFormField(label: "Initial Price", icon: Icons.monetization_on, controller: _initialPriceController, keyboardType: TextInputType.number),
            _buildFormField(label: "Medical Notes", icon: Icons.note, controller: _medicalNotesController),
            SizedBox(height: 24),
            _isSubmitting
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text("Simpan", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}