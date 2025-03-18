import 'package:flutter/material.dart';
import 'package:papacapim_ui/screens/profile_screen.dart';
import '../screens/replies_screen.dart';

class PostCard extends StatelessWidget {
  final String userName;
  final String userLogin;
  final String postContent;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onDelete;
  final VoidCallback? onUserTap; // 🔥 Callback para quando clicar no login
  final bool showDeleteButton;
  final bool showFollowerButton;

  const PostCard({
    Key? key,
    required this.userName,
    required this.userLogin,
    required this.postContent,
    this.onLike,
    this.onComment,
    this.onDelete,
    this.onUserTap,
    this.showDeleteButton =
        false, // Define se o botão de deletar aparecerá (para perfil do usuário)
    this.showFollowerButton =
        true, // Define se o botão de seguir aparecerá (para outros usuários)
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.black,
        elevation: 8.0,
        shadowColor: Color(0xFFD8FF6F),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome do usuário e botão de opções/excluir
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()));
                        },
                        child: Text(
                          "@$userLogin",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 13.0, bottom: 5),
                        child: Text(
                          "há 2 horas",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Color.fromARGB(255, 83, 83, 83)),
                        ),
                      )
                    ],
                  ),
                  if (showFollowerButton)
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F63FF),
                      ),
                      child: const Text("Seguir",
                          style: TextStyle(color: Colors.white)),
                    ),
                  if (showDeleteButton && onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Conteúdo da postagem
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 13.0), // Espaço em cima, embaixo e nas laterais
                child: Text(
                  postContent,
                  style: const TextStyle(
                      // fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),

              // Botões de curtir e comentar
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: IconButton(
                      icon: const Icon(Icons.thumb_up_alt_outlined,
                          color: Color(0xFFD8FF6F)),
                      onPressed: onLike,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.thumb_down_alt_outlined,
                        color: Color(0xFFD8FF6F)),
                    onPressed: onLike,
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined,
                        color: Color(0xFFD8FF6F)),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RepliesScreen(
                                    userName: userName,
                                    userLogin: userLogin,
                                    postContent: postContent,
                                  )));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
