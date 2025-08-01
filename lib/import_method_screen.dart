import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

// Top-level constant for medium gray text, accessible to any widget.
const Color mediumTextColor = Color(0xFF666666);

class ImportMethodScreen extends StatefulWidget {
  const ImportMethodScreen({Key? key}) : super(key: key);

  @override
  State<ImportMethodScreen> createState() => _ImportMethodScreenState();
}

class _ImportMethodScreenState extends State<ImportMethodScreen> {
  String? _selectedForm;

  static const Color _darkText = Color(0xFF333333);
  static const Color _panelBg = Color(0xFFFAF8F2);
  static const Color _buttonBg = Color(0xFFEFEFEF);
  static const Color _linkColor = Color(0xFF007BFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              Text(
                'GEARCHAIN > IMPORT > IMPORT',
                style: const TextStyle(
                  fontSize: 12,
                  color: mediumTextColor,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 24),
              // Page title
              const Text(
                'Choose your Import Method',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _darkText,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const SizedBox(
                width: 600,
                child: Text(
                  'Select one option to import your data. You can either upload a CSV file or connect to your Google Sheets.',
                  style: TextStyle(
                    fontSize: 14,
                    color: mediumTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Form label
              const Text(
                'Select a form to Import',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF444444),
                ),
              ),
              const SizedBox(height: 8),
              // Dropdown
              SizedBox(
                width: 300,
                child: DropdownButtonFormField<String>(
                  value: _selectedForm,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                  ),
                  hint: const Text('Form Name'),
                  items: const [
                    DropdownMenuItem(value: 'Product', child: Text('Product')),
                    DropdownMenuItem(value: 'Transfer', child: Text('Transfer')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedForm = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 32),
              // Two panel options
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 800;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildCsvPanel(isNarrow ? constraints.maxWidth : (constraints.maxWidth - 16) / 2),
                      _buildSheetPanel(isNarrow ? constraints.maxWidth : (constraints.maxWidth - 16) / 2),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCsvPanel(double width) {
    // Ensure the card never exceeds 500px while still filling available width.
    final double cardWidth = width.clamp(0.0, 500.0);

    return SizedBox(
      width: cardWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card container
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header bar
                  Container(
                    height: 56,
                    color: const Color(0xFFF7F3EA),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'CSV/Excel Import',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ),
                  // Body section
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 400,
                          child: Text(
                            'Import Products by CSV or XLSX files.\nMake sure your file is ready for import by checking your data formatting.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 20 / 14, // line-height 20px
                              color: mediumTextColor,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        const SizedBox(height: 32), // 32px spacing between desc and drop-zone
                        // Drop-zone box
                        DottedBorder(
                          color: const Color(0xFFCCCCCC),
                          strokeWidth: 2,
                          dashPattern: [6, 4],
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(6),
                          child: Container(
                            width: 200,
                            height: 140,
                            padding: const EdgeInsets.all(16),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.note_add_outlined,
                                  size: 48,
                                  color: Color(0xFF444444),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Add File',
                                  style: TextStyle(fontSize: 14, color: Color(0xFF444444)),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {},
            child: const Text(
              'Download sample CSV',
              style: TextStyle(
                fontSize: 14,
                color: _linkColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetPanel(double width) {
    final double cardWidth = width.clamp(0.0, 500.0);

    return SizedBox(
      width: cardWidth,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header bar
              Container(
                height: 56,
                color: const Color(0xFFF7F3EA),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Google Sheets Import',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
              ),
              // Body section
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Instruction list
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InstructionItem(text: '1. Open the Google Sheet you want to import'),
                        SizedBox(height: 8),
                        _InstructionItem(text: '2. Click the Share button in the top-right corner.'),
                        SizedBox(height: 8),
                        _InstructionItem(text: '3. Make a copy the link'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Connect button
                    Center(
                      child: Container(
                        width: 200,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Color(0xFFEFEFEF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.import_export, size: 48, color: Color(0xFF444444)),
                            SizedBox(height: 12),
                            Text(
                              'Connect Google Sheet',
                              style: TextStyle(fontSize: 14, color: Color(0xFF444444)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstructionItem extends StatelessWidget {
  final String text;
  const _InstructionItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 0),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: mediumTextColor),
          ),
        ),
      ],
    );
  }
} 