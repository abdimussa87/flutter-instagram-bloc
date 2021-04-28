import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_bloc/blocs/blocs.dart';
import 'package:instagram_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:instagram_bloc/widgets/widgets.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              state.user.username,
            ),
            actions: [
              if (state.isCurrentUser)
                IconButton(
                  icon: Icon(
                    Icons.logout,
                  ),
                  onPressed: () =>
                      context.read<AuthBloc>().add(AuthLogoutRequested()),
                )
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 32, 23, 0),
                      child: Row(
                        children: [
                         UserProfileImage(radius:40,profileImageUrl:state.user.profileImageUrl),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
