import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  void _prosesLogin() {
    setState(() {
      // Logika Validasi Sederhana
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        _errorMessage = 'Email dan Password wajib diisi!';
      } else if (_emailController.text == 'admin@utd.id' && _passwordController.text == 'rahasia123') {
        _errorMessage = '';
        // Pindah ke halaman sukses pura-pura
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuksesScreen()),
        );
      } else {
        _errorMessage = 'Kredensial Anda salah!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Kunci (Key) ini sangat penting agar Robot mudah menemukan kotak ini!
            TextField(
              key: const Key('field_email'),
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('field_password'),
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            // Area Teks Error Merah
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                key: const Key('text_error'),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              key: const Key('tombol_login'),
              onPressed: _prosesLogin,
              child: const Text('LOGIN SEKARANG'),
            )
          ],
        ),
      ),
    );
  }
}

// Layar sederhana penanda sukses
class SuksesScreen extends StatelessWidget {
  const SuksesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda Utama')),
      body: const Center(
        child: Text('Selamat Datang Admin!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
