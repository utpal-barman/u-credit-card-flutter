// Renders the README demo animation frame-by-frame using the real
// CreditCardUi widget, driven on the test binding's fake clock.
//
//   DEMO_OUT=/path/to/frames flutter test tool/demo/render_demo_test.dart
//   then: tool/demo/make_gif.sh /path/to/frames out.gif
//
// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:u_credit_card/u_credit_card.dart';

const fps = 20;
const totalSeconds = 30.0;
const sceneSize = Size(800, 450);
const capturePixelRatio = 2.0;

// ---------------------------------------------------------------- timeline
const tIntroEnd = 3.0;
const tTypeStart = 3.0;
const typeSlot = 1.8;
const tGradStart = 10.2;
const tFlipStart = 15.0;
const tBalanceStart = 21.0;
const tFanStart = 25.0;
const tOutroStart = 28.0;

const flipTimes = [15.8, 17.3, 18.9, 20.2];
const tBalanceTap = 22.1;

const typed = [
  ('4111111111111111', Color(0xFF1F4FD8)), // Visa
  ('5555555555554444', Color(0xFF2A2A31)), // Mastercard
  ('378282246310005', Color(0xFF0E8A94)), // Amex
  ('6011111111111117', Color(0xFFE8740C)), // Discover
];

const introColor = Color(0xFF7B2FBE);
const gradientCycle = [
  Color(0xFFE8740C),
  Color(0xFFD81B60),
  Color(0xFF8E24AA),
  Color(0xFF3949AB),
  Color(0xFF00897B),
  Color(0xFF3949AB),
];
const flipColor = Color(0xFF3949AB);
const balanceColor = Color(0xFF00897B);
const fanColor = Color(0xFF7B2FBE);

const bg = Color(0xFF0B0F1A);

double seg(double t, double a, double b) => ((t - a) / (b - a)).clamp(0.0, 1.0);
double ease(double x) => Curves.easeOutCubic.transform(x);
double easeIO(double x) => Curves.easeInOutCubic.transform(x);

Color shade(Color c) {
  final hsl = HSLColor.fromColor(c);
  return hsl
      .withHue((hsl.hue + 28) % 360)
      .withLightness((hsl.lightness * 0.55).clamp(0.0, 1.0))
      .toColor();
}

Color lerpList(List<Color> cs, double x) {
  final p = x * (cs.length - 1);
  final i = p.floor().clamp(0, cs.length - 2);
  return Color.lerp(cs[i], cs[i + 1], easeIO(p - i))!;
}

/// Mutable bits the test loop sets for the scene (finger overlay target).
Offset balancePillCenter = Offset.zero;

// ------------------------------------------------------------- main card
class MainCardState {
  MainCardState(this.t);
  final double t;

  int get typingSlot => ((t - tTypeStart) / typeSlot).floor().clamp(0, 3);

  bool get isTyping => t >= tTypeStart && t < tGradStart;

  String get number {
    if (isTyping) {
      final s = tTypeStart + typingSlot * typeSlot;
      final full = typed[typingSlot].$1;
      final n = (seg(t, s + 0.15, s + 1.05) * full.length).round();
      return full.substring(0, n);
    }
    if (t >= tFanStart) return '5555555555554444';
    return '4111111111111111';
  }

  Color get color {
    if (t < tTypeStart) return introColor;
    if (isTyping) {
      final s = tTypeStart + typingSlot * typeSlot;
      final from = typingSlot == 0 ? introColor : typed[typingSlot - 1].$2;
      // colour settles once the network is recognised (typing done)
      return Color.lerp(
          from, typed[typingSlot].$2, easeIO(seg(t, s + 1.0, s + 1.35)))!;
    }
    if (t < tFlipStart) {
      return lerpList(gradientCycle, seg(t, tGradStart, tFlipStart - 0.2));
    }
    if (t < tBalanceStart) return flipColor;
    if (t < tFanStart) {
      return Color.lerp(flipColor, balanceColor,
          easeIO(seg(t, tBalanceStart, tBalanceStart + 0.5)))!;
    }
    return Color.lerp(balanceColor, fanColor, easeIO(seg(t, tFanStart, 25.6)))!;
  }
}

