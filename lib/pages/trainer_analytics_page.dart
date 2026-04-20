import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../model/analytics_models.dart';
import '../services/analytics_data_service.dart';

class TrainerAnalyticsPage extends StatefulWidget {
  const TrainerAnalyticsPage({super.key});

  @override
  State<TrainerAnalyticsPage> createState() => _TrainerAnalyticsPageState();
}

class _TrainerAnalyticsPageState extends State<TrainerAnalyticsPage> {
  final AnalyticsDataService _dataService = AnalyticsDataService();
  String _selectedRange = '30min';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        // FutureBuilder manages the async connection to Firebase
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dataService.getAnalyticsData(_selectedRange),
          builder: (context, snapshot) {
            // 1. Loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF166B57)),
              );
            }
            
            // 2. Error state
            if (snapshot.hasError) {
              return Center(child: Text("Cloud Error: ${snapshot.error}"));
            }

            // 3. Success state
            final bundle = snapshot.data!['bundle'] as AnalyticsBundle;
            final currentAlertCount = snapshot.data!['alertCount'] as int;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(currentAlertCount),
                        const SizedBox(height: 24),
                        _buildRangeTabs(),
                        const SizedBox(height: 24),

                        // --- Heart Rate ---
                        AnalyticsChartCard(
                          title: 'Heart Rate',
                          subtitle: 'Avg: ${bundle.heartRateSummary.avg} BPM • Min: ${bundle.heartRateSummary.min} • Max: ${bundle.heartRateSummary.max}',
                          points: bundle.heartRate,
                          yMin: bundle.heartRateSummary.yMin,
                          yMax: bundle.heartRateSummary.yMax,
                          threshold: bundle.heartRateSummary.threshold,
                          normalColor: const Color(0xFF166B57),
                          warningColor: const Color(0xFFEF4444),
                          yLabels: bundle.heartRateSummary.yLabels,
                          tooltipLabelBuilder: (point) => '${point.label}\nHeart Rate : ${point.value.toStringAsFixed(0)} BPM',
                        ),

                        const SizedBox(height: 22),

                        // --- SpO2 ---
                        AnalyticsChartCard(
                          title: 'Blood Oxygen (SpO2)',
                          subtitle: 'Avg: ${bundle.spo2Summary.avg}%',
                          points: bundle.spo2,
                          yMin: bundle.spo2Summary.yMin,
                          yMax: bundle.spo2Summary.yMax,
                          threshold: bundle.spo2Summary.threshold,
                          normalColor: const Color(0xFF166B57),
                          warningColor: const Color(0xFFEF4444),
                          yLabels: bundle.spo2Summary.yLabels,
                          tooltipLabelBuilder: (point) => '${point.label}\nSpO2 : ${point.value.toStringAsFixed(1)}%',
                        ),

                        const SizedBox(height: 22),

                        // --- Temperature ---
                        AnalyticsChartCard(
                          title: 'Body Temperature',
                          subtitle: '°F',
                          points: bundle.temperature,
                          yMin: bundle.temperatureSummary.yMin,
                          yMax: bundle.temperatureSummary.yMax,
                          threshold: bundle.temperatureSummary.threshold,
                          normalColor: const Color(0xFFFF6F31),
                          warningColor: const Color(0xFFEF4444),
                          yLabels: bundle.temperatureSummary.yLabels,
                          tooltipLabelBuilder: (point) => '${point.label}\nTemperature : ${point.value.toStringAsFixed(1)}°F',
                        ),

                        const SizedBox(height: 22),

                        // --- Head Acceleration ---
                        AnalyticsChartCard(
                          title: 'Head Acceleration Events',
                          subtitle: 'Max Impact: ${bundle.headAccelerationSummary.max}g',
                          points: bundle.headAcceleration,
                          yMin: bundle.headAccelerationSummary.yMin,
                          yMax: bundle.headAccelerationSummary.yMax,
                          threshold: bundle.headAccelerationSummary.threshold,
                          normalColor: const Color(0xFFF9A826),
                          warningColor: const Color(0xFFEF4444),
                          yLabels: bundle.headAccelerationSummary.yLabels,
                          badgeText: bundle.headAccelerationSummary.badgeText,
                          tooltipLabelBuilder: (point) => '${point.label}\nImpact : ${point.value.toStringAsFixed(1)}g',
                        ),

                        const SizedBox(height: 22),

                        // --- Bite Force ---
                        AnalyticsChartCard(
                          title: 'Bite Force',
                          subtitle: 'Newtons (N)',
                          points: bundle.biteForce,
                          yMin: bundle.biteForceSummary.yMin,
                          yMax: bundle.biteForceSummary.yMax,
                          threshold: bundle.biteForceSummary.threshold,
                          normalColor: const Color(0xFF166B57),
                          warningColor: const Color(0xFFEF4444),
                          yLabels: bundle.biteForceSummary.yLabels,
                          tooltipLabelBuilder: (point) => '${point.label}\nBite Force : ${point.value.toStringAsFixed(1)} N',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- Private Header Builder ---
  Widget _buildHeader(int currentAlertCount) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 54, height: 54,
            decoration: const BoxDecoration(color: Color(0xFFD9D4C8), shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
          ),
        ),
        const SizedBox(width: 18),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Performance\nHistory', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1F1F1F), height: 1.25)),
              SizedBox(height: 6),
              Text('Track your metrics over time', style: TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: const Color(0xFFFCE9EC), borderRadius: BorderRadius.circular(16)),
          child: Text('$currentAlertCount Alerts', style: const TextStyle(color: Color(0xFFEF4444), fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  // --- Range Tabs Builder ---
  Widget _buildRangeTabs() {
    final tabs = ['30min', '1hr', '3hr', '24hr'];
    return Row(
      children: tabs.map((tab) {
        final selected = _selectedRange == tab;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: tab == tabs.last ? 0 : 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedRange = tab),
              child: Container(
                height: 62,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF166B57) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFD9D6CD)),
                ),
                child: Center(
                  child: Text(tab, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: selected ? Colors.white : Colors.grey)),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- Bottom Navigation ---
  Widget _buildBottomNav() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
        decoration: const BoxDecoration(color: Color(0xFFF8F8F6), border: Border(top: BorderSide(color: Color(0xFFE5E2DA)))),
        child: Row(
          children: [
            Expanded(child: _BottomNavButton(label: 'Dashboard', icon: Icons.dashboard_outlined, isSelected: false, onTap: () => Navigator.pop(context))),
            const SizedBox(width: 12),
            Expanded(child: _BottomNavButton(label: 'History', icon: Icons.show_chart_outlined, isSelected: true, onTap: () {})),
          ],
        ),
      ),
    );
  }
}

