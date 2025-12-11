import 'package:flutter/material.dart';

class VerticalListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Function? onLoadMore;
  final EdgeInsets? padding;
  final double? separatedSpace;
  final bool? shrinkWrap;
  final ScrollPhysics? physics;
  final bool? reverse;
  final ScrollController? scrollController;

  const VerticalListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.onLoadMore,
    this.padding,
    this.separatedSpace,
    this.shrinkWrap,
    this.physics,
    this.reverse = false,
    this.scrollController,
  });

  @override
  State<VerticalListView> createState() => _VerticalListViewState();
}

class _VerticalListViewState extends State<VerticalListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      reverse: widget.reverse ?? false,
      shrinkWrap: widget.shrinkWrap ?? false,
      padding: widget.padding ?? EdgeInsets.zero,
      controller: widget.scrollController ?? _scrollController,
      physics: widget.physics,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
      separatorBuilder: (context, index) {
        return SizedBox(height: widget.separatedSpace ?? 10);
      },
    );
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        widget.onLoadMore?.call();
      }
    }
  }
}
