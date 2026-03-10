import 'package:flutter/material.dart';

class BottomPullRefresh extends StatefulWidget {
  const BottomPullRefresh({super.key});

  @override
  State<BottomPullRefresh> createState() => _BottomPullRefreshState();
}

class _BottomPullRefreshState extends State<BottomPullRefresh>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _isRefreshing = false;
  double _dragOffset = 0;
  final double _triggerThreshold = 80.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _triggerRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate network call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _dragOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bottom Pull Refresh')),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            final metrics = notification.metrics;
            final isAtBottom = metrics.pixels >= metrics.maxScrollExtent;

            if (isAtBottom && !_isRefreshing) {
              final overscroll = metrics.pixels - metrics.maxScrollExtent;
              setState(() => _dragOffset = overscroll.clamp(0, _triggerThreshold * 1.5));

              if (_dragOffset >= _triggerThreshold) {
                _triggerRefresh();
              }
            }
          }

          if (notification is ScrollEndNotification && !_isRefreshing) {
            setState(() => _dragOffset = 0);
          }

          return false;
        },
        child: Stack(
          children: [
            ListView.builder(
              physics: BouncingScrollPhysics(), // enables overscroll
              itemCount: 20,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(child: Text('${index + 1}')),
                title: Text('Item ${index + 1}'),
                subtitle: Text('Pull from the bottom to refresh'),
              ),
            ),

            // Bottom indicator
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: _dragOffset.clamp(0, _triggerThreshold).toDouble(),
                color: Colors.blue.withOpacity(0.1),
                child: Center(
                  child: _dragOffset > 20
                      ? _isRefreshing
                          ? RotationTransition(
                              turns: _rotationAnimation,
                              child: Icon(Icons.refresh, color: Colors.blue),
                            )
                          : AnimatedOpacity(
                              opacity: (_dragOffset / _triggerThreshold).clamp(0, 1),
                              duration: Duration(milliseconds: 100),
                              child: Icon(
                                _dragOffset >= _triggerThreshold
                                    ? Icons.refresh
                                    : Icons.keyboard_arrow_up,
                                color: Colors.blue,
                              ),
                            )
                      : SizedBox.shrink(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}