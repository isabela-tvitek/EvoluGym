import 'package:dio/dio.dart';
import 'package:evolugym/models/exercise_detail.dart';

class ExerciseDetailService {
  final Dio dio;

  ExerciseDetailService(this.dio);

  Future<List<ExerciseDetail>> getDetailsByExerciseId(int exerciseId) async {
    try {
      final response = await dio.get('https://sua-api-url.com/exercise_details/$exerciseId');
      if (response.statusCode == 200) {
        List<ExerciseDetail> exerciseDetails = (response.data as List)
            .map((item) => ExerciseDetail.fromMap(item))
            .toList();
        return exerciseDetails;
      } else {
        throw Exception('Erro ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar dados: $e');
    }
  }

  Future<void> addExerciseDetail(ExerciseDetail exerciseDetail) async {
    try {
      final response = await dio.post('https://sua-api-url.com/exercise_details', data: exerciseDetail.toMap());
      if (response.statusCode != 200) {
        throw Exception('Erro ao adicionar exercício: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao adicionar exercício: $e');
    }
  }
}
