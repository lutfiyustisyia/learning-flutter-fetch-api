import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:futter_user_list_cubit/user_list/cubit/user_list_state.dart';
import 'package:futter_user_list_cubit/user_list/model/user.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(const UserListState.initial());

  Future<void> fetchUser() async {
    try {
      emit(const UserListState.loading());
      Dio dio = Dio();
      final res = await dio.get("https://jsonplaceholder.typicode.com/posts");

      if (res.statusCode == 200) {
        final List<dynamic> data = res.data;
        final List<User> users =
            data.map<User>((d) => User.fromJson(d)).toList();
        emit(UserListState.success(users));
      } else {
        emit(UserListState.error("Error loading data: ${res.data.toString()}"));
      }
    } catch (e) {
      emit(UserListState.error("Error loading data: ${e.toString()}"));
    }
  }

  deleteUser(int userId) {
    state.maybeWhen(
      success: (List<User> users) {
        final updatedUsers = users.where((user) => user.id != userId).toList();
        emit(UserListState.success(updatedUsers));
      },
      error: (String message) {
        emit(UserListState.error(
            "Cannot delete user, state status is error: $message"));
      },
      orElse: () {
        // Handle cases where state is not success or error
      },
    );
  }
}
