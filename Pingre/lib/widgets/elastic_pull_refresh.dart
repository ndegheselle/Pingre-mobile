import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ElasticPullToRefresh extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final void Function() onRefresh;

  const ElasticPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    required this.scrollController,
  });

  @override
  State<ElasticPullToRefresh> createState() => _ElasticPullToRefreshState();
}

class _ElasticPullToRefreshState extends State<ElasticPullToRefresh>
    with SingleTickerProviderStateMixin {
  double _drag = 0;
  bool get _canRefresh => _drag > maxDrag;
  bool get _startedDragging => _drag != 0;

  late AnimationController _controller;
  late Animation<double> _returnAnimation;
  static const double maxDrag = 100.0;
  static const double dragScale = 300.0;

  double _applyResistance(double value) {
    final t = (value / dragScale).clamp(0.0, 1.0);
    return Curves.decelerate.transform(t) * maxDrag;
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

  void _animateBack() {
    _returnAnimation = Tween<double>(
      begin: _drag,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final offset = _applyResistance(_drag);

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        setState(() {
          _drag -= details.delta.dy;
        });
      },
      onVerticalDragEnd: (_) async {
        if (_canRefresh) widget.onRefresh();
        _animateBack();
      },
      child: Stack(
        children: [
          widget.child,
          Positioned(
            bottom: offset,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _startedDragging ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 100),
              child: Center(
                child: Column(
                  children: [
                    Icon(_canRefresh ? FIcons.check : FIcons.arrowUp),
                    SizedBox(height: 4),
                    Text(_canRefresh ? "Release to load more" : "Pull up for more", style: context.theme.typography.sm,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
