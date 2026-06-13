import 'package:flutter/material.dart';
import 'core/config/env_config.dart'; // Jangan lupa import config kita!
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'core/di/injection.dart';
import 'features/todo/data/isar_service.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'features/auth/presentation/pages/login_screen.dart'; // Import layar login


// 1. NAMA TUGAS (Konstanta agar tidak salah ketik)
const String syncTask = "tugas_sinkronisasi_rutin";

// 2. PEKERJA LATAR BELAKANG (Top-Level Function)
@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == syncTask) {
      try {
        debugPrint("Mulai mengambil data dari server secara gaib...");
        await Future.delayed(const Duration(seconds: 3));
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        String currentTime = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.now());
        await prefs.setString("last_sync_time", "Sinkronisasi diam-diam sukses pada: $currentTime");
        
        debugPrint("Tugas Latar Belakang Selesai!");
      } catch (e) {
        debugPrint("Tugas gagal: $e");
        return Future.value(false);
      }
    } else if (taskName == "tugas_sekali_jalan") {
      try {
        debugPrint("Mulai menjalankan One-Off Task...");
        await Future.delayed(const Duration(seconds: 3));
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        String currentTime = DateFormat('dd MMM yyyy, HH:mm:ss').format(DateTime.now());
        await prefs.setString("last_sync_time", "One-Off Task sukses pada: $currentTime");
        
        debugPrint("One-Off Task Latar Belakang Selesai!");
      } catch (e) {
        debugPrint("Tugas One-Off gagal: $e");
        return Future.value(false);
      }
    }
    return Future.value(true);
  });
}


void main() async {
  // WAJIB: Pastikan binding Flutter siap sebelum kode async/native dijalankan
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Isar Database sebelum runApp (cegah crash di UI)
  try {
    await IsarService.init();
  } catch (e) {
    // Jika init gagal (misal emulator tidak kompatibel), app tetap berjalan
    debugPrint('[IsarService] Gagal init: $e');
  }

  // Setup Dependency Injection (GetIt)
  setupLocator();

  // 3. Inisialisasi WorkManager (Memberikan ID Card ke Satpam)
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // SEKARANG PITA DEBUG INI BISA DIKONTROL DARI TERMINAL!
      debugShowCheckedModeBanner: EnvConfig.showDebugBanner,
      title: 'UTD Advanced App',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
