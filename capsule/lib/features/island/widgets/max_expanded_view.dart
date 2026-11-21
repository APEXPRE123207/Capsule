import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';
import '../../audio/services/audio_service.dart';
import '../../clipboard/services/clipboard_service.dart';
import '../../launcher/services/app_launcher_service.dart';
import '../../system/services/system_service.dart';
import '../../toolbox/calculator/widgets/calculator_widget.dart';
import '../../toolbox/qr/widgets/qr_widget.dart';
import '../../weather/widgets/weather_widget.dart';

/// Full multi-module widget hub view (Max Expand state)
class MaxExpandedView extends StatefulWidget {
  const MaxExpandedView({
    super.key,
    required this.onCollapse,
  });

  final VoidCallback onCollapse;

  @override
  State<MaxExpandedView> createState() => _MaxExpandedViewState();
}

class _MaxExpandedViewState extends State<MaxExpandedView> {
  int _activeTab = 0; // 0: System, 1: Weather, 2: Clipboard, 3: Launcher, 4: Tools
  double _volume = AudioService.instance.volume;
  bool _isMuted = AudioService.instance.isMuted;
  List<AppItem> _apps = [];
  String _appSearch = '';

  @override
  void initState() {
    super.initState();
    ClipboardService.instance.startMonitoring();
    SystemService.instance.startMonitoring();
    _loadApps();
  }

  Future<void> _loadApps() async {
    final list = await AppLauncherService.instance.getInstalledApps();
    if (mounted) setState(() => _apps = list);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header: App icon, Title, Tab pill bar, and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 26.0,
                      height: 26.0,
                      decoration: BoxDecoration(
                        color: CapsuleTheme.accentCyan.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Icon(
                        Icons.blur_on_rounded,
                        size: 16.0,
                        color: CapsuleTheme.accentCyan,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      'Capsule Hub',
                      style: TextStyle(
                        color: CapsuleTheme.textPrimary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                // Close / Collapse button
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18.0),
                  color: CapsuleTheme.textSecondary,
                  tooltip: 'Collapse',
                  visualDensity: VisualDensity.compact,
                  onPressed: widget.onCollapse,
                ),
              ],
            ),

            const SizedBox(height: 8.0),

