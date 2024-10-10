import 'package:flutter/material.dart';
import 'package:avaliacaoapi/pages/create_page.dart';
import 'package:avaliacaoapi/pages/update_page.dart';
import 'package:avaliacaoapi/services/api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService apiService = ApiService();
  List<dynamic> livros = [];

  @override
  void initState() {
    super.initState();
    _loadLivros();
  }

  _loadLivros() async {
    final livrosData = await apiService.getLivros();
    setState(() {
      livros = livrosData;
    });
  }

  _confirmarExclusao(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Exclusão'),
          content: Text('Você tem certeza que deseja excluir este livro?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () async {
                await apiService.deletarLivro(id);
                Navigator.of(context).pop();
                _loadLivros();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livros Cadastrados'),
      ),
      body: ListView.builder(
        itemCount: livros.length,
        itemBuilder: (context, index) {
          final livro = livros[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(livro['nome']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Autor: ${livro['autor']}'),
                  Text('Data de publicação: ${livro['data']}'),
                  Text('Preço: R\$ ${livro['preco'].toStringAsFixed(2)}'),
                  Text(
                      'Disponível: ${livro['disponibilidade'] ? 'Sim' : 'Não'}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdatePage(livro: livro),
                        ),
                      ).then((value) => _loadLivros());
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _confirmarExclusao(livro['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePage()),
          ).then((value) => _loadLivros());
        },
      ),
    );
  }
}
