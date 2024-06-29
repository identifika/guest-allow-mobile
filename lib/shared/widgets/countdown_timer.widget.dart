import 'dart:developer';

import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({
    super.key,
    required this.secondsRemaining,
    this.countDownTimerStyle,
    required this.whenTimeExpires,
    this.countDownFormatter,
    this.text,
  });

  final int secondsRemaining;
  final Function whenTimeExpires;
  final Function? countDownFormatter;
  final TextStyle? countDownTimerStyle;
  final String? text;

  @override
  State createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Duration duration;

  String get timerDisplayString {
    Duration duration = _controller.duration! * _controller.value;
    return widget.countDownFormatter != null
        ? widget.countDownFormatter!(duration.inSeconds)
        : formatHHMMSS(duration.inSeconds);
    // In case user doesn't provide formatter use the default one
    // for that create a method which will be called formatHHMMSS or whatever you like
  }

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.secondsRemaining);
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller.reverse(from: widget.secondsRemaining.toDouble());
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.whenTimeExpires();
      }
    });
  }

  @override
  void didUpdateWidget(CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      setState(() {
        duration = Duration(seconds: widget.secondsRemaining);
        _controller.dispose();
        _controller = AnimationController(
          vsync: this,
          duration: duration,
        );
        _controller.reverse(from: widget.secondsRemaining.toDouble());
        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.whenTimeExpires();
          } else if (status == AnimationStatus.dismissed) {
            log("Animation Complete");
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, Widget? child) {
          return Text(
            widget.text != null
                ? '${widget.text} $timerDisplayString'
                : timerDisplayString,
            style: widget.countDownTimerStyle,
          );
        },
      ),
    );
  }

  String formatHHMMSS(int seconds) {
    // Implement your default formatter here
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return [hours, minutes, remainingSeconds]
        .map((seg) => seg.toString().padLeft(2, '0'))
        .join(':');
  }
}
