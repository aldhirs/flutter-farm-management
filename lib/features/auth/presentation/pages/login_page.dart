import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _isObscured = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _attemptLogin() async {
    final username = _emailController.text.trim();
    final password = _passwordController.text;

    // setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate login delay

    // 🟢 Dummy login check (admin / admin)
    if (username == 'admin' && password == 'admin') {
      widget.onLoginSuccess(); // Redirect to homepage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username atau password salah'),
          backgroundColor: Colors.teal,
        ),
      );
    }

    // setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _HeaderBackground(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: ListView(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Sign in",
                    style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: _isObscured,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isObscured = !_isObscured),
                      ),
                      border: const UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        activeColor: themeColor,
                        onChanged: (val) => setState(() => _rememberMe = val!),
                      ),
                      const Text("Remember Me"),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text("Forgot Password?", style: TextStyle(color: themeColor)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _attemptLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("Login", style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text.rich(
                      TextSpan(
                        text: "Don’t have an Account? ",
                        style: TextStyle(color: Colors.grey[700]),
                        children: [
                          TextSpan(
                            text: "Sign up",
                            style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.teal;

    return ClipPath(
      clipper: _TopWaveClipper(),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          color: themeColor,
          image: const DecorationImage(
            image: AssetImage("assets/images/topo_texture.png"), // Tambahkan gambar topo di sini
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
      ),
    );
  }
}

class _TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
