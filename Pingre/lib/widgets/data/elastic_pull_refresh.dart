import 'package:flutter/material.dart';
import 'package:forui/assets.dart';

class ElasticPullToRefresh extends StatefulWidget {
  final void Function() onRefresh;
  final void Function() onDrag;

  const ElasticPullToRefresh({
    super.key,
    required this.onRefresh,
    required this.onDrag,
  });

  @override
  State<ElasticPullToRefresh> createState() => _ElasticPullToRefreshState();
}

class _ElasticPullToRefreshState extends State<ElasticPullToRefresh>
    with SingleTickerProviderStateMixin {
  double _drag = 0;
  bool get _canRefresh => _drag > maxDrag;

  late AnimationController _controller;
  late Animation<double> _returnAnimation;
  static const double maxDrag = 120.0;
  static const double minHeiht = 80.0;
  static const double dragScale = 300.0;

  double _applyResistance(double value) {
    final t = (value / dragScale).clamp(0.0, 1.0);
    return minHeiht + Curves.decelerate.transform(t) * maxDrag;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _returnAnimation = Tween<double>(begin: 0, end: 0).animate(_controller)
      ..addListener(() {
        setState(() {
          _drag = _returnAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateBack() {
    _returnAnimation = Tween<double>(
      begin: _drag,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final height = _applyResistance(_drag);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragStart: (_) {},
      onVerticalDragUpdate: (details) {
        setState(() {
          _drag -= details.delta.dy;
          widget.onDrag();
        });
      },
      onVerticalDragEnd: (_) {
        if (_canRefresh) widget.onRefresh();
        _animateBack();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 0),
        height: height,
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 8),
            const Icon(FIcons.moveUp),
            Spacer(flex: 1),
            Center(
              child: _canRefresh
                  ? Row(
                    mainAxisAlignment: .center,
                      children: [
                        const Icon(FIcons.check),
                        SizedBox(width: 8),
                        Text("Release for more"),
                      ],
                    )
                  : Text("Pull for more"),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
