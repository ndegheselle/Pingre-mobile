import 'dart:math';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class ElasticPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const ElasticPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<ElasticPullToRefresh> createState() => _ElasticPullToRefreshState();
}

class _ElasticPullToRefreshState extends State<ElasticPullToRefresh>
    with SingleTickerProviderStateMixin {
  double _drag = 0;
  late AnimationController _controller;
  late Animation<double> _returnAnimation;
  static const double maxDrag = 100.0;
  static const double dragScale = 200.0;

  double _applyResistance(double value) {
  final t = (value / dragScale).clamp(0.0, 1.0);
  return Curves.easeOut.transform(t) * maxDrag;
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
        if (_drag > maxDrag) {
          await widget.onRefresh();
        }
        _animateBack();
      },
      child: Stack(
        children: [
          widget.child,
          Positioned(
            bottom: offset - 20,
            left: 0,
            right: 0,
            child: const Center(child: FCircularProgress(style: .delta(iconStyle: .delta(size: 32)), icon: FIcons.refreshCw,)),
          ),
        ],
      ),
    );
  }
}
