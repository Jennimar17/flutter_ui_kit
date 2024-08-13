import 'package:devkitflutter/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';

class RotationTransitionPage extends StatefulWidget {
  @override
  _RotationTransitionPageState createState() => _RotationTransitionPageState();
}

class _RotationTransitionPageState extends State<RotationTransitionPage> with TickerProviderStateMixin {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticOut,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _globalWidget.globalAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _globalWidget.createDetailWidget2(
                title: 'Rotation Transition',
                desc: 'Animates the rotation of a widget.',
                icon: Icons.animation
            ),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: RotationTransition(
                turns: _animation,
                child: Image.asset('assets/images/lamp.jpg', height: 200),
              ),
            )
          ],
        ),
      ),
    );
  }
}
