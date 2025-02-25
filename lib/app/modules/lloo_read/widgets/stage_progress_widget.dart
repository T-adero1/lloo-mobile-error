import 'package:flutter/material.dart';
import '../lloo_read_styles.dart';
import '../models/search_stage.dart';


class StageProgressWidgetController extends ValueNotifier<SearchStage> {
  StageProgressWidgetController([super.value = SearchStage.cue]);
}


class StageProgressWidget extends StatefulWidget {
  const StageProgressWidget({
    super.key,
    required this.controller,
  });

  final StageProgressWidgetController controller;

  @override
  State<StageProgressWidget> createState() => _StageProgressWidgetState();
}

class _StageProgressWidgetState extends State<StageProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late double _prevProgress;

  @override
  void initState() {
    super.initState();
    _prevProgress = widget.controller.value.index.toDouble();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _updateAnimation();

    // Listen to controller changes
    widget.controller.addListener(_handleStageChange);
  }

  void _handleStageChange() {
    _prevProgress = _progressAnimation.value;
    _updateAnimation();
    _animationController.forward(from: 0);
  }

  void _updateAnimation() {
    _progressAnimation = Tween<double>(
      begin: _prevProgress,
      end: widget.controller.value.index.toDouble(),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleStageChange);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // STYLES
    final dotSize = 7.0;
    final dotSpacing = 4.0;
    final theme = Theme.of(context);
    final progressTextColor = theme.colorScheme.onSurface;
    final progressDotColor = theme.colorScheme.surfaceDim;
    final progressBarColor = theme.colorScheme.onSurface;

    return ValueListenableBuilder<SearchStage>(
      valueListenable: widget.controller,
      builder: (context, stage, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //----------------------------------------------------------
            // LABEL
            Text(
              stage.name,
              style: TextStyle(
                fontSize: 14,
                color: progressTextColor,
              ),
            ),
            SizedBox(height: dotSpacing),
            Stack(
              children: [

                // ----------------------------------------------------------
                // DOTS
                Row(
                  children: List.generate(
                    SearchStage.values.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        right: index < SearchStage.values.length - 1
                            ? dotSpacing
                            : 0,
                      ),
                      child: Container(
                        height: dotSize,
                        width: dotSize,
                        decoration: BoxDecoration(
                          color: progressDotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                //----------------------------------------------------------
                // BAR
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    final segments = SearchStage.values.length - 1; // number of segments between dots
                    final totalWidth = segments * (dotSize + dotSpacing) + dotSize; // + current dot
                    final segmentWidth = dotSize + dotSpacing; // width of one segment

                    // Calculate how many complete segments to show, plus any partial segment
                    final progressWidth = (_progressAnimation.value * segmentWidth + dotSize)
                        .clamp(dotSize, totalWidth); // ensure it at least covers first dot

                    return Container(
                      height: dotSize,
                      width: progressWidth,
                      decoration: BoxDecoration(
                        color: progressBarColor,
                        borderRadius: BorderRadius.circular(dotSize / 2.0),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}