part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final User user;
  final bool isCurrentUser;
  final bool isFollowing;
  final bool isGridView;
  final ProfileStatus status;
  final Failure failure;
  // final List<Post> posts;
  const ProfileState({
    @required this.user,
    @required this.isCurrentUser,
    @required this.isFollowing,
    @required this.isGridView,
    @required this.status,
    @required this.failure,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      user: User.empty,
      isCurrentUser: false,
      isFollowing: false,
      isGridView: true,
      status: ProfileStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props =>
      [user, isCurrentUser, isFollowing, isGridView, status, failure];

  ProfileState copyWith({
    User user,
    bool isCurrentUser,
    bool isFollowing,
    bool isGridView,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isFollowing: isFollowing ?? this.isFollowing,
      isGridView: isGridView ?? this.isGridView,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
