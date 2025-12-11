import 'package:flutter/material.dart';

/// Optimized rating bar widget with animation support
class RatingBar extends StatefulWidget {
  /// Widget to display when the rating is unselected
  final Widget emptyWidget;

  /// Widget to display when the rating is selected
  final Widget fullWidget;

  /// Callback to retrieve the rating value when changed
  final ValueChanged<int>? onRatingChanged;

  /// Whether the rating bar is interactive (can be changed by user)
  final bool isInteractive;

  /// Number of rating items
  final int itemCount;

  /// Initial rating value (0 to itemCount)
  final int initialRating;

  /// Current rating value (for external control)
  final int? rating;

  /// Space between rating items
  final double spacing;

  /// Size of each rating item
  final double itemSize;

  /// Animation duration for rating changes
  final Duration animationDuration;

  /// Animation curve for rating changes
  final Curve animationCurve;

  /// Whether to animate rating changes
  final bool enableAnimation;

  /// Direction of the rating bar
  final Axis direction;

  /// Alignment of rating items
  final MainAxisAlignment alignment;

  /// Minimum rating value (cannot go below this)
  final int minRating;

  /// Allow half ratings (0.5, 1.5, etc.)
  final bool allowHalfRating;

  /// Tap area padding for better touch experience
  final EdgeInsets tapPadding;

  const RatingBar({
    super.key,
    required this.emptyWidget,
    required this.fullWidget,
    this.onRatingChanged,
    this.isInteractive = true,
    this.itemCount = 5,
    this.initialRating = 0,
    this.rating,
    this.spacing = 0,
    this.itemSize = 20.0,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.enableAnimation = true,
    this.direction = Axis.horizontal,
    this.alignment = MainAxisAlignment.start,
    this.minRating = 0,
    this.allowHalfRating = false,
    this.tapPadding = const EdgeInsets.all(4.0),
  }) : assert(initialRating >= 0 && initialRating <= itemCount,
  'initialRating must be between 0 and itemCount'),
        assert(minRating >= 0 && minRating <= itemCount,
        'minRating must be between 0 and itemCount'),
        assert(rating == null || (rating >= 0 && rating <= itemCount),
        'rating must be between 0 and itemCount');

  /// Factory constructor for read-only rating display
  factory RatingBar.readOnly({
    required Widget emptyWidget,
    required Widget fullWidget,
    required int rating,
    int itemCount = 5,
    double spacing = 4.0,
    double itemSize = 24.0,
    Axis direction = Axis.horizontal,
    MainAxisAlignment alignment = MainAxisAlignment.start,
    bool allowHalfRating = false,
  }) {
    return RatingBar(
      emptyWidget: emptyWidget,
      fullWidget: fullWidget,
      rating: rating,
      itemCount: itemCount,
      spacing: spacing,
      itemSize: itemSize,
      direction: direction,
      alignment: alignment,
      allowHalfRating: allowHalfRating,
      isInteractive: false,
      enableAnimation: false,
    );
  }

