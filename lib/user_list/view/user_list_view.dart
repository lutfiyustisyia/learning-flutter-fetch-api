import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futter_user_list_cubit/user_list/cubit/user_list_cubit.dart';
import 'package:futter_user_list_cubit/user_list/cubit/user_list_state.dart';
// import 'package:futter_user_list_cubit/user_list/model/user.dart';
// import 'package:futter_user_list_cubit/user_list/model/user.dart';
import 'package:futter_user_list_cubit/user_list/view/user_detail_page.dart';

class UserListView extends StatelessWidget {
  const UserListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade200,
              Colors.blue.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BlocBuilder<UserListCubit, UserListState>(
          builder: (context, state) {
            if (state is UserListSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  String bodyText = state.users[index].body.length > 55
                      ? state.users[index].body.substring(0, 55) + '...'
                      : state.users[index].body;

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      title: Text(
                        state.users[index].title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      subtitle: Text(bodyText),
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade700,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserDetailPage(user: state.users[index]),
                          ),
                        );
                      },
                      onLongPress: () async {
                        bool? confirmDelete = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you want to delete this item?"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text("DELETE"),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmDelete == true) {
                          context
                              .read<UserListCubit>()
                              .deleteUser(state.users[index].id);
                        }
                      },
                    ),
                  );
                },
              );
            }

            if (state is UserListLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UserListError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              );
            }

            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<UserListCubit>().fetchUser();
                },
                child: const Text("Refresh"),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserListCubit>().fetchUser();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
