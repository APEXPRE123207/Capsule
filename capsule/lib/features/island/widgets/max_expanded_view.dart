import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';

/// Full widget hub view (Max Expand state)
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
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
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
                    width: 28.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                      color: CapsuleTheme.accentCyan.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(
                      Icons.blur_on_rounded,
                      size: 18.0,
                      color: CapsuleTheme.accentCyan,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Capsule Hub',
                    style: TextStyle(
                      color: CapsuleTheme.textPrimary,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              // Close / Collapse button
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20.0),
                color: CapsuleTheme.textSecondary,
                tooltip: 'Collapse',
                onPressed: widget.onCollapse,
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Tab Selector
          Container(
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              color: CapsuleTheme.surfaceHighlight,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                _buildTabItem(0, 'System', Icons.speed_rounded),
                _buildTabItem(1, 'Quick Note', Icons.edit_note_rounded),
                _buildTabItem(2, 'Controls', Icons.tune_rounded),
              ],
            ),
          ),

          const SizedBox(height: 16.0),

          // Content body
          Expanded(
            child: AnimatedSwitcher(
              duration: CapsuleTheme.fastDuration,
              child: _buildActiveTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: AnimatedContainer(
          duration: CapsuleTheme.fastDuration,
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          decoration: BoxDecoration(
            color: isSelected ? CapsuleTheme.islandCard : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: isSelected
                ? Border.all(color: CapsuleTheme.subtleBorder)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14.0,
                color: isSelected ? CapsuleTheme.accentCyan : CapsuleTheme.textSecondary,
              ),
              const SizedBox(width: 6.0),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? CapsuleTheme.textPrimary : CapsuleTheme.textSecondary,
                  fontSize: 12.0,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeTab) {
      case 0:
        return _buildSystemMonitorTab();
      case 1:
        return _buildQuickNoteTab();
      case 2:
      default:
        return _buildQuickControlsTab();
    }
  }

  Widget _buildSystemMonitorTab() {
    return Column(
      key: const ValueKey('system_tab'),
      children: [
        _buildStatCard(
          title: 'CPU Usage',
          value: '24%',
          subtitle: '12 Cores • 3.8 GHz',
          percentage: 0.24,
          accent: CapsuleTheme.accentCyan,
        ),
        const SizedBox(height: 10.0),
        _buildStatCard(
          title: 'RAM Usage',
          value: '8.4 / 32 GB',
          subtitle: '26% Allocated',
          percentage: 0.26,
          accent: CapsuleTheme.accentGreen,
        ),
        const SizedBox(height: 10.0),
        _buildStatCard(
          title: 'GPU Memory',
          value: '3.1 / 16 GB',
          subtitle: 'DirectX 12 • 48°C',
          percentage: 0.19,
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
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(14.0),
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
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: accent,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 4.0,
              backgroundColor: CapsuleTheme.surfaceHighlight,
              valueColor: AlwaysStoppedAnimation<Color>(accent),
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            subtitle,
            style: const TextStyle(
              color: CapsuleTheme.textMuted,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNoteTab() {
    return Container(
      key: const ValueKey('note_tab'),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(color: CapsuleTheme.subtleBorder),
      ),
      child: const TextField(
        maxLines: null,
        expands: true,
        style: TextStyle(
          color: CapsuleTheme.textPrimary,
          fontSize: 13.0,
          height: 1.4,
        ),
        decoration: InputDecoration(
          hintText: 'Type a quick note or task here...\nSaved automatically.',
          hintStyle: TextStyle(color: CapsuleTheme.textMuted, fontSize: 13.0),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildQuickControlsTab() {
    return Column(
      key: const ValueKey('controls_tab'),
      children: [
        Row(
          children: [
            Expanded(child: _buildToggleTile('Mute Audio', Icons.volume_up_rounded, false)),
            const SizedBox(width: 10.0),
            Expanded(child: _buildToggleTile('Do Not Disturb', Icons.bedtime_rounded, true)),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Expanded(child: _buildToggleTile('Night Light', Icons.wb_sunny_rounded, false)),
            const SizedBox(width: 10.0),
            Expanded(child: _buildToggleTile('Auto-Hide Pill', Icons.visibility_rounded, false)),
          ],
        ),
      ],
    );
  }

  Widget _buildToggleTile(String title, IconData icon, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
      decoration: BoxDecoration(
        color: active ? CapsuleTheme.accentCyan.withValues(alpha: 0.12) : CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(14.0),
        border: Border.all(
          color: active ? CapsuleTheme.accentCyan.withValues(alpha: 0.4) : CapsuleTheme.subtleBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18.0,
            color: active ? CapsuleTheme.accentCyan : CapsuleTheme.textSecondary,
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: active ? CapsuleTheme.textPrimary : CapsuleTheme.textSecondary,
                fontSize: 12.0,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
