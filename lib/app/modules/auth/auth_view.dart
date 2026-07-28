import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/app/modules/auth/auth_controller.dart';

class AuthScreen extends GetView<AuthController> {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: DecoratedBox(
   
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primary.withOpacity(.10), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 3),

             
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary,
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(.35),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 52,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  'Recipe Explorer',
                  style: TextStyle(
                    color: primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .2,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Discover and share amazing recipes!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),

                const Spacer(flex: 4),

                Obx(() {
                  if (controller.isLoading.value) {
                    return SizedBox(
                      height: 56,
                      child: Center(
                        child: CircularProgressIndicator(color: primary),
                      ),
                    );
                  }

                  return _GoogleSignInButton(
                    onPressed: controller.signInWithGoogle,
                  );
                }),

                const SizedBox(height: 16),

                Text(
                  'By continuing, you agree to our Terms & Privacy Policy',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(.15),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleG(),
                const SizedBox(width: 12),
                const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _GoogleG extends StatelessWidget {
  const _GoogleG();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleGPainter()),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2;

    final paint = Paint()..style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.22;
    paint.strokeCap = StrokeCap.butt;

    void arc(double startDeg, double sweepDeg, Color color) {
      paint.color = color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - paint.strokeWidth / 2),
        startDeg * 3.1415926535 / 180,
        sweepDeg * 3.1415926535 / 180,
        false,
        paint,
      );
    }

    arc(-45, 90, const Color(0xFF4285F4)); // blue
    arc(45, 90, const Color(0xFF34A853)); // green
    arc(135, 90, const Color(0xFFFBBC05)); // yellow
    arc(225, 90, const Color(0xFFEA4335)); // red

    // Horizontal bar of the G
    final barPaint = Paint()..color = const Color(0xFF4285F4);
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - paint.strokeWidth / 2,
        radius,
        paint.strokeWidth,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
