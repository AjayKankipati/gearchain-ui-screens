import 'package:flutter/material.dart';

// Design tokens
const _bg = Color(0xFFF7F8FA);
const _fontDark = Color(0xFF222222);
const _muted = Color(0xFF6B7280);
const _subtitle = Color(0xFF555555);
const _helper = Color(0xFF777777);
const _border = Color(0xFFE5E7EB);
const _cardBorder = Color(0xFFD9D9D9);
const _desc = Color(0xFF666666);
const _toggleOff = Color(0xFFEEEEEE);
const _toggleRed = Color(0xFFE11D48);
// Icon colors
const _excelIconColor = _fontDark;
const _oneDriveBlue = Color(0xFF2F6FE4);
const _gsGreen = Color(0xFF34A853);
const _autoLabelRed = _toggleRed;

class ExportMethodScreen extends StatelessWidget {
  const ExportMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GEARCHAIN > Import / Export > Export',
                    style: TextStyle(fontSize: 12, color: _muted)),
                const SizedBox(height: 16),
                const Text('Choose your Export Method',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _fontDark)),
                const SizedBox(height: 8),
                const Text(
                  'Select an option to export your data: Download an Excel file or export to connected cloud storage. Linked account and access permission required.',
                  style: TextStyle(fontSize: 14, color: _subtitle),
                ),
                const SizedBox(height: 32),
                // Card container
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Export to:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _fontDark)),
                          const SizedBox(height: 4),
                          const Text('Choose how to export your data: download to your computer or send to your cloud storage.',
                              style: TextStyle(fontSize: 13, color: _helper)),
                          const SizedBox(height: 16),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isNarrow = constraints.maxWidth < 650;
                              return Wrap(
                                spacing: 24,
                                runSpacing: 24,
                                children: [
                                  _ExportCard(
                                    icon: Icons.insert_drive_file_outlined,
                                    iconColor: _excelIconColor,
                                    title: 'Excel file',
                                    description: 'Download your file as an Excel file directly to your computer.',
                                  ),
                                  _ExportCard(
                                    icon: Icons.cloud,
                                    iconColor: _oneDriveBlue,
                                    title: 'OneDrive',
                                    description: 'Sign in to Microsoft to save to OneDrive. Business account required to enable autosync after export.',
                                    showToggle: true,
                                  ),
                                  _ExportCard(
                                    icon: Icons.table_view,
                                    iconColor: _gsGreen,
                                    title: 'Google Sheets',
                                    description: 'Sign in to Gmail to save to Google Drive. Autosync can be enabled after export.',
                                    showToggle: true,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExportCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final bool showToggle;
  const _ExportCard({required this.icon, required this.iconColor, required this.title, required this.description, this.showToggle = false});

  @override
  State<_ExportCard> createState() => _ExportCardState();
}

class _ExportCardState extends State<_ExportCard> {
  bool _auto = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 240,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _cardBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, size: 32, color: widget.iconColor),
                    const SizedBox(width: 8),
                    Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.description,
                    style: const TextStyle(fontSize: 13, color: _desc), textAlign: TextAlign.center),
              ],
            ),
            if (widget.showToggle)
              Row(
                children: [
                  Text('Auto Sync', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _autoLabelRed)),
                  const Spacer(),
                  Switch(
                    value: _auto,
                    onChanged: (v) => setState(() => _auto = v),
                    activeColor: Colors.white,
                    activeTrackColor: _toggleRed,
                    inactiveThumbColor: _toggleRed,
                    inactiveTrackColor: _toggleOff,
                  ),
                ],
              )
            else
              const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
} 