            // Horizontal Tab Selector Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabChip(0, 'System', Icons.speed_rounded),
                  _buildTabChip(1, 'Weather', Icons.cloud_rounded),
                  _buildTabChip(2, 'Clipboard', Icons.content_paste_rounded),
                  _buildTabChip(3, 'Apps', Icons.grid_view_rounded),
                  _buildTabChip(4, 'Calculator', Icons.calculate_rounded),
                  _buildTabChip(5, 'QR Code', Icons.qr_code_rounded),
                ],
              ),
            ),

            const SizedBox(height: 10.0),

            // Tab Content
            AnimatedSwitcher(
              duration: CapsuleTheme.fastDuration,
              child: _buildActiveTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabChip(int index, String label, IconData icon) {
    final isSelected = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Container(
        margin: const EdgeInsets.only(right: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        decoration: BoxDecoration(
          color: isSelected ? CapsuleTheme.accentCyan.withValues(alpha: 0.18) : CapsuleTheme.surfaceHighlight,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? CapsuleTheme.accentCyan.withValues(alpha: 0.4) : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13.0,
              color: isSelected ? CapsuleTheme.accentCyan : CapsuleTheme.textSecondary,
            ),
            const SizedBox(width: 4.0),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? CapsuleTheme.textPrimary : CapsuleTheme.textSecondary,
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 0:
        return _buildSystemAndAudioTab();
      case 1:
        return const WeatherWidget(key: ValueKey('weather_tab'));
      case 2:
        return _buildClipboardTab();
      case 3:
        return _buildAppLauncherTab();
      case 4:
        return const CalculatorWidget(key: ValueKey('calculator_tab'));
      case 5:
      default:
        return const QrWidget(key: ValueKey('qr_tab'));
    }
  }

  // 1. System Telemetry & Audio Control Tab
  Widget _buildSystemAndAudioTab() {
    final metrics = SystemService.instance.current;

    return Column(
      key: const ValueKey('system_tab'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Master Volume & Audio Control Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: CapsuleTheme.islandCard,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: CapsuleTheme.subtleBorder),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _isMuted || _volume == 0 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  size: 18.0,
                ),
                color: _isMuted ? CapsuleTheme.accentRose : CapsuleTheme.accentCyan,
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  setState(() => _isMuted = !_isMuted);
                  AudioService.instance.toggleMute();
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4.5),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 8.0),
                    activeTrackColor: CapsuleTheme.accentCyan,
                    inactiveTrackColor: CapsuleTheme.surfaceHighlight,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: _isMuted ? 0.0 : _volume,
                    onChanged: (val) {
                      setState(() {
                        _volume = val;
                        _isMuted = false;
                      });
                      AudioService.instance.setVolume(val);
                    },
                  ),
                ),
              ),
              Text(
                '${(_isMuted ? 0 : (_volume * 100)).toInt()}%',
                style: const TextStyle(
                  color: CapsuleTheme.textSecondary,
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8.0),

        _buildStatCard(
          title: 'CPU Usage',
          value: '${metrics.cpuPercent.toStringAsFixed(0)}%',
          subtitle: 'Active utilization',
          percentage: (metrics.cpuPercent / 100.0).clamp(0.0, 1.0),
          accent: CapsuleTheme.accentCyan,
        ),
        const SizedBox(height: 6.0),
        _buildStatCard(
          title: 'RAM Usage',
          value: '${metrics.ramUsedGb.toStringAsFixed(1)} / ${metrics.ramTotalGb.toInt()} GB',
          subtitle: '${metrics.ramPercent.toStringAsFixed(0)}% Allocated',
          percentage: (metrics.ramPercent / 100.0).clamp(0.0, 1.0),
          accent: CapsuleTheme.accentGreen,
        ),
        const SizedBox(height: 6.0),
        _buildStatCard(
          title: 'GPU Engine',
          value: '${metrics.gpuPercent.toStringAsFixed(0)}%',
          subtitle: 'DirectX 12 Graphics',
          percentage: (metrics.gpuPercent / 100.0).clamp(0.0, 1.0),
          accent: CapsuleTheme.accentAmber,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required double percentage,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: CapsuleTheme.subtleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: CapsuleTheme.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: accent,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(3.0),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 3.5,
              backgroundColor: CapsuleTheme.surfaceHighlight,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            subtitle,
            style: const TextStyle(
              color: CapsuleTheme.textMuted,
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }

  // 2. Clipboard History Tab
  Widget _buildClipboardTab() {
    final history = ClipboardService.instance.history;

    return Container(
      key: const ValueKey('clipboard_tab'),
      height: 250.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: CapsuleTheme.subtleBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Copies (${history.length})',
                style: const TextStyle(color: CapsuleTheme.textSecondary, fontSize: 11.5, fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  setState(() => ClipboardService.instance.clearHistory());
                },
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                child: const Text('Clear', style: TextStyle(color: CapsuleTheme.accentRose, fontSize: 11.0)),
              ),
            ],
          ),
          const Divider(color: CapsuleTheme.subtleBorder, height: 8.0),
          Expanded(
            child: history.isEmpty
                ? const Center(
                    child: Text('Clipboard is empty', style: TextStyle(color: CapsuleTheme.textMuted, fontSize: 11.5)),
                  )
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: CapsuleTheme.surfaceHighlight,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.preview,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: CapsuleTheme.textPrimary, fontSize: 11.5),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy_rounded, size: 14.0),
                              color: CapsuleTheme.accentCyan,
                              tooltip: 'Copy',
                              visualDensity: VisualDensity.compact,
                              onPressed: () {
                                ClipboardService.instance.copyToClipboard(item.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to clipboard'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 3. App Launcher Tab
  Widget _buildAppLauncherTab() {
    final filtered = _apps.where((a) => a.name.toLowerCase().contains(_appSearch.toLowerCase())).toList();

    return Container(
      key: const ValueKey('app_launcher_tab'),
      height: 250.0,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: CapsuleTheme.subtleBorder),
      ),
      child: Column(
        children: [
          TextField(
            onChanged: (val) => setState(() => _appSearch = val),
            style: const TextStyle(color: CapsuleTheme.textPrimary, fontSize: 12.0),
            decoration: InputDecoration(
              hintText: 'Search applications...',
              hintStyle: const TextStyle(color: CapsuleTheme.textMuted, fontSize: 12.0),
              prefixIcon: const Icon(Icons.search_rounded, size: 16.0, color: CapsuleTheme.textSecondary),
              filled: true,
              fillColor: CapsuleTheme.surfaceHighlight,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 6.0,
                childAspectRatio: 2.2,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final app = filtered[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(8.0),
                  onTap: () => AppLauncherService.instance.launchApp(app),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    decoration: BoxDecoration(
                      color: CapsuleTheme.surfaceHighlight,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Icon(app.iconData ?? Icons.launch_rounded, size: 14.0, color: CapsuleTheme.accentCyan),
                        const SizedBox(width: 6.0),
                        Expanded(
                          child: Text(
                            app.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: CapsuleTheme.textPrimary, fontSize: 11.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