  /// Factory constructor for interactive rating input
  factory RatingBar.interactive({
    required Widget emptyWidget,
    required Widget fullWidget,
    required ValueChanged<int> onRatingChanged,
    int itemCount = 5,
    int initialRating = 0,
    double spacing = 4.0,
    double itemSize = 24.0,
    Duration animationDuration = const Duration(milliseconds: 200),
    Curve animationCurve = Curves.easeInOut,
    int minRating = 0,
    bool allowHalfRating = false,
    EdgeInsets tapPadding = const EdgeInsets.all(4.0),
  }) {
    return RatingBar(
      emptyWidget: emptyWidget,
      fullWidget: fullWidget,
      onRatingChanged: onRatingChanged,
      itemCount: itemCount,
      initialRating: initialRating,
      spacing: spacing,
      itemSize: itemSize,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      minRating: minRating,
      allowHalfRating: allowHalfRating,
      tapPadding: tapPadding,
      isInteractive: true,
      enableAnimation: true,
    );
  }

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> with TickerProviderStateMixin {
  late int _currentRating;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating ?? widget.initialRating;

    if (widget.enableAnimation) {
      _animationController = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      _scaleAnimation = Tween<double>(
        begin: 1.0,
        end: 1.2,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ));
    }
  }

  @override
  void didUpdateWidget(RatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update rating if controlled externally
    if (widget.rating != null && widget.rating != _currentRating) {
      setState(() {
        _currentRating = widget.rating!;
      });
    }

    // Update animation duration if changed
    if (widget.enableAnimation &&
        oldWidget.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _animationController.dispose();
    }
    super.dispose();
  }

  void _updateRating(int newRating) {
    // Ensure rating is within bounds
    newRating = newRating.clamp(widget.minRating, widget.itemCount);

    if (newRating != _currentRating) {
      setState(() {
        _currentRating = newRating;
      });

      // Trigger animation
      if (widget.enableAnimation) {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
      }

      // Notify parent
      widget.onRatingChanged?.call(newRating);
    }
  }

  Widget _buildRatingItem(int index) {
    final isSelected = index < _currentRating;
    final widget_ = isSelected ? widget.fullWidget : widget.emptyWidget;

    Widget ratingWidget = SizedBox(
      width: widget.itemSize,
      height: widget.itemSize,
      child: widget_,
    );

    // Add animation if enabled
    if (widget.enableAnimation && index < _currentRating) {
      ratingWidget = AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: ratingWidget,
      );
    }

    // Add interaction if interactive
    if (widget.isInteractive) {
      ratingWidget = GestureDetector(
        onTap: () => _updateRating(index + 1),
        child: Padding(
          padding: widget.tapPadding,
          child: ratingWidget,
        ),
      );
    }

    return ratingWidget;
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (int i = 0; i < widget.itemCount; i++) {
      children.add(_buildRatingItem(i));

      // Add spacing between items (except for the last item)
      if (i < widget.itemCount - 1 && widget.spacing > 0) {
        children.add(SizedBox(
          width: widget.direction == Axis.horizontal ? widget.spacing : 0,
          height: widget.direction == Axis.vertical ? widget.spacing : 0,
        ));
      }
    }

    if (widget.direction == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.alignment,
        children: children,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: widget.alignment,
        children: children,
      );
    }
  }
}

// Extension for easier star rating creation
extension StarRating on RatingBar {
  /// Creates a star rating bar with default star icons
  static Widget stars({
    Key? key,
    required ValueChanged<int> onRatingChanged,
    int itemCount = 5,
    int initialRating = 0,
    double size = 24.0,
    Color selectedColor = Colors.amber,
    Color unselectedColor = Colors.grey,
    bool isInteractive = true,
    double spacing = 4.0,
  }) {
    return RatingBar(
      key: key,
      emptyWidget: Icon(
        Icons.star_outline,
        color: unselectedColor,
        size: size,
      ),
      fullWidget: Icon(
        Icons.star,
        color: selectedColor,
        size: size,
      ),
      onRatingChanged: isInteractive ? onRatingChanged : null,
      itemCount: itemCount,
      initialRating: initialRating,
      itemSize: size,
      spacing: spacing,
      isInteractive: isInteractive,
    );
  }

  /// Creates a heart rating bar with heart icons
  static Widget hearts({
    Key? key,
    required ValueChanged<int> onRatingChanged,
    int itemCount = 5,
    int initialRating = 0,
    double size = 24.0,
    Color selectedColor = Colors.red,
    Color unselectedColor = Colors.grey,
    bool isInteractive = true,
    double spacing = 4.0,
  }) {
    return RatingBar(
      key: key,
      emptyWidget: Icon(
        Icons.favorite_outline,
        color: unselectedColor,
        size: size,
      ),
      fullWidget: Icon(
        Icons.favorite,
        color: selectedColor,
        size: size,
      ),
      onRatingChanged: isInteractive ? onRatingChanged : null,
      itemCount: itemCount,
      initialRating: initialRating,
      itemSize: size,
      spacing: spacing,
      isInteractive: isInteractive,
    );
  }

  /// Creates a thumbs rating bar
  static Widget thumbs({
    Key? key,
    required ValueChanged<int> onRatingChanged,
    int itemCount = 5,
    int initialRating = 0,
    double size = 24.0,
    Color selectedColor = Colors.green,
    Color unselectedColor = Colors.grey,
    bool isInteractive = true,
    double spacing = 4.0,
  }) {
    return RatingBar(
      key: key,
      emptyWidget: Icon(
        Icons.thumb_up_outlined,
        color: unselectedColor,
        size: size,
      ),
      fullWidget: Icon(
        Icons.thumb_up,
        color: selectedColor,
        size: size,
      ),
      onRatingChanged: isInteractive ? onRatingChanged : null,
      itemCount: itemCount,
      initialRating: initialRating,
      itemSize: size,
      spacing: spacing,
      isInteractive: isInteractive,
    );
  }
}