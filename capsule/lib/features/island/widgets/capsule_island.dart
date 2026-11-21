import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';
import '../models/island_state.dart';
import 'idle_pill_view.dart';
import 'hover_pill_view.dart';
import 'expanded_card_view.dart';
import 'max_expanded_view.dart';

/// The central animated Dynamic Island / Capsule widget
class CapsuleIsland extends StatefulWidget {
  const CapsuleIsland({
    super.key,
    required this.currentState,
    required this.onStateChanged,
  });

  final IslandState currentState;
  final ValueChanged<IslandState> onStateChanged;

  @override
  State<CapsuleIsland> createState() => _CapsuleIslandState();
}

class _CapsuleIslandState extends State<CapsuleIsland> {
  void _handleHover(bool isHovered) {
    if (widget.currentState == IslandState.idle && isHovered) {
      widget.onStateChanged(IslandState.hover);
    } else if (widget.currentState == IslandState.hover && !isHovered) {
      widget.onStateChanged(IslandState.idle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.currentState;

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: state.topMargin),
        child: MouseRegion(
          onEnter: (_) => _handleHover(true),
          onExit: (_) => _handleHover(false),
          child: AnimatedContainer(
            duration: CapsuleTheme.morphDuration,
            curve: CapsuleTheme.springCurve,
            width: state.width,
            height: state.height,
            decoration: BoxDecoration(
              color: CapsuleTheme.islandBlack,
              borderRadius: BorderRadius.circular(state.borderRadius),
              border: Border.all(
                color: state.isCompact
                    ? CapsuleTheme.subtleBorder
                    : CapsuleTheme.subtleBorder.withValues(alpha: 0.35),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.65),
                  blurRadius: state.isCard ? 36.0 : 16.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, state.isCard ? 14.0 : 6.0),
                ),
                if (state == IslandState.hover)
                  const BoxShadow(
                    color: CapsuleTheme.subtleGlow,
                    blurRadius: 16.0,
                    spreadRadius: 1.0,
                  ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: AnimatedSwitcher(
              duration: CapsuleTheme.fastDuration,
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _buildCurrentStateContent(state),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStateContent(IslandState state) {
    switch (state) {
      case IslandState.idle:
        return KeyedSubtree(
          key: const ValueKey('idle'),
          child: IdlePillView(
            onTap: () => widget.onStateChanged(IslandState.expanded),
          ),
        );
      case IslandState.hover:
        return KeyedSubtree(
          key: const ValueKey('hover'),
          child: HoverPillView(
            onExpand: () => widget.onStateChanged(IslandState.expanded),
          ),
        );
      case IslandState.expanded:
        return KeyedSubtree(
          key: const ValueKey('expanded'),
          child: ExpandedCardView(
            onCollapse: () => widget.onStateChanged(IslandState.idle),
            onMaxExpand: () => widget.onStateChanged(IslandState.maxExpanded),
          ),
        );
      case IslandState.maxExpanded:
        return KeyedSubtree(
          key: const ValueKey('maxExpanded'),
          child: MaxExpandedView(
            onCollapse: () => widget.onStateChanged(IslandState.idle),
          ),
        );
    }
  }
}
