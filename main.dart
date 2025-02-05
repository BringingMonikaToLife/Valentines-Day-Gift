import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Envelope Letter Animation',
      debugShowCheckedModeBanner: false,
      home: EnvelopeAnimationScreen(),
    );
  }
}

class EnvelopeAnimationScreen extends StatefulWidget {
  @override
  _EnvelopeAnimationScreenState createState() =>
      _EnvelopeAnimationScreenState();
}

class _EnvelopeAnimationScreenState extends State<EnvelopeAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _letterSlideAnimation;

  final double envelopeWidth = 300;
  final double envelopeHeight = 200;
  final double coverHeight = 50;
  final double letterHeight = 150;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _letterSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -1),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    if (_controller.status == AnimationStatus.completed ||
        _controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Envelope Letter Animation'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _toggleAnimation,
          child: EnvelopeWidget(
            envelopeWidth: envelopeWidth,
            envelopeHeight: envelopeHeight,
            coverHeight: coverHeight,
            letterHeight: letterHeight,
            letterSlideAnimation: _letterSlideAnimation,
          ),
        ),
      ),
    );
  }
}

class EnvelopeWidget extends StatelessWidget {
  final double envelopeWidth;
  final double envelopeHeight;
  final double coverHeight;
  final double letterHeight;
  final Animation<Offset> letterSlideAnimation;

  const EnvelopeWidget({
    Key? key,
    required this.envelopeWidth,
    required this.envelopeHeight,
    required this.coverHeight,
    required this.letterHeight,
    required this.letterSlideAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: envelopeWidth,
      height: envelopeHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: letterSlideAnimation,
              child: LetterWidget(
                width: envelopeWidth,
                height: letterHeight,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: coverHeight,
            child: EnvelopeBody(
              width: envelopeWidth,
              height: envelopeHeight - coverHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class EnvelopeBody extends StatelessWidget {
  final double width;
  final double height;

  const EnvelopeBody({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red, width: 2),
      ),
    );
  }
}

class LetterWidget extends StatelessWidget {
  final double width;
  final double height;

  const LetterWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'I love you ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              WidgetSpan(
                child: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