// --- Component Classes (AnalyticsChartCard, _InteractiveBarChart, etc.) should remain as they were in your previous file ---
// Please ensure you append those classes to the end of this file.

// --- ORIGINAL COMPONENT CLASSES PRESERVED ---

class AnalyticsChartCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<ChartPoint> points;
  final double yMin;
  final double yMax;
  final double threshold;
  final List<String> yLabels;
  final Color normalColor;
  final Color warningColor;
  final Color? iconBg;
  final Color? iconColor;
  final String? badgeText;
  final String Function(ChartPoint point) tooltipLabelBuilder;

  const AnalyticsChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.points,
    required this.yMin,
    required this.yMax,
    required this.threshold,
    required this.yLabels,
    required this.normalColor,
    required this.warningColor,
    required this.tooltipLabelBuilder,
    this.iconBg,
    this.iconColor,
    this.badgeText,
  });

  @override
  State<AnalyticsChartCard> createState() => _AnalyticsChartCardState();
}

class _AnalyticsChartCardState extends State<AnalyticsChartCard> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 7, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1F1F1F)))),
              if (widget.badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: const Color(0xFFFCE9EC), borderRadius: BorderRadius.circular(16)),
                  child: Text(widget.badgeText!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFEF4444))),
                )
              else
                Container(
                  width: 54, height: 54,
                  decoration: BoxDecoration(color: widget.iconBg ?? const Color(0xFFE5ECE8), shape: BoxShape.circle),
                  child: Icon(Icons.trending_up, color: widget.iconColor ?? const Color(0xFF166B57)),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(widget.subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF666666), fontWeight: FontWeight.w500)),
          const SizedBox(height: 18),
          _InteractiveBarChart(
            points: widget.points,
            yMin: widget.yMin,
            yMax: widget.yMax,
            threshold: widget.threshold,
            yLabels: widget.yLabels,
            normalColor: widget.normalColor,
            warningColor: widget.warningColor,
            hoveredIndex: _hoveredIndex,
            onHoverIndexChanged: (index) => setState(() => _hoveredIndex = index),
            tooltipLabelBuilder: widget.tooltipLabelBuilder,
          ),
        ],
      ),
    );
  }
}

