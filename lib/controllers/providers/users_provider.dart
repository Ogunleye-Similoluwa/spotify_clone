

import 'package:flutter/cupertino.dart';
import 'package:spotify/models/baseUser.dart';

class UsersProvider extends ChangeNotifier{

  BaseUser user = BaseUser();



  void setUser(BaseUser baseUser){
    user = baseUser;
    notifyListeners();
  }

  BaseUser getUser(){
    return user;
  }


}