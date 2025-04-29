import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  bool isLiked;
  final VoidCallback onTap;

  LikeButton({
    Key? key,
    required this.isLiked,
    required this.onTap,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite,
        color: isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: onTap,
      tooltip: isLiked ? 'Descurtir' : 'Curtir',
    );
  }
}