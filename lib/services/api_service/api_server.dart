import 'package:avms/services/api_service/end_point.dart';
import 'package:http/http.dart' as http;

class ApiServer{
  Future<bool>SignUp(dynamic data)async{
    try {
      http.Response response=await http.post(Uri.parse('$BASE_URL api/v1/auth/register'),body: data);
      if(response.statusCode==200){
        return true;
      }else{
        return false;
      }
    }catch(e){
      throw Exception(e);
    }
  }
}