import 'package:flutter/material.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/model/company_list.dart';
import 'package:habar/profile/profile_screen.dart';

class UserSubscriptions extends StatelessWidget {
  final List<Company> companies;

  const UserSubscriptions({
    Key? key,
    required this.companies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 16),
            child: Row(
              children: [
                const Text(' Подписан на компании', style: Constant.profileHeadersStyle),
              ],
            ),
          ),
          ..._getCompaniesWidgets(context),
        ],
      ),
    );
  }

  List<Widget> _getCompaniesWidgets(BuildContext context) {
    List<Widget> widgets = [];

    for (final company in companies) {
      widgets.add(ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(company.icon),
          backgroundColor: Colors.transparent,
        ),
        title: Text(company.name, style: const TextStyle(fontSize: 15)),
        subtitle: Text(company.specializm, style: const TextStyle(fontSize: 13)),
        onTap: () async {
          final login = company.path.replaceFirst(RegExp(r'(/company/)'), '');
          // login = login.replaceAll(RegExp(r'/'), '');

          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(login: login)),
          );
        },
      ));
    }

    return widgets;
  }
}
