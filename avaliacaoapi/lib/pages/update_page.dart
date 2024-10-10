import 'package:flutter/material.dart';
import 'package:avaliacaoapi/services/api_service.dart';
import 'package:intl/intl.dart';

class UpdatePage extends StatefulWidget {
  final Map<String, dynamic> livro;

  UpdatePage({required this.livro});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late String nome;
  late String autor;
  late String data;
  late double preco;
  late bool disponibilidade;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    nome = widget.livro['nome'];
    autor = widget.livro['autor'];
    data = widget.livro['data'];
    preco = widget.livro['preco'];
    disponibilidade = widget.livro['disponibilidade'];
    _selectedDate = DateTime.tryParse(data);
  }

  //showDatePicker
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        data = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final livroAtualizado = {
        'nome': nome,
        'autor': autor,
        'data': data,
        'preco': preco,
        'disponibilidade': disponibilidade,
      };

      await apiService.atualizarLivro(widget.livro['id'], livroAtualizado);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Atualizar Livro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                initialValue: nome,
                onChanged: (value) => nome = value,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Autor'),
                initialValue: autor,
                onChanged: (value) => autor = value,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      decoration:
                          InputDecoration(labelText: 'Data de publicação'),
                      controller: TextEditingController(text: data),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selecionarData(context),
                  ),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Preço'),
                initialValue: preco.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) => preco = double.parse(value),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              SwitchListTile(
                title: Text('Disponível'),
                value: disponibilidade,
                onChanged: (value) {
                  setState(() {
                    disponibilidade = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
