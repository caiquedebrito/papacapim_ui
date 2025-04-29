import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  bool following;
  final VoidCallback onTap;

  FollowButton({
    Key? key,
    required this.following,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            child: Text(following ? 'Seguindo' : 'Seguir',
                style: TextStyle(color: Colors.black)),
          );
  }
}