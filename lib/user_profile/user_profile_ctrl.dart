import 'package:get/get.dart';
import 'package:habar/user_profile/user_profile_repo.dart';

class UserProfileCtrl extends GetxController {
  final _repo = UserProfileRepo();
  final selectedIndex = 0.obs;
  final isAuth = false.obs;

  @override
  void onInit() {
    super.onInit();
  }
}
