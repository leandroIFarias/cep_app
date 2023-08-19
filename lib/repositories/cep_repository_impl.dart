import 'dart:math';

import 'package:dio/dio.dart';
import '../models/endereco_model.dart';
import './cep_repository.dart';


class CepRepositoryImpl implements CepRepository {
  @override
  Future<EnderecoModel> getCep(String cep) async {
    try {
      final result = await Dio().get('viacep.com.br/ws/$cep/json/');
      return EnderecoModel.fromMap(result.data);
    } on DioException catch (e) {
      log(e.hashCode);
      throw Exception("Erro ao buscar CEP");
    }
  }

}