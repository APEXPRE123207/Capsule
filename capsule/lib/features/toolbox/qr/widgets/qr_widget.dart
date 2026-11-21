import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/capsule_theme.dart';

/// Instant offline QR Code Generator utility
class QrWidget extends StatefulWidget {
  const QrWidget({super.key});

  @override
  State<QrWidget> createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {
  final TextEditingController _controller = TextEditingController(text: 'https://github.com/APEXPRE123207/Capsule');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: CapsuleTheme.subtleBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(color: CapsuleTheme.textPrimary, fontSize: 12.0),
                  decoration: InputDecoration(
                    hintText: 'Enter text or URL to generate QR...',
                    hintStyle: const TextStyle(color: CapsuleTheme.textMuted, fontSize: 12.0),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    filled: true,
                    fillColor: CapsuleTheme.surfaceHighlight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // QR Code Card
          Center(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: QrImageView(
                data: _controller.text.isNotEmpty ? _controller.text : ' ',
                version: QrVersions.auto,
                size: 130.0,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