// ---------------------------------------------------------------- scene
class DemoScene extends StatelessWidget {
  const DemoScene({required this.t, required this.controller, super.key});

  final double t;
  final CreditCardController controller;

  @override
  Widget build(BuildContext context) {
    final s = MainCardState(t);
    final color = s.color;

    // ---- main card transform
    final rise = Curves.easeOutBack.transform(seg(t, 0.2, 1.5));
    var dy = (1 - rise) * 320 + math.sin(t * 1.8) * 3;
    var scale = 1.42;
    var rotY = 0.0;
    var rotX = (1 - ease(seg(t, 0.2, 1.6))) * 0.5;

    if (t >= tGradStart && t < tFlipStart) {
      final env = math.sin(seg(t, tGradStart, tFlipStart) * math.pi);
      rotY = math.sin((t - tGradStart) * 1.6) * 0.32 * env;
      rotX += math.cos((t - tGradStart) * 1.1) * 0.08 * env;
    }
    final fanIn = easeIO(seg(t, tFanStart, tFanStart + 0.8));
    final fanOut = easeIO(seg(t, tOutroStart + 0.2, tOutroStart + 1.0));
    final fan = fanIn * (1 - fanOut);
    scale = ui.lerpDouble(1.42, 1.0, fan)!;
    dy -= fan * 6;

    final mainCard = Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0012)
        ..translateByDouble(0, dy, 0, 1)
        ..rotateX(rotX)
        ..rotateY(rotY)
        ..scaleByDouble(scale, scale, 1, 1),
      child: CreditCardUi(
        controller: controller,
        width: 300,
        cardHolderFullName: 'Alex Morgan',
        cardNumber: s.number,
        validFrom: '01/25',
        validThru: '01/30',
        topLeftColor: color,
        bottomRightColor: shade(color),
        shouldMaskCardNumber: !s.isTyping,
        cardType: t >= tFanStart ? CardType.credit : CardType.debit,
        showBalance: t >= tBalanceStart && t < tFanStart,
        autoHideBalance: true,
        balance: 2840.75,
        enableFlipping: true,
        cvvNumber: '123',
        disableHapticFeedBack: true,
      ),
    );

    Widget sideCard({
      required double dir,
      required Widget card,
    }) {
      return Opacity(
        opacity: fan.clamp(0.0, 1.0),
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0012)
            ..translateByDouble(dir * 225 * fan, 22 * fan, 0, 1)
            ..rotateZ(dir * 0.10 * fan)
            ..rotateY(-dir * 0.35 * fan)
            ..scaleByDouble(0.9, 0.9, 1, 1),
          child: card,
        ),
      );
    }

    final glow = Color.lerp(color, Colors.white, 0.1)!;

    return ColoredBox(
      color: bg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ambient glow following the card colour
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0.05),
                radius: 0.95,
                colors: [
                  glow.withValues(alpha: 0.38 * ease(seg(t, 0.2, 1.4))),
                  bg.withValues(alpha: 0),
                ],
              ),
            ),
          ),
          const _GridDots(),
          // header
          Positioned(
            top: 22,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: ease(seg(t, 0.1, 0.9)),
              child: Transform.translate(
                offset: Offset(0, (1 - ease(seg(t, 0.1, 0.9))) * -12),
                child: const _Header(),
              ),
            ),
          ),
          // cards
          Center(
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                if (fan > 0)
                  sideCard(
                    dir: -1,
                    card: const CreditCardUi(
                      width: 300,
                      cardHolderFullName: 'Sam Lee',
                      cardNumber: '4111111111111111',
                      validThru: '08/29',
                      topLeftColor: Color(0xFF0E8A94),
                      bottomRightColor: Color(0xFF0A2E52),
                      cardType: CardType.prepaid,
                      placeNfcIconAtTheEnd: true,
                      cardProviderLogo: FlutterLogo(size: 26),
                      cardProviderLogoPosition: CardProviderLogoPosition.left,
                    ),
                  ),
                if (fan > 0)
                  sideCard(
                    dir: 1,
                    card: const CreditCardUi(
                      width: 300,
                      cardHolderFullName: 'Maya Chen',
                      cardNumber: '378282246310005',
                      validThru: '11/28',
                      topLeftColor: Color(0xFFD81B60),
                      bottomRightColor: Color(0xFF4A0E3A),
                      cardType: CardType.giftCard,
                      doesSupportNfc: false,
                    ),
                  ),
                mainCard,
              ],
            ),
          ),
          // finger / touch indicator
          IgnorePointer(child: Stack(children: _finger())),
          // caption
          Positioned(
            left: 0,
            right: 0,
            bottom: 26,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 380),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0, 0.35),
                      end: Offset.zero,
                    ).animate(anim),
                    child: child,
                  ),
                ),
                child: _caption(),
              ),
            ),
          ),
          // loop fade
          IgnorePointer(
            child: ColoredBox(
              color: bg.withValues(
                alpha: easeIO(seg(t, totalSeconds - 0.6, totalSeconds - 0.05)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _caption() {
    if (t < 1.2) return const SizedBox(key: ValueKey('none'), height: 34);
    if (t < tTypeStart) {
      return const _Caption('A beautiful card widget for Flutter');
    }
    if (t < tGradStart) {
      return const _Caption('Auto-detects Visa · Mastercard · Amex · Discover');
    }
    if (t < tFlipStart) return const _Caption('Any gradient, any brand colour');
    if (t < 18.5) return const _Caption('Swipe to flip — shows the CVV side');
    if (t < tBalanceStart) {
      return const _Caption(
        'Or flip it from code',
        code: 'controller.flipCard()',
      );
    }
    if (t < tFanStart) return const _Caption('Hidden balance · tap to reveal');
    if (t < tOutroStart) {
      return const _Caption('Credit · Debit · Prepaid · Gift card');
    }
    return const _Caption(null, code: 'flutter pub add u_credit_card');
  }

  List<Widget> _finger() {
    // swipe gestures for the first two flips
    for (final (i, ft) in flipTimes.take(2).indexed) {
      final a = ft - 0.55;
      final b = ft + 0.1;
      if (t >= a - 0.15 && t <= b + 0.2) {
        final p = easeIO(seg(t, a, b));
        final dir = i.isEven ? 1.0 : -1.0;
        final x = sceneSize.width / 2 + dir * (-150 + 300 * p);
        final alpha = seg(t, a - 0.15, a) * (1 - seg(t, b, b + 0.2));
        return [_dot(Offset(x, sceneSize.height / 2 + 30), alpha, 1)];
      }
    }
    // tap on balance pill
    const a = tBalanceTap - 0.5;
    const b = tBalanceTap + 0.35;
    if (t >= a && t <= b) {
      final alpha = seg(t, a, a + 0.2) * (1 - seg(t, b - 0.2, b));
      final press = 1 -
          0.25 *
              math.sin(
                  seg(t, tBalanceTap - 0.15, tBalanceTap + 0.15) * math.pi);
      final ring = seg(t, tBalanceTap, b);
      return [
        _dot(balancePillCenter, alpha, press),
        if (ring > 0) _ring(balancePillCenter, ring),
      ];
    }
    return const [];
  }

  Widget _dot(Offset c, double alpha, double s) {
    const r = 17.0;
    return Positioned(
      left: c.dx - r,
      top: c.dy - r,
      child: Transform.scale(
        scale: s,
        child: Container(
          width: r * 2,
          height: r * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.42 * alpha),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85 * alpha),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _ring(Offset c, double p) {
    final r = 17 + 26 * ease(p);
    return Positioned(
      left: c.dx - r,
      top: c.dy - r,
      child: Container(
        width: r * 2,
        height: r * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.6 * (1 - p)),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FlutterLogo(size: 20),
            SizedBox(width: 8),
            Text(
              'u_credit_card',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption(this.text, {this.code});

  final String? text;
  final String? code;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ValueKey('$text|$code'),
      mainAxisSize: MainAxisSize.min,
      children: [
        if (text != null)
          Text(
            text!,
            style: const TextStyle(
              color: Color(0xFFE6E9F2),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        if (text != null && code != null) const SizedBox(width: 12),
        if (code != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFF1B2236),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2E3A5C)),
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  if (code!.startsWith('flutter'))
                    const TextSpan(
                      text: r'$ ',
                      style: TextStyle(color: Color(0xFF6B7795)),
                    ),
                  TextSpan(text: code),
                ],
              ),
              style: const TextStyle(
                fontFamily: 'DemoMono',
                color: Color(0xFF7FD1FF),
                fontSize: 16,
              ),
            ),
          ),
      ],
    );
  }
}

class _GridDots extends StatelessWidget {
  const _GridDots();

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _DotsPainter());
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.white.withValues(alpha: 0.045);
    for (var x = 12.0; x < size.width; x += 24) {
      for (var y = 12.0; y < size.height; y += 24) {
        canvas.drawCircle(Offset(x, y), 1, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ------------------------------------------------------------------ fonts
Future<void> _loadFont(String family, List<String> paths) async {
  final loader = FontLoader(family);
  for (final path in paths) {
    final bytes = File(path).readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

String _firstExisting(List<String> paths) =>
    paths.firstWhere((p) => File(p).existsSync());

Future<void> _loadFonts() async {
  final root = Platform.environment['FLUTTER_ROOT']!;
  final mf = '$root/bin/cache/artifacts/material_fonts';
  await _loadFont('Roboto', [
    '$mf/Roboto-Regular.ttf',
    '$mf/Roboto-Medium.ttf',
    '$mf/Roboto-Bold.ttf',
  ]);
  await _loadFont('packages/u_credit_card/ocr-a', ['fonts/OCR-A-regular.ttf']);
  final home = Platform.environment['HOME'];
  await _loadFont('DemoMono', [
    _firstExisting([
      '$home/Library/Fonts/FiraCode-VariableFont_wght.ttf',
      '/Library/Fonts/FiraCode-VariableFont_wght.ttf',
      '/System/Library/Fonts/Supplemental/Andale Mono.ttf',
    ]),
  ]);
}

// ------------------------------------------------------------------- main
void main() {
  testWidgets('render README demo frames', (tester) async {
    final outDir = Directory(
      Platform.environment['DEMO_OUT'] ?? 'build/demo_frames',
    )..createSync(recursive: true);

    await tester.runAsync(_loadFonts);

    // Haptics are awaited before the balance reveals; answer instantly.
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (_) async => null,
    );

    tester.view
      ..physicalSize = sceneSize
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final controller = CreditCardController();
    final time = ValueNotifier<double>(0);
    final boundaryKey = GlobalKey();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto'),
        home: RepaintBoundary(
          key: boundaryKey,
          child: Material(
            color: bg,
            child: ValueListenableBuilder<double>(
            valueListenable: time,
            builder: (_, t, __) => DemoScene(t: t, controller: controller),
            ),
          ),
        ),
      ),
    );

    // Decode all bundled images up front so they show on the first frame.
    final ctx = tester.element(find.byType(DemoScene));
    await tester.runAsync(() async {
      for (final name in [
        'visa_logo',
        'master_card',
        'amex',
        'discover',
        'chip',
        'nfc',
      ]) {
        await precacheImage(
          AssetImage(
            'assets/images/$name.png',
            package: 'u_credit_card',
          ),
          ctx,
        );
      }
    });

    final pendingFlips = [...flipTimes];
    var tapped = false;
    var pillLocated = false;
    const frameDt = Duration(microseconds: 1000000 ~/ fps);
    final frameCount = (totalSeconds * fps).round();

    for (var i = 0; i < frameCount; i++) {
      final t = i / fps;
      time.value = t;

      while (pendingFlips.isNotEmpty && pendingFlips.first <= t) {
        pendingFlips.removeAt(0);
        controller.flipCard();
      }
      if (!pillLocated && t >= tBalanceTap - 0.6) {
        pillLocated = true;
        balancePillCenter = tester.getCenter(find.text('TAP TO SEE BALANCE'));
      }
      if (!tapped && t >= tBalanceTap) {
        tapped = true;
        await tester.tapAt(balancePillCenter);
      }

      await tester.pump(frameDt);

      final boundary = boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: capturePixelRatio);
        final png = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();
        await File(
          '${outDir.path}/f_${i.toString().padLeft(4, '0')}.png',
        ).writeAsBytes(png!.buffer.asUint8List());
      });
      if (i % 50 == 0) print('frame $i / $frameCount');
    }

    controller.dispose();
  }, timeout: Timeout.none);
}
