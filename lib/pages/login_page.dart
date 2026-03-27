import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // 模拟 React 的状态
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;

  // 动画控制
  late AnimationController _headerController;
  late AnimationController _formController;
  late Animation<Offset> _headerOffset;
  late Animation<Offset> _formOffset;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    
    // 初始化动画 (模拟 framer-motion 的 initial/animate)
    _headerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _formController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _headerOffset = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerController, curve: Curves.easeOut));
    
    _formOffset = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _formController, curve: Curves.easeOut));

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_headerController);

    // 延迟播放动画
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 150), () => _formController.forward());
  }

  @override
  void dispose() {
    _headerController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF1A5C4C);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // --- Logo / Hero (motion.div) ---
              FadeTransition(
                opacity: _opacity,
                child: SlideTransition(
                  position: _headerOffset,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64, bottom: 24),
                    child: Column(
                      children: [
                        // Shield Logo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Center(
                            child: CustomPaint(
                              size: const Size(44, 48),
                              painter: ShieldPainter(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'GuardSync',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Smart mouthguard monitoring',
                          style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- Login Form (motion.form) ---
              FadeTransition(
                opacity: _formController, // 使用第二个控制器的透明度
                child: SlideTransition(
                  position: _formOffset,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildLabel("Email"),
                      _buildTextField(
                        controller: _emailController,
                        hint: "you@example.com",
                        prefixIcon: Icons.mail_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildLabel("Password"),
                      _buildTextField(
                        controller: _passwordController,
                        hint: "Enter your password",
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                        obscureText: !_showPassword,
                        onTogglePassword: () => setState(() => _showPassword = !_showPassword),
                      ),
                      
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: const Text('Forgot password?', 
                            style: TextStyle(color: primaryColor, fontSize: 12)),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/role'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Sign In', style: TextStyle(fontSize: 16)),
                      ),

                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          children: [
                            const Expanded(child: Divider(color: Color(0xFFCCCCCC))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('or continue with', 
                                style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
                            ),
                            const Expanded(child: Divider(color: Color(0xFFCCCCCC))),
                          ],
                        ),
                      ),

                      // Social Buttons
                      Row(
                        children: [
                          Expanded(child: _buildSocialButton('Google', 'assets/google_logo.png', isGoogle: true)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildSocialButton('Apple', 'assets/apple_logo.png', isApple: true)),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Footer
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? ", 
                                  style: TextStyle(color: Color(0xFF777777), fontSize: 14)),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/role'),
                                  child: const Text("Sign Up", 
                                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/flow-diagram'),
                              child: const Text("View User Flow Diagram", 
                                style: TextStyle(color: Color(0xFF999999), fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label, style: const TextStyle(color: Color(0xFF555555), fontSize: 14)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onTogglePassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
        prefixIcon: Icon(prefixIcon, color: const Color(0xFF999999), size: 20),
        suffixIcon: isPassword 
          ? IconButton(
              icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, 
                         color: const Color(0xFF999999), size: 20),
              onPressed: onTogglePassword,
            )
          : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A5C4C)),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, String iconPath, {bool isGoogle = false, bool isApple = false}) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: Color(0xFFDDDDDD)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 此处使用图标占位，实际开发请替换为 Image.asset
          Icon(isGoogle ? Icons.g_mobiledata : Icons.apple, color: Colors.black),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Color(0xFF555555), fontSize: 14)),
        ],
      ),
    );
  }
}

// 绘制原始 SVG 中的盾牌图标
class ShieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // 盾牌外轮廓
    path.moveTo(size.width * 0.5, size.height * 0.08);
    path.lineTo(size.width * 0.14, size.height * 0.25);
    path.lineTo(size.width * 0.14, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.14, size.height * 0.75, size.width * 0.5, size.height * 0.95);
    path.quadraticBezierTo(size.width * 0.86, size.height * 0.75, size.width * 0.86, size.height * 0.5);
    path.lineTo(size.width * 0.86, size.height * 0.25);
    path.close();
    
    // 对勾
    path.moveTo(size.width * 0.36, size.height * 0.5);
    path.lineTo(size.width * 0.45, size.height * 0.58);
    path.lineTo(size.width * 0.64, size.height * 0.38);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}