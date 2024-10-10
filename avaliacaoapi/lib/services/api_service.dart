import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://127.0.0.1:5000/livros';

  //get
  Future<List<dynamic>> getLivros() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao carregar livros');
    }
  }

  //post
  Future<void> criarLivro(Map<String, dynamic> livro) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(livro),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao criar livro');
    }
  }

  //put
  Future<void> atualizarLivro(int id, Map<String, dynamic> livro) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(livro),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar livro');
    }
  }

  //delete
  Future<void> deletarLivro(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Erro ao excluir livro');
    }
  }
}
