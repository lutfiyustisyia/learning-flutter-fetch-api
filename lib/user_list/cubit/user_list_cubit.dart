import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:futter_user_list_cubit/user_list/cubit/user_list_state.dart';
import 'package:futter_user_list_cubit/user_list/model/user.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(const UserListState.initial());

  // Local list to store users
  List<User> _users = [];

  Future<void> fetchUser() async {
    try {
      emit(const UserListState.loading());
      Dio dio = Dio();
      final res = await dio.get("https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data;
        _users = data.map<User>((d) => User.fromJson(d)).toList();
        emit(UserListState.success(_users));
      } else {
        emit(UserListState.error("Error loading data: ${res.data.toString()}"));
      }
    } catch (e) {
      emit(UserListState.error("Error loading data: ${e.toString()}"));
    }
  }

  void deleteUser(int userId) {
    _users = _users.where((user) => user.id != userId).toList();
    emit(UserListState.success(_users));
  }
}
