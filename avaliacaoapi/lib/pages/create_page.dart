import 'package:flutter/material.dart';
import 'package:avaliacaoapi/services/api_service.dart';
import 'package:intl/intl.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  String nome = '';
  String autor = '';
  String data = '';
  double preco = 0.0;
  bool disponibilidade = true;
  DateTime? _selectedDate;

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
      final novoLivro = {
        'nome': nome,
        'autor': autor,
        'data': data,
        'preco': preco,
        'disponibilidade': disponibilidade,
      };

      await apiService.criarLivro(novoLivro);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Livro')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome'),
                onChanged: (value) => nome = value,
                validator: (value) =>
                    value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Autor'),
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
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
