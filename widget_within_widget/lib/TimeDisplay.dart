import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  final Duration duration;
  final Color color;
  final ValueChanged<Duration> onClear;
  final TargetPlatform platform;

  TimeDisplay({
    Key key,
    @required this.platform,
    this.onClear,
    this.color = Colors.green,
    this.duration = const Duration(),
  }) : super(key: key);

  void _onClicked() {
    onClear(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(5.0),
          child: Text(
            duration.toString(),
            style: TextStyle(
                fontSize: platform == TargetPlatform.iOS ? 28.0 : 32.0,
                color: color),
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: _onClicked,
        )
      ],
    );
  }
}
