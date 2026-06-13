// KODE UTAMA KITA (lib/features/auth/auth_service.dart)
// Kita buat kontrak/interface sederhana untuk ApiClient
abstract class ApiClient {
  Future<bool> loginKeServer(String email, String password);
}

// Ini adalah Class yang mau kita Test!
class AuthService {
  // AuthService butuh ApiClient untuk bekerja (Dependency)
  final ApiClient apiClient;
  AuthService(this.apiClient);
  
  Future<String> loginUser(String email, String password) async {
    // Validasi dasar
    if (email.isEmpty || password.isEmpty) {
      return "Email dan Password tidak boleh kosong!";
    }
    try {
      // Memanggil layanan API (Internet)
      final isSuccess = await apiClient.loginKeServer(email, password);
      if (isSuccess) {
        return "Login Berhasil!";
      } else {
        return "Kredensial Salah!";
      }
    } catch (e) {
      return "Terjadi Kesalahan Jaringan";
    }
  }
}
