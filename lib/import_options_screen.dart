import 'package:flutter/material.dart';
import 'dart:math' as math;

// -------------------------------------------------------------------------------------------------
// Design Tokens – extracted directly from the MVP UI specification so changes are easy to audit.
// -------------------------------------------------------------------------------------------------
const Color _kPageBackground = Color(0xFFF7F8FA);
const Color _kFontDark = Color(0xFF222222);
const Color _kBreadcrumbColor = Color(0xFF6B7280);
const Color _kSubtitleColor = Color(0xFF4B5563);
const Color _kPanelBorder = Color(0xFFE5E7EB);
const Color _kCardBackground = Color(0xFFFAFAFA);
const Color _kCardBorder = Color(0xFFD9D9D9);
const Color _kLinkBlue = Color(0xFF2563EB);
const Color _kHoverOutline = Color(0xFF2563EB);

const double _kContentMaxWidth = 1040; // px
const double _kPanelFixedWidth = 720; // px

// Card dimensions (desktop)
const double _kCardWidth = 317; // previously 317, reduced slightly
const double _kCardHeight = 172;
/// All supported import methods in the MVP.
enum ImportMethod { myComputer, oneDrive, googleDrive, googleSheetsUrl }

class ImportOptionsScreen extends StatelessWidget {
  const ImportOptionsScreen({Key? key, this.onSelect}) : super(key: key);

  final void Function(ImportMethod method)? onSelect;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kPageBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // 24 px horizontal gutter
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _kContentMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24), // Safe area offset approximation
                  // --------------- BREADCRUMB ---------------------------------------------------
                  const _Breadcrumb(),
                  const SizedBox(height: 40),
                  // ---------------- HERO --------------------------------------------------------
                  const _HeroCopy(),
                  const SizedBox(height: 40),
                  // ---------------- IMPORT PANEL ------------------------------------------------
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final bool isWide = constraints.maxWidth > 768;
                      const double indent = 120; 
                      return Padding(
                        padding: EdgeInsets.only(left: isWide ? indent : 0),
                        child: _ImportPanel(onSelect: onSelect),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------------------------------
// Breadcrumb widget
// -------------------------------------------------------------------------------------------------
class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb();

  @override
  Widget build(BuildContext context) {
    return Text(
      'GEARCHAIN  ›  Import / Export  ›  Import',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.24, // 0.02em of 12 px
        color: _kBreadcrumbColor,
      ),
    );
  }
}

// -------------------------------------------------------------------------------------------------
// Hero copy – title & subtitle
// -------------------------------------------------------------------------------------------------
class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Choose your Import Method',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: _kFontDark,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          width: 680, // max-width for subtitle
          child: Text(
            'Select an option to import your data: Upload a spreadsheet from your computer or connect to cloud storage.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
              color: _kSubtitleColor,
            ),
          ),
        ),
      ],
    );
  }
}

// -------------------------------------------------------------------------------------------------
// Import Panel – white card containing the grid
// -------------------------------------------------------------------------------------------------
class _ImportPanel extends StatelessWidget {
  const _ImportPanel({this.onSelect});

  final void Function(ImportMethod method)? onSelect;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isNarrow = constraints.maxWidth <= 768;
        // Cap the panel width on large screens so the rectangle is a bit shorter.
        final double panelWidth = isNarrow ? constraints.maxWidth : math.min(constraints.maxWidth, 770);
        return Container(
          width: panelWidth,
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _kPanelBorder),
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12, // 0.06 opacity roughly equals 15-20 alpha
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            label: 'Import panel',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Import From:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _kFontDark),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Import your spreadsheet into GearChain.\nEnsure column headers are in the first row and grant access to your cloud storage.',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {},
                  hoverColor: Colors.transparent,
                  child: const Text(
                    'Download sample spreadsheet',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: _kLinkBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // ---------------- GRID (Wrap) ------------------------------------------------
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    _ImportMethodCard(
                      method: ImportMethod.myComputer,
                      title: 'My Computer',
                      description: 'Choose a CSV or Excel file from your computer.',
                      icon: Icons.note_add_outlined,
                      iconColor: _kFontDark,
                      onSelect: onSelect,
                    ),
                    _ImportMethodCard(
                      method: ImportMethod.oneDrive,
                      title: 'OneDrive',
                      description: 'Connect to your Microsoft OneDrive and choose an Excel file to import.',
                      icon: Icons.cloud,
                      iconColor: Color(0xFF2F6FE4),
                      onSelect: onSelect,
                    ),
                    _ImportMethodCard(
                      method: ImportMethod.googleDrive,
                      title: 'Google Drive',
                      description: 'Connect to your Google Drive and select a Google Sheet to import.',
                      icon: Icons.drive_eta, // substitute icon
                      iconColor: Colors.green,
                      onSelect: onSelect,
                    ),
                    _ImportMethodCard(
                      method: ImportMethod.googleSheetsUrl,
                      title: 'Google Sheets URL',
                      description: 'Copy and paste the shareable link of the Google Sheet to import.',
                      icon: Icons.link_rounded,
                      iconColor: _kFontDark,
                      onSelect: onSelect,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------------------------------------------
// Individual Import Method Card
// -------------------------------------------------------------------------------------------------
class _ImportMethodCard extends StatefulWidget {
  const _ImportMethodCard({
    required this.method,
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    this.onSelect,
  });

  final ImportMethod method;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final void Function(ImportMethod method)? onSelect;

  @override
  State<_ImportMethodCard> createState() => _ImportMethodCardState();
}

class _ImportMethodCardState extends State<_ImportMethodCard> {
  bool _hovering = false;

  void _setHover(bool hovering) => setState(() => _hovering = hovering);

  @override
  Widget build(BuildContext context) {
    final bool isMobileWidth = MediaQuery.of(context).size.width <= 480;

    final Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _kCardBackground,
        border: Border.all(color: _hovering ? _kHoverOutline : _kCardBorder, width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: _hovering
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(37, 99, 235, 0.25),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: isMobileWidth
          // Mobile / narrow: icon + stacked title+desc inline
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 36, color: widget.iconColor),
                const SizedBox(width: 12),
                Expanded(child: _CardText(title: widget.title, description: widget.description)),
              ],
            )
          // Desktop: icon directly to the left of bold title, description on its own line
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(widget.icon, size: 40, color: widget.iconColor),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(top: 6), // move text slightly down
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _kFontDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 260,
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                      color: _kSubtitleColor,
                    ),
                  ),
                ),
              ],
            ),
    );

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: () => widget.onSelect?.call(widget.method),
        child: isMobileWidth
            ? ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _kCardHeight, maxWidth: double.infinity),
                child: cardContent,
              )
            : SizedBox(
                width: _kCardWidth,
                height: _kCardHeight,
                child: cardContent,
              ),
      ),
    );
  }
}

class _CardText extends StatelessWidget {
  const _CardText({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: _kFontDark),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 240,
          child: Text(
            description,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: _kSubtitleColor, height: 1.5),
          ),
        ),
      ],
    );
  }
} 