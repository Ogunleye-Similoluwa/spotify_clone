

import 'package:flutter/cupertino.dart';
import 'package:spotify/controllers/api_service/ApiService.dart';

class ImagesProvider extends ChangeNotifier{

  ApiService service = ApiService();
  List<dynamic> imgUrls = [];

  Future<void> fetchRandomImages() async{
    imgUrls = await service.fetchRandomImages();
    notifyListeners();
  }

  void setImageUrls(List<dynamic> imageUrls){
    imgUrls = imageUrls;
    notifyListeners();
  }


  ImagesProvider(){
    fetchRandomImages();
  }
}