import 'package:flutter/material.dart';
import 'core/theme/capsule_theme.dart';
import 'core/window/capsule_window_controller.dart';
import 'features/island/models/island_state.dart';
import 'features/island/widgets/capsule_island.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CapsuleWindowController.instance.initialize();
  runApp(const CapsuleApp());
}

class CapsuleApp extends StatelessWidget {
  const CapsuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Capsule',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: CapsuleTheme.accentCyan,
          surface: CapsuleTheme.islandCard,
        ),
        fontFamily: 'Segoe UI',
      ),
      home: const CapsuleHome(),
    );
  }
}

class CapsuleHome extends StatefulWidget {
  const CapsuleHome({super.key});

  @override
  State<CapsuleHome> createState() => _CapsuleHomeState();
}

class _CapsuleHomeState extends State<CapsuleHome> {
  IslandState _state = IslandState.idle;

  void _updateState(IslandState newState) {
    setState(() => _state = newState);
    CapsuleWindowController.instance.onStateChanged(newState);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Dismiss backdrop when in card states (Expanded / MaxExpanded)
          if (_state.isCard)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _updateState(IslandState.idle),
                child: Container(color: Colors.transparent),
              ),
            ),

          // Central Floating Dynamic Island
          Align(
            alignment: Alignment.topCenter,
            child: CapsuleIsland(
              currentState: _state,
              onStateChanged: _updateState,
            ),
          ),
        ],
      ),
    );
  }
}
