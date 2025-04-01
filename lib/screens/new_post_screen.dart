import 'package:flutter/material.dart';
import '../components/bottom_navegation.dart';

class NewPostScreen extends StatefulWidget {
  const NewPostScreen({super.key});

  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  final TextEditingController _postController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handlePost() async {
    if (_postController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite algo antes de postar')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Implementar a chamada à API para criar o post
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Postagem criada com sucesso!')),
    );

    // Voltar para o feed após postar
    // Navigator.pop(context);
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Nova Postagem"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de texto para o post
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "O que você está pensando?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Botão para postar
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _handlePost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    child: const Text("Postar"),
                  ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavigation(currentIndex: 2),
    );
  }
}
