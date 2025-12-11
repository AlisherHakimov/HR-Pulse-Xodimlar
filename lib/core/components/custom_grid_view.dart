import 'package:flutter/material.dart';

class CustomGridView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Function()? onLoadMore;
  final bool isLoading;
  final EdgeInsets? padding;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final int crossAxisCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final bool reverse;
  final ScrollController? scrollController;

  const CustomGridView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onLoadMore,
    required this.isLoading, // ✅ External control
    this.padding,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.childAspectRatio = 170 / 320,
    this.crossAxisCount = 2,
    this.shrinkWrap = false,
    this.physics,
    this.reverse = false,
    this.scrollController,
  });

  @override
  State<CustomGridView> createState() => _CustomGridViewState();
}

class _CustomGridViewState extends State<CustomGridView> {
  late final ScrollController _internalController;

  ScrollController get _controller =>
      widget.scrollController ?? _internalController;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController == null) {
      _internalController = ScrollController();
    }
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (widget.scrollController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.pixels >=
            _controller.position.maxScrollExtent - 200 &&
        !widget.isLoading) {
      widget.onLoadMore?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      reverse: widget.reverse,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding ?? EdgeInsets.zero,
      controller: _controller,
      physics: widget.physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
    );
  }
}
