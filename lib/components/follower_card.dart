
import 'package:flutter/material.dart';
import 'package:papacapim_ui/screens/profile_screen.dart';

class FollowerCard extends StatelessWidget{
  final String userLogin;

  const FollowerCard({
    Key? key,
    required this.userLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(userLogin[0]),
      ),
      title: Text(userLogin),
      subtitle: Text("@${userLogin}"),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ProfileScreen(),
        //   ),
        // );
      },
    );
  }

}