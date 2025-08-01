import 'package:flutter/material.dart';

// -------------------------------------------------------------------------------------------------
// Design Tokens
// -------------------------------------------------------------------------------------------------
const Color _kPageBg = Color(0xFFF7F8FA);
const Color _kFontDark = Color(0xFF222222);
const Color _kSubtleText = Color(0xFF4B5563);
const Color _kBreadcrumb = Color(0xFF6B7280);
const Color _kTableBorder = Color(0xFFE5E7EB);
const Color _kTableHeaderBg = Color(0xFFF8F4E8);
const Color _kCardBg = _kTableHeaderBg; // light beige background for card
const Color _kMatched = Color(0xFF00804B);
const Color _kUnmatched = Color(0xFFE11D48);
const Color _kUnmatchedBg = Color(0xFFFFECEC);

class MatchFieldNamesScreen extends StatefulWidget {
  const MatchFieldNamesScreen({super.key});

  @override
  State<MatchFieldNamesScreen> createState() => _MatchFieldNamesScreenState();
}

class _MatchFieldNamesScreenState extends State<MatchFieldNamesScreen> {
  // For MVP, hard-code 5 columns.
  final List<String?> _selected = [
    'Barcode',
    null,
    'Photo',
    null,
    'Stock',
  ];

  final List<String> _headers = [
    'Barcode',
    'Middle Name',
    'email',
    'Price',
    'Quantity',
  ];

  final List<List<String>> _sampleRows = [
    ['2044285156449', 'Ann', 'tim.jenning@example.com', '\$8.99', '24'],
    ['2044285156449', 'Greg', 'mike.mitc@example.com', '\$6.48', '321'],
    ['2044285156449', 'Arlene', 'nevaeh.simmon@example.com', ' \$14.81 ', '563'],
    ['2044285156449', 'Angel', 'ken.lawson@example.com', '\$11.70', '10'],
  ];

  bool get _hasMatch => _selected.any((e) => e != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kPageBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isNarrow = constraints.maxWidth < 768;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1040),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Breadcrumb
                    const Text(
                      'GEARCHAIN  ›  Import  ›  CSV / Excel Import',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: _kBreadcrumb),
                    ),
                    const SizedBox(height: 24),
                    // Header
                    const Text('Match Field Names',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _kFontDark)),
                    const SizedBox(height: 8),
                    const SizedBox(
                      width: 680,
                      child: Text(
                        "Now let’s match the columns in your file with Gearchain field names.",
                        style: TextStyle(fontSize: 14, color: _kSubtleText),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Continue button & table
                    Align(
                      alignment: Alignment.centerRight,
                      child: Transform.translate(
                        offset: const Offset(0, -20),
                        child: _ContinueButton(enabled: _hasMatch, onPressed: _hasMatch ? () {} : null),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: _buildTable(isNarrow),
                    ),
                    const SizedBox(height: 8),
                    // Footer
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('9 unmatched columns.',
                              style: TextStyle(fontSize: 14, color: _kSubtleText)),
                          const SizedBox(height: 8),
                          _SkipButton(onPressed: () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTable(bool isNarrow) {
    final tableContent = Column(
      children: [
        // Row 0 – dropdowns
        SizedBox(
          height: 56,
          child: Row(
            children: List.generate(_headers.length, (i) => _buildDropdownCell(i)),
          ),
        ),
        // Row1 – matched/unmatched labels
        Container(
          height: 24,
          color: _kTableHeaderBg,
          child: Row(
            children: List.generate(_headers.length, (i) {
              final matched = _selected[i] != null;
              return _expCell(
                Text(
                  matched ? 'Matched' : 'Unmatched',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: matched ? _kMatched : _kUnmatched,
                  ),
                ),
                bg: _kTableHeaderBg,
              );
            }),
          ),
        ),
        // Row2 – column letters
        Container(
          height: 32,
          color: const Color(0xFF4B4B4B),
          child: Row(
            children: List.generate(_headers.length, (i) {
              return _expCell(
                Text(
                  String.fromCharCode(65 + i),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                bg: const Color(0xFF4B4B4B),
              );
            }),
          ),
        ),
        // Header row from file
        _row([
          for (int i = 0; i < _headers.length; i++)
            _expCell(
              Center(
                child: Text(
                  _headers[i],
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              bg: _selected[i] != null ? Colors.white : _kUnmatchedBg,
              last: i == _headers.length - 1,
            ),
        ]),
        // Sample rows
        ..._sampleRows.map((row) {
          return _row([
            for (int i = 0; i < _headers.length; i++)
              _expCell(
                Text(row[i], style: const TextStyle(fontSize: 14)),
                bg: _selected[i] != null ? Colors.white : _kUnmatchedBg,
                last: i == _headers.length - 1,
              ),
          ]);
        }),
      ],
    );

    final table = Container(
      decoration: BoxDecoration(
        color: _kCardBg,
        border: Border.all(color: _kTableBorder),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
      ),
      child: tableContent,
    );

    return table;
  }

  Widget _buildDropdownCell(int index) {
    return _expCell(
      Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD9D9D9)),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String?>(
            value: _selected[index],
            isExpanded: true,
            hint: const Text('Select a Field'),
            borderRadius: BorderRadius.circular(4),
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: _kFontDark),
            items: const [
              DropdownMenuItem(value: 'Barcode', child: Text('Barcode')),
              DropdownMenuItem(value: 'Photo', child: Text('Photo')),
              DropdownMenuItem(value: 'Stock', child: Text('Stock')),
            ],
            onChanged: (val) => setState(() => _selected[index] = val),
            icon: const Icon(Icons.expand_more),
          ),
        ),
      ),
      bg: _kTableHeaderBg,
    );
  }

  Widget _baseCell(Widget child, {Color bg = Colors.white, bool center = false}) {
    return Container(
      // width flexible via Expanded
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: center ? Alignment.center : Alignment.centerLeft,
      color: bg,
      child: child,
    );
  }

  Widget _expCell(Widget child, {Color bg = Colors.white, bool last = false}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          border: Border(
            right: last ? BorderSide.none : const BorderSide(color: _kTableBorder, width: 0.5),
          ),
        ),
        child: _baseCell(child, bg: Colors.transparent, center: true),
      ),
    );
  }

  Container _row(List<Widget> cells, {double height = 40}) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kTableBorder, width: 0.5)),
      ),
      child: Row(children: cells),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;
  const _ContinueButton({required this.enabled, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? Colors.black : const Color(0xFFB5B5B5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: const Text('Continue', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SkipButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 32,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFECE5D8),
          foregroundColor: _kFontDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ).merge(
          ButtonStyle(overlayColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.hovered) || states.contains(MaterialState.pressed)) {
              return const Color(0xFFE0D7C6);
            }
            return null;
          })),
        ),
        child: const Text('Skip unmatched', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
    
  }
} 