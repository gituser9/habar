import 'package:flutter/material.dart';
import 'package:habar/common/costants.dart';
import 'package:habar/model/profile.dart';

class UserMedalsWidget extends StatelessWidget {
  final Profile profile;

  const UserMedalsWidget({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Значки',
                    style: Constant.profileHeadersStyle,
                  ),
                ),
                Wrap(
                  children: [
                    for (final medal in profile.data.badges)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(medal.title, style: const TextStyle(color: Colors.blue)),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
