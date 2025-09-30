import 'package:video/app/module/auth/controllers/login_api_provider.dart';
import 'package:video/app/module/auth/models/auth_model.dart';
import 'package:video/app/utils/helpers/dailog_helper.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs; // Observable loading state
  var errorMessage = ''.obs; // Observable error message
  var loginResponse =
      LoginResponse(access_token: null).obs; // Observable for login response

  final LoginApiProvider apiProvider = LoginApiProvider();

  Future<void> login(String userName, String password) async {
    DialogHelper.showLoading();
    isLoading.value = true;
    errorMessage.value = '';
    try {
      loginResponse.value = await apiProvider.userLogin(userName, password);
      DialogHelper.hideLoading();
      if (loginResponse.value.access_token==null) {
        errorMessage.value = loginResponse.value.message ?? "Login failed";
      }
    } catch (e) {
      // DialogHelper.hideLoading();
      errorMessage.value = e.toString(); // Handle error
    } finally {
      isLoading.value = false;
      DialogHelper.hideLoading();
    }
  }
}
