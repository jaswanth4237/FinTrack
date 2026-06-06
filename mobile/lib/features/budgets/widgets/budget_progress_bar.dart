import 'package:flutter/material.dart';

class BudgetProgressBar extends StatefulWidget {
  final double spent;
  final double limit;
  final double alertThreshold;

  const BudgetProgressBar({
    super.key,
    required this.spent,
    required this.limit,
    required this.alertThreshold,
  });

  @override
  State<BudgetProgressBar> createState() => _BudgetProgressBarState();
}

class _BudgetProgressBarState extends State<BudgetProgressBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    final percentage = (widget.spent / widget.limit).clamp(0.0, 1.0);
    _animation = Tween<double>(begin: 0, end: percentage).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColor(double percentage) {
    if (percentage < 0.6) return const Color(0xFF4CAF50); // green
    if (percentage * 100 < widget.alertThreshold) return const Color(0xFFFF9800); // orange
    return const Color(0xFFF44336); // red
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentPercentage = _animation.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: currentPercentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getColor(currentPercentage),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
