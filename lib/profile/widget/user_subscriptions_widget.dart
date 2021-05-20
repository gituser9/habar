import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/profile/profile_ctrl.dart';

class UserSubscriptions extends StatelessWidget {
  final String login;
  final ProfileCtrl ctrl = Get.find();

  UserSubscriptions({Key? key, required this.login}) : super(key: key) {
    ctrl.getProfileCompanies(login);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _getCompaniesWidgets(ctrl.profileCompanies));
  }

  Widget _getCompaniesWidgets(List<Company> companies) {
    if (companies.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Подписан на компании',
              style: Constant.profileHeadersStyle,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: companies.length,
          itemBuilder: (ctx, index) {
            final company = companies[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(company.icon),
                backgroundColor: Colors.transparent,
              ),
              title: Text(company.name, style: const TextStyle(fontSize: 15)),
              subtitle: Text(company.specializm, style: const TextStyle(fontSize: 13)),
              // onTap: () async {
              //   final login = company.path.replaceFirst(RegExp(r'(/company/)'), '');
              //   // login = login.replaceAll(RegExp(r'/'), '');
              //   await Get.to(ProfileScreen(login: login));
              // },
            );
          },
        ),
      ],
    );
  }
}
