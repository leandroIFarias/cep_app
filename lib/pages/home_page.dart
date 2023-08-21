import 'package:flutter/material.dart';

import '../models/endereco_model.dart';
import '../repositories/cep_repository.dart';
import '../repositories/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;

  bool loading = false; 
  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar CEP:'),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CEP obrigatório!';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final valid = formKey.currentState?.validate() ?? false;
                  if (valid) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      final endereco = await cepRepository.getCep(cepEC.text);
                      setState(() {
                        loading = false;
                        enderecoModel = endereco;
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                        enderecoModel = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Erro ao buscar o endereço.',
                          ),
                        ),
                      );
                    }
                  }
                },
                child: const Text(
                  'Buscar',
                ),
              ),
              Visibility(
                visible: loading,
                child: const CircularProgressIndicator()),
              Visibility(
                visible: enderecoModel != null,
                child: Text(
                  '${enderecoModel?.logradouro} ${enderecoModel?.complemento} ${enderecoModel?.cep}.',
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
