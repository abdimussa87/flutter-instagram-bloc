import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:instagram_bloc/models/models.dart';
import 'package:instagram_bloc/repositories/repositories.dart';
import 'package:instagram_bloc/screens/profile/bloc/profile_bloc.dart';
import 'package:meta/meta.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final ProfileBloc _profileBloc;

  EditProfileCubit(
      {@required UserRepository userRepository,
      @required StorageRepository storageRepository,
      @required ProfileBloc profileBloc})
      : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _profileBloc = profileBloc,
        super(EditProfileState.initial()) {
    final user = _profileBloc.state.user;
    emit(state.copyWith(username: user.username, bio: user.bio));
  }

  void onProfileImageChanged(File image) {
    emit(
        state.copyWith(profileImage: image, status: EditProfileStatus.initial));
  }

  void onUsernameChanged(String username) {
    emit(state.copyWith(username: username, status: EditProfileStatus.initial));
  }

  void onBioChanged(String bio) {
    emit(state.copyWith(bio: bio, status: EditProfileStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;
      var profileImageUrl = user.profileImageUrl;
      // if our user selected a new profile image
      if (state.profileImage != null) {
        profileImageUrl = await _storageRepository.uploadProfileImage(
            url: user.profileImageUrl, image: state.profileImage);
      }
      final updatedUser = user.copyWith(
          username: state.username,
          bio: state.bio,
          profileImageUrl: profileImageUrl);

      await _userRepository.updateUser(user: updatedUser);
      // will refetch our new user data from firebase to update our user in the profile screen
      _profileBloc.add(ProfileLoadUser(userId: user.id));

      emit(state.copyWith(status: EditProfileStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
          status: EditProfileStatus.error,
          failure: const Failure(message: 'Unable to update your profile.'),
        ),
      );
    }
  }
}
