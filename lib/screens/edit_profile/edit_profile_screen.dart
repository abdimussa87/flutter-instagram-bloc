import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:instagram_bloc/repositories/repositories.dart';
import 'package:instagram_bloc/screens/profile/bloc/profile_bloc.dart';

import 'cubit/edit_profile_cubit.dart';

class EditProfileScreenArgs {
  final BuildContext context;
  EditProfileScreenArgs({
    @required this.context,
  });
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/editProfile';
  static Route route({@required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider(
        create: (_) => EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
    );
  }
}