class _InteractiveBarChart extends StatelessWidget {
  final List<ChartPoint> points;
  final double yMin;
  final double yMax;
  final double threshold;
  final List<String> yLabels;
  final Color normalColor;
  final Color warningColor;
  final int? hoveredIndex;
  final ValueChanged<int?> onHoverIndexChanged;
  final String Function(ChartPoint point) tooltipLabelBuilder;

  const _InteractiveBarChart({
    required this.points,
    required this.yMin,
    required this.yMax,
    required this.threshold,
    required this.yLabels,
    required this.normalColor,
    required this.warningColor,
    required this.hoveredIndex,
    required this.onHoverIndexChanged,
    required this.tooltipLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    const chartHeight = 280.0;
    const leftPadding = 46.0;
    const bottomLabelHeight = 28.0;

    // Use a percentage-based padding instead of a fixed step to avoid overflow
    final barPadding = points.length <= 20 ? 4.0 : 2.0;

    return SizedBox(
      height: chartHeight + bottomLabelHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chartWidth = constraints.maxWidth - leftPadding;

          return Column(
            children: [
              SizedBox(
                height: chartHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Y Axis Labels
                    SizedBox(
                      width: leftPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: yLabels.map((label) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              label,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF8A8A8A), fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    // Chart Area
                    Expanded(
                      child: MouseRegion(
                        onExit: (_) => onHoverIndexChanged(null),
                        child: Stack(
                          clipBehavior: Clip.none, // Allow tooltips to breathe
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _ChartGridPainter(
                                  threshold: threshold,
                                  yMin: yMin,
                                  yMax: yMax,
                                  lineCount: yLabels.length,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(points.length, (index) {
                                  final point = points[index];
                                  final normalized = ((point.value - yMin) / (yMax - yMin)).clamp(0.0, 1.0);
                                  final barHeight = normalized * (chartHeight - 10);

                                  final isHovered = hoveredIndex == index;
                                  final color = point.isWarning ? warningColor : normalColor;

                                  // --- FIX 1: Use Expanded instead of hardcoded width to prevent overflow ---
                                  return Expanded(
                                    child: MouseRegion(
                                      onEnter: (_) => onHoverIndexChanged(index),
                                      child: GestureDetector(
                                        onTap: () => onHoverIndexChanged(index),
                                        child: Container(
                                          alignment: Alignment.bottomCenter,
                                          color: Colors.transparent, // Padding area for touch
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: barPadding / 2),
                                            child: AnimatedContainer(
                                              duration: const Duration(milliseconds: 100),
                                              width: double.infinity, // Fills the Expanded space minus padding
                                              height: math.max(barHeight, 4.0),
                                              decoration: BoxDecoration(
                                                color: isHovered ? color.withOpacity(0.8) : color,
                                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                            // Safe Bounds check for Tooltip
                            if (hoveredIndex != null && hoveredIndex! < points.length)
                              _buildTooltip(hoveredIndex!, chartWidth, chartHeight),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom X-Axis Labels
              SizedBox(
                height: bottomLabelHeight,
                child: Row(
                  children: [
                    const SizedBox(width: leftPadding),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _buildBottomLabels(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- FIX 2: Limit the number of labels to prevent horizontal overlapping ---
  List<Widget> _buildBottomLabels() {
    if (points.isEmpty) return [];
    
    final length = points.length;
    final List<int> displayIndexes = [0]; // Always include first
    
    // We target showing around 5 labels max to ensure they fit on screen
    int targetLabelCount = 5;
    if (length > 1) {
      double step = (length - 1) / (targetLabelCount - 1);
      for (int i = 1; i < targetLabelCount - 1; i++) {
        displayIndexes.add((i * step).round());
      }
      displayIndexes.add(length - 1); // Always include last
    }

    return List.generate(displayIndexes.length, (i) {
      final idx = displayIndexes[i];
      return Text(
        points[idx].label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF8A8A8A), fontWeight: FontWeight.w500),
      );
    });
  }
  Widget _buildTooltip(int index, double chartWidth, double chartHeight) {
    final point = points[index];
    final slotWidth = chartWidth / points.length;
    final x = slotWidth * index + (slotWidth / 2);
    final normalized = ((point.value - yMin) / (yMax - yMin)).clamp(0.0, 1.0);
    final y = chartHeight - (normalized * (chartHeight - 10));

    double tooltipLeft = x - 64;
    if (tooltipLeft < 8) tooltipLeft = 8;
    if (tooltipLeft > chartWidth - 140) tooltipLeft = chartWidth - 140;

    double tooltipTop = y - 84;
    if (tooltipTop < 8) tooltipTop = 8;

    return Stack(
      children: [
        Positioned(left: x, top: 0, bottom: 0, child: Container(width: 3, color: const Color(0xFFD0D0D0))),
        Positioned(
          left: tooltipLeft,
          top: tooltipTop,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 132,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 4))]),
              child: Text(tooltipLabelBuilder(point), style: const TextStyle(fontSize: 12, height: 1.5, color: Color(0xFF1F1F1F), fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartGridPainter extends CustomPainter {
  final double threshold;
  final double yMin;
  final double yMax;
  final int lineCount;

  _ChartGridPainter({required this.threshold, required this.yMin, required this.yMax, required this.lineCount});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()..color = const Color(0xFFE6E6E6)..strokeWidth = 1;
    final dashPaint = Paint()..color = const Color(0xFFF3A4AA)..strokeWidth = 1.2;

    for (int i = 0; i < lineCount; i++) {
      final y = size.height * (i / (lineCount - 1));
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), gridPaint);
    }

    const verticalLines = 7;
    for (int i = 0; i < verticalLines; i++) {
      final x = size.width * (i / (verticalLines - 1));
      _drawDashedLine(canvas, Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    final thresholdRatio = ((threshold - yMin) / (yMax - yMin)).clamp(0.0, 1.0);
    final thresholdY = size.height - (thresholdRatio * size.height);
    _drawDashedLine(canvas, Offset(0, thresholdY), Offset(size.width, thresholdY), dashPaint, dashWidth: 6, dashGap: 5);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint, {double dashWidth = 4, double dashGap = 4}) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final dashCount = (distance / (dashWidth + dashGap)).floor();

    for (int i = 0; i < dashCount; i++) {
      final x1 = start.dx + (dx / distance) * (i * (dashWidth + dashGap));
      final y1 = start.dy + (dy / distance) * (i * (dashWidth + dashGap));
      final x2 = start.dx + (dx / distance) * (i * (dashWidth + dashGap) + dashWidth);
      final y2 = start.dy + (dy / distance) * (i * (dashWidth + dashGap) + dashWidth);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _BottomNavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavButton({required this.label, required this.icon, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: BoxDecoration(color: isSelected ? const Color(0xFF166B57) : const Color(0xFFF0EFEA), borderRadius: BorderRadius.circular(18)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : const Color(0xFF5F5F5F)),
            const SizedBox(width: 10),
            Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : const Color(0xFF5F5F5F))),
          ],
        ),
      ),
    );
  }
}