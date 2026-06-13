import 'package:flutter_test/flutter_test.dart';
// Import file yang mau diuji dari lib
import 'package:utd_advanced_app/features/calculator/simple_calculator.dart';

void main() {
  // group() digunakan untuk mengelompokkan pengujian yang mirip
  group('Pengujian SimpleCalculator -', () {
    // Siapkan wadah untuk kelas yang mau diuji
    late SimpleCalculator calculator;
    
    // setUp() akan dijalankan SEBELUM setiap test() dimulai
    setUp(() {
      calculator = SimpleCalculator(); // [ARRANGE]
    });
    
    // Robot 1: Menguji fungsi pertambahan
    test('Fungsi add() harus mengembalikan hasil 5 jika 2 ditambah 3', () {
      // 1. ACT (Aksi)
      final result = calculator.add(2, 3);
      // 2. ASSERT (Pembuktian)
      // expect(hasil_asli, hasil_harapan)
      expect(result, 5);
    });
    
    // Robot 2: Menguji perhitungan diskon
    test('Fungsi calculateDiscount() harus mengembalikan 8000 jika harga 10000 diskon 20%', () {
      // 1. ACT
      final result = calculator.calculateDiscount(10000, 20);
      // 2. ASSERT
      expect(result, 8000);
    });
    
    // Robot 3: Menguji Error (Exception)
    test('Fungsi calculateDiscount() harus melempar error jika diskon 150%', () {
      // Untuk menguji error, kita membungkus Act di dalam penangkap error 'throwsArgumentError'
      expect(
        () => calculator.calculateDiscount(10000, 150), // ACT
        throwsArgumentError, // ASSERT: Kita berekspektasi ini akan meledak!
      );
    });
  });
}
