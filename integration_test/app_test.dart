import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Import pintu masuk aplikasi utama Anda!
import 'package:utd_advanced_app/main.dart' as app;
import 'package:get_it/get_it.dart';

void main() {
  // Ini wajib dipanggil untuk menghubungkan test ke Emulator / HP Fisik
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-End: Alur Login Admin Sukses', (WidgetTester tester) async {
    // 1. ARRANGE (Nyalakan Mesin Aplikasi!)
    await GetIt.I.reset(); // Reset memori agar tidak bentrok dengan test sebelumnya
    app.main(); // Memanggil fungsi main() asli aplikasi kita

    // Tunggu sampai aplikasi benar-benar selesai loading (Splash screen, dll)
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // 2. ACT (Mulai Mengetik & Mengklik)
    // Robot mencari kotak Email dan mengetik teks
    final fieldEmail = find.byKey(const Key('field_email'));
    await tester.enterText(fieldEmail, 'admin@utd.id');

    // Robot mencari kotak Password dan mengetik teks
    final fieldPassword = find.byKey(const Key('field_password'));
    await tester.enterText(fieldPassword, 'rahasia123');

    // Kita perintahkan Robot untuk menutup keyboard virtual di HP
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Robot menekan tombol Login!
    final tombolLogin = find.byKey(const Key('tombol_login'));
    await tester.tap(tombolLogin);

    // Tunggu animasi pindah halaman (Route transition) selesai
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // 3. ASSERT (Pembuktian)
    // Kita buktikan bahwa layar berhasil pindah dan menemukan teks Beranda
    expect(find.text('Selamat Datang Admin!'), findsOneWidget);

    // Kita buktikan bahwa teks tombol 'LOGIN SEKARANG' sudah tidak ada (karena sudah pindah layar)
    expect(find.text('LOGIN SEKARANG'), findsNothing);
  });

  // --- TUGAS MANDIRI 1 ---
  testWidgets('End-to-End: Alur Login Sabotase (Gagal)', (WidgetTester tester) async {
    await GetIt.I.reset(); // Wajib reset!
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final fieldEmail = find.byKey(const Key('field_email'));
    await tester.enterText(fieldEmail, 'admin@utd.id');

    final fieldPassword = find.byKey(const Key('field_password'));
    await tester.enterText(fieldPassword, 'passwordasal123'); // Password disalahkan

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final tombolLogin = find.byKey(const Key('tombol_login'));
    await tester.tap(tombolLogin);

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Assert mengecek pesan error merah
    expect(find.text('Kredensial Anda salah!'), findsOneWidget);
  });
}
