import 'package:flutter/material.dart';

import 'model/product.dart';

const double _kFlingVelocity = 2.0;

class Backdrop extends StatefulWidget {
  final Category currentCategory;
  final Widget frontLayer;
  final Widget backLayer;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({
    required this.currentCategory,
    required this.frontLayer,
    required this.backLayer,
    required this.frontTitle,
    required this.backTitle,
    Key? key,
  }) : super(key: key);

  @override
  _BackdropState createState() => _BackdropState();
}

class _FrontLayer extends StatelessWidget {
  const _FrontLayer({
    required this.onTap,
    required this.child,
  });

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 16.0,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(46.0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: const SizedBox(
              height: 48.0,
              width: double.infinity,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  const _BackdropTitle({
    required Animation<double> listenable,
    required this.onPress,
    required this.frontTitle,
    required this.backTitle,
  }) : super(listenable: listenable);

  final VoidCallback onPress;
  final Widget frontTitle;
  final Widget backTitle;

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;

    return GestureDetector(
      onTap: onPress,
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.titleLarge!,
        child: Stack(
          children: <Widget>[
            FadeTransition(
              opacity: animation,
              child: frontTitle,
            ),
            FadeTransition(
              opacity: ReverseAnimation(animation),
              child: backTitle,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleBackdropLayerVisibility() {
    _controller.fling(
      velocity: _controller.value == 1.0
          ? -_kFlingVelocity
          : _kFlingVelocity,
    );
  }

  Widget _buildStack(
      BuildContext context,
      BoxConstraints constraints,
      ) {
    final Size layerSize = constraints.biggest;
    final double layerHeight = layerSize.height;

    return Stack(
      key: _backdropKey,
      children: <Widget>[
        ExcludeSemantics(
          excluding: _controller.value == 1.0,
          child: widget.backLayer,
        ),
        PositionedTransition(
          rect: RelativeRectTween(
            begin: RelativeRect.fromLTRB(
              0.0,
              layerHeight - 48.0,
              0.0,
              0.0,
            ),
            end: const RelativeRect.fromLTRB(
              0.0,
              0.0,
              0.0,
              0.0,
            ),
          ).animate(_controller),
          child: _FrontLayer(
            onTap: _toggleBackdropLayerVisibility,
            child: widget.frontLayer,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0.0,
      titleSpacing: 0.0,
      leading: IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.close_menu,
          progress: _controller,
        ),
        onPressed: _toggleBackdropLayerVisibility,
        tooltip: 'Menu',
      ),
      title: _BackdropTitle(
        listenable: _controller,
        onPress: _toggleBackdropLayerVisibility,
        frontTitle: widget.frontTitle,
        backTitle: widget.backTitle,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search,
            semanticLabel: 'search',
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.tune,
            semanticLabel: 'filter',
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/login');
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return _buildStack(context, constraints);
        },
      ),
    );
  }
}