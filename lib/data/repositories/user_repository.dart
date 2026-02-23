import '../../core/network/api_end_points.dart';
import '../../core/network/dio_client.dart';

class UserRepository {
  final DioClient _client = DioClient();

  Future<dynamic> login(String email, String password) async {
    final payload = {'email': email, 'password': password};
    final res = await _client.post(ApiEndpoints.login, data: payload);
    return res;
  }
}
