import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Added for BackdropFilter
import 'dart:ui'; // Added for ImageFilter

// Color constants
const Color pageBgColor = Color(0xFFF5F5F5);
const Color black = Color(0xFF111111);
const Color primaryDark = Color(0xFF222222);
const Color secondaryGray = Color(0xFF444444);
const Color bodyGray = Color(0xFF666666);
const Color lightGrayBorder = Color(0xFFE0E0E0);
const Color panelBeige = Color(0xFFF7F3EA);
const Color errorRed = Color(0xFFE05A4F);

class GoogleSheetsSyncScreen extends StatefulWidget {
  const GoogleSheetsSyncScreen({Key? key}) : super(key: key);

  @override
  State<GoogleSheetsSyncScreen> createState() => _GoogleSheetsSyncScreenState();
}

class _GoogleSheetsSyncScreenState extends State<GoogleSheetsSyncScreen> {
  bool _autoSync = true;

  final List<Map<String, dynamic>> _forms = [
    {'name': 'Form Name 1', 'products': 196},
    {'name': 'Form Name 2', 'products': 583},
    {'name': 'Form Name 3', 'products': 798},
    {'name': 'Form Name 4', 'products': 423},
    {'name': 'Form Name 5', 'products': 556},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBgColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Breadcrumb
                  const Text(
                    'GEARCHAIN > IMPORT > GOOGLE SHEETS SYNC',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF777777),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title & Tabs row
                  Row(
                    children: [
                      const Text(
                        'Google Sheets Sync',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: primaryDark,
                        ),
                      ),
                      const Spacer(),
                      _TabButton(
                        label: 'Import',
                        active: false,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _TabButton(
                        label: 'Export',
                        active: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Section header
                  const Text(
                    'Export',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'All your forms below will be exported to Google Sheets.',
                    style: TextStyle(fontSize: 14, color: bodyGray),
                  ),
                  const SizedBox(height: 24),
                  // Forms table
                  _buildTable(),
                  const SizedBox(height: 32),
                  // AutoSync toggle card
                  _buildAutoSyncCard(),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'AutoSync can be enabled after export.',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: lightGrayBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Header row
              Container(
                height: 56,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: lightGrayBorder),
                  ),
                ),
                child: Row(
                  children: [
                    _buildHeaderCell('Name', flex: 2, alignment: Alignment.centerLeft),
                    _buildHeaderCell('Products', flex: 1, alignment: Alignment.center),
                    _buildHeaderCell('Notes', flex: 1, alignment: Alignment.center),
                  ],
                ),
              ),
              // Data rows
              ..._forms.asMap().entries.map((entry) {
                final idx = entry.key;
                final data = entry.value;
                return GestureDetector(
                  onTap: () async {
                    final url = await _showGoogleSheetUrlDialog(context);
                    if (url != null && url.isNotEmpty) {
                      // For demo, just print. Replace with your logic.
                      debugPrint('URL entered for ${data['name']}: $url');
                    }
                  },
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      border: idx == _forms.length - 1
                          ? const Border()
                          : const Border(
                              bottom: BorderSide(color: lightGrayBorder),
                            ),
                    ),
                    child: Row(
                      children: [
                        // Name cell with icon
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.folder_open_outlined, size: 20, color: bodyGray),
                                const SizedBox(width: 8),
                                Text(
                                  data['name'],
                                  style: const TextStyle(fontSize: 14, color: primaryDark),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Products
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              '',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                        ),
                        // Notes (empty)
                        const Expanded(
                          flex: 1,
                          child: Center(child: Text('')),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {required int flex, required Alignment alignment}) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: secondaryGray),
          ),
        ),
      ),
    );
  }

  Widget _buildAutoSyncCard() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: lightGrayBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AutoSync Google Sheets',
                style: TextStyle(fontSize: 14, color: primaryDark),
              ),
              _AutoSyncSwitch(value: _autoSync, onChanged: (v) => setState(() => _autoSync = v)),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _showGoogleSheetUrlDialog(BuildContext context) {
    return showGeneralDialog<String>(
      context: context,
      barrierLabel: 'Google Sheet URL',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children: [
            // Blur backdrop
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: _GoogleSheetUrlDialog(),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: ScaleTransition(scale: anim1, child: child));
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabButton({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 104,
        height: 40,
        decoration: BoxDecoration(
          color: active ? black : panelBeige,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: active ? Colors.white : errorRed,
          ),
        ),
      ),
    );
  }
}

class _AutoSyncSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _AutoSyncSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? errorRed : const Color(0xFFCCCCCC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // On label
            if (value)
              Center(
                child: Text(
                  'ON',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            // Knob
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------------------------------
// Google Sheet URL Modal Dialog
// -------------------------------------------------------------------------------------------------

class _GoogleSheetUrlDialog extends StatefulWidget {
  @override
  State<_GoogleSheetUrlDialog> createState() => _GoogleSheetUrlDialogState();
}

class _GoogleSheetUrlDialogState extends State<_GoogleSheetUrlDialog> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Autofocus when first frame rendered
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    if (_controller.text.trim().isNotEmpty) {
      Navigator.of(context).pop(_controller.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Google Sheet URL dialog',
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(48, 40, 48, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 30)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Google Sheet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter Google Sheet URL',
                  style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: 'Enter Google Sheet URL',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 128,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          shadowColor: Colors.transparent,
                        ).merge(
                          ButtonStyle(overlayColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.hovered) || states.contains(MaterialState.pressed)) {
                              return Colors.black.withOpacity(0.9);
                            }
                            return null;
                          }))),
                        child: const Text(
                          'Okay',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 128,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEFE9DD),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          shadowColor: Colors.transparent,
                        ).merge(
                          ButtonStyle(overlayColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.hovered) || states.contains(MaterialState.pressed)) {
                              return const Color(0xFFE0DACA);
                            }
                            return null;
                          }))),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 