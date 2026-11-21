/// Available presentation states for the Capsule Dynamic Island
enum IslandState {
  /// Minimal pill tucked at the top of the screen
  idle(
    width: 210.0,
    height: 38.0,
    borderRadius: 19.0,
    topMargin: 12.0,
  ),

  /// Hovered pill with additional peek information & quick glow
  hover(
    width: 280.0,
    height: 48.0,
    borderRadius: 24.0,
    topMargin: 12.0,
  ),

  /// Expanded card showing interactive controls (e.g. Media Player, Timers)
  expanded(
    width: 390.0,
    height: 180.0,
    borderRadius: 32.0,
    topMargin: 14.0,
  ),

  /// Max expand view showing full widgets (e.g. System Monitor, Todo, Notes)
  maxExpanded(
    width: 440.0,
    height: 360.0,
    borderRadius: 36.0,
    topMargin: 14.0,
  );

  const IslandState({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.topMargin,
  });

  final double width;
  final double height;
  final double borderRadius;
  final double topMargin;

  bool get isCompact => this == IslandState.idle || this == IslandState.hover;
  bool get isCard => this == IslandState.expanded || this == IslandState.maxExpanded;
}
