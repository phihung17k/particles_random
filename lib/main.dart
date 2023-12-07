import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          child: Stack(fit: StackFit.loose, children: [AnimationWidget()]),
        ));
  }
}

class AnimationWidget extends StatefulWidget {
  const AnimationWidget({super.key});

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> {
  late Timer timer;
  final List<Particle> particles = List.generate(100, (index) => Particle());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double width = MediaQuery.sizeOf(context).width;
      double height = MediaQuery.sizeOf(context).height;
      timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
        setState(() {
          for (var p in particles) {
            if (p.pos.dx <= 0 && p.dx <= 0 || p.pos.dx >= width && p.dx > 0) {
              p.dx *= -1;
            }
            if (p.pos.dy <= 0 && p.dy <= 0 ||
                p.pos.dy >= height - 60 && p.dy > 0) {
              p.dy *= -1;
            }
            p.pos += Offset(p.dx, p.dy);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        child: Container(),
        size: Size(MediaQuery.sizeOf(context).width,
            MediaQuery.sizeOf(context).height),
        painter: AnimationPainter(particles),
      ),
    );
  }
}

class AnimationPainter extends CustomPainter {
  List<Particle> particles;
  AnimationPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      canvas.drawCircle(
          p.pos,
          p.radius,
          Paint()
            ..color = p.color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Random ran = Random();

class Utils {
  static double Range(double min, double max) =>
      ran.nextDouble() * (max - min) + min;
}

class Particle {
  late double radius;
  late Color color;
  late Offset pos;
  late double dx;
  late double dy;

  Particle() {
    radius = Utils.Range(3, 10);
    color = Colors.amber;
    pos = Offset(Utils.Range(0, 300), Utils.Range(0, 500));
    dx = Utils.Range(-0.5, 0.5);
    dy = Utils.Range(-0.5, 0.5);
  }
}
