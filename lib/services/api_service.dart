import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:evolugym/models/exercise.dart';

part 'api_service.g.dart'; // Geração do código Retrofit

@RestApi(baseUrl: "http://192.168.1.109:3000") // URL da sua API local
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/exercises") 
  Future<List<Exercise>> getExercises();

  @POST("/exercises")
  Future<void> addExercise(@Body() Exercise exercise); // Adicionando exercício

  @PUT("/exercises/{id}")
  Future<void> editExercise(@Path("id") int id, @Body() Exercise exercise); // Editando exercício

  @DELETE("/exercises/{id}")
  Future<void> deleteExercise(@Path("id") int id); // Deletando exercício
}
