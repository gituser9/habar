import 'package:flutter/material.dart';
import 'package:habar/common/util.dart';
import 'package:habar/model/profile.dart';

class UserPersonWidget extends StatelessWidget {
  final Profile profile;

  const UserPersonWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      // color: Colors.white,
      child: Column(
        children: [
          if (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage('https:${profile.avatarUrl}'),
                backgroundColor: Colors.transparent,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '@${profile.alias}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          if (profile.fullname != null && profile.fullname!.isNotEmpty)
            Text(
              profile.fullname!,
              style: const TextStyle(),
            ),
          _buildStatusRow(),
          // Text(
          //   '${profile.data.counters.followers} подписчиков | ${profile.data.counters.followed} подписок',
          //   style: const TextStyle(fontSize: 12),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Зарегистрировался ${Util.dateToString(profile.registerDateTime)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          const SizedBox(height: 8)
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    const labelStyle = TextStyle(color: Colors.grey, fontSize: 12);
    const valueStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (profile.scoreStats?.score != 0.0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Карма'.toUpperCase(),
                        style: labelStyle,
                      ),
                      Text(
                        profile.scoreStats?.score.toString() ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: (profile.scoreStats?.score ?? 0) > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                if (profile.rating > 0.0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Рейтинг'.toUpperCase(),
                        style: labelStyle,
                      ),
                      Text(
                        profile.rating.toString(),
                        style: valueStyle,
                      ),
                    ],
                  ),
                if (profile.ratingPos != 0.0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Позиция'.toUpperCase(),
                        style: labelStyle,
                      ),
                      Text(
                        profile.ratingPos?.toString() ?? '',
                        style: valueStyle,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
