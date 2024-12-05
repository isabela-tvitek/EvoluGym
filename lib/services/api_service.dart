import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:evolugym/models/exercise.dart';
import 'package:evolugym/models/exercise_record.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://192.168.1.109:3000")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/exercises")
  Future<List<Exercise>> getExercises();

  @GET("/exercises/{id}")
  Future<Exercise> getExerciseById(@Path("id") int id);

  @POST("/exercises")
  Future<void> addExercise(@Body() Exercise exercise);

  @PUT("/exercises/{id}")
  Future<void> editExercise(@Path("id") int id, @Body() Exercise exercise);

  @DELETE("/exercises/{id}")
  Future<void> deleteExercise(@Path("id") int id);

  @GET("/exercises/{id}/records")
  Future<List<ExerciseRecord>> getExerciseRecords(@Path("id") int exerciseId);

  @POST("/exercises/{id}/records")
  Future<void> addExerciseRecord(@Path("id") int exerciseId, @Body() ExerciseRecord record);

  @PUT("/exercises/{exerciseId}/records/{recordId}")
  Future<void> editExerciseRecord(
    @Path("exerciseId") int exerciseId,
    @Path("recordId") int recordId,
    @Body() ExerciseRecord record
  );

  @DELETE("/exercises/{exerciseId}/records/{recordId}")
  Future<void> deleteExerciseRecord(
    @Path("exerciseId") int exerciseId,
    @Path("recordId") int recordId
  );
}
