import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  // Menggunakan TickerProviderStateMixin agar bisa memiliki lebih dari 1 Metronome
  State<AnimationPage> createState() => _AnimationPageState() /* with TickerProviderStateMixin */;
}

class _AnimationPageState extends State<AnimationPage> with TickerProviderStateMixin {
  // 1. Controller untuk Animasi Putaran Bintang
  late AnimationController _spinController;
  
  // 2. Controller khusus untuk Animasi Lottie
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi _spinController
    _spinController = AnimationController(
      vsync: this, // Metronome halaman ini
      duration: const Duration(seconds: 2), // 2 detik per putaran penuh
    );
    _spinController.repeat(); // Loop terus-menerus

    // Inisialisasi _lottieController
    _lottieController = AnimationController(
      vsync: this,
      // Durasi akan diatur nanti mengikuti durasi bawaan Lottie JSON
    );
  }

  @override
  void dispose() {
    // WAJIB dihancurkan agar tidak terjadi memory leak (HP panas)
    _spinController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Animations'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Explicit Animation (Putaran Tanpa Henti):",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              
              // AnimatedBuilder untuk merender ulang Icon 60x/detik
              AnimatedBuilder(
                animation: _spinController,
                builder: (context, child) {
                  return Transform.rotate(
                    // _spinController.value bernilai 0.0 - 1.0, 
                    // dikalikan 2 Pi (6.2831853) untuk 1 putaran penuh Radian
                    angle: _spinController.value * 6.2831853,
                    child: child,
                  );
                },
                child: const Icon(Icons.star, size: 100, color: Colors.orange),
              ),
              
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 40),

              const Text(
                "Lottie Integration & Scrubbing:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "(Geser/Scrub kotak lottie ke kiri & kanan secara manual!)",
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // GestureDetector untuk TUGAS C2 (Interactive Animation Scrubbing)
              GestureDetector(
                onPanUpdate: (details) {
                  // Memanipulasi nilai _lottieController (0.0 s/d 1.0)
                  // Pembagi 200 mengatur sensitivitas geseran jari
                  _lottieController.value += details.delta.dx / 200;
                },
                child: Container(
                  color: Colors.transparent, // Supaya bisa digeser di seluruh area container
                  child: Lottie.network(
                    // Menggunakan URL JSON stabil dari Lottie-Flutter repo
                    'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/LottieLogo1.json',
                    width: 200,
                    height: 200,
                    controller: _lottieController,
                    animate: false, // Mencegah jalan otomatis
                    onLoaded: (composition) {
                      // Sinkronkan durasi Controller dengan durasi asli file Lottie
                      setState(() {
                        _lottieController.duration = composition.duration;
                      });
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Gagal memuat animasi. Periksa koneksi internet."),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),

              // Tombol-tombol kontrol (TUGAS C1 ada di sini)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Play Forward (Maju)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _lottieController.reset();
                      _lottieController.forward();
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Play"),
                  ),
                  const SizedBox(width: 15),
                  // Tombol Reverse (TUGAS C1: Membalik Waktu)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      // Jika animasi belum selesai, reverse dari posisinya
                      // Jika posisinya di awal (0.0), kita set ke akhir (1.0) dulu baru reverse
                      if (_lottieController.value == 0.0) {
                        _lottieController.value = 1.0;
                      }
                      _lottieController.reverse();
                    },
                    icon: const Icon(Icons.fast_rewind),
                    label: const Text("Reverse"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